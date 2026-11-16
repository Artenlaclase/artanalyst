import 'package:flutter/material.dart';
import 'package:art_analyst_shared/shared.dart';

/// The Panofsky Stepper guides the student systematically through the 3 methodological levels.
class PanofskyStepper extends StatefulWidget {
  final List<AnalysisGuide> guides;
  final List<UserAnalysisProgress> initialProgress;
  final Function(PanofskyLevel level, String response, bool isCompleted) onSaveProgress;

  const PanofskyStepper({
    super.key,
    required this.guides,
    required this.initialProgress,
    required this.onSaveProgress,
  });

  @override
  State<PanofskyStepper> createState() => _PanofskyStepperState();
}

class _PanofskyStepperState extends State<PanofskyStepper> {
  int _currentStep = 0;
  final Map<PanofskyLevel, TextEditingController> _controllers = {};
  final Map<PanofskyLevel, bool> _revealedModelAnswers = {};
  final Map<PanofskyLevel, bool> _completedSteps = {};

  @override
  void initState() {
    super.initState();
    for (final level in PanofskyLevel.values) {
      final existing = widget.initialProgress.cast<UserAnalysisProgress?>().firstWhere(
            (p) => p?.level == level,
            orElse: () => null,
          );
      _controllers[level] = TextEditingController(text: existing?.userResponse ?? '');
      _completedSteps[level] = existing?.isCompleted ?? false;
      _revealedModelAnswers[level] = existing?.isCompleted ?? false;
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSubmitCurrentStep(PanofskyLevel level) {
    final text = _controllers[level]?.text.trim() ?? '';
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe tu reflexión antes de comparar con la respuesta modelo.')),
      );
      return;
    }

    setState(() {
      _revealedModelAnswers[level] = true;
      _completedSteps[level] = true;
    });

    widget.onSaveProgress(level, text, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Respuesta guardada! Revisa y contrasta con el análisis modelo curado.'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.guides.isEmpty) {
      return const Center(child: Text('No hay guiones de análisis disponibles para esta obra.'));
    }

    final levels = [PanofskyLevel.formal, PanofskyLevel.iconographic, PanofskyLevel.iconological];

    return Stepper(
      type: StepperType.vertical,
      currentStep: _currentStep,
      onStepTapped: (step) => setState(() => _currentStep = step),
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: levels.map((level) {
        final guide = widget.guides.cast<AnalysisGuide?>().firstWhere(
              (g) => g?.level == level,
              orElse: () => null,
            );
        final isCompleted = _completedSteps[level] ?? false;
        final hasModelRevealed = _revealedModelAnswers[level] ?? false;

        return Step(
          isActive: _currentStep >= levels.indexOf(level),
          state: isCompleted ? StepState.complete : StepState.indexed,
          title: Text(
            level.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            level.questionPrompt,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Guiding Question Prompt
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                ),
                child: Text(
                  guide?.prompt ?? level.questionPrompt,
                  style: const TextStyle(fontSize: 13.5, height: 1.45, fontWeight: FontWeight.w500),
                ),
              ),

              // Pedagogical hints expansion
              if (guide != null && guide.hints.isNotEmpty) ...[
                const SizedBox(height: 8),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
                      SizedBox(width: 6),
                      Text('Pistas para el análisis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  children: guide.hints.map((hint) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(hint, style: const TextStyle(fontSize: 12, height: 1.3))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 12),
              // Student Response Input
              TextField(
                controller: _controllers[level],
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Redacta aquí tus observaciones analíticas...',
                  hintStyle: const TextStyle(fontSize: 12.5),
                  suffixIcon: IconButton(
                    tooltip: 'Guardar borrador',
                    icon: const Icon(Icons.save_as_outlined, size: 18),
                    onPressed: () {
                      final text = _controllers[level]?.text ?? '';
                      widget.onSaveProgress(level, text, false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Borrador guardado localmente.')),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () => _handleSubmitCurrentStep(level),
                    icon: Icon(hasModelRevealed ? Icons.refresh : Icons.check_circle_outline, size: 16),
                    label: Text(hasModelRevealed ? 'Actualizar y comparar' : 'Comparar con respuesta modelo'),
                  ),
                ],
              ),

              // Model Answer Comparison Card
              if (hasModelRevealed && guide != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school_rounded, size: 18, color: Color(0xFF2E7D32)),
                          SizedBox(width: 8),
                          Text(
                            'Respuesta Modelo (Curada por el equipo pedagógico):',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        guide.modelAnswer,
                        style: const TextStyle(fontSize: 13, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      }).toList(),
    );
  }
}
