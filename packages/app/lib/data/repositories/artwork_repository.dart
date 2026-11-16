import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:art_analyst_shared/shared.dart';

class ArtworkRepository {
  final String catalogBaseUrl;
  final String licensingBaseUrl;

  ArtworkRepository({
    this.catalogBaseUrl = 'http://localhost:8080',
    this.licensingBaseUrl = 'http://localhost:8081',
  });

  // Built-in fallback dataset with CORS-friendly URLs guaranteeing flawless rendering
  final List<Artwork> _mockArtworks = const [
    Artwork(
      id: 'a1000000-0000-0000-0000-000000000001',
      externalId: '436535',
      source: 'met',
      title: 'Autorretrato con sombrero de paja',
      artistName: 'Vincent van Gogh',
      dateDisplay: '1887',
      medium: 'Óleo sobre lienzo montado sobre tabla',
      dimensions: '40.6 x 31.8 cm',
      description: 'Pintado en París en el verano de 1887, este autorretrato demuestra el dominio de Van Gogh de la técnica postimpresionista y el uso de colores complementarios.',
      officialUrl: 'https://www.metmuseum.org/art/collection/search/436535',
      department: 'Pintura Europea',
    ),
    Artwork(
      id: 'a2000000-0000-0000-0000-000000000002',
      externalId: '1915.534',
      source: 'cleveland',
      title: 'Nenúfares (Water Lilies)',
      artistName: 'Claude Monet',
      dateDisplay: 'c. 1915–1926',
      medium: 'Óleo sobre lienzo',
      dimensions: '201.3 x 426.1 cm',
      description: 'Monet disuelve el horizonte tradicional para sumergir al espectador en el reflejo del agua.',
      officialUrl: 'https://www.clevelandart.org/art/1915.534',
      department: 'Pintura Moderna Europea',
    ),
    Artwork(
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
    ),
    Artwork(
      id: 'a5000000-0000-0000-0000-000000000005',
      externalId: 'friedrich-wanderer',
      source: 'partner_museum',
      title: 'El caminante sobre el mar de nubes',
      artistName: 'Caspar David Friedrich',
      dateDisplay: '1818',
      medium: 'Óleo sobre lienzo',
      dimensions: '94.8 x 74.8 cm',
      description: 'Obra cumbre del Romanticismo alemán. Utiliza la figura de espaldas (Rückenfigur) para meditar sobre la inmensidad del infinito y la naturaleza sublime.',
      officialUrl: 'https://online-sammlung.hamburger-kunsthalle.de/de/objekt/HK-5161',
      department: 'Romanticismo',
    ),
    Artwork(
      id: 'a4000000-0000-0000-0000-000000000004',
      externalId: 'cl010062370',
      source: 'louvre',
      title: 'Retrato de Lisa Gherardini (Mona Lisa / La Gioconda)',
      artistName: 'Leonardo da Vinci',
      dateDisplay: '1503–1519',
      medium: 'Óleo sobre tabla de álamo',
      dimensions: '77 x 53 cm',
      description: 'Célebre por el sfumato y su sonrisa enigmática. Reproducción oficial protegida por derechos de autor del Louvre.',
      officialUrl: 'https://collections.louvre.fr/en/ark:/53355/cl010062370',
      department: 'Peintures italiennes',
    ),
  ];

