import json

with open('C:/proyectos/arteapp/scripts/all_20_self_portraits_urls.json', 'r', encoding='utf-8') as f:
    urls = json.load(f)

with open('C:/proyectos/arteapp/scripts/curated_metadata.json', 'r', encoding='utf-8') as f:
    meta = json.load(f)

dart_code = '''import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:art_analyst_shared/shared.dart';

class ArtworkRepository {
  final String catalogBaseUrl;
  final String licensingBaseUrl;
  final bool enableRemoteBackend;

  ArtworkRepository({
    this.catalogBaseUrl = 'http://localhost:8080',
    this.licensingBaseUrl = 'http://localhost:8081',
    this.enableRemoteBackend = false,
  });

  // =========================================================================
  // CATÁLOGO COMPLETO DE OBRAS MAESTRAS (INCLUYE LOS 20 AUTORRETRATOS EN DOMINIO PÚBLICO)
  // =========================================================================
  final List<Artwork> _mockArtworks = const [
    // --- SESIÓN ESPECIAL: 20 AUTORRETRATOS FUNDAMENTALES EN DOMINIO PÚBLICO ---
'''

for m in meta:
    k = m['key']
    u = urls.get(k, {})
    thumb = u.get('thumb', '')
    dart_code += f'''    Artwork(
      id: '{m["id"]}',
      externalId: 'sp-{k}',
      source: 'wikimedia',
      title: '{m["title"]}',
      artistName: '{m["artist"]}',
      dateDisplay: '{m["year"]}',
      medium: '{m["medium"]}',
      dimensions: '{m["dims"]}',
      description: '{m["desc"].replace("'", "\\\\'")}',
      officialUrl: '{m["officialUrl"]}',
      department: '{m["movement"]}',
    ),
'''

