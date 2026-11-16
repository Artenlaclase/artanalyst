/// Erwin Panofsky's three methodological levels of visual art analysis.
enum PanofskyLevel {
  formal(
    code: 'formal',
    title: '1. Descripción Pre-iconográfica (Formal)',
    questionPrompt: '¿Qué veo y cómo está construido?',
    subtopics: ['Composición y líneas', 'Color y paleta', 'Técnica y pincelada', 'Luz y espacio'],
  ),
  iconographic(
    code: 'iconographic',
    title: '2. Análisis Iconográfico',
    questionPrompt: '¿Qué significa lo que veo?',
    subtopics: ['Identificación de temas', 'Símbolos y alegorías', 'Personajes e historias', 'Atributos iconográficos'],
  ),
  iconological(
    code: 'iconological',
    title: '3. Interpretación Iconológica',
    questionPrompt: '¿Qué nos dice la obra sobre su época y cosmovisión?',
    subtopics: ['Contexto histórico y político', 'Valores sociales y religiosos', 'Mentalidad de la época', 'Recepción de la obra'],
  );

  final String code;
  final String title;
  final String questionPrompt;
  final List<String> subtopics;

  const PanofskyLevel({
    required this.code,
    required this.title,
    required this.questionPrompt,
    required this.subtopics,
  });

  static PanofskyLevel fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'formal':
        return PanofskyLevel.formal;
      case 'iconographic':
        return PanofskyLevel.iconographic;
      case 'iconological':
      default:
        return PanofskyLevel.iconological;
    }
  }
}

/// Type of interactive micro-exercise that accompanies the analysis step
enum InteractiveExerciseType {
  openReflection,
  focalPointSelect,
  vanishingPointSelect,
  colorPaletteInspect,
  regionAnnotationTag,
}

/// A curated educational guiding question and model answer for an artwork.
class AnalysisGuide {
  final String id;
  final String artworkId;
  final PanofskyLevel level;
  final String prompt;
  final String modelAnswer;
  final List<String> hints;
  final InteractiveExerciseType exerciseType;
  final Map<String, dynamic>? exerciseConfig; // e.g. target focal coordinates
  final int orderIndex;

  const AnalysisGuide({
    required this.id,
    required this.artworkId,
    required this.level,
    required this.prompt,
    required this.modelAnswer,
    this.hints = const [],
    this.exerciseType = InteractiveExerciseType.openReflection,
    this.exerciseConfig,
    required this.orderIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artwork_id': artworkId,
      'level': level.code,
      'prompt': prompt,
      'model_answer': modelAnswer,
      'hints': hints,
      'exercise_type': exerciseType.name,
      'exercise_config': exerciseConfig,
      'order_index': orderIndex,
    };
  }

  factory AnalysisGuide.fromJson(Map<String, dynamic> json) {
    final levelCode = json['level'] as String? ?? 'formal';
    final exerciseTypeName = json['exercise_type'] as String?;
    InteractiveExerciseType exerciseType = InteractiveExerciseType.openReflection;
    for (final t in InteractiveExerciseType.values) {
      if (t.name == exerciseTypeName) {
        exerciseType = t;
        break;
      }
    }

    return AnalysisGuide(
      id: json['id'] as String,
      artworkId: json['artwork_id'] as String,
      level: PanofskyLevel.fromCode(levelCode),
      prompt: json['prompt'] as String,
      modelAnswer: json['model_answer'] as String,
      hints: (json['hints'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      exerciseType: exerciseType,
      exerciseConfig: json['exercise_config'] as Map<String, dynamic>?,
      orderIndex: (json['order_index'] as int?) ?? 0,
    );
  }
}