  final Map<String, ArtworkImage> _mockImages = {
    // 1. Van Gogh - Verde CC0
    'a1000000-0000-0000-0000-000000000001': const ArtworkImage(
      id: 'img-01',
      artworkId: 'a1000000-0000-0000-0000-000000000001',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Vincent_van_Gogh_-_Self-Portrait_with_Straw_Hat_-_Google_Art_Project.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Vincent_van_Gogh_-_Self-Portrait_with_Straw_Hat_-_Google_Art_Project.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"Autorretrato con sombrero de paja" por Vincent van Gogh. The Metropolitan Museum of Art. Dominio Público CC0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
      width: 2718,
      height: 3420,
    ),
    // 2. Monet - Verde CC0
    'a2000000-0000-0000-0000-000000000002': const ArtworkImage(
      id: 'img-02',
      artworkId: 'a2000000-0000-0000-0000-000000000002',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Claude_Monet_-_Water_Lilies_-_Google_Art_Project.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Claude_Monet_-_Water_Lilies_-_Google_Art_Project.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"Nenúfares" por Claude Monet. Cleveland Museum of Art. Dominio Público CC0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
      width: 2800,
      height: 3274,
    ),
    // 3. Vermeer - Verde PDM
    'a3000000-0000-0000-0000-000000000003': const ArtworkImage(
      id: 'img-03',
      artworkId: 'a3000000-0000-0000-0000-000000000003',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/1665_Girl_with_a_Pearl_Earring.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/1665_Girl_with_a_Pearl_Earring.jpg',
      licenseType: LicenseType.publicDomainMark,
      licenseUri: 'https://creativecommons.org/publicdomain/mark/1.0/',
      attributionText: '"La joven de la perla" por Johannes Vermeer. Mauritshuis. Dominio Público Mundial (PDM).',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
      width: 1400,
      height: 1600,
    ),
    // 4. Caspar David Friedrich - Amarillo CC BY-SA
    'a5000000-0000-0000-0000-000000000005': const ArtworkImage(
      id: 'img-05',
      artworkId: 'a5000000-0000-0000-0000-000000000005',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b9/Caspar_David_Friedrich_-_Wanderer_above_the_sea_of_fog.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/b/b9/Caspar_David_Friedrich_-_Wanderer_above_the_sea_of_fog.jpg',
      licenseType: LicenseType.ccBySa,
      licenseUri: 'https://creativecommons.org/licenses/by-sa/4.0/',
      attributionText: '"El caminante sobre el mar de nubes" por Caspar David Friedrich. Hamburger Kunsthalle / Reproducción digital bajo CC BY-SA 4.0. Las obras derivadas deben compartirse con la misma licencia.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.yellow,
      width: 1900,
      height: 2400,
    ),
    // 5. Mona Lisa - Rojo Derechos Reservados
    'a4000000-0000-0000-0000-000000000004': const ArtworkImage(
      id: 'img-04',
      artworkId: 'a4000000-0000-0000-0000-000000000004',
      imageUrl: null, // Protected under Red semaphore
      thumbnailUrl: null,
      licenseType: LicenseType.copyright,
      licenseUri: '',
      attributionText: 'Derechos de reproducción reservados por Musée du Louvre / GrandPalaisRmn.',
      isWorldwide: false,
      semaphoreColor: LicenseSemaphore.red,
    ),
  };

  Future<List<Artwork>> fetchArtworks() async {
    try {
      final res = await http.get(Uri.parse('$catalogBaseUrl/api/v1/artworks')).timeout(const Duration(milliseconds: 800));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['artworks'] as List<dynamic>;
        return list.map((a) => Artwork.fromJson(a as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return _mockArtworks;
  }

  Future<Map<String, ArtworkImage>> fetchPrimaryImages() async {
    return _mockImages;
  }

  Future<List<AnalysisGuide>> fetchGuides(String artworkId) async {
    try {
      final res = await http.get(Uri.parse('$catalogBaseUrl/api/v1/artworks/$artworkId/guides')).timeout(const Duration(milliseconds: 800));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = data['guides'] as List<dynamic>;
        return list.map((g) => AnalysisGuide.fromJson(g as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return [
      AnalysisGuide(
        id: 'guide-01',
        artworkId: artworkId,
        level: PanofskyLevel.formal,
        prompt: '1. Nivel Formal: Observa la dirección de las pinceladas y la relación cromática. ¿Qué efecto genera el contraste y la textura?',
        modelAnswer: 'La yuxtaposición cromática de colores complementarios y el trazo rítmico generan dinamismo centrífugo focalizado en el centro de interés.',
        hints: const ['Presta atención a la dirección de los trazos', 'Observa los colores cálidos frente a los fríos'],
        orderIndex: 1,
      ),
      AnalysisGuide(
        id: 'guide-02',
        artworkId: artworkId,
        level: PanofskyLevel.iconographic,
        prompt: '2. Nivel Iconográfico: Identifica los atributos y objetos representados. ¿Qué significado simbólico transmiten?',
        modelAnswer: 'La indumentaria y los atributos conectan al personaje con valores de sencillez, pureza moral y trabajo manual frente a las convenciones de la época.',
        hints: const ['Compara la indumentaria con retratos formales de la época'],
        orderIndex: 2,
      ),
      AnalysisGuide(
        id: 'guide-03',
        artworkId: artworkId,
        level: PanofskyLevel.iconological,
        prompt: '3. Nivel Iconológico: ¿Qué nos dice esta obra sobre la época histórica y la evolución del arte?',
        modelAnswer: 'Refleja la transición hacia la subjetividad y la afirmación de la autonomía expresiva del artista frente a las exigencias académicas tradicionales.',
        hints: const ['Considera el contexto social e industrial'],
        orderIndex: 3,
      ),
    ];
  }

  Future<List<UserAnalysisProgress>> fetchUserProgress(String userId, String artworkId) async {
    return [];
  }

  Future<void> saveProgress(UserAnalysisProgress progress) async {
    try {
      await http.post(
        Uri.parse('$catalogBaseUrl/api/v1/users/${progress.userId}/progress'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(progress.toJson()),
      ).timeout(const Duration(milliseconds: 800));
    } catch (_) {}
  }
}