dart_code += '''
    // --- OBRAS MAESTRAS HISTÓRICAS ADICIONALES DEL CATÁLOGO ---
    // 1. Postimpresionismo - Van Gogh (Sombrero de paja)
    Artwork(
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
      department: 'Postimpresionismo',
    ),
    // 2. Impresionismo - Monet
    Artwork(
      id: 'a2000000-0000-0000-0000-000000000002',
      externalId: '1915.534',
      source: 'cleveland',
      title: 'Nenúfares (Water Lilies)',
      artistName: 'Claude Monet',
      dateDisplay: 'c. 1915–1926',
      medium: 'Óleo sobre lienzo',
      dimensions: '201.3 x 426.1 cm',
      description: 'Monet disuelve el horizonte tradicional para sumergir al espectador en el reflejo de la luz sobre el agua en Giverny.',
      officialUrl: 'https://www.clevelandart.org/art/1915.534',
      department: 'Impresionismo',
    ),
    // 3. Barroco - Vermeer
    Artwork(
      id: 'a3000000-0000-0000-0000-000000000003',
      externalId: 'vermeer-pearl',
      source: 'wikimedia',
      title: 'La joven de la perla (Meisje met de parel)',
      artistName: 'Johannes Vermeer',
      dateDisplay: 'c. 1665',
      medium: 'Óleo sobre lienzo',
      dimensions: '44.5 x 39 cm',
      description: 'Obra cumbre del Barroco holandés, conocida como un "tronie": estudio de expresión y carácter con turbante exótico y un pendiente de perla con destello óptico singular.',
      officialUrl: 'https://www.mauritshuis.nl/en/our-collection/artworks/670-girl-with-a-pearl-earring/',
      department: 'Barroco',
    ),
    // 4. Romanticismo - Friedrich
    Artwork(
      id: 'a5000000-0000-0000-0000-000000000005',
      externalId: 'friedrich-wanderer',
      source: 'partner_museum',
      title: 'El caminante sobre el mar de nubes',
      artistName: 'Caspar David Friedrich',
      dateDisplay: '1818',
      medium: 'Óleo sobre lienzo',
      dimensions: '94.8 x 74.8 cm',
      description: 'Icono del Romanticismo alemán. Utiliza la figura de espaldas (Rückenfigur) para meditar sobre la inmensidad del infinito y la naturaleza sublime.',
      officialUrl: 'https://online-sammlung.hamburger-kunsthalle.de/de/objekt/HK-5161',
      department: 'Romanticismo',
    ),
    // 5. Renacimiento - Leonardo da Vinci
    Artwork(
      id: 'a4000000-0000-0000-0000-000000000004',
      externalId: 'cl010062370',
      source: 'louvre',
      title: 'Retrato de Lisa Gherardini (Mona Lisa / La Gioconda)',
      artistName: 'Leonardo da Vinci',
      dateDisplay: '1503–1519',
      medium: 'Óleo sobre tabla de álamo',
      dimensions: '77 x 53 cm',
      description: 'Célebre por el sfumato, la perspectiva aérea y su sonrisa enigmática. Reproducción oficial protegida por derechos de autor del Louvre.',
      officialUrl: 'https://collections.louvre.fr/en/ark:/53355/cl010062370',
      department: 'Renacimiento',
    ),
    // 6. Barroco - Rembrandt
    Artwork(
      id: 'a6000000-0000-0000-0000-000000000006',
      externalId: 'rembrandt-self',
      source: 'met',
      title: 'Autorretrato con boina y cuello alzado',
      artistName: 'Rembrandt van Rijn',
      dateDisplay: '1659',
      medium: 'Óleo sobre lienzo',
      dimensions: '84.5 x 66 cm',
      description: 'Magistral empleo del claroscuro barroco y empastes rugosos para retratar la introspección y vulnerabilidad en la madurez del artista.',
      officialUrl: 'https://www.nga.gov/collection/art-object-page.79.html',
      department: 'Barroco',
    ),
    // 7. Romanticismo - Goya
    Artwork(
      id: 'a7000000-0000-0000-0000-000000000007',
      externalId: 'goya-3mayo',
      source: 'wikimedia',
      title: 'El 3 de mayo en Madrid (Los fusilamientos)',
      artistName: 'Francisco de Goya',
      dateDisplay: '1814',
      medium: 'Óleo sobre lienzo',
      dimensions: '268 x 347 cm',
      description: 'Tragedia y fuerza expresiva precursora del arte moderno. El foco de luz sobre el héroe de camisa blanca condena la brutalidad de la guerra.',
      officialUrl: 'https://www.museodelprado.es/coleccion/obra-de-arte/el-3-de-mayo-en-madrid-o-los-fusilamientos/5e122e0d-29e6-4102-af45-c8a50eb50002',
      department: 'Romanticismo',
    ),
    // 8. Renacimiento - Botticelli
    Artwork(
      id: 'a8000000-0000-0000-0000-000000000008',
      externalId: 'botticelli-venus',
      source: 'wikimedia',
      title: 'El nacimiento de Venus',
      artistName: 'Sandro Botticelli',
      dateDisplay: 'c. 1485',
      medium: 'Tempera sobre lienzo',
      dimensions: '172.5 x 278.5 cm',
      description: 'Símbolo del Renacimiento florentino y el neoplatonismo. Destaca la pureza del contorno lineal frente a la tridimensionalidad volumétrica.',
      officialUrl: 'https://www.uffizi.it/en/artworks/birth-of-venus',
      department: 'Renacimiento',
    ),
    // 9. Impresionismo - Degas
    Artwork(
      id: 'a9000000-0000-0000-0000-000000000009',
      externalId: 'degas-dance',
      source: 'met',
      title: 'La clase de danza',
      artistName: 'Edgar Degas',
      dateDisplay: '1874',
      medium: 'Óleo sobre lienzo',
      dimensions: '85 x 75 cm',
      description: 'Composición atectónica y audaz con punto de vista sesgado, captando la tensión física y el movimiento espontáneo de las bailarinas.',
      officialUrl: 'https://www.metmuseum.org/art/collection/search/438817',
      department: 'Impresionismo',
    ),
    // 10. Postimpresionismo - Cézanne
    Artwork(
      id: 'a1000000-0000-0000-0000-000000000010',
      externalId: 'cezanne-cards',
      source: 'met',
      title: 'Los jugadores de cartas',
      artistName: 'Paul Cézanne',
      dateDisplay: 'c. 1890–1892',
      medium: 'Óleo sobre lienzo',
      dimensions: '65.4 x 81.9 cm',
      description: 'Estructuración geométrica del volumen pictórico. Cézanne convierte a los campesinos provenzales en una arquitectura monumental de color.',
      officialUrl: 'https://www.metmuseum.org/art/collection/search/435882',
      department: 'Postimpresionismo',
    ),
    // 11. Postimpresionismo - Van Gogh (Noche Estrellada)
    Artwork(
      id: 'a1100000-0000-0000-0000-000000000011',
      externalId: 'van-gogh-starry',
      source: 'wikimedia',
      title: 'La noche estrellada',
      artistName: 'Vincent van Gogh',
      dateDisplay: '1889',
      medium: 'Óleo sobre lienzo',
      dimensions: '73.7 x 92.1 cm',
      description: 'Visión visionaria del cosmos desde Saint-Rémy. Espirales celestes y contrastes de amarillos y azules que exteriorizan el alma del artista.',
      officialUrl: 'https://www.moma.org/collection/works/79802',
      department: 'Postimpresionismo',
    ),
    // 12. Impresionismo - Monet (Sol Naciente)
    Artwork(
      id: 'a1200000-0000-0000-0000-000000000012',
      externalId: 'monet-sunrise',
      source: 'wikimedia',
      title: 'Impresión, sol naciente',
      artistName: 'Claude Monet',
      dateDisplay: '1872',
      medium: 'Óleo sobre lienzo',
      dimensions: '48 x 63 cm',
      description: 'La obra que dio nombre al movimiento impresionista. El puerto de Le Havre envuelto en bruma matinal y pinceladas sintéticas y directas.',
      officialUrl: 'https://www.marmottan.fr/collections/impression-soleil-levant/',
      department: 'Impresionismo',
    ),
    // 13. Ukiyo-e - Hokusai
    Artwork(
      id: 'a1300000-0000-0000-0000-000000000013',
      externalId: 'hokusai-wave',
      source: 'met',
      title: 'Bajo la ola en alta mar en Kanagawa (La gran ola)',
      artistName: 'Katsushika Hokusai',
      dateDisplay: 'c. 1831',
      medium: 'Xilografía policroma sobre papel',
      dimensions: '25.7 x 37.8 cm',
      description: 'Cúspide del arte Ukiyo-e y su influencia en el Japonismo europeo. Dinamismo espiral de la ola frente a la serenidad inmóvil del Monte Fuji.',
      officialUrl: 'https://www.metmuseum.org/art/collection/search/45434',
      department: 'Ukiyo-e',
    ),
    // 14. Expresionismo - Munch
    Artwork(
      id: 'a1400000-0000-0000-0000-000000000014',
      externalId: 'munch-scream',
      source: 'wikimedia',
      title: 'El grito',
      artistName: 'Edvard Munch',
      dateDisplay: '1893',
      medium: 'Óleo, témpera y pastel sobre cartón',
      dimensions: '91 x 73.5 cm',
      description: 'Manifiesto universal de la angustia existencial moderna. Los ritmos ondulantes del paisaje reflejan el grito infinito que atraviesa la naturaleza.',
      officialUrl: 'https://www.nasjonalmuseet.no/en/collection/object/NG.M.00939',
      department: 'Expresionismo',
    ),
    // 15. Modernismo - Gustav Klimt
    Artwork(
      id: 'a1500000-0000-0000-0000-000000000015',
      externalId: 'klimt-kiss',
      source: 'wikimedia',
      title: 'El beso (Der Kuss)',
      artistName: 'Gustav Klimt',
      dateDisplay: '1907–1908',
      medium: 'Óleo y pan de oro sobre lienzo',
      dimensions: '180 x 180 cm',
      description: 'Punto culminante del Período Dorado de la Secesión vienesa. Fusión ornamental de mosaicos bizantinos, erotismo y abstracción geométrica.',
      officialUrl: 'https://www.belvedere.at/en/art/artworks/the-kiss',
      department: 'Modernismo',
    ),
  ];

  // =========================================================================
  // IMÁGENES Y METADATOS DE LICENCIA (TODOS LOS 20 AUTORRETRATOS EN VERDE CC0/PDM)
  // =========================================================================
  final Map<String, ArtworkImage> _mockImages = {
'''

