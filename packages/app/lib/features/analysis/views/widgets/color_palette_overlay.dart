import 'package:flutter/material.dart';

class ArtworkColorSwatch {
  final Color color;
  final String hex;
  final String name;
  final String role; // 'Dominante', 'Subordinado', 'Acento'

  const ArtworkColorSwatch({
    required this.color,
    required this.hex,
    required this.name,
    required this.role,
  });
}

/// Color palette inspection overlay.
class ColorPaletteOverlay extends StatelessWidget {
  final List<ArtworkColorSwatch> swatches;
  final String harmonyDescription;

  const ColorPaletteOverlay({
    super.key,
    required this.swatches,
    this.harmonyDescription = 'Armonía de contraste complementario (Amarillo / Azul-Verde)',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, size: 16, color: Colors.amber),
              const SizedBox(width: 8),
              const Text(
                'Paleta Cromática & Armonía',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              Text(
                '${swatches.length} tonos',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: swatches.map((s) {
              return Tooltip(
                message: '${s.name} (${s.hex}) - ${s.role}',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: s.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white60, width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      s.hex,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            harmonyDescription,
            style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
