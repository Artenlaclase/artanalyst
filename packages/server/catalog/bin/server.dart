import 'dart:convert';
import 'dart:io';
import 'package:art_analyst_shared/shared.dart';
import '../lib/repositories/catalog_repository.dart';

void main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final repository = CatalogRepository();

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('================================================================');
  print(' ArtAnalyst - Microservicio de Catálogo y Análisis (Serverpod/REST)');
  print(' Escuchando en http://localhost:$port');
  print(' Endpoints:');
  print('   - GET  /health');
  print('   - GET  /api/v1/artworks');
  print('   - GET  /api/v1/artworks/:id');
  print('   - GET  /api/v1/artworks/:id/guides');
  print('   - GET  /api/v1/users/:userId/progress/:artworkId');
  print('   - POST /api/v1/users/:userId/progress');
  print('================================================================');

  await for (final HttpRequest request in server) {
    _handleCors(request);

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      continue;
    }

    try {
      final pathSegments = request.uri.pathSegments;

      if (request.uri.path == '/health' || request.uri.path == '/') {
        await _jsonResponse(request, {
          'status': 'ok',
          'service': 'art_analyst_catalog',
          'version': '1.0.0',
          'time': DateTime.now().toIso8601String(),
        });
        continue;
      }

      // /api/v1/artworks
      if (pathSegments.length == 3 &&
          pathSegments[0] == 'api' &&
          pathSegments[1] == 'v1' &&
          pathSegments[2] == 'artworks' &&
          request.method == 'GET') {
        final artworks = repository.getAllArtworks();
        final list = artworks.map((a) {
          final json = a.toJson();
          final images = repository.getArtworkImages(a.id);
          json['images'] = images.map((i) => i.toJson()).toList();
          return json;
        }).toList();
        await _jsonResponse(request, {'artworks': list, 'count': list.length});
        continue;
      }

      // /api/v1/artworks/:id
      if (pathSegments.length == 4 &&
          pathSegments[0] == 'api' &&
          pathSegments[1] == 'v1' &&
          pathSegments[2] == 'artworks' &&
          request.method == 'GET') {
        final id = pathSegments[3];
        final artwork = repository.getArtworkById(id);
        if (artwork == null) {
          await _jsonResponse(request, {'error': 'Obra no encontrada'}, statusCode: HttpStatus.notFound);
          continue;
        }
        final json = artwork.toJson();
        final images = repository.getArtworkImages(id);
        json['images'] = images.map((i) => i.toJson()).toList();
        await _jsonResponse(request, json);
        continue;
      }

      // /api/v1/artworks/:id/guides
      if (pathSegments.length == 5 &&
          pathSegments[0] == 'api' &&
          pathSegments[1] == 'v1' &&
          pathSegments[2] == 'artworks' &&
          pathSegments[4] == 'guides' &&
          request.method == 'GET') {
        final id = pathSegments[3];
        final guides = repository.getAnalysisGuides(id);
        await _jsonResponse(request, {
          'artwork_id': id,
          'guides': guides.map((g) => g.toJson()).toList(),
          'count': guides.length,
        });
        continue;
      }

      // /api/v1/users/:userId/progress/:artworkId
      if (pathSegments.length == 6 &&
          pathSegments[0] == 'api' &&
          pathSegments[1] == 'v1' &&
          pathSegments[2] == 'users' &&
          pathSegments[4] == 'progress' &&
          request.method == 'GET') {
        final userId = pathSegments[3];
        final artworkId = pathSegments[5];
        final progressList = repository.getAllUserProgress(userId, artworkId);
        await _jsonResponse(request, {
          'user_id': userId,
          'artwork_id': artworkId,
          'progress': progressList.map((p) => p.toJson()).toList(),
        });
        continue;
      }

      // POST /api/v1/users/:userId/progress
      if (pathSegments.length == 5 &&
          pathSegments[0] == 'api' &&
          pathSegments[1] == 'v1' &&
          pathSegments[2] == 'users' &&
          pathSegments[4] == 'progress' &&
          request.method == 'POST') {
        final userId = pathSegments[3];
        final body = await utf8.decodeStream(request);
        final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;

        final progress = UserAnalysisProgress(
          id: (json['id'] as String?) ?? 'prog-${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          artworkId: json['artwork_id'] as String,
          level: PanofskyLevel.fromCode(json['level'] as String? ?? 'formal'),
          userResponse: (json['user_response'] as String?) ?? '',
          regions: (json['regions'] as List<dynamic>?)
                  ?.map((r) => AnnotationRegion.fromJson(r as Map<String, dynamic>))
                  .toList() ??
              [],
          isCompleted: (json['is_completed'] as bool?) ?? false,
          updatedAt: DateTime.now(),
        );

        final saved = repository.saveUserProgress(progress);
        await _jsonResponse(request, saved.toJson(), statusCode: HttpStatus.created);
        continue;
      }

      await _jsonResponse(request, {
        'error': 'Ruta no encontrada en microservicio de catálogo: ${request.method} ${request.uri.path}',
      }, statusCode: HttpStatus.notFound);
    } catch (e, st) {
      print('Error en catálogo: $e\n$st');
      await _jsonResponse(request, {
        'error': 'Error interno del servidor de catálogo',
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
