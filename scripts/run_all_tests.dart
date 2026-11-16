import 'dart:io';

void main() async {
  print('================================================================');
  print('   ArtAnalyst: SUITE DE VERIFICACIÓN Y PRUEBAS AUTOMATIZADAS    ');
  print('================================================================\n');

  final dartExecutable = Platform.resolvedExecutable;
  final rootDir = Directory.current.path;

  final testSuites = [
    {
      'name': '1. Paquete Shared (Motor de Licencias y Modelos de Dominio)',
      'config': '$rootDir/packages/server/licensing/.dart_tool/package_config.json',
      'path': '$rootDir/packages/shared/test/license_evaluator_test.dart',
    },
    {
      'name': '2. Microservicio de Medios y Licencias (Adaptadores y Filtro)',
      'config': '$rootDir/packages/server/licensing/.dart_tool/package_config.json',
      'path': '$rootDir/packages/server/licensing/test/licensing_service_test.dart',
    },
    {
      'name': '3. Microservicio de Catálogo y Análisis (Panofsky & Progreso)',
      'config': '$rootDir/packages/server/catalog/.dart_tool/package_config.json',
      'path': '$rootDir/packages/server/catalog/test/catalog_repository_test.dart',
    },
  ];

  int totalSuites = testSuites.length;
  int passedSuites = 0;

  for (final suite in testSuites) {
    print('>> Ejecutando: ${suite['name']}');
    final result = await Process.run(
      dartExecutable,
      ['--packages=${suite['config']}', suite['path']!],
    );

    stdout.write(result.stdout);
    if (result.stderr.toString().trim().isNotEmpty) {
      stderr.write(result.stderr);
    }

    if (result.exitCode == 0) {
      print('✓ Suite completada con éxito.\n');
      passedSuites++;
    } else {
      print('✗ Error en la suite (${result.exitCode}).\n');
    }
  }

  print('================================================================');
  print(' RESUMEN FINAL: $passedSuites de $totalSuites suites aprobadas');
  print('================================================================');

  if (passedSuites < totalSuites) {
    exit(1);
  }
}
