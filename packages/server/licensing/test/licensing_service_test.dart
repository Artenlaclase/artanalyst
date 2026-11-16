import 'package:art_analyst_shared/shared.dart';
import '../lib/services/licensing_service.dart';

void main() async {
  print('--- EJECUTANDO PRUEBAS DE INTEGRACIÓN: LICENSING SERVICE & ADAPTERS ---');
  int passed = 0;
  int failed = 0;

  void test(String desc, bool condition) {
    if (condition) {
      print(' [PASS] $desc');
      passed++;
    } else {
      print(' [FAIL] $desc');
      failed++;
    }
  }

  final service = LicensingService();

  // 1. Resolve Met (CC0)
  final metRes = await service.resolveLicense(source: 'met', externalId: '436535');
  test('Met 436535 resuelve en VERDE con imagen autorizada', 
    metRes != null && metRes.semaphore == LicenseSemaphore.green && metRes.canDisplayImage && metRes.imageUrl != null);

  // 2. Resolve Cleveland (CC0)
  final clevelandRes = await service.resolveLicense(source: 'cleveland', externalId: '1915.534');
  test('Cleveland 1915.534 resuelve en VERDE CC0',
    clevelandRes != null && clevelandRes.semaphore == LicenseSemaphore.green && clevelandRes.attributionText!.contains('Cleveland Museum of Art'));

  // 3. Resolve Wikimedia Worldwide CC0 (Vermeer)
  final wikiRes = await service.resolveLicense(source: 'wikimedia', externalId: 'vermeer');
  test('Wikimedia con CC0 mundial resuelve en VERDE',
    wikiRes != null && wikiRes.semaphore == LicenseSemaphore.green && wikiRes.canDisplayImage);

  // 4. Resolve Louvre (Red Semaphore)
  final louvreRes = await service.resolveLicense(source: 'louvre', externalId: 'cl010062370');
  test('Louvre Mona Lisa resuelve en ROJO y la imagen se bloquea directamente',
    louvreRes != null && louvreRes.semaphore == LicenseSemaphore.red && !louvreRes.canDisplayImage && louvreRes.imageUrl == null);

  // 5. Educational guide generation
  test('Guía educativa para ROJO explica no redistribución y ofrece cita oficial',
    louvreRes != null && louvreRes.educationalGuide['semaphore'] == 'red' && louvreRes.educationalGuide['prohibited'].isNotEmpty);

  print('========================================');
  print('RESULTADOS LICENSING: $passed APROBADOS, $failed FALLIDOS');
  print('========================================');
  if (failed > 0) throw Exception('$failed pruebas de Licensing fallaron.');
}
