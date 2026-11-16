import 'package:art_analyst_shared/shared.dart';

/// In-memory & DB-capable repository for artworks and their images.
class CatalogRepository {
  final Map<String, Artwork> _artworks = {};
  final Map<String, List<ArtworkImage>> _images = {};
  final Map<String, List<AnalysisGuide>> _guides = {};
  final Map<String, UserAnalysisProgress> _userProgress = {};

  CatalogRepository() {
    _seedInitialData();
  }

  void _seedInitialData() {
    // 1. Van Gogh - The Met (Green CC0)
    const art1 = Artwork(
      id: 'a1000000-0000-0000-0000-000000000001',
      externalId: '436535',
      source: 'met',
      title: 'Autorretrato con sombrero de paja',
      artistName: 'Vincent van Gogh',
      dateDisplay: '1887',
      medium: 'Óleo sobre lienzo montado sobre tabla',
      dimensions: '40.6 x 31.8 cm',
      description: 'Pintado en París en el verano de 1887, este autorretrato demuestra el dominio de Van Gogh de la técnica postimpresionista y el uso expresivo de colores complementarios.',
      officialUrl: 'https://www.metmuseum.org/art/collection/search/436535',
      department: 'Pintura Europea',
    );
    _artworks[art1.id] = art1;
    _images[art1.id] = [
      const ArtworkImage(
        id: 'img-vg-01',
        artworkId: art1.id,
        imageUrl: 'https://images.metmuseum.org/CRDImages/ep/original/DT1502_cropped2.jpg',
        thumbnailUrl: 'https://images.metmuseum.org/CRDImages/ep/web-large/DT1502_cropped2.jpg',
        licenseType: LicenseType.cc0,
        licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
        attributionText: '"Autorretrato con sombrero de paja" por Vincent van Gogh. Colección: The Metropolitan Museum of Art (Open Access). Licencia: Dominio Público CC0.',
        isWorldwide: true,
        semaphoreColor: LicenseSemaphore.green,
        width: 2718,
        height: 3420,
      )
    ];
    _guides[art1.id] = [
      const AnalysisGuide(
        id: 'guide-vg-01',
        artworkId: art1.id,
        level: PanofskyLevel.formal,
        prompt: '1. Nivel Formal: Observa la dirección de las pinceladas y la relación cromática entre el sombrero y el fondo. ¿Qué efecto óptico genera el uso de colores complementarios?',
        modelAnswer: 'Van Gogh yuxtapone amarillos y anaranjados brillantes en el sombrero frente al azul violáceo y verde del fondo. Las pinceladas rítmicas y radiales emanan del rostro hacia afuera, creando un dinamismo centrífugo que focaliza la tensión en los ojos penetrantes del pintor.',
        hints: [
          'Presta atención a la rueda de colores: el azul y el naranja son complementarios.',
          'Nota cómo los trazos de óleo tienen textura matérica visible (empaste).'
        ],
        exerciseType: InteractiveExerciseType.focalPointSelect,
        exerciseConfig: {'targetX': 0.50, 'targetY': 0.42, 'tolerance': 0.15},
        orderIndex: 1,
      ),
      const AnalysisGuide(
        id: 'guide-vg-02',
        artworkId: art1.id,
        level: PanofskyLevel.iconographic,
        prompt: '2. Nivel Iconográfico: Identifica los atributos personales del retratado (el sombrero de paja, la camisa campesina). ¿Qué mensaje simbólico comunica esta elección indumentaria?',
        modelAnswer: 'El sombrero de paja y la vestimenta rústica vinculan a Van Gogh con los campesinos y labradores, a quienes consideraba portadores de una dignidad moral superior frente a la burguesía urbana académica.',
        hints: [
          '¿Cómo solían vestir los pintores académicos de la época en sus autorretratos oficiales?',
          'Recuerda las obras tempranas de Van Gogh en Nuenen, como "Los comedores de patatas".'
        ],
        exerciseType: InteractiveExerciseType.regionAnnotationTag,
        exerciseConfig: {'requiredCategory': 'symbol'},
        orderIndex: 2,
      ),
      const AnalysisGuide(
        id: 'guide-vg-03',
        artworkId: art1.id,
        level: PanofskyLevel.iconological,
        prompt: '3. Nivel Iconológico: ¿Qué manifiesta esta obra sobre la transición de la pintura occidental a finales del siglo XIX hacia la subjetividad y la vanguardia?',
        modelAnswer: 'Marca la superación del Naturalismo e Impresionismo documental: el arte ya no busca reflejar la apariencia externa de las cosas, sino exteriorizar el estado psíquico y espiritual del creador, anticipando el Expresionismo del siglo XX.',
        hints: [
          'Reflexiona sobre el aislamiento social del artista en la gran ciudad moderna.',
          'Considera cómo el color adquiere un valor emocional autónomo.'
        ],
        exerciseType: InteractiveExerciseType.openReflection,
        orderIndex: 3,
      ),
    ];

    // 2. Claude Monet - Cleveland Museum (Green CC0)
    const art2 = Artwork(
      id: 'a2000000-0000-0000-0000-000000000002',
      externalId: '1915.534',
      source: 'cleveland',
      title: 'Nenúfares (Water Lilies)',
      artistName: 'Claude Monet',
      dateDisplay: 'c. 1915–1926',
      medium: 'Óleo sobre lienzo',
      dimensions: '201.3 x 426.1 cm',
      description: 'Monet disuelve el horizonte tradicional para sumergir al observador directamente en la superficie del estanque de Giverny.',
      officialUrl: 'https://www.clevelandart.org/art/1915.534',
      department: 'Pintura Moderna Europea',
    );
    _artworks[art2.id] = art2;
    _images[art2.id] = [
      const ArtworkImage(
        id: 'img-monet-01',
        artworkId: art2.id,
        imageUrl: 'https://openaccess-cdn.clevelandart.org/1915.534/1915.534_web.jpg',
        thumbnailUrl: 'https://openaccess-cdn.clevelandart.org/1915.534/1915.534_thumb.jpg',
        licenseType: LicenseType.cc0,
        licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
        attributionText: '"Nenúfares" por Claude Monet. Cleveland Museum of Art (Open Access). Dominio Público CC0.',
        isWorldwide: true,
        semaphoreColor: LicenseSemaphore.green,
        width: 2800,
        height: 3274,
      )
    ];
    _guides[art2.id] = [
      const AnalysisGuide(
        id: 'guide-monet-01',
        artworkId: art2.id,
        level: PanofskyLevel.formal,
        prompt: '1. Nivel Formal: Examina la ausencia de horizonte y la relación entre masa y vacío cromático. ¿Cómo estructura Monet el espacio pictórico?',
        modelAnswer: 'Al suprimir la línea de tierra y de cielo, el lienzo se convierte en un continuo bidimensional donde agua y reflejo se confunden. La pincelada gestual y amplia genera una vibración atmosférica sin punto de fuga euclidiano.',
        hints: ['Busca dónde termina el agua y dónde empieza la orilla: ¿existe esa división?'],
        exerciseType: InteractiveExerciseType.colorPaletteInspect,
        orderIndex: 1,
      ),
      const AnalysisGuide(
        id: 'guide-monet-02',
        artworkId: art2.id,
        level: PanofskyLevel.iconographic,
        prompt: '2. Nivel Iconográfico: ¿Qué papel juegan el nenúfar y el sauce llorón reflejado como motivos poéticos?',
        modelAnswer: 'Los nenúfares flotantes representan puntos de anclaje visual y reposo, mientras que las ramas invisibles del sauce que solo vemos en su reflejo evocan la melancolía y el duelo de la Primera Guerra Mundial.',
        hints: ['Considera los años de creación: 1914-1918 en plena Gran Guerra.'],
        exerciseType: InteractiveExerciseType.regionAnnotationTag,
        orderIndex: 2,
      ),
      const AnalysisGuide(
        id: 'guide-monet-03',
        artworkId: art2.id,
        level: PanofskyLevel.iconological,
        prompt: '3. Nivel Iconológico: ¿De qué manera esta serie anticipa el Expresionismo Abstracto (Pollock, Rothko) de mediados del siglo XX?',
        modelAnswer: 'La pintura "all-over" (todo el lienzo cubierto sin jerarquía de centro ni bordes) y la escala monumental transforman el cuadro en un entorno inmersivo donde el espectador ya no contempla desde afuera, sino que habita el espacio pictórico.',
        hints: ['Compara el tratamiento con los grandes murales del Expresionismo Abstracto neoyorquino.'],
        exerciseType: InteractiveExerciseType.openReflection,
        orderIndex: 3,
      ),
    ];

    // 3. Vermeer - Mauritshuis / Wikimedia Worldwide CC0 (Green CC0)
    const art3 = Artwork(
      id: 'a3000000-0000-0000-0000-000000000003',
      externalId: 'vermeer-pearl',
      source: 'wikimedia',
      title: 'La joven de la perla (Meisje met de parel)',
      artistName: 'Johannes Vermeer',
      dateDisplay: 'c. 1665',
      medium: 'Óleo sobre lienzo',
      dimensions: '44.5 x 39 cm',
      description: 'Una de las obras maestras del Barroco holandés, conocida como un "tronie": estudio de expresión y carácter con turbante oriental y un pendiente de perla de brillo singular.',
      officialUrl: 'https://www.mauritshuis.nl/en/our-collection/artworks/670-girl-with-a-pearl-earring/',
      department: 'Barroco Holandés',
    );
    _artworks[art3.id] = art3;
    _images[art3.id] = [
      const ArtworkImage(
        id: 'img-vermeer-01',
        artworkId: art3.id,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/1665_Girl_with_a_Pearl_Earring.jpg',
        thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/1665_Girl_with_a_Pearl_Earring.jpg/500px-1665_Girl_with_a_Pearl_Earring.jpg',
        licenseType: LicenseType.publicDomainMark,
        licenseUri: 'https://creativecommons.org/publicdomain/mark/1.0/',
        attributionText: '"La joven de la perla" por Johannes Vermeer. Mauritshuis. Dominio Público Mundial (PDM).',
        isWorldwide: true,
        semaphoreColor: LicenseSemaphore.green,
        width: 1400,
        height: 1600,
      )
    ];
    _guides[art3.id] = [
      const AnalysisGuide(
        id: 'guide-vermeer-01',
        artworkId: art3.id,
        level: PanofskyLevel.formal,
        prompt: '1. Nivel Formal: Observa el contraste de luz (claroscuro) y la técnica del reflejo en la perla y los labios húmedos.',
        modelAnswer: 'Vermeer crea la perla con apenas dos pinceladas: un toque de empaste blanco en la parte superior donde incide la luz directa de la izquierda, y un reflejo suave en la base inferior que recoge la luz reflejada del cuello blanco.',
        hints: ['Haz zoom sobre el pendiente: ¿está completamente delineado o sugerido por toques de luz?'],
        exerciseType: InteractiveExerciseType.focalPointSelect,
        exerciseConfig: {'targetX': 0.48, 'targetY': 0.58, 'tolerance': 0.12},
        orderIndex: 1,
      ),
      const AnalysisGuide(
        id: 'guide-vermeer-02',
        artworkId: art3.id,
        level: PanofskyLevel.iconographic,
        prompt: '2. Nivel Iconográfico: ¿Es este cuadro un retrato o un "tronie"? ¿Qué simbolismo aporta el turbante oriental y la perla?',
        modelAnswer: 'No es un retrato formal de encargo sino un "tronie", un estudio de fisonomía y ropaje exótico. La perla en el siglo XVII holandés simbolizaba tanto la pureza femenina como el refinamiento y la riqueza mercantil.',
        hints: ['En el siglo XVII Delft era un centro cosmopolita conectado con la Compañía Holandesa de las Indias Orientales.'],
        exerciseType: InteractiveExerciseType.regionAnnotationTag,
        orderIndex: 2,
      ),
      const AnalysisGuide(
        id: 'guide-vermeer-03',
        artworkId: art3.id,
        level: PanofskyLevel.iconological,
        prompt: '3. Nivel Iconológico: ¿Qué nos enseña sobre la sociedad burguesa de la Edad de Oro holandesa y su comercio global?',
        modelAnswer: 'A diferencia del arte monárquico o católico de Francia o España, el arte holandés se orienta al coleccionismo privado burgués. El turbante de seda y el azul de ultramar (lapis lázuli afgano) atestiguan las rutas globales de comercio que convirtieron a la República Holandesa en potencia comercial.',
        hints: ['El pigmento azul de ultramar era más costoso que el oro en esa época.'],
        exerciseType: InteractiveExerciseType.openReflection,
        orderIndex: 3,
      ),
    ];

    // 4. Leonardo da Vinci - Mona Lisa (Musée du Louvre - RED Semáforo)
    const art4 = Artwork(
      id: 'a4000000-0000-0000-0000-000000000004',
      externalId: 'cl010062370',
      source: 'louvre',
      title: 'Retrato de Lisa Gherardini (Mona Lisa / La Gioconda)',
      artistName: 'Leonardo da Vinci',
      dateDisplay: '1503–1519',
      medium: 'Óleo sobre tabla de álamo',
      dimensions: '77 x 53 cm',
      description: 'Célebre por el uso magistral del sfumato y su sonrisa enigmática. La reproducción digital oficial se encuentra bajo derechos reservados del Musée du Louvre / GrandPalaisRmn.',
      officialUrl: 'https://collections.louvre.fr/en/ark:/53355/cl010062370',
      department: 'Peintures italiennes',
    );
    _artworks[art4.id] = art4;
    _images[art4.id] = [
      const ArtworkImage(
        id: 'img-mona-01',
        artworkId: art4.id,
        imageUrl: null, // Protegido: la app NO aloja ni muestra imágenes con semáforo Rojo
        thumbnailUrl: null,
        licenseType: LicenseType.copyright,
        licenseUri: '',
        attributionText: 'Derechos de reproducción digital reservados por Musée du Louvre / GrandPalaisRmn.',
        isWorldwide: false,
        semaphoreColor: LicenseSemaphore.red,
      )
    ];
    _guides[art4.id] = [
      const AnalysisGuide(
        id: 'guide-mona-01',
        artworkId: art4.id,
        level: PanofskyLevel.formal,
        prompt: '1. Nivel Formal: Explica la técnica del sfumato y la composición piramidal renacentista.',
        modelAnswer: 'Leonardo difumina los contornos mediante capas veladas y translúcidas de óleo, eliminando las líneas duras especialmente en las comisuras de los ojos y la boca, generando una transición imperceptible entre luz y sombra.',
        hints: ['Sfumato proviene de "fumo" (humo en italiano).'],
        exerciseType: InteractiveExerciseType.openReflection,
        orderIndex: 1,
      ),
      const AnalysisGuide(
        id: 'guide-mona-02',
        artworkId: art4.id,
        level: PanofskyLevel.iconographic,
        prompt: '2. Nivel Iconográfico: Analiza el velo (guarnello) y el paisaje primordial de fondo sin presencia humana visible.',
        modelAnswer: 'El sutil velo de gasa que cubre su cabello era característico de las mujeres embarazadas o recién dadas a luz en la Florencia del Cinquecento. El paisaje geológico de puentes y rocas conecta el cuerpo humano (microcosmos) con la naturaleza viva de la Tierra (macrocosmos).',
        hints: ['Investiga el concepto de microcosmos y macrocosmos en los tratados de anatomía de Leonardo.'],
        exerciseType: InteractiveExerciseType.openReflection,
        orderIndex: 2,
      ),
      const AnalysisGuide(
        id: 'guide-mona-03',
        artworkId: art4.id,
        level: PanofskyLevel.iconological,
        prompt: '3. Nivel Iconológico: ¿Cómo representa la Mona Lisa el ideal humanista del Alto Renacimiento italiano?',
        modelAnswer: 'Consagra la confianza renacentista en la razón, la observación empírica de la naturaleza y la dignidad humana. El retrato trasciende la mera efigie nobiliaria para convertirse en arquetipo de la psique humana universal.',
        hints: ['Compara con el humanismo de Marsilio Ficino y la corte de los Médici.'],
        exerciseType: InteractiveExerciseType.openReflection,
        orderIndex: 3,
      ),
    ];
  }

  List<Artwork> getAllArtworks() => _artworks.values.toList();

  Artwork? getArtworkById(String id) => _artworks[id];

  List<ArtworkImage> getArtworkImages(String artworkId) => _images[artworkId] ?? [];

  List<AnalysisGuide> getAnalysisGuides(String artworkId) => _guides[artworkId] ?? [];

  UserAnalysisProgress? getUserProgress(String userId, String artworkId, PanofskyLevel level) {
    final key = '$userId:$artworkId:${level.code}';
    return _userProgress[key];
  }

  List<UserAnalysisProgress> getAllUserProgress(String userId, String artworkId) {
    return _userProgress.values
        .where((p) => p.userId == userId && p.artworkId == artworkId)
        .toList();
  }

  UserAnalysisProgress saveUserProgress(UserAnalysisProgress progress) {
    final key = '${progress.userId}:${progress.artworkId}:${progress.level.code}';
    _userProgress[key] = progress;
    return progress;
  }
}
