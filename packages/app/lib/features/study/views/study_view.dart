import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver al catálogo',
          onPressed: () => context.go('/catalog'),
        ),
        title: const Text('Guía Metodológica y Estudio de Arte'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.auto_stories_rounded), text: 'Metodología (Panofsky & Wölfflin)'),
            Tab(icon: Icon(Icons.touch_app_rounded), text: '¿Cómo Funciona la App?'),
            Tab(icon: Icon(Icons.quiz_rounded), text: 'Taller & Autoevaluación'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMethodologyTab(context),
          _buildHowAppWorksTab(context),
          _buildQuizTab(context),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 1: METODOLOGÍA DE ANÁLISIS VISUAL (PANOFSKY & WÖLFFLIN)
  // =========================================================================
  Widget _buildMethodologyTab(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    color: Colors.brown.withOpacity(0.2),
                    blurRadius: 12,
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'El Método Riguroso de Análisis Visual',
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Síntesis de Erwin Panofsky y Heinrich Wölfflin',
                              style: TextStyle(color: Colors.white70, fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Analizar una obra de arte no es emitir una opinión subjetiva de agrado, sino descifrar un lenguaje formal, simbólico y cultural. '
                    'Este método estructura la mirada en 4 pasos progresivos: desde las formas puras hasta la verificación histórica que evita el anacronismo.',
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // PASO 1
            _buildStepCard(
              context: context,
              stepNumber: 1,
              title: 'Paso 1: Descripción Pre-iconográfica y Análisis Formal',
              subtitle: 'La observación empírica de formas, colores y el esquema óptico',
              sourceReference: 'Panofsky (1979) • Wölfflin (1915/2017)',
              accentColor: const Color(0xFF1E88E5),
              icon: Icons.brush_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'La observación inicial debe centrarse estrictamente en los elementos visibles básicos y en cómo se configuran las formas en el soporte:',
                    style: TextStyle(fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    title: 'Identificación de motivos artísticos',
                    text: 'Reconoce las formas puras: configuraciones de líneas, planos de color, texturas y volúmenes tridimensionales que representan objetos naturales, seres humanos, plantas o arquitecturas.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 10),
                  _buildSubtopic(
                    title: 'Significación fáctica y significación expresiva',
                    text: '• Fáctica: lo que los personajes hacen literalmente (un hombre que camina, una mujer que sostiene un paño).\n'
                        '• Expresiva: la atmósfera psicológica y emotiva (una postura doliente, la serenidad en la mirada o la agitación de una escena), descifrable mediante la experiencia práctica cotidiana.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  // WOLFFLIN SECTION
                  Row(
                    children: [
                      Icon(Icons.visibility_rounded, color: Colors.blue.shade800, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Análisis del Esquema Óptico (Los 5 pares de Heinrich Wölfflin)',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Heinrich Wölfflin sistematizó la evolución de la mirada entre el Renacimiento y el Barroco en cinco conceptos contrapuestos para entender cómo organiza el artista la visión:',
                    style: TextStyle(fontSize: 13.5, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 14),
                  _buildWolfflinPair(
                    title: '1. Lo lineal frente a lo pictórico',
                    contrastA: 'Lineal (visión táctil/plástica):',
                    descA: 'Destaca contornos precisos y límites rígidos. El dibujo aísla cada objeto como un cuerpo tangible con límites claros.',
                    contrastB: 'Pictórico (visión óptica):',
                    descB: 'Se basa en manchas cromáticas, masas de luz y sombras continuas. Los bordes se desvanecen y la luz funde las figuras con el entorno.',
                  ),
                  const SizedBox(height: 10),
                  _buildWolfflinPair(
                    title: '2. Lo superficial frente a lo profundo',
                    contrastA: 'Superficial (plano):',
                    descA: 'Los elementos se ordenan en planos estratificados paralelos al espectador (organización en frisos o franjas frontales).',
                    contrastB: 'Profundo (espacio penetrado):',
                    descB: 'La composición rompe el plano y penetra en profundidad mediante diagonales dinámicas, escorzos pronunciados y planos sesgados.',
                  ),
                  const SizedBox(height: 10),
                  _buildWolfflinPair(
                    title: '3. Forma cerrada frente a forma abierta',
                    contrastA: 'Forma cerrada (tectónica):',
                    descA: 'Composición autosuficiente, simétrica y equilibrada, regida por horizontales y verticales que se cierran sobre el marco del cuadro.',
                    contrastB: 'Forma abierta (atectónica):',
                    descB: 'Líneas diagonales y fugas que aluden intencionalmente a lo que está fuera del cuadro; sensación de instante fugaz y espacio ilimitado.',
                  ),
                  const SizedBox(height: 10),
                  _buildWolfflinPair(
                    title: '4. Pluralidad frente a unidad',
                    contrastA: 'Pluralidad (articulación múltiple):',
                    descA: 'Cada componente y detalle conserva su independencia formal y cromática dentro del conjunto armónico.',
                    contrastB: 'Unidad (subordinación unificada):',
                    descB: 'Todos los elementos se subordinan a un único motivo dominante, flujo de luz o centro visual rector que suprime la autonomía de las partes.',
                  ),
                  const SizedBox(height: 10),
                  _buildWolfflinPair(
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
              stepNumber: 2,
              title: 'Paso 2: Análisis Iconográfico',
              subtitle: 'El significado secundario o convencional: historias, alegorías y fuentes',
              sourceReference: 'Panofsky, Erwin (1979)',
              accentColor: const Color(0xFFD84315),
              icon: Icons.auto_stories_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Una vez definida la forma pura y los motivos, el análisis avanza hacia el significado secundario o convencional de la obra:',
                    style: TextStyle(fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    title: 'Identificación de temas, alegorías y conceptos',
                    text: 'Relaciona los motivos visuales con imágenes, historias y alegorías codificadas. Por ejemplo, una figura femenina con balanza y espada se identifica como la Alegoría de la Justicia, o una mujer con turbante y perla se reconoce como un estudio de carácter o "tronie".',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 10),
                  _buildSubtopic(
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
              stepNumber: 3,
              title: 'Paso 3: Interpretación Iconológica',
              subtitle: 'La significación intrínseca: la obra como síntoma de una cosmovisión cultural',
              sourceReference: 'Panofsky, Erwin (1979)',
              accentColor: const Color(0xFF6A1B9A),
              icon: Icons.lightbulb_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'El paso cumbre busca comprender la obra de arte como documento vivo y síntoma de un contexto histórico, filosófico y social más amplio:',
                    style: TextStyle(fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildSubtopic(
                    title: 'Significación intrínseca o contenido',
                    text: 'Investiga los principios subyacentes que revelan la mentalidad básica de una nación, una época histórica, una clase social o una convicción religiosa y filosófica, matizada por la personalidad individual del artista.',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 10),
                  _buildSubtopic(
                    title: 'Valores simbólicos de la forma y el tema',
                    text: 'Interpreta las formas formales (el color, la composición) y las historias como manifestaciones de estos principios profundos (ej. el uso del espacio infinito en Friedrich como expresión de la sublimidad romántica).',
                    bookRef: 'Panofsky, Erwin: El significado en las artes visuales (1979)',
                  ),
                  const SizedBox(height: 10),
                  _buildSubtopic(
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
              stepNumber: 4,
              title: 'Paso 4: Verificación Histórica (Principios Correctivos)',
              subtitle: 'El control contra la subjetividad, las proyecciones y el anacronismo',
              sourceReference: 'Panofsky, Erwin (1979)',
              accentColor: const Color(0xFF2E7D32),
              icon: Icons.verified_user_rounded,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Para evitar que la experiencia personal, la fantasía o la intuición desvíen el análisis hacia el anacronismo, Erwin Panofsky estableció que cada nivel debe estar respaldado por un control histórico riguroso de la tradición:',
                    style: TextStyle(fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  _buildCorrectionCard(
                    levelNumber: 'Para el Paso 1 (Formal)',
                    title: 'Historia del Estilo',
                    description: 'Corrige la descripción de las formas investigando cómo, en distintas condiciones históricas, los objetos y acontecimientos se expresaban mediante líneas, luces y colores. Evita interpretar un escorzo renacentista con la sensibilidad visual del siglo XXI.',
                  ),
                  const SizedBox(height: 10),
                  _buildCorrectionCard(
                    levelNumber: 'Para el Paso 2 (Iconográfico)',
                    title: 'Historia de los Tipos',
                    description: 'Corrige el análisis de historias y alegorías investigando cómo temas específicos se expresaban convencionalmente a través de ciertos objetos, poses y atributos en diferentes épocas (tipología iconográfica).',
                  ),
                  const SizedBox(height: 10),
                  _buildCorrectionCard(
                    levelNumber: 'Para el Paso 3 (Iconológico)',
                    title: 'Historia de los Síntomas Culturales',
                    description: 'Corrige la interpretación profunda comparando la obra con otros documentos y testimonios culturales coetáneos (literatura, filosofía, política, teología) para verificar cómo las tendencias esenciales de la mente humana se manifestaron efectivamente en ese momento.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Sinoptic Table
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.table_chart_rounded, color: Color(0xFF8B4513)),
                        SizedBox(width: 10),
                        Text(
                          'Cuadro Sinóptico Integrado de Erwin Panofsky',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.brown.shade50),
                        columns: const [
                          DataColumn(label: Text('Nivel / Paso', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Objeto de Interpretación', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Bagaje de Conocimiento', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Principio Correctivo', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: const [
                          DataRow(cells: [
                            DataCell(Text('1. Pre-iconográfico', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('Formas puras, motivos, hechos y cualidades expresivas')),
                            DataCell(Text('Experiencia práctica cotidiana')),
                            DataCell(Text('Historia del estilo (cómo se configuraban las formas)')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('2. Iconográfico', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('Temas, alegorías, personajes e historias convencionales')),
                            DataCell(Text('Conocimiento de fuentes literarias y textos')),
                            DataCell(Text('Historia de los tipos (cómo se representaban los temas)')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('3. Iconológico', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text('Significación intrínseca y valores simbólicos de época')),
                            DataCell(Text('Intuición sintética y cosmovisión cultural')),
                            DataCell(Text('Historia de los síntomas culturales en general')),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Call to action button to Catalog
            Center(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                onPressed: () => context.go('/catalog'),
                icon: const Icon(Icons.palette_rounded),
                label: const Text('Aplicar este método en una obra del Catálogo', style: TextStyle(fontSize: 15)),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 2: CÓMO FUNCIONA LA APP (GUÍA DE USUARIO Y FUNCIONALIDADES)
  // =========================================================================
  Widget _buildHowAppWorksTab(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                      Icon(Icons.auto_stories_outlined, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Guía de Uso de ArtAnalyst',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ArtAnalyst combina herramientas de análisis visual formal, aprendizaje metodológico guiado '
                    'y un motor estricto de respeto por los derechos de autor (Semáforo Legal). Descubre cómo aprovechar todas sus capacidades.',
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.45),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _buildAppFeatureCard(
              number: '1',
              title: 'Catálogo y Filtrado Inteligente',
              icon: Icons.grid_view_rounded,
              color: const Color(0xFF8B4513),
              description:
                  'Explora obras maestras de museos de referencia internacional (The Met, Cleveland Museum of Art, Mauritshuis, Hamburger Kunsthalle, Louvre). '
                  'Puedes buscar en tiempo real por título, artista o movimiento, y filtrar por el estado legal de la reproducción digital mediante los botones del Semáforo.',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
              number: '2',
              title: 'Visor Interactivo y Zoom de Alta Resolución',
              icon: Icons.zoom_in_rounded,
              color: const Color(0xFF1565C0),
              description:
                  'Al seleccionar una obra, accede al visor dual. Utiliza el gesto de pellizco en dispositivos móviles o la rueda del ratón en escritorio para ampliar detalles minuciosos de la pincelada, empastes y craquelados con nitidez.',
            ),

            const SizedBox(height: 16),

            _buildAppFeatureCard(
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
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () => context.go('/licenses-guide'),
                    icon: const Icon(Icons.policy_outlined),
                    label: const Text('Consultar Guía Legal de Licencias'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => context.go('/catalog'),
                    icon: const Icon(Icons.explore_rounded),
                    label: const Text('Ir al Catálogo de Obras'),
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
  // TAB 3: TALLER Y AUTOEVALUACIÓN PRÁCTICA
  // =========================================================================
  Widget _buildQuizTab(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology_rounded, size: 28, color: Color(0xFF8B4513)),
                      SizedBox(width: 12),
                      Text(
                        'Autoevaluación de Conceptos Clave',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pon a prueba tus conocimientos sobre los pares de Heinrich Wölfflin y los niveles de Erwin Panofsky antes de redactar tus análisis.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildQuizQuestion(
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
  // HELPER WIDGETS
  // =========================================================================
  Widget _buildStepCard({
    required BuildContext context,
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
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Fuente: $sourceReference',
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade800),
                ),
              ),
            ),
            const SizedBox(height: 14),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildSubtopic({
    required String title,
    required String text,
    required String bookRef,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            bookRef,
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildWolfflinPair({
    required String title,
    required String contrastA,
    required String descA,
    required String contrastB,
    required String descB,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        title: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
        ),
        subtitle: const Text('Toca para ver el contraste y la aplicación analítica', style: TextStyle(fontSize: 11.5)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contrastA, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.amber.shade900)),
                        const SizedBox(height: 4),
                        Text(descA, style: const TextStyle(fontSize: 12, height: 1.35)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contrastB, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.blue.shade900)),
                        const SizedBox(height: 4),
                        Text(descB, style: const TextStyle(fontSize: 12, height: 1.35)),
                      ],
                    ),
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
    required String levelNumber,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  levelNumber,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Colors.green.shade900),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildAppFeatureCard({
    required String number,
    required String title,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Text(
                number,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13.5, height: 1.45),
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
    required int questionNumber,
    required String question,
    required List<String> options,
    required int correctIndex,
    required String explanation,
  }) {
    return _QuizQuestionWidget(
      questionNumber: questionNumber,
      question: question,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
    );
  }
}

class _QuizQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _QuizQuestionWidget({
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${widget.questionNumber}: ${widget.question}',
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(widget.options.length, (index) {
              final isThisOptionSelected = _selectedIndex == index;
              final isThisOptionCorrect = index == widget.correctIndex;

              Color? tileColor;
              if (_revealed) {
                if (isThisOptionCorrect) {
                  tileColor = Colors.green.shade50;
                } else if (isThisOptionSelected) {
                  tileColor = Colors.red.shade50;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: tileColor ?? Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _revealed
                        ? (isThisOptionCorrect
                            ? Colors.green
                            : (isThisOptionSelected ? Colors.red : Colors.grey.shade300))
                        : (isThisOptionSelected ? const Color(0xFF8B4513) : Colors.grey.shade300),
                  ),
                ),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedIndex,
                  dense: true,
                  title: Text(widget.options[index], style: const TextStyle(fontSize: 13.5)),
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
            const SizedBox(height: 8),
            Row(
              children: [
                if (!_revealed)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                    onPressed: _selectedIndex != null
                        ? () {
                            setState(() {
                              _revealed = true;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Verificar respuesta'),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _revealed = false;
                        _selectedIndex = null;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reiniciar pregunta'),
                  ),
              ],
            ),
            if (_revealed) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.shade50 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isCorrect ? Colors.green.shade300 : Colors.amber.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                      color: isCorrect ? Colors.green.shade800 : Colors.amber.shade900,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.explanation,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: isCorrect ? Colors.green.shade900 : Colors.brown.shade900,
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