for m in meta:
    k = m['key']
    u = urls.get(k, {})
    thumb = u.get('thumb', '')
    full = u.get('full', thumb)
    escaped_museum = m["museum"].replace("'", "\\'")
    dart_code += f'''    '{m["id"]}': const ArtworkImage(
      id: 'img-{k}',
      artworkId: '{m["id"]}',
      imageUrl: '{thumb}',
      thumbnailUrl: '{thumb}',
      licenseType: LicenseType.publicDomainMark,
      licenseUri: 'https://creativecommons.org/publicdomain/mark/1.0/',
      attributionText: '"{m["title"]}" por {m["artist"]} ({m["year"]}). {escaped_museum}. Dominio Público Internacional.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
'''

dart_code += '''
    // 1. Van Gogh - Verde CC0
    'a1000000-0000-0000-0000-000000000001': const ArtworkImage(
      id: 'img-01',
      artworkId: 'a1000000-0000-0000-0000-000000000001',
      imageUrl: 'assets/images/van_gogh.jpg',
      thumbnailUrl: 'assets/images/van_gogh.jpg',
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
      imageUrl: 'assets/images/monet.jpg',
      thumbnailUrl: 'assets/images/monet.jpg',
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
      imageUrl: 'assets/images/vermeer.jpg',
      thumbnailUrl: 'assets/images/vermeer.jpg',
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
      imageUrl: 'assets/images/friedrich.jpg',
      thumbnailUrl: 'assets/images/friedrich.jpg',
      licenseType: LicenseType.ccBySa,
      licenseUri: 'https://creativecommons.org/licenses/by-sa/4.0/',
      attributionText: '"El caminante sobre el mar de nubes" por Caspar David Friedrich. Hamburger Kunsthalle / CC BY-SA 4.0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.yellow,
      width: 1900,
      height: 2400,
    ),
    // 5. Mona Lisa - Rojo Derechos Reservados
    'a4000000-0000-0000-0000-000000000004': const ArtworkImage(
      id: 'img-04',
      artworkId: 'a4000000-0000-0000-0000-000000000004',
      imageUrl: null,
      thumbnailUrl: null,
      licenseType: LicenseType.copyright,
      licenseUri: '',
      attributionText: 'Derechos de reproducción reservados por Musée du Louvre / GrandPalaisRmn.',
      isWorldwide: false,
      semaphoreColor: LicenseSemaphore.red,
    ),
    // 6. Rembrandt - Verde CC0
    'a6000000-0000-0000-0000-000000000006': const ArtworkImage(
      id: 'img-06',
      artworkId: 'a6000000-0000-0000-0000-000000000006',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Rembrandt_van_Rijn_-_Self-Portrait_-_Google_Art_Project.jpg/1200px-Rembrandt_van_Rijn_-_Self-Portrait_-_Google_Art_Project.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Rembrandt_van_Rijn_-_Self-Portrait_-_Google_Art_Project.jpg/600px-Rembrandt_van_Rijn_-_Self-Portrait_-_Google_Art_Project.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"Autorretrato" por Rembrandt van Rijn. National Gallery of Art. Dominio Público CC0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 7. Goya - Verde CC0
    'a7000000-0000-0000-0000-000000000007': const ArtworkImage(
      id: 'img-07',
      artworkId: 'a7000000-0000-0000-0000-000000000007',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/El_tres_de_mayo_de_1808_en_Madrid_%282%29.jpg/1200px-El_tres_de_mayo_de_1808_en_Madrid_%282%29.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/El_tres_de_mayo_de_1808_en_Madrid_%282%29.jpg/600px-El_tres_de_mayo_de_1808_en_Madrid_%282%29.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"El 3 de mayo en Madrid" por Francisco de Goya. Museo del Prado. Dominio Público.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 8. Botticelli - Verde CC0
    'a8000000-0000-0000-0000-000000000008': const ArtworkImage(
      id: 'img-08',
      artworkId: 'a8000000-0000-0000-0000-000000000008',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg/1200px-Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg/600px-Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project_-_edited.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"El nacimiento de Venus" por Sandro Botticelli. Gallerie degli Uffizi. Dominio Público.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 9. Degas - Verde CC0
    'a9000000-0000-0000-0000-000000000009': const ArtworkImage(
      id: 'img-09',
      artworkId: 'a9000000-0000-0000-0000-000000000009',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Edgar_Degas_-_The_Dance_Class_-_1987.47.1_-_Metropolitan_Museum_of_Art.jpg/1200px-Edgar_Degas_-_The_Dance_Class_-_1987.47.1_-_Metropolitan_Museum_of_Art.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Edgar_Degas_-_The_Dance_Class_-_1987.47.1_-_Metropolitan_Museum_of_Art.jpg/600px-Edgar_Degas_-_The_Dance_Class_-_1987.47.1_-_Metropolitan_Museum_of_Art.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"La clase de danza" por Edgar Degas. The Metropolitan Museum of Art. Dominio Público CC0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 10. Cézanne - Verde CC0
    'a1000000-0000-0000-0000-000000000010': const ArtworkImage(
      id: 'img-10',
      artworkId: 'a1000000-0000-0000-0000-000000000010',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Paul_C%C3%A9zanne%2C_1892-95%2C_Les_joueurs_de_carte_%28The_Card_Players%29%2C_60_x_73_cm%2C_oil_on_canvas%2C_Courtauld_Institute_of_Art%2C_London.jpg/1200px-Paul_C%C3%A9zanne%2C_1892-95%2C_Les_joueurs_de_carte_%28The_Card_Players%29%2C_60_x_73_cm%2C_oil_on_canvas%2C_Courtauld_Institute_of_Art%2C_London.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Paul_C%C3%A9zanne%2C_1892-95%2C_Les_joueurs_de_carte_%28The_Card_Players%29%2C_60_x_73_cm%2C_oil_on_canvas%2C_Courtauld_Institute_of_Art%2C_London.jpg/600px-Paul_C%C3%A9zanne%2C_1892-95%2C_Les_joueurs_de_carte_%28The_Card_Players%29%2C_60_x_73_cm%2C_oil_on_canvas%2C_Courtauld_Institute_of_Art%2C_London.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"Los jugadores de cartas" por Paul Cézanne. The Metropolitan Museum of Art. Dominio Público CC0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 11. Van Gogh (Noche Estrellada) - Verde CC0
    'a1100000-0000-0000-0000-000000000011': const ArtworkImage(
      id: 'img-11',
      artworkId: 'a1100000-0000-0000-0000-000000000011',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/1200px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/600px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"La noche estrellada" por Vincent van Gogh. Museum of Modern Art (MoMA). Dominio Público.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 12. Monet (Sol Naciente) - Verde CC0
    'a1200000-0000-0000-0000-000000000012': const ArtworkImage(
      id: 'img-12',
      artworkId: 'a1200000-0000-0000-0000-000000000012',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Monet_-_Impression%2C_Sunrise.jpg/1200px-Monet_-_Impression%2C_Sunrise.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Monet_-_Impression%2C_Sunrise.jpg/600px-Monet_-_Impression%2C_Sunrise.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"Impresión, sol naciente" por Claude Monet. Musée Marmottan Monet. Dominio Público.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 13. Hokusai - Verde CC0
    'a1300000-0000-0000-0000-000000000013': const ArtworkImage(
      id: 'img-13',
      artworkId: 'a1300000-0000-0000-0000-000000000013',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Tsunami_by_hokusai_19th_century.jpg/1200px-Tsunami_by_hokusai_19th_century.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Tsunami_by_hokusai_19th_century.jpg/600px-Tsunami_by_hokusai_19th_century.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"La gran ola de Kanagawa" por Katsushika Hokusai. The Metropolitan Museum of Art. Dominio Público CC0.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 14. Munch - Verde CC0
    'a1400000-0000-0000-0000-000000000014': const ArtworkImage(
      id: 'img-14',
      artworkId: 'a1400000-0000-0000-0000-000000000014',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg/1200px-Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg/600px-Edvard_Munch%2C_1893%2C_The_Scream%2C_oil%2C_tempera_and_pastel_on_cardboard%2C_91_x_73_cm%2C_National_Gallery_of_Norway.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"El grito" por Edvard Munch. Galería Nacional de Noruega. Dominio Público.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
    // 15. Klimt - Verde CC0
    'a1500000-0000-0000-0000-000000000015': const ArtworkImage(
      id: 'img-15',
      artworkId: 'a1500000-0000-0000-0000-000000000015',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/The_Kiss_-_Gustav_Klimt_-_Google_Cultural_Institute.jpg/1200px-The_Kiss_-_Gustav_Klimt_-_Google_Cultural_Institute.jpg',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/The_Kiss_-_Gustav_Klimt_-_Google_Cultural_Institute.jpg/600px-The_Kiss_-_Gustav_Klimt_-_Google_Cultural_Institute.jpg',
      licenseType: LicenseType.cc0,
      licenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      attributionText: '"El beso" por Gustav Klimt. Österreichische Galerie Belvedere. Dominio Público.',
      isWorldwide: true,
      semaphoreColor: LicenseSemaphore.green,
    ),
  };

  /// Lista de acceso directo a los 20 autorretratos en Dominio Público
  List<Artwork> get selfPortraitArtworks => _mockArtworks.where((a) => a.id.startsWith('sp')).toList();

  Future<List<Artwork>> fetchArtworks() async {
    if (enableRemoteBackend) {
      try {
        final res = await http.get(Uri.parse('$catalogBaseUrl/api/v1/artworks')).timeout(const Duration(milliseconds: 800));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final list = data['artworks'] as List<dynamic>;
          return list.map((a) => Artwork.fromJson(a as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }
    return _mockArtworks;
  }

  Future<Map<String, ArtworkImage>> fetchPrimaryImages() async {
    return _mockImages;
  }

  Future<List<AnalysisGuide>> fetchGuides(String artworkId) async {
    if (enableRemoteBackend) {
      try {
        final res = await http.get(Uri.parse('$catalogBaseUrl/api/v1/artworks/$artworkId/guides')).timeout(const Duration(milliseconds: 800));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final list = data['guides'] as List<dynamic>;
          return list.map((g) => AnalysisGuide.fromJson(g as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }

    // Guías pedagógicas específicas para los 20 autorretratos
    final spGuide = _selfPortraitGuides[artworkId];
    if (spGuide != null) {
      return spGuide;
    }

    // Guía genérica por defecto
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

  // Diccionario de guías Panofsky detalladas para cada uno de los 20 autorretratos
  static final Map<String, List<AnalysisGuide>> _selfPortraitGuides = {
'''

