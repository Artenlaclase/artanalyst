import 'dart:convert';
import 'dart:io';
import '../lib/services/licensing_service.dart';

void main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8081') ?? 8081;
  final licensingService = LicensingService();

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('================================================================');
  print(' ArtAnalyst - Microservicio de Medios y Licencias (Dart Frog/Shelf)');
  print(' Escuchando en http://localhost:$port');
  print(' Endpoints:');
  print('   - GET  /health');
  print('   - GET  /api/v1/license/resolve?source=met&id=436535');
  print('   - POST /api/v1/license/batch');
  print('================================================================');

  await for (final HttpRequest request in server) {
    _handleCors(request);

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      continue;
    }

    try {
      final path = request.uri.path;

      if (path == '/health' || path == '/') {
        await _jsonResponse(request, {
          'status': 'ok',
          'service': 'art_analyst_licensing',
          'version': '1.0.0',
          'time': DateTime.now().toIso8601String(),
        });
        continue;
      }

      if (path == '/api/v1/license/resolve' && request.method == 'GET') {
        final source = request.uri.queryParameters['source'];
        final id = request.uri.queryParameters['id'];

        if (source == null || id == null || source.isEmpty || id.isEmpty) {
          await _jsonResponse(request, {
            'error': 'Faltan parámetros requeridos: "source" y "id".',
          }, statusCode: HttpStatus.badRequest);
          continue;
        }

        final result = await licensingService.resolveLicense(
          source: source,
          externalId: id,
          bypassCache: request.uri.queryParameters['fresh'] == 'true',
        );

        if (result == null) {
          await _jsonResponse(request, {
            'error': 'No se encontró la obra en la fuente "$source" con ID "$id".',
          }, statusCode: HttpStatus.notFound);
          continue;
        }

        await _jsonResponse(request, result.toJson());
        continue;
      }

      if (path == '/api/v1/license/batch' && request.method == 'POST') {
        final body = await utf8.decodeStream(request);
        final Map<String, dynamic> jsonBody = jsonDecode(body) as Map<String, dynamic>;
        final items = jsonBody['items'] as List<dynamic>? ?? [];

        final results = <Map<String, dynamic>>[];
        for (final item in items) {
          final s = item['source'] as String?;
          final i = item['id'] as String?;
          if (s != null && i != null) {
            final res = await licensingService.resolveLicense(source: s, externalId: i);
            if (res != null) results.add(res.toJson());
          }
        }

        await _jsonResponse(request, {'results': results, 'count': results.length});
        continue;
      }

      // 404 Not Found
      await _jsonResponse(request, {
        'error': 'Ruta no encontrada: ${request.method} $path',
      }, statusCode: HttpStatus.notFound);
    } catch (e, st) {
      print('Error procesando solicitud: $e\n$st');
      await _jsonResponse(request, {
        'error': 'Error interno del servidor de licencias',
        'details': e.toString(),
      }, statusCode: HttpStatus.internalServerError);
    }
  }
}

void _handleCors(HttpRequest request) {
  request.response.headers.add('Access-Control-Allow-Origin', '*');
  request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  request.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, Authorization');
}

Future<void> _jsonResponse(HttpRequest request, Map<String, dynamic> data, {int statusCode = HttpStatus.ok}) async {
  request.response.statusCode = statusCode;
  request.response.headers.contentType = ContentType.json;
  request.response.write(jsonEncode(data));
  await request.response.close();
}
