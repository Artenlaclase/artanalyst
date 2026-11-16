import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:art_analyst_shared/shared.dart';

/// Educational dialog explaining intellectual property rights and digital reproduction rules.
class LicenseEducationalDialog extends StatelessWidget {
  final LicenseSemaphore semaphore;
  final LicenseType licenseType;
  final String? attributionText;
  final String? officialSourceUrl;
  final String? institutionName;

  const LicenseEducationalDialog({
    super.key,
    required this.semaphore,
    required this.licenseType,
    this.attributionText,
    this.officialSourceUrl,
    this.institutionName,
  });

  Color _getColor() {
    switch (semaphore) {
      case LicenseSemaphore.green:
        return const Color(0xFF2E7D32);
      case LicenseSemaphore.yellow:
        return const Color(0xFFEF6C00);
      case LicenseSemaphore.red:
        return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guide = AttributionFormatter.generateEducationalGuide(licenseType, semaphore);
    final color = _getColor();
    final allowed = (guide['allowed'] as List<dynamic>?) ?? [];
    final prohibited = (guide['prohibited'] as List<dynamic>?) ?? [];
    final citationAdvice = guide['citationAdvice'] as String? ?? '';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              semaphore == LicenseSemaphore.green
                  ? Icons.check_circle_rounded
                  : semaphore == LicenseSemaphore.yellow
                      ? Icons.attribution_rounded
                      : Icons.gavel_rounded,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide['title'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  licenseType.name,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  guide['summary'] as String,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Permitido:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 6),
              ...allowed.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, size: 16, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.toString(), style: const TextStyle(fontSize: 12.5))),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),
              const Text(
                'Restricciones y Prohibiciones:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFC62828)),
              ),
              const SizedBox(height: 6),
              ...prohibited.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.close, size: 16, color: Color(0xFFC62828)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.toString(), style: const TextStyle(fontSize: 12.5))),
                      ],
                    ),
                  )),
              if (attributionText != null && attributionText!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Cita oficial de atribución (TASL):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          attributionText!,
                          style: const TextStyle(fontSize: 11.5, fontFamily: 'monospace'),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Copiar atribución',
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: attributionText!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Atribución copiada al portapapeles'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                citationAdvice,
                style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (officialSourceUrl != null && officialSourceUrl!.isNotEmpty)
          TextButton.icon(
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: const Text('Ver en catálogo oficial'),
            onPressed: () {
              // Can launch URL
            },
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendido'),
        ),
      ],
    );
  }
}
