import '../lib/shared.dart';

void main() {
  print('--- EJECUTANDO PRUEBAS UNITARIAS: LICENSE EVALUATOR & MODELS ---');
  int passed = 0;
  int failed = 0;

  void test(String description, void Function() body) {
    try {
      body();
      print(' [PASS] $description');
      passed++;
    } catch (e, st) {
      print(' [FAIL] $description: $e\n$st');
      failed++;
    }
  }

  void expect(dynamic actual, dynamic expected) {
    if (actual != expected) {
      throw Exception('Esperado "$expected", pero se obtuvo "$actual"');
    }
  }

  // 1. The Met (CC0 Open Access)
  test('The Met con isPublicDomain=true debe ser VERDE CC0', () {
    final result = LicenseEvaluator.evaluate(
      source: 'met',
      isOpenAccessFlag: true,
      title: 'Self-Portrait with a Straw Hat',
      artistName: 'Vincent van Gogh',
      institution: 'The Met',
      officialSourceUrl: 'https://www.metmuseum.org/art/collection/search/436535',
    );
    expect(result.semaphore, LicenseSemaphore.green);
    expect(result.licenseType, LicenseType.cc0);
    expect(result.canDisplayImage, true);
    expect(result.isWorldwide, true);
    expect(result.attributionText!.contains('The Metropolitan Museum of Art'), true);
  });

  test('The Met con isPublicDomain=false debe ser ROJO', () {
    final result = LicenseEvaluator.evaluate(
      source: 'met',
      isOpenAccessFlag: false,
      title: 'Modern Art Piece',
      artistName: 'Contemporary Artist',
      institution: 'The Met',
    );
    expect(result.semaphore, LicenseSemaphore.red);
    expect(result.canDisplayImage, false);
  });

  // 2. Cleveland Museum of Art (CC0)
  test('Cleveland Museum con CC0 debe ser VERDE', () {
    final result = LicenseEvaluator.evaluate(
      source: 'cleveland',
      isOpenAccessFlag: true,
      rawLicenseText: 'CC0',
      title: 'Water Lilies',
      artistName: 'Claude Monet',
      institution: 'Cleveland Museum of Art',
    );
    expect(result.semaphore, LicenseSemaphore.green);
    expect(result.licenseType, LicenseType.cc0);
    expect(result.canDisplayImage, true);
  });

  // 3. Wikimedia Commons con filtro estricto
  test('Wikimedia con CC0 mundial debe ser VERDE', () {
    final result = LicenseEvaluator.evaluate(
      source: 'wikimedia',
      rawLicenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      isWorldwideFlag: true,
      title: 'Girl with a Pearl Earring',
      artistName: 'Johannes Vermeer',
      institution: 'Mauritshuis',
    );
    expect(result.semaphore, LicenseSemaphore.green);
    expect(result.canDisplayImage, true);
  });

  test('Wikimedia con pd-us (limitada a EE.UU.) debe ser rechazada y marcada como ROJA', () {
    final result = LicenseEvaluator.evaluate(
      source: 'wikimedia',
      rawLicenseUri: 'https://creativecommons.org/publicdomain/mark/1.0/',
      jurisdictionConstraint: 'pd-us', // Restricción no mundial
      title: 'US Regional Archive Photo',
      institution: 'Wikimedia',
    );
    expect(result.semaphore, LicenseSemaphore.red);
    expect(result.canDisplayImage, false);
    expect(result.legalReason.contains('limitada territorialmente'), true);
  });

  test('Wikimedia con CC-BY debe ser rechazada (ArtAnalyst solo acepta CC0/PDM mundial de agregadores)', () {
    final result = LicenseEvaluator.evaluate(
      source: 'wikimedia',
      rawLicenseUri: 'https://creativecommons.org/licenses/by/4.0/',
      title: 'User Photograph of Sculpture',
      institution: 'Wikimedia',
    );
    expect(result.semaphore, LicenseSemaphore.red);
    expect(result.canDisplayImage, false);
  });

  // 4. Creative Commons con atribución de museos aliados (AMARILLO)
  test('Museo aliado con CC BY-SA debe ser AMARILLO y advertir ShareAlike', () {
    final result = LicenseEvaluator.evaluate(
      source: 'partner_museum',
      rawLicenseUri: 'https://creativecommons.org/licenses/by-sa/4.0/',
      title: 'Historical Manuscript',
      artistName: 'Monje Copista',
      institution: 'Biblioteca Digital',
    );
    expect(result.semaphore, LicenseSemaphore.yellow);
    expect(result.licenseType, LicenseType.ccBySa);
    expect(result.canDisplayImage, true);
    expect(result.attributionText!.contains('ShareAlike'), true);
  });

  // 5. Obras con derechos reservados / Copyright (ROJO)
  test('Museo del Prado o Louvre con copyright fotográfico debe ser ROJO', () {
    final result = LicenseEvaluator.evaluate(
      source: 'louvre',
      rawLicenseText: 'All rights reserved - Réunion des Musées Nationaux',
      title: 'Mona Lisa',
      artistName: 'Leonardo da Vinci',
      institution: 'Musée du Louvre',
      officialSourceUrl: 'https://collections.louvre.fr/en/ark:/53355/cl010062370',
    );
    expect(result.semaphore, LicenseSemaphore.red);
    expect(result.canDisplayImage, false);
    expect(result.officialSourceUrl != null, true);
  });

  // 6. Serialización y deserialización de modelos
  test('Artwork y ArtworkImage serializan correctamente', () {
    final artwork = Artwork(
      id: 'art-001',
      externalId: '436535',
      source: 'met',
      title: 'Self-Portrait with a Straw Hat',
      artistName: 'Vincent van Gogh',
      dateDisplay: '1887',
      medium: 'Oil on canvas',
    );
    final json = artwork.toJson();
    final restored = Artwork.fromJson(json);
    expect(restored.id, artwork.id);
    expect(restored.title, artwork.title);
    expect(restored.artistName, artwork.artistName);

    final image = ArtworkImage(
      id: 'img-001',
      artworkId: 'art-001',
      imageUrl: 'https://images.metmuseum.org/CRDImages/ep/original/DT1502_cropped2.jpg',
      licenseType: LicenseType.cc0,
      semaphoreColor: LicenseSemaphore.green,
      isWorldwide: true,
    );
    final imgJson = image.toJson();
    final imgRestored = ArtworkImage.fromJson(imgJson);
    expect(imgRestored.canDisplayDirectly, true);
    expect(imgRestored.semaphoreColor, LicenseSemaphore.green);
  });

  // 7. Panofsky Levels y progreso
  test('PanofskyLevel y AnalysisGuide funcionan correctamente', () {
    final guide = AnalysisGuide(
      id: 'guide-01',
      artworkId: 'art-001',
      level: PanofskyLevel.formal,
      prompt: '¿Cómo incide la luz sobre el rostro y el sombrero?',
      modelAnswer: 'La luz proviene desde la izquierda en un marcado claroscuro...',
      orderIndex: 1,
    );
    expect(guide.level.code, 'formal');
    expect(guide.level.subtopics.length, 4);

    final region = AnnotationRegion(
      id: 'reg-01',
      x: 0.35,
      y: 0.25,
      width: 0.30,
      height: 0.40,
      label: 'Rostro y mirada',
      notes: 'Pinceladas directas y empastadas en tonos ocres y verdes complementarios.',
      category: 'brushwork',
      createdAt: DateTime.now(),
    );
    expect(region.label, 'Rostro y mirada');
  });

  print('========================================');
  print('RESULTADOS: $passed APROBADOS, $failed FALLIDOS');
  print('========================================');
  if (failed > 0) throw Exception('$failed pruebas fallaron.');
}