def esc(s):
    return s.replace("'", "\\'").replace('\n', ' ')

for m in meta:
    dart_code += f'''    '{m["id"]}': [
      AnalysisGuide(
        id: 'g-{m["key"]}-1',
        artworkId: '{m["id"]}',
        level: PanofskyLevel.formal,
        prompt: '{esc(m["formalPrompt"])}',
        modelAnswer: '{esc(m["formalAns"])}',
        hints: const ['Aplica los 5 pares de Heinrich Wölfflin', 'Revisa si predomina la línea precisa o la mancha pictórica'],
        orderIndex: 1,
      ),
      AnalysisGuide(
        id: 'g-{m["key"]}-2',
        artworkId: '{m["id"]}',
        level: PanofskyLevel.iconographic,
        prompt: '{esc(m["iconPrompt"])}',
        modelAnswer: '{esc(m["iconAns"])}',
        hints: const ['Observa la indumentaria, las manos y los objetos del taller', 'Identifica el tema convencional o alegórico'],
        orderIndex: 2,
      ),
      AnalysisGuide(
        id: 'g-{m["key"]}-3',
        artworkId: '{m["id"]}',
        level: PanofskyLevel.iconological,
        prompt: '{esc(m["iconoPrompt"])}',
        modelAnswer: '{esc(m["iconoAns"])}',
        hints: const ['Conecta con el contexto político, social y filosófico de la época', 'Considera el cambio de estatus del artista'],
        orderIndex: 3,
      ),
    ],
'''

dart_code += '''  };

  Future<List<UserAnalysisProgress>> fetchUserProgress(String userId, String artworkId) async {
    return [];
  }

  Future<void> saveProgress(UserAnalysisProgress progress) async {
    if (enableRemoteBackend) {
      try {
        await http.post(
          Uri.parse('$catalogBaseUrl/api/v1/users/${progress.userId}/progress'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(progress.toJson()),
        ).timeout(const Duration(milliseconds: 800));
      } catch (_) {}
    }
  }
}
'''

with open('C:/proyectos/arteapp/packages/app/lib/data/repositories/artwork_repository.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print('Generated artwork_repository.dart successfully.')
