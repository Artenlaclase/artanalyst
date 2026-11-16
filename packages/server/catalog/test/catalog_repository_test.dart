import 'package:art_analyst_shared/shared.dart';
import '../lib/repositories/catalog_repository.dart';

void main() {
  print('--- EJECUTANDO PRUEBAS DE INTEGRACIÓN: CATALOG REPOSITORY ---');
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

  final repo = CatalogRepository();

  // 1. Obtener todas las obras
  final artworks = repo.getAllArtworks();
  test('El catálogo contiene 5 obras semilla iniciales', artworks.length == 5);

  // Verificar semáforo amarillo (CC BY-SA)
  final friedrich = artworks.firstWhere((a) => a.source == 'partner_museum');
  final friedrichImages = repo.getArtworkImages(friedrich.id);
  test('Caspar David Friedrich tiene semáforo AMARILLO (CC BY-SA)',
    friedrichImages.isNotEmpty && friedrichImages.first.semaphoreColor == LicenseSemaphore.yellow);

  // 2. Verificar semáforo rojo en Mona Lisa
  final monaLisa = artworks.firstWhere((a) => a.source == 'louvre');
  final monaImages = repo.getArtworkImages(monaLisa.id);
  test('Mona Lisa tiene semáforo ROJO y sin URL de imagen directa alojada',
    monaImages.isNotEmpty && monaImages.first.semaphoreColor == LicenseSemaphore.red && monaImages.first.imageUrl == null);

  // 3. Verificar guías pedagógicas de Panofsky
  final vanGogh = artworks.firstWhere((a) => a.source == 'met');
  final guides = repo.getAnalysisGuides(vanGogh.id);
  test('Van Gogh tiene las 3 capas de Panofsky (formal, iconográfico, iconológico)',
    guides.length == 3 &&
    guides.any((g) => g.level == PanofskyLevel.formal) &&
    guides.any((g) => g.level == PanofskyLevel.iconographic) &&
    guides.any((g) => g.level == PanofskyLevel.iconological));

  // 4. Guardar y recuperar progreso de análisis del estudiante
  final progress = UserAnalysisProgress(
    id: 'prog-test-01',
    userId: 'user-estudiante-123',
    artworkId: vanGogh.id,
    level: PanofskyLevel.formal,
    userResponse: 'Observo un contraste llamativo entre los tonos amarillos del sombrero y el fondo azul.',
    regions: [
      AnnotationRegion(
        id: 'reg-01',
        x: 0.5,
        y: 0.4,
        width: 0.3,
        height: 0.3,
        label: 'Punto focal',
        notes: 'Mirada frontal directa con ojos verdes/azulados.',
        createdAt: DateTime.now(),
      )
    ],
    isCompleted: true,
    updatedAt: DateTime.now(),
  );

  repo.saveUserProgress(progress);
  final retrieved = repo.getUserProgress('user-estudiante-123', vanGogh.id, PanofskyLevel.formal);
  test('El progreso del estudiante persiste respuestas y regiones ROI anotadas',
    retrieved != null && retrieved.isCompleted && retrieved.regions.length == 1 && retrieved.userResponse.contains('sombrero'));

  print('========================================');
  print('RESULTADOS CATALOG: $passed APROBADOS, $failed FALLIDOS');
  print('========================================');
  if (failed > 0) throw Exception('$failed pruebas de Catalog fallaron.');
}
