import 'package:flutter/material.dart';
import 'package:art_analyst_shared/shared.dart';
import 'license_educational_dialog.dart';

/// Reusable UI widget showing the license traffic light badge.
/// Clicking it opens the educational intellectual property dialog.
class LicenseBadge extends StatelessWidget {
  final LicenseSemaphore semaphore;
  final LicenseType licenseType;
  final String? attributionText;
  final String? officialSourceUrl;
  final String? institutionName;
  final bool compact;

  const LicenseBadge({
    super.key,
    required this.semaphore,
    required this.licenseType,
    this.attributionText,
    this.officialSourceUrl,
    this.institutionName,
    this.compact = false,
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

  IconData _getIcon() {
    switch (semaphore) {
      case LicenseSemaphore.green:
        return Icons.lock_open_rounded;
      case LicenseSemaphore.yellow:
        return Icons.attribution_rounded;
      case LicenseSemaphore.red:
        return Icons.lock_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: 'Pulsa para ver la ficha legal y educativa de derechos',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => LicenseEducationalDialog(
                semaphore: semaphore,
                licenseType: licenseType,
                attributionText: attributionText,
                officialSourceUrl: officialSourceUrl,
                institutionName: institutionName,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 8 : 12,
              vertical: compact ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.25 : 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.5), width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getIcon(), size: compact ? 14 : 16, color: color),
                const SizedBox(width: 6),
                Text(
                  compact ? licenseType.code : semaphore.label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: compact ? 11 : 12,
                    letterSpacing: 0.2,
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.info_outline_rounded, size: 14, color: color.withOpacity(0.7)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
