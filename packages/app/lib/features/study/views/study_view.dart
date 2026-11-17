import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_analyst_app/features/catalog/cubit/catalog_cubit.dart';

class StudyView extends StatefulWidget {
  final int initialTab;

  const StudyView({super.key, this.initialTab = 0});

  @override
  State<StudyView> createState() => _StudyViewState();
}

class _StudyViewState extends State<StudyView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final tabIndex = widget.initialTab.clamp(0, 3);
    _tabController = TabController(length: 4, vsync: this, initialIndex: tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: Text(
          'Guía Metodológica y Estudio de Arte',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 13.5),
          tabs: const [
            Tab(icon: Icon(Icons.auto_stories_rounded), text: 'Metodología (Panofsky & Wölfflin)'),
            Tab(icon: Icon(Icons.palette_rounded), text: 'Movimientos & Exponentes'),
            Tab(icon: Icon(Icons.touch_app_rounded), text: '¿Cómo Funciona la App?'),
            Tab(icon: Icon(Icons.quiz_rounded), text: 'Taller & Autoevaluación'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMethodologyTab(context, isDark),
          _buildMovementsTab(context, isDark),
          _buildHowAppWorksTab(context, isDark),
          _buildQuizTab(context, isDark),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 1: METODOLOGÍA DE ANÁLISIS VISUAL (PANOFSKY & WÖLFFLIN)
  // =========================================================================
  Widget _buildMethodologyTab(BuildContext context, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Hero Banner
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5D2E0C), Color(0xFF8B4513)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'El Método Canónico de Análisis Visual',
                              style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Síntesis de Erwin Panofsky y Heinrich Wölfflin',
                              style: TextStyle(color: Color(0xFFFFE0B2), fontSize: 14.5, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Analizar una obra no es expresar una opinión subjetiva de agrado, sino descifrar un lenguaje formal, simbólico y cultural. '
                    'Este método estructura la mirada en 4 pasos progresivos: desde las formas puras hasta la verificación histórica que evita el anacronismo.',
                    style: TextStyle(color: Colors.white, fontSize: 15.5, height: 1.55),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            InkWell(
              onTap: () => context.go('/session/self-portraits'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E2018) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF8B4513).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.face_retouching_natural_rounded, color: Color(0xFF8B4513), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sesión de Aplicación: 20 Autorretratos en Dominio Público',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Aplica la metodología Panofsky-Wölfflin en 4 estaciones y con la Fórmula de las 4 Partes.',
                            style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF8B4513)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // PASO 1
            _buildStepCard(
              context: context,
              isDark: isDark,
              stepNumber: 1,
              title: 'Paso 1: Descripción Pre-iconográfica y Análisis Formal',
              subtitle: 'La observación empírica de formas, colores y el esquema óptico',
              sourceReference: 'Panofsky (1979) • Wölfflin (1915/2017)',
              accentColor: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
              icon: Icons.brush_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'La observación inicial debe centrarse estrictamente en los elementos visibles básicos y en cómo se configuran las formas en el lienzo:',
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.5,
                      color: isDark ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Identificación de motivos artísticos',
                    text: 'Reconoce las formas puras: configuraciones de líneas, planos de color, texturas y volúmenes tridimensionales que representan objetos naturales, seres humanos, plantas o arquitecturas.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Significación fáctica y significación expresiva',
                    text: '• Fáctica: lo que los personajes hacen literalmente (un hombre que camina, una mujer que sostiene un paño).\n'
                        '• Expresiva: la atmósfera psicológica y emotiva (una postura doliente, la serenidad en la mirada o la agitación de una escena), descifrable mediante la experiencia práctica cotidiana.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 18),
                  Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  const SizedBox(height: 12),
                  // WOLFFLIN SECTION
                  Row(
                    children: [
                      Icon(Icons.visibility_rounded, color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1), size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Análisis del Esquema Óptico (Los 5 pares de Heinrich Wölfflin)',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Heinrich Wölfflin sistematizó la evolución de la mirada entre el Renacimiento y el Barroco en cinco conceptos contrapuestos para entender cómo organiza el artista la visión:',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildWolfflinPair(
                    isDark: isDark,
                    title: '1. Lo lineal frente a lo pictórico',
                    contrastA: 'Lineal (visión táctil/plástica):',
                    descA: 'Destaca contornos precisos y límites rígidos. El dibujo aísla cada objeto como un cuerpo tangible con límites claros.',
                    contrastB: 'Pictórico (visión óptica):',
                    descB: 'Se basa en manchas cromáticas, masas de luz y sombras continuas. Los bordes se desvanecen y la luz funde las figuras con el entorno.',
                  ),
                  const SizedBox(height: 12),
                  _buildWolfflinPair(
                    isDark: isDark,
                    title: '2. Lo superficial frente a lo profundo',
                    contrastA: 'Superficial (plano):',
                    descA: 'Los elementos se ordenan en planos estratificados paralelos al espectador (organización en frisos o franjas frontales).',
                    contrastB: 'Profundo (espacio penetrado):',
                    descB: 'La composición rompe el plano y penetra en profundidad mediante diagonales dinámicas, escorzos pronunciados y planos sesgados.',
                  ),
                  const SizedBox(height: 12),
                  _buildWolfflinPair(
                    isDark: isDark,
                    title: '3. Forma cerrada frente a forma abierta',
                    contrastA: 'Forma cerrada (tectónica):',
                    descA: 'Composición autosuficiente, simétrica y equilibrada, regida por horizontales y verticales que se cierran sobre el marco del cuadro.',
                    contrastB: 'Forma abierta (atectónica):',
                    descB: 'Líneas diagonales y fugas que aluden intencionalmente a lo que está fuera del cuadro; sensación de instante fugaz y espacio ilimitado.',
                  ),
                  const SizedBox(height: 12),
                  _buildWolfflinPair(
                    isDark: isDark,
                    title: '4. Pluralidad frente a unidad',
                    contrastA: 'Pluralidad (articulación múltiple):',
                    descA: 'Cada componente y detalle conserva su independencia formal y cromática dentro del conjunto armónico.',
                    contrastB: 'Unidad (subordinación unificada):',
                    descB: 'Todos los elementos se subordinan a un único motivo dominante, flujo de luz o centro visual rector que suprime la autonomía de las partes.',
                  ),
                  const SizedBox(height: 12),
                  _buildWolfflinPair(
                    isDark: isDark,
                    title: '5. Claridad absoluta frente a claridad relativa (oscuridad)',
                    contrastA: 'Claridad absoluta:',
                    descA: 'La forma de cada objeto se muestra por entero al primer golpe de vista bajo una iluminación uniforme y comprensiva.',
                    contrastB: 'Claridad relativa:',
                    descB: 'La obra evita revelar la forma por completo; usa claroscuros intensos, sombras enigmáticas y zonas que el espectador debe intuir.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PASO 2
            _buildStepCard(
              context: context,
              isDark: isDark,
              stepNumber: 2,
              title: 'Paso 2: Análisis Iconográfico',
              subtitle: 'El significado secundario o convencional: historias, alegorías y fuentes',
              sourceReference: 'Panofsky, Erwin (1979)',
              accentColor: isDark ? const Color(0xFFFF8A65) : const Color(0xFFD84315),
              icon: Icons.auto_stories_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Una vez definida la forma pura y los motivos, el análisis avanza hacia el significado secundario o convencional de la obra:',
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.5,
                      color: isDark ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Identificación de temas, alegorías y conceptos',
                    text: 'Relaciona los motivos visuales con imágenes, historias y alegorías codificadas. Por ejemplo, una figura femenina con balanza y espada se identifica como la Alegoría de la Justicia, o una mujer con turbante y perla se reconoce como un estudio de carácter o "tronie".',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Consulta rigurosa de fuentes',
                    text: 'Para comprender este nivel, se recurre a la familiaridad con fuentes literarias, teológicas, mitológicas, poemas de época o la tradición oral que el artista y sus contemporáneos conocían íntimamente.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PASO 3
            _buildStepCard(
              context: context,
              isDark: isDark,
              stepNumber: 3,
              title: 'Paso 3: Interpretación Iconológica',
              subtitle: 'La significación intrínseca: la obra como síntoma de una cosmovisión cultural',
              sourceReference: 'Panofsky, Erwin (1979)',
              accentColor: isDark ? const Color(0xFFBA68C8) : const Color(0xFF6A1B9A),
              icon: Icons.lightbulb_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'El paso cumbre busca comprender la obra de arte como documento vivo y síntoma de un contexto histórico, filosófico y social más amplio:',
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.5,
                      color: isDark ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Significación intrínseca o contenido',
                    text: 'Investiga los principios subyacentes que revelan la mentalidad básica de una nación, una época histórica, una clase social o una convicción religiosa y filosófica, matizada por la personalidad individual del artista.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Valores simbólicos de la forma y el tema',
                    text: 'Interpreta las formas (el color, la pincelada, la composición) y las historias como manifestaciones de estos principios profundos (ej. el uso del espacio infinito en Friedrich como expresión de la sublimidad romántica).',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    isDark: isDark,
                    title: 'Intuición sintética',
                    text: 'Facultad mental del historiador para integrar todos los datos formales, iconográficos y documentales en un todo articulado y coherente.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PASO 4
            _buildStepCard(
              context: context,
              isDark: isDark,
              stepNumber: 4,
              title: 'Paso 4: Verificación Histórica (Principios Correctivos)',
              subtitle: 'El control contra la subjetividad, las proyecciones y el anacronismo',
              sourceReference: 'Panofsky, Erwin (1979)',
              accentColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
              icon: Icons.verified_user_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Para evitar que la experiencia personal, la fantasía o la intuición desvíen el análisis hacia el anacronismo, Erwin Panofsky estableció que cada nivel debe estar respaldado por un control histórico riguroso de la tradición:',
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.5,
                      color: isDark ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildCorrectionCard(
                    isDark: isDark,
                    levelNumber: 'Para el Paso 1 (Formal)',
                    title: 'Historia del Estilo',
                    description: 'Corrige la descripción de las formas investigando cómo, en distintas condiciones históricas, los objetos y acontecimientos se expresaban mediante líneas, luces y colores. Evita interpretar un escorzo renacentista con la sensibilidad visual del siglo XXI.',
                  ),
                  const SizedBox(height: 12),
                  _buildCorrectionCard(
                    isDark: isDark,
                    levelNumber: 'Para el Paso 2 (Iconográfico)',
                    title: 'Historia de los Tipos',
                    description: 'Corrige el análisis de historias y alegorías investigando cómo temas específicos se expresaban convencionalmente a través de ciertos objetos, poses y atributos en diferentes épocas (tipología iconográfica).',
                  ),
                  const SizedBox(height: 12),
                  _buildCorrectionCard(
                    isDark: isDark,
                    levelNumber: 'Para el Paso 3 (Iconológico)',
                    title: 'Historia de los Síntomas Culturales',
                    description: 'Corrige la interpretación profunda comparando la obra con otros documentos y testimonios culturales coetáneos (literatura, filosofía, política, teología) para verificar cómo las tendencias esenciales de la mente humana se manifestaron efectivamente en ese momento.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Cuadro Sinóptico adaptativo para móviles y escritorio
            _buildSinopticSection(context, isDark),

            const SizedBox(height: 32),

            // Call to action button to Catalog con alto contraste
            Center(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => context.go('/catalog'),
                icon: const Icon(Icons.palette_rounded, color: Colors.white, size: 24),
                label: const Text(
                  'Aplicar este método en el Catálogo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 2: MOVIMIENTOS ARTÍSTICOS & EXPONENTES
  // =========================================================================
  Widget _buildMovementsTab(BuildContext context, bool isDark) {
    final movementsData = [
      {
        'name': 'Renacimiento',
        'period': 'Siglos XV – XVI (Florencia, Roma, Venecia)',
        'color': const Color(0xFF1565C0),
        'optics': 'Lineal • Superficial (planos ordenados) • Forma cerrada (tectónica) • Pluralidad armónica • Claridad absoluta.',
        'description':
            'Revolución humanista que rescata la antigüedad grecolatina. Introduce la perspectiva lineal matemática de Brunelleschi y Alberti, el estudio anatómico directo del natural y la búsqueda del orden, equilibrio y proporción áurea.',
        'exponents': [
          {
            'name': 'Leonardo da Vinci (1452–1519)',
            'role': 'Polímata florentino y maestro supremo de la perspectiva aérea y el sfumato.',
            'works': 'Mona Lisa (La Gioconda), La última cena, La Virgen de las Rocas.',
            'concept': 'Sfumato: difuminación imperceptible de contornos para dar ilusión de aire circundante y misterio psicológico.',
          },
          {
            'name': 'Sandro Botticelli (1445–1510)',
            'role': 'Genio de la gracia poética lineal y el humanismo neoplatónico de la corte de los Médici.',
            'works': 'El nacimiento de Venus, La primavera, Palas y el Centauro.',
            'concept': 'Predominio del dibujo y la curva lírica sobre el modelado escultórico de sombras.',
          },
        ],
      },
      {
        'name': 'Barroco',
        'period': 'Siglo XVII (Roma, Países Bajos, España, Flandes)',
        'color': const Color(0xFFC25E00),
        'optics': 'Pictórico • Profundo (diagonales dinámicas) • Forma abierta • Unidad unificada de luz • Claridad relativa (claroscuro).',
        'description':
            'Arte de la pasión dramática y el movimiento continuo. Rechaza la serenidad estática renacentista a favor de contrastes violentos de luces y sombras (tenebrismo) y composiciones teatrales que sumergen emocionalmente al espectador.',
        'exponents': [
          {
            'name': 'Johannes Vermeer (1632–1675)',
            'role': 'Pintor de la intimidad doméstica silenciosa y la luz diurna septentrional en Delft.',
            'works': 'La joven de la perla, La lechera, Vista de Delft.',
            'concept': 'Uso magistral de la cámara oscura y pigmento de lapislázuli (azul ultramar) para destellos luminosos puntillistas.',
          },
          {
            'name': 'Rembrandt van Rijn (1606–1669)',
            'role': 'Titán del claroscuro expresivo y la introspección psicológica del ser humano.',
            'works': 'Autorretrato con boina, La ronda de noche, La lección de anatomía.',
            'concept': 'Empaste matérico rugoso y luz dorada que emana desde el interior espiritual de las figuras.',
          },
        ],
      },
      {
        'name': 'Romanticismo',
        'period': 'Fines del siglo XVIII – Mediados del siglo XIX (Alemania, Francia, España, Inglaterra)',
        'color': const Color(0xFF2E7D32),
        'optics': 'Pictórico • Profundo • Forma abierta • Tensión dramática entre la pequeñez humana y la inmensidad infinita.',
        'description':
            'Rebelión estética contra el racionalismo frío de la Ilustración y la rigidez neoclásica. Exalta el sentimiento desgarrador, la imaginación desbordada, la noche, la patria y la contemplación de lo sublime en la naturaleza.',
        'exponents': [
          {
            'name': 'Caspar David Friedrich (1774–1840)',
            'role': 'Pintor místico del paisaje alemán y la trascendencia espiritual.',
            'works': 'El caminante sobre el mar de nubes, Monje a la orilla del mar, El mar de hielo.',
            'concept': 'Rückenfigur: figura vista de espaldas que funciona como espejo empático para que el espectador medite ante el infinito.',
          },
          {
            'name': 'Francisco de Goya (1746–1828)',
            'role': 'Visionario español precursor directo del arte moderno y el expresionismo.',
            'works': 'El 3 de mayo en Madrid (Los fusilamientos), Saturno devorando a su hijo, Los caprichos.',
            'concept': 'Libertad de pincelada y condena frontal de la irracionalidad y brutalidad bélica sin edulcorantes épicos.',
          },
        ],
      },
      {
        'name': 'Impresionismo',
        'period': '1874 – 1886 (París y la cuenca del Sena)',
        'color': const Color(0xFF00838F),
        'optics': 'Pictórico extremo • Disolución del contorno • Pintura plein air • Visión óptica de luz vibrante y cambiante.',
        'description':
            'Revolución artística que abandona los talleres académicos para pintar directamente al aire libre (plein air). Descompone los tonos en pinceladas rápidas y yuxtapuestas de colores puros para capturar el instante atmosférico fugaz.',
        'exponents': [
          {
            'name': 'Claude Monet (1840–1926)',
            'role': 'Líder indiscutible y padre del movimiento impresionista.',
            'works': 'Nenúfares (Water Lilies), Impresión, sol naciente, Serie de la Catedral de Ruan.',
            'concept': 'Pintura en serie: registrar la misma catedral o estanque a distintas horas para demostrar que el motivo es la luz misma.',
          },
          {
            'name': 'Edgar Degas (1834–1917)',
            'role': 'Maestro de la composición sesgada, la fugacidad corporal y la vida moderna urbana.',
            'works': 'La clase de danza, El ajenjo, En las carreras.',
            'concept': 'Encuadres descentrados inspirados en el corte fotográfico y las estampas japonesas Ukiyo-e.',
          },
        ],
      },
      {
        'name': 'Postimpresionismo',
        'period': '1886 – 1905 (Francia y Europa)',
        'color': const Color(0xFFD84315),
        'optics': 'Color autónomo expresivo • Contorno reforzado • Pincelada matérica • Transición hacia la vanguardia del siglo XX.',
        'description':
            'Superación del impresionismo: los creadores sienten que la captura de la luz pasajera diluyó la solidez y el significado. El arte se bifurca en dos caminos modernos: la exteriorización del estado psíquico y la geometrización formal.',
        'exponents': [
          {
            'name': 'Vincent van Gogh (1853–1890)',
            'role': 'Pionero del expresionismo contemporáneo y el uso emocional del color.',
            'works': 'Autorretrato con sombrero de paja, La noche estrellada, Campo de trigo con cuervos.',
            'concept': 'Pincelada pastosa en ritmos espirales y contrastes feroces de amarillo y azul para plasmar el volcán espiritual interior.',
          },
          {
            'name': 'Paul Cézanne (1839–1906)',
            'role': 'El "padre del arte moderno" y puente directo hacia el Cubismo de Picasso.',
            'works': 'Los jugadores de cartas, Monte Sainte-Victoire, Bodegón con manzanas.',
            'concept': 'Modulación cromática de volúmenes: reconstruir la naturaleza a partir de cilindros, esferas y conos geométricos.',
          },
        ],
      },
      {
        'name': 'Vanguardias & Expresionismo',
        'period': 'Primera mitad del siglo XX (Europa y América)',
        'color': const Color(0xFF6A1B9A),
        'optics': 'Ruptura de la perspectiva unifocal • Deconstrucción geométrica • Distorsión visceral • Autonomía absoluta del lienzo.',
        'description':
            'Destrucción de la mímesis tradicional. La pintura ya no representa una ventana transparente hacia el mundo exterior, sino un objeto plástico independiente que desafía las convenciones espaciales y psicológicas.',
        'exponents': [
          {
            'name': 'Edvard Munch (1863–1944)',
            'role': 'Heraldo del expresionismo nórdico y la angustia existencial de la modernidad.',
            'works': 'El grito, Madonna, Ansiedad.',
            'concept': 'Ondulaciones de fuego y colores disonantes que proyectan el grito psíquico del individuo en la naturaleza entera.',
          },
          {
            'name': 'Pablo Picasso (1881–1973)',
            'role': 'Genio proteico creador del Cubismo y refundador del lenguaje visual contemporáneo.',
            'works': 'Las señoritas de Avignon, Guernica, Los tres músicos.',
            'concept': 'Cubismo analítico y sintético: mostrar simultáneamente el frente, perfil y dorso de los cuerpos en un solo plano.',
          },
        ],
      },
      {
        'name': 'Ukiyo-e (Grabado Japonés)',
        'period': 'Siglos XVII – XIX (Período Edo, Japón)',
        'color': const Color(0xFF00796B),
        'optics': 'Línea de contorno pura • Planos cromáticos planos (sin claroscuro) • Perspectiva cenital y aérea.',
        'description':
            'Las célebres "estampas del mundo flotante". Xilografías en madera policroma de asombrosa síntesis geométrica que deslumbraron a Van Gogh, Monet y Degas, detonando la fiebre del Japonismo en Occidente.',
        'exponents': [
          {
            'name': 'Katsushika Hokusai (1760–1849)',
            'role': 'Maestro legendario del grabado y de la serie de las Treinta y seis vistas del monte Fuji.',
            'works': 'Bajo la ola en alta mar en Kanagawa (La gran ola), Fuji rojo (Viento del sur, cielo claro).',
            'concept': 'Contraste del dinamismo violento de las garras de la ola frente a la serenidad impasible del Monte Fuji sagrado.',
          },
        ],
      },
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette_rounded, color: Colors.white, size: 30),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Movimientos Artísticos & Exponentes Clave',
                          style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cada época histórica concibe una manera distinta de ver el mundo. Revisa las características esenciales de los grandes períodos artísticos y sus 1 o 2 exponentes paradigmáticos.',
                    style: TextStyle(color: Color(0xFFE3F2FD), fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ...movementsData.map((mov) {
              final color = mov['color'] as Color;
              final exponents = mov['exponents'] as List<Map<String, String>>;
              final movName = mov['name'] as String;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isDark ? const Color(0xFF1E1A17) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movement title row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.museum_rounded, color: color, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  mov['period'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Definition
                      Text(
                        mov['description'] as String,
                        style: TextStyle(
                          fontSize: 15.5,
                          height: 1.55,
                          color: isDark ? Colors.white : const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Wölfflin optical formula badge
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(isDark ? 0.15 : 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.visibility_rounded, color: color, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.45,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Clave Óptica (Wölfflin): ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: mov['optics'] as String),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),
                      Text(
                        'Exponentes Principales:',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFFFCC80) : const Color(0xFF5D2E0C),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Exponents list
                      ...exponents.map((exp) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF27211C) : const Color(0xFFF9F6F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? const Color(0xFF4A3B31) : const Color(0xFFE2D7CC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: color.withOpacity(0.2),
                                    child: Icon(Icons.person_rounded, size: 18, color: color),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      exp['name']!,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                exp['role']!,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  height: 1.4,
                                  color: isDark ? const Color(0xFFD7CCC8) : const Color(0xFF424242),
                                ),
                              ),
                              const SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Obras destacadas: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: exp['works']!),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: isDark ? const Color(0xFFFFCC80) : const Color(0xFF8B4513),
                                  ),
                                  children: [
                                    const TextSpan(text: 'Aporte conceptual: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: exp['concept']!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      // Action button: filter catalog by this movement
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            side: BorderSide(color: color),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            context.read<CatalogCubit>().filterByMovement(movName);
                            context.go('/catalog');
                          },
                          icon: const Icon(Icons.explore_rounded, size: 18),
                          label: Text('Ver obras de $movName en Catálogo', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 3: CÓMO FUNCIONA LA APP (GUÍA DE USUARIO Y FUNCIONALIDADES)
  // =========================================================================
  Widget _buildHowAppWorksTab(BuildContext context, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_stories_outlined, color: Colors.white, size: 30),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Guía de Uso de ArtAnalyst',
                          style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ArtAnalyst combina herramientas de análisis visual formal, aprendizaje metodológico guiado '
                    'y un motor estricto de respeto por los derechos de autor (Semáforo Legal). Descubre cómo aprovechar todas sus capacidades.',
                    style: TextStyle(color: Color(0xFFE8F5E9), fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildAppFeatureCard(
              isDark: isDark,
              number: '1',
              title: 'Catálogo Extendido y Búsqueda por Artistas y Movimientos',
              icon: Icons.grid_view_rounded,
              color: const Color(0xFF8B4513),
              description:
                  'Explora decenas de obras maestras organizadas por grandes movimientos artísticos. Puedes buscar en tiempo real por el nombre del artista (ej. Van Gogh, Monet, Rembrandt), por movimiento (ej. Barroco, Impresionismo) o filtrar por el Semáforo Legal de la reproducción.',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
              isDark: isDark,
              number: '2',
              title: 'Visor Interactivo y Zoom de Alta Resolución',
              icon: Icons.zoom_in_rounded,
              color: const Color(0xFF1565C0),
              description:
                  'Al seleccionar una obra, accede al visor dual. Utiliza el gesto de pellizco en dispositivos móviles o la rueda del ratón en escritorio para ampliar detalles minuciosos de la pincelada, empastes y craquelados con nitidez.',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
              isDark: isDark,
              number: '3',
              title: 'Herramientas de Análisis Formal Superpuestas',
              icon: Icons.layers_rounded,
              color: const Color(0xFFE65100),
              description:
                  'En la esquina superior derecha del visor encontrarás botones flotantes para activar capas pedagógicas:\n'
                  '• 📐 Capa Geométrica: superpone la regla de los tercios con sus cuatro intersecciones áureas, diagonales de tensión visual y ejes de simetría.\n'
                  '• 🎨 Capa de Paleta Cromática: analiza los colores predominantes de la obra, muestra sus códigos HEX, calcula su luminancia y explica su tipo de armonía cromática.',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
              isDark: isDark,
              number: '4',
              title: 'Anotación de Regiones de Interés (ROI)',
              icon: Icons.highlight_alt_rounded,
              color: const Color(0xFF6A1B9A),
              description:
                  'Pulsa el botón de lápiz / anotación para activar el modo de marcado. Arrastra sobre cualquier zona del cuadro para trazar un rectángulo sobre un detalle simbólico o formal. '
                  'Podrás asignarle un título, redactar notas y categorizarlo (Símbolo, Composición, Color o Pincelada).',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
              isDark: isDark,
              number: '5',
              title: 'Guía Metodológica Panofsky y Respuestas Modelo',
              icon: Icons.edit_note_rounded,
              color: const Color(0xFF00695C),
              description:
                  'En el panel lateral derecho (o en la pestaña de Guía en móviles), sigue las preguntas de los niveles formal, iconográfico e iconológico. '
                  'Redacta tus propias observaciones y pulsa "Comparar con respuesta modelo" para contrastar tu análisis con el redactado por historiadores del arte.',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
              isDark: isDark,
              number: '6',
              title: 'Semáforo de Licencias y Protección Jurídica',
              icon: Icons.policy_rounded,
              color: const Color(0xFFC62828),
              description:
                  '• 🟢 Verde (CC0 / Dominio Público): descarga y uso irrestricto.\n'
                  '• 🟡 Amarillo (Creative Commons CC BY / CC BY-SA): atribución formal automática bajo estándar TASL.\n'
                  '• 🔴 Rojo (Derechos Reservados): bloqueo ético de la reproducción protegida con mensaje educativo y enlace directo a la colección oficial del museo.',
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.go('/licenses-guide'),
                    icon: const Icon(Icons.policy_outlined),
                    label: const Text('Consultar Semáforo Legal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.go('/catalog'),
                    icon: const Icon(Icons.explore_rounded, color: Colors.white),
                    label: const Text('Ir al Catálogo de Obras', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 4: TALLER Y AUTOEVALUACIÓN PRÁCTICA
  // =========================================================================
  Widget _buildQuizTab(BuildContext context, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B231D) : const Color(0xFFF5ECE3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8B4513).withOpacity(0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_rounded, size: 30, color: Color(0xFFD84315)),
                      const SizedBox(width: 12),
                      Text(
                        'Autoevaluación de Conceptos Clave',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF5D2E0C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pon a prueba tus conocimientos sobre los pares de Heinrich Wölfflin y los niveles de Erwin Panofsky antes de redactar tus análisis.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: isDark ? const Color(0xFFD7CCC8) : const Color(0xFF4E342E),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildQuizQuestion(
              isDark: isDark,
              questionNumber: 1,
              question: '¿Qué par de conceptos de Wölfflin distingue si una obra se basa en contornos dibujísticos precisos o en masas difusas de luz y color?',
              options: [
                'Lo superficial frente a lo profundo',
                'Lo lineal frente a lo pictórico',
                'Forma cerrada frente a forma abierta',
                'Pluralidad frente a unidad',
              ],
              correctIndex: 1,
              explanation: 'Exacto: "Lo lineal" destaca la línea, el dibujo y el límite táctil de los objetos (visión plástica), mientras que "Lo pictórico" se basa en manchas de luz y color donde los bordes se funden (visión óptica).',
            ),

            const SizedBox(height: 20),

            _buildQuizQuestion(
              isDark: isDark,
              questionNumber: 2,
              question: 'Según Erwin Panofsky, ¿cuál es el principio correctivo para evitar anacronismos en la interpretación iconológica (significación intrínseca)?',
              options: [
                'La Historia del Estilo',
                'La Historia de los Tipos',
                'La Historia de los Síntomas Culturales',
                'La regla de los tercios',
              ],
              correctIndex: 2,
              explanation: '¡Correcto! La Historia de los Síntomas Culturales compara la obra con la literatura, religión y filosofía de su época para verificar que las tendencias mentales inferidas realmente existieron.',
            ),

            const SizedBox(height: 20),

            _buildQuizQuestion(
              isDark: isDark,
              questionNumber: 3,
              question: '¿Por qué ArtAnalyst bloquea la descarga o muestra un semáforo rojo para ciertas reproducciones de cuadros de 500 años de antigüedad?',
              options: [
                'Porque el artista original aún posee derechos de autor patrimoniales.',
                'Porque la fotografía digital de alta resolución puede estar sujeta a derechos de autor del museo o fotógrafo.',
                'Porque la obra no es apta para estudiantes de arte.',
                'Porque la imagen tiene baja calidad de compresión.',
              ],
              correctIndex: 1,
              explanation: '¡Excelente! Aunque la obra física original esté en dominio público, la fotografía digital reciente puede tener derechos reservados de la institución, requiriendo un semáforo legal riguroso.',
            ),

            const SizedBox(height: 20),

            _buildQuizQuestion(
              isDark: isDark,
              questionNumber: 4,
              question: 'Una composición donde las diagonales y miradas aluden con fuerza a lo que ocurre fuera del marco del cuadro corresponde a:',
              options: [
                'Forma cerrada (tectónica)',
                'Claridad absoluta',
                'Forma abierta (atectónica)',
                'Pluralidad múltiple',
              ],
              correctIndex: 2,
              explanation: '¡Muy bien! La forma abierta o atectónica supera los límites del marco y genera la ilusión de un espacio continuo que se prolonga más allá del lienzo.',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // HELPER WIDGETS CON ALTO CONTRASTE Y TIPOGRAFÍA AGRANDADA
  // =========================================================================
  Widget _buildStepCard({
    required BuildContext context,
    required bool isDark,
    required int stepNumber,
    required String title,
    required String subtitle,
    required String sourceReference,
    required Color accentColor,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF1E1A17) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: isDark ? const Color(0xFFD7CCC8) : const Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A231E) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? const Color(0xFF4E3D35) : Colors.grey.shade300),
                ),
                child: Text(
                  'Fuente: $sourceReference',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : Colors.grey.shade800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildSubtopic({
    required bool isDark,
    required String title,
    required String text,
    required String bookRef,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF28221D) : const Color(0xFFF7F3EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF4A3C33) : const Color(0xFFE2D7CB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.5,
              color: isDark ? const Color(0xFFFFCC80) : const Color(0xFF5D2E0C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.55,
              color: isDark ? Colors.white : const Color(0xFF1F1C19),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bookRef,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: isDark ? const Color(0xFFBCAAA4) : const Color(0xFF6D4C41),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWolfflinPair({
    required bool isDark,
    required String title,
    required String contrastA,
    required String descA,
    required String contrastB,
    required String descB,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF241F1C) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF3E332A) : Colors.blue.shade100),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1),
          ),
        ),
        subtitle: Text(
          'Toca para ver el contraste analítico',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Contrast A
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF332617) : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF6D4C15) : const Color(0xFFFFE082)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contrastA,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: isDark ? const Color(0xFFFFD54F) : const Color(0xFFE65100),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        descA,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: isDark ? Colors.white : const Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Contrast B
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF152238) : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? const Color(0xFF1E3A6D) : const Color(0xFF90CAF9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contrastB,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                          color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        descB,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: isDark ? Colors.white : const Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectionCard({
    required bool isDark,
    required String levelNumber,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E1E) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  levelNumber,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5,
                    color: isDark ? const Color(0xFFA5D6A7) : const Color(0xFF1B5E20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.5,
              color: isDark ? Colors.white : const Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinopticSection(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF1E1A17) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart_rounded, color: isDark ? const Color(0xFFFFCC80) : const Color(0xFF8B4513), size: 26),
                const SizedBox(width: 12),
                Text(
                  'Cuadro Sinóptico Integrado de Erwin Panofsky',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mobile-first adaptive cards
            _buildSinopticCard(
              isDark: isDark,
              level: '1. Nivel Pre-iconográfico (Formal)',
              objectText: 'Formas puras, configuraciones de líneas, colores, motivos artísticos y significación fáctica/expresiva.',
              knowledgeText: 'Experiencia práctica cotidiana y familiaridad con el mundo visible.',
              correctiveText: 'Historia del estilo (indagar cómo, en distintas condiciones históricas, se expresaban las formas).',
              accentColor: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
            ),
            const SizedBox(height: 12),
            _buildSinopticCard(
              isDark: isDark,
              level: '2. Nivel Iconográfico',
              objectText: 'Significado secundario: temas, alegorías, personajes e historias convencionales.',
              knowledgeText: 'Conocimiento de fuentes literarias, textos bíblicos, mitológicos y tradición oral.',
              correctiveText: 'Historia de los tipos (investigar cómo temas y conceptos específicos se expresaban convencionalmente).',
              accentColor: isDark ? const Color(0xFFFF8A65) : const Color(0xFFD84315),
            ),
            const SizedBox(height: 12),
            _buildSinopticCard(
              isDark: isDark,
              level: '3. Nivel Iconológico',
              objectText: 'Significación intrínseca o contenido: valores simbólicos que revelan la mentalidad básica de una época o cultura.',
              knowledgeText: 'Intuición sintética y comprensión de la cosmovisión filosófica, política y religiosa.',
              correctiveText: 'Historia de los síntomas culturales en general (confrontar la obra con los demás testimonios de la civilización).',
              accentColor: isDark ? const Color(0xFFBA68C8) : const Color(0xFF6A1B9A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinopticCard({
    required bool isDark,
    required String level,
    required String objectText,
    required String knowledgeText,
    required String correctiveText,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF28221D) : const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            level,
            style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: accentColor),
          ),
          const SizedBox(height: 8),
          _buildSinopticRow(isDark, 'Objeto de interpretación: ', objectText),
          const SizedBox(height: 5),
          _buildSinopticRow(isDark, 'Bagaje requerido: ', knowledgeText),
          const SizedBox(height: 5),
          _buildSinopticRow(isDark, 'Principio correctivo: ', correctiveText, isCorrective: true),
        ],
      ),
    );
  }

  Widget _buildSinopticRow(bool isDark, String label, String value, {bool isCorrective = false}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.5,
          height: 1.45,
          color: isDark ? Colors.white : Colors.black87,
        ),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCorrective
                  ? (isDark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32))
                  : (isDark ? const Color(0xFFFFCC80) : const Color(0xFF5D2E0C)),
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildAppFeatureCard({
    required bool isDark,
    required String number,
    required String title,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isDark ? const Color(0xFF1E1A17) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.18),
              child: Text(
                number,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 22, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? Colors.white : const Color(0xFF263238),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizQuestion({
    required bool isDark,
    required int questionNumber,
    required String question,
    required List<String> options,
    required int correctIndex,
    required String explanation,
  }) {
    return _QuizQuestionWidget(
      isDark: isDark,
      questionNumber: questionNumber,
      question: question,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
    );
  }
}

class _QuizQuestionWidget extends StatefulWidget {
  final bool isDark;
  final int questionNumber;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _QuizQuestionWidget({
    required this.isDark,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  State<_QuizQuestionWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<_QuizQuestionWidget> {
  int? _selectedIndex;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedIndex == widget.correctIndex;
    final isDark = widget.isDark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isDark ? const Color(0xFF1E1A17) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${widget.questionNumber}: ${widget.question}',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                height: 1.35,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(widget.options.length, (index) {
              final isThisOptionSelected = _selectedIndex == index;
              final isThisOptionCorrect = index == widget.correctIndex;

              Color? tileColor;
              if (_revealed) {
                if (isThisOptionCorrect) {
                  tileColor = isDark ? const Color(0xFF1B3A22) : Colors.green.shade50;
                } else if (isThisOptionSelected) {
                  tileColor = isDark ? const Color(0xFF3E1B1B) : Colors.red.shade50;
                }
              } else if (isThisOptionSelected) {
                tileColor = isDark ? const Color(0xFF3E2D22) : const Color(0xFFFBE9E7);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: tileColor ?? (isDark ? const Color(0xFF28231E) : Colors.grey.shade50),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _revealed
                        ? (isThisOptionCorrect
                            ? Colors.green
                            : (isThisOptionSelected ? Colors.red : (isDark ? Colors.white24 : Colors.grey.shade300)))
                        : (isThisOptionSelected
                            ? const Color(0xFF8B4513)
                            : (isDark ? const Color(0xFF4A3C33) : Colors.grey.shade300)),
                    width: isThisOptionSelected ? 1.5 : 1,
                  ),
                ),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedIndex,
                  dense: false,
                  activeColor: const Color(0xFFD84315),
                  title: Text(
                    widget.options[index],
                    style: TextStyle(
                      fontSize: 15.5,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: isThisOptionSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onChanged: (val) {
                    if (!_revealed) {
                      setState(() {
                        _selectedIndex = val;
                      });
                    }
                  },
                ),
              );
            }),
            const SizedBox(height: 10),
            Row(
              children: [
                if (!_revealed)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _selectedIndex != null
                        ? () {
                            setState(() {
                              _revealed = true;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.check, size: 18, color: Colors.white),
                    label: const Text('Verificar respuesta', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _revealed = false;
                        _selectedIndex = null;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Reiniciar pregunta', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            if (_revealed) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? (isDark ? const Color(0xFF1B3A22) : Colors.green.shade50)
                      : (isDark ? const Color(0xFF3E2D1B) : Colors.amber.shade50),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCorrect
                        ? (isDark ? const Color(0xFF2E7D32) : Colors.green.shade300)
                        : (isDark ? const Color(0xFFFFB300) : Colors.amber.shade300),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                      color: isCorrect
                          ? (isDark ? const Color(0xFFA5D6A7) : Colors.green.shade800)
                          : (isDark ? const Color(0xFFFFD54F) : Colors.amber.shade900),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.explanation,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          color: isCorrect
                              ? (isDark ? Colors.white : Colors.green.shade900)
                              : (isDark ? Colors.white : Colors.brown.shade900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
