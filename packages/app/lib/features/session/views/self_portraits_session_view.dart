import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:art_analyst_shared/shared.dart';
import 'package:art_analyst_app/core/widgets/smart_artwork_image.dart';
import 'package:art_analyst_app/features/catalog/cubit/catalog_cubit.dart';
import 'package:art_analyst_app/features/catalog/cubit/catalog_state.dart';
import 'package:art_analyst_app/features/analysis/cubit/analysis_cubit.dart';

/// Vista interactiva dedicada a la Sesión Pedagógica de Autorretratos en Dominio Público.
/// Diseñada para estudiantes y docentes: incluye galería filtrada de las 20 obras,
/// ruta didáctica de 4 estaciones con preguntas de alto orden (Fórmula de las 4 Partes)
/// y guía del taller de creación con rúbrica formativa.
class SelfPortraitsSessionView extends StatefulWidget {
  final int initialTab;

  const SelfPortraitsSessionView({super.key, this.initialTab = 0});

  @override
  State<SelfPortraitsSessionView> createState() => _SelfPortraitsSessionViewState();
}

class _SelfPortraitsSessionViewState extends State<SelfPortraitsSessionView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedMovement;

  // Mapa de focos de análisis visual según el documento curricular
  static const Map<String, String> _analysisFocus = {
    'sp01-durero-1500': 'Línea y Textura: Detalle minucioso de rizos y piel. Pose similar a Cristo.',
    'sp02-parmigianino-1524': 'Forma: Distorsión óptica y cómo el soporte convexo influye en la composición.',
    'sp03-sofonisba-1556': 'Propósito: La mujer artista reafirmando su oficio frente al caballete.',
    'sp04-leonardo-1512': 'Línea y Sombra: Uso del sfumato y dibujo a tiza roja (sanguina).',
    'sp05-tiziano-1567': 'Color: Pincelada suelta y atmósfera crepuscular de la vejez.',
    'sp06-rubens-1609': 'Textura y Composición: El lujo de las sedas y el lazo conyugal (dextrarum iunctio).',
    'sp07-leyster-1630': 'Expresión: Dinamismo, captura del instante y maestría en la sonrisa.',
    'sp08-artemisia-1638': 'Forma y Escorzo: Ángulo dinámico inusual y la acción física de pintar.',
    'sp09-velazquez-1656': 'Contexto y Espacio: El artista dentro de la corte y el juego metanarrativo de miradas.',
    'sp10-rembrandt-1665': 'Luz y Claroscuro: Manejo de sombras para crear profundidad psicológica y arcos de Giotto.',
    'sp11-vigeelbrun-1782': 'Color y Luz: Frescura de los tonos y luminosidad de la luz natural indirecta.',
    'sp12-goya-1795': 'Luz y Contraluz: Fuerte contraste entre el ventanal y la figura con sombrero de velas.',
    'sp13-courbet-1843': 'Expresión y Gesto: Exageración gestual visceral e impacto emocional en primer plano.',
    'sp14-friedrich-1810': 'Línea y Mirada: Austeridad tonal, mirada penetrante y recogimiento romántico.',
    'sp15-cezanne-1875': 'Forma: Simplificación geométrica del rostro en volúmenes y facetas cromáticas.',
    'sp16-cassatt-1878': 'Color y Asimetría: Técnica al gouache, dinamismo diagonal y mujer cosmopolita.',
    'sp17-monet-1886': 'Luz y Pincelada: Cómo la luz disuelve los bordes y contornos académicos.',
    'sp18-vangogh-1889': 'Pincelada y Color: Líneas curvas estriadas y contraste de colores complementarios.',
    'sp19-gauguin-1893': 'Color Arbitrario: Masas de color plano y ruptura con la mímesis ilusionista.',
    'sp20-schiele-1910': 'Línea Expresiva: Trazo quebrado, tenso y deformación corporal expresionista.',
  };

  @override
  void initState() {
    super.initState();
    final tab = widget.initialTab.clamp(0, 2);
    _tabController = TabController(length: 3, vsync: this, initialIndex: tab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openArtworkAnalysis(BuildContext context, Artwork artwork, ArtworkImage? image) {
    context.read<AnalysisCubit>().loadArtworkAnalysis(artwork, image);
    context.go('/artwork/${artwork.id}');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver al catálogo',
          onPressed: () => context.go('/catalog'),
        ),
        title: Row(
          children: [
            const Icon(Icons.face_retouching_natural_rounded, color: Color(0xFF8B4513)),
            const SizedBox(width: 10),
            Text(
              'Sesión: 20 Autorretratos en Dominio Público',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 13.5),
          tabs: const [
            Tab(
              icon: Icon(Icons.grid_view_rounded),
              text: 'Galería de los 20 Autorretratos',
            ),
            Tab(
              icon: Icon(Icons.alt_route_rounded),
              text: 'Ruta: 4 Estaciones de Aprendizaje',
            ),
            Tab(
              icon: Icon(Icons.draw_rounded),
              text: 'Taller Creativo & Rúbrica',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGalleryTab(context, isDark),
          _buildStationsTab(context, isDark),
          _buildWorkshopTab(context, isDark),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 1: GALERÍA DE LOS 20 AUTORRETRATOS
  // =========================================================================
  Widget _buildGalleryTab(BuildContext context, bool isDark) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state is CatalogLoading || state is CatalogInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CatalogError) {
          return Center(child: Text(state.message));
        }

        final loaded = state as CatalogLoaded;
        // Filtrar exclusivamente los 20 autorretratos en Dominio Público (prefijo sp)
        final allSelfPortraits = loaded.artworks.where((a) => a.id.startsWith('sp')).toList();

        final filtered = _selectedMovement == null
            ? allSelfPortraits
            : allSelfPortraits.where((a) => (a.department ?? '').toLowerCase() == _selectedMovement!.toLowerCase()).toList();

        final movements = [
          'Todos',
          'Renacimiento',
          'Manierismo',
          'Barroco',
          'Rococó',
          'Romanticismo',
          'Realismo',
          'Impresionismo',
          'Postimpresionismo',
          'Expresionismo',
        ];

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Banner pedagógico
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A2311), Color(0xFF7E3B16)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              '🟢 20 Obras 100% Libres de Derechos',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Colección Curada 2026',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'El Espejo del Tiempo: Autorretratos y la Identidad Visual',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selección de 20 autorretratos fundamentales en Dominio Público Internacional, organizados cronológicamente desde el Renacimiento hasta las Vanguardias. Cada obra cuenta con visor de alta definición, superposición geométrica, paleta cromática interactiva y preguntas guiadas según el método de Panofsky y Wölfflin.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: 14.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Selector horizontal de movimientos
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: movements.map((mov) {
                  final isSelected = mov == 'Todos' ? _selectedMovement == null : _selectedMovement == mov;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(mov),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedMovement = mov == 'Todos' ? null : mov;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Contador de obras
            Text(
              'Mostrando ${filtered.length} de ${allSelfPortraits.length} autorretratos en Dominio Público',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 14),

            // Grid responsivo de tarjetas
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth >= 1100) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth >= 800) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth >= 520) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final artwork = filtered[index];
                    final image = loaded.primaryImages[artwork.id];
                    final focusText = _analysisFocus[artwork.id] ?? 'Análisis del lenguaje visual y contexto histórico.';

                    return _buildArtworkCard(context, artwork, image, focusText, isDark);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildArtworkCard(
    BuildContext context,
    Artwork artwork,
    ArtworkImage? image,
    String focusText,
    bool isDark,
  ) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => _openArtworkAnalysis(context, artwork, image),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la obra
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SmartArtworkImage(
                    artworkId: artwork.id,
                    imageUrl: image?.imageUrl,
                    fit: BoxFit.cover,
                    placeholderTitle: artwork.title,
                    placeholderArtist: artwork.artistName,
                  ),
                  // Badge verde de Dominio Público
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black38, blurRadius: 4),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Dominio Público',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Chip de movimiento
                  if (artwork.department != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          artwork.department!,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Información y Foco de Análisis
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artwork.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${artwork.artistName ?? "Anónimo"} (${artwork.dateDisplay ?? ""})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2B2520) : const Color(0xFFF7F3EE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: Text(
                        focusText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: isDark ? const Color(0xFFFFD8A8) : const Color(0xFF8B4513),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () => _openArtworkAnalysis(context, artwork, image),
                        icon: const Icon(Icons.analytics_outlined, size: 16),
                        label: const Text('Analizar en Visor', style: TextStyle(fontSize: 12.5)),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 2: RUTA DIDÁCTICA - 4 ESTACIONES DE APRENDIZAJE
  // =========================================================================
  Widget _buildStationsTab(BuildContext context, bool isDark) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state is! CatalogLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final loaded = state;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Cabecera metodológica
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF261D17) : const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF8B4513).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology_rounded, color: Color(0xFF8B4513), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Ruta Metodológica de Análisis (Bloom + Panofsky + Wölfflin)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cada estación aborda un problema estético clave del autorretrato mediante preguntas formuladas con la Fórmula de las 4 Partes:\n[Disparador abierto] + [Verbo de habilidad de alto orden] + [Contenido técnico] + [Contexto del estudiante].',
                    style: TextStyle(fontSize: 13.5, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Estación 1
            _buildStationCard(
              context,
              number: 1,
              title: 'La Afirmación Profesional de la Mujer Artista',
              epoch: 'Renacimiento & Barroco (Siglos XVI y XVII)',
              wolfflinFocus: 'Lineal vs. Pictórico | Superficial vs. Profundo | Forma Abierta',
              questionDisparador: '¿Cómo...',
              questionVerbo: 'reinterpretarías...',
              questionTecnico: 'los atributos del caballete, el tiento y el pincel de Artemisia y Sofonisba...',
              questionContexto: 'para representar un talento, afición o destreza que sientes poco valorada en tu entorno cotidiano?',
              artworkIds: ['sp03-sofonisba-1556', 'sp08-artemisia-1638'],
              loaded: loaded,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // Estación 2
            _buildStationCard(
              context,
              number: 2,
              title: 'El Claroscuro Psicológico y la Mirada',
              epoch: 'Barroco & Romanticismo (Siglos XVII y XVIII)',
              wolfflinFocus: 'Claridad absoluta vs. Claridad relativa (penumbra) | Masa sobre contorno',
              questionDisparador: '¿De qué manera...',
              questionVerbo: 'utilizarías...',
              questionTecnico: 'el contraste de claroscuro y los empastes lumínicos de Rembrandt y Goya...',
              questionContexto: 'para destacar en un autorretrato aquella parte de tu personalidad que mantienes en reserva frente al resto?',
              artworkIds: ['sp10-rembrandt-1665', 'sp12-goya-1795'],
              loaded: loaded,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // Estación 3
            _buildStationCard(
              context,
              number: 3,
              title: 'La Pincelada Expresiva y el Color Arbitrario',
              epoch: 'Postimpresionismo & Simbolismo (Finales del siglo XIX)',
              wolfflinFocus: 'Fuerza cromática de complementarios | Textura táctil visible | Forma Abierta',
              questionDisparador: '¿Por qué...',
              questionVerbo: 'elegirías...',
              questionTecnico: 'una paleta de colores complementarios vibrantes o masas cromáticas no miméticas...',
              questionContexto: 'para comunicar en tu rostro el clima emocional de una jornada difícil o transformadora en tu vida?',
              artworkIds: ['sp18-vangogh-1889', 'sp19-gauguin-1893'],
              loaded: loaded,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // Estación 4
            _buildStationCard(
              context,
              number: 4,
              title: 'La Tensión Expresionista de la Línea y el Cuerpo',
              epoch: 'Realismo & Expresionismo (Siglos XIX y XX)',
              wolfflinFocus: 'Línea quebrada no academicista | Tensión de superficie en primer plano',
              questionDisparador: '¿Qué pasaría si...',
              questionVerbo: 'alteraras...',
              questionTecnico: 'la proporción anatómica de las líneas de tus manos y rostro como Schiele y Courbet...',
              questionContexto: 'para evidenciar una tensión o energía vital intensa que experimentas en tu vida diaria?',
              artworkIds: ['sp20-schiele-1910', 'sp13-courbet-1843'],
              loaded: loaded,
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStationCard(
    BuildContext context, {
    required int number,
    required String title,
    required String epoch,
    required String wolfflinFocus,
    required String questionDisparador,
    required String questionVerbo,
    required String questionTecnico,
    required String questionContexto,
    required List<String> artworkIds,
    required CatalogLoaded loaded,
    required bool isDark,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header estación
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF8B4513),
                  child: Text(
                    '$number',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estación $number: $title',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        epoch,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Foco de Wölfflin
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2833) : const Color(0xFFEBF3FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.remove_red_eye_outlined, size: 18, color: Color(0xFF1976D2)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fórmula Óptica de Wölfflin: $wolfflinFocus',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Pregunta de Alto Orden Cognitivo con Fórmula de las 4 Partes
            const Text(
              'Pregunta de Alto Orden Cognitivo (Fórmula de las 4 Partes):',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E2218) : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5)),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: questionDisparador,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE65100)),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: questionVerbo,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: questionTecnico,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: questionContexto,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1565C0)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Obras maestras de la estación
            const Text(
              'Obras en Dominio Público para Analizar en Esta Estación:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: artworkIds.map((id) {
                final art = loaded.artworks.firstWhere((a) => a.id == id, orElse: () => loaded.artworks.first);
                final img = loaded.primaryImages[id];

                return SizedBox(
                  width: 320,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    tileColor: isDark ? const Color(0xFF241E1A) : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: SmartArtworkImage(
                          artworkId: art.id,
                          imageUrl: img?.thumbnailUrl ?? img?.imageUrl,
                          fallbackUrl: img?.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      art.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${art.artistName} (${art.dateDisplay})',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: FilledButton.tonal(
                      onPressed: () => _openArtworkAnalysis(context, art, img),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Visor', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 3: TALLER CREATIVO & RÚBRICA FORMATIVA
  // =========================================================================
  Widget _buildWorkshopTab(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // Guía del taller
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E4057), Color(0xFF1D2D44)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.palette_rounded, color: Colors.amberAccent, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Taller de Creación: "Mi Autorretrato Intencionado"',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Consigna para los estudiantes: Diseña un boceto de tu autorretrato eligiendo conscientemente una sola decisión formal orientada a comunicar una dimensión de tu identidad personal, escolar o comunitaria.',
                style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 14.5, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Las 3 Estrategias Formales
        const Text(
          'Elige 1 de las 3 Estrategias Técnicas Fundamentales:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildStrategyCard(
          icon: Icons.light_mode_outlined,
          color: Colors.amber.shade800,
          title: 'Estrategia 1: Claroscuro Psicológico (Rembrandt / Goya)',
          description:
              'Trabaja sombras profundas con carboncillo, grafito blando o aguada. Deja que la luz impacte selectivamente en una sola zona del rostro para insinuar introspección o misterio.',
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _buildStrategyCard(
          icon: Icons.color_lens_outlined,
          color: Colors.pink.shade700,
          title: 'Estrategia 2: Color Subjetivo y Complementarios (Van Gogh / Gauguin)',
          description:
              'Abandona el tono realista de la piel. Selecciona 2 colores complementarios (ej. azul/naranja o violeta/amarillo) o tintas planas para exteriorizar un estado de ánimo o tensión emocional.',
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _buildStrategyCard(
          icon: Icons.gesture_rounded,
          color: Colors.teal.shade700,
          title: 'Estrategia 3: Línea Expresiva Quebrada (Schiele / Durero)',
          description:
              'Prioriza el dibujo de contorno enfatizando la angulosidad de los dedos, la rigidez o la pose del cuerpo frente al vacío para comunicar energía contenida o vulnerabilidad.',
          isDark: isDark,
        ),
        const SizedBox(height: 24),

        // Ficha conceptual
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF26201B) : const Color(0xFFF9F6F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ficha Conceptual de Entrega (Al reverso del trabajo):',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '1. ¿Qué estrategia formal elegiste (Línea, Color o Claroscuro) y a qué artista de la sesión tomaste como referente?\n'
                '2. ¿Qué rasgo de tu identidad o de tu contexto quisiste comunicar?\n'
                '3. ¿Por qué consideras que esta decisión formal expresa mejor tu intención que una fotografía instantánea de celular?',
                style: TextStyle(fontSize: 13, height: 1.5, color: isDark ? Colors.white70 : Colors.black87),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Rúbrica formativa
        const Text(
          'Rúbrica de Evaluación Formativa:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildRubricTable(isDark),
      ],
    );
  }

  Widget _buildStrategyCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRubricTable(bool isDark) {
    final rows = [
      {
        'crit': 'Análisis Visual (Panofsky/Wölfflin)',
        'dest': 'Identifica con precisión elementos formales (línea, claroscuro, color) y los conecta fluidamente con el significado simbólico y social.',
        'comp': 'Reconoce los elementos formales principales y describe el tema de la obra de manera coherente.',
        'bas': 'Menciona solo aspectos evidentes o literales de la obra sin profundizar en el lenguaje visual.',
      },
      {
        'crit': 'Fórmula de las 4 Partes (Cognición Alta)',
        'dest': 'Argumenta con vocabulario disciplinar fundamentando su postura desde su propia experiencia y contexto.',
        'comp': 'Responde vinculando el concepto técnico con su realidad de forma comprensible.',
        'bas': 'Responde con frases breves sin justificar la elección técnica ni conectarla con el contexto.',
      },
      {
        'crit': 'Taller de Creación Intencionada',
        'dest': 'La propuesta visual evidencia una clara intención estética (color, línea o claroscuro) coherente con la ficha conceptual.',
        'comp': 'Aplica una técnica formal visible y redacta una breve explicación de su autorretrato.',
        'bas': 'El trabajo presenta el rostro pero sin una decisión técnica clara o sin justificación.',
      },
      {
        'crit': 'Conciencia de Propiedad Intelectual',
        'dest': 'Comprende el valor del Dominio Público, reconoce por qué estas 20 obras se pueden reutilizar libremente y cita adecuadamente.',
        'comp': 'Reconoce la diferencia entre obras libres de derechos y obras protegidas por derechos reservados.',
        'bas': 'Identifica con dificultad si una imagen es de uso libre o protegida.',
      },
    ];

    return Column(
      children: rows.map((r) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r['crit']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Color(0xFF8B4513)),
                ),
                const SizedBox(height: 8),
                _buildRubricRow('🌟 Destacado (4 pts): ', r['dest']!, const Color(0xFF2E7D32), isDark),
                const SizedBox(height: 4),
                _buildRubricRow('✓ Competente (3 pts): ', r['comp']!, const Color(0xFF1565C0), isDark),
                const SizedBox(height: 4),
                _buildRubricRow('△ Básico (2 pts): ', r['bas']!, const Color(0xFFE65100), isDark),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRubricRow(String label, String text, Color labelColor, bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12.5, height: 1.35, color: isDark ? Colors.white70 : Colors.black87),
        children: [
          TextSpan(text: label, style: TextStyle(fontWeight: FontWeight.bold, color: labelColor)),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
