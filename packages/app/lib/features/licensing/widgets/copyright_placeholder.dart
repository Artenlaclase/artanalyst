import 'package:flutter/material.dart';

/// Displayed when an artwork has a RED license semaphore.
/// Prohibits digital image redistribution while educating the user.
class CopyrightPlaceholder extends StatelessWidget {
  final String title;
  final String? artistName;
  final String? officialSourceUrl;
  final String institution;

  const CopyrightPlaceholder({
    super.key,
    required this.title,
    this.artistName,
    this.officialSourceUrl,
    required this.institution,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221A1A) : const Color(0xFFFDF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE57373).withOpacity(0.4)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: Color(0xFFC62828),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Semáforo Rojo: Derechos Reservados',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC62828),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ArtAnalyst no aloja ni muestra directamente esta fotografía digital para respetar estrictamente los derechos de autor de $institution.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 8),
              Text(
                'Aun cuando la pintura original sea histórica, la fotografía de alta resolución posee copyright de la institución.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              if (officialSourceUrl != null)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.open_in_browser_rounded),
                  label: const Text('Ver obra en la web del museo'),
                  onPressed: () {
                    // Open browser
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
