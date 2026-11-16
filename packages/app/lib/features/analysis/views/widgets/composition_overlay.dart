import 'package:flutter/material.dart';

/// Interactive overlay for geometric and compositional analysis of artworks.
/// Draws Rule of Thirds, Diagonals, and Symmetry axes.
class CompositionOverlay extends StatelessWidget {
  final bool showThirds;
  final bool showDiagonals;
  final bool showGoldenRatio;

  const CompositionOverlay({
    super.key,
    this.showThirds = true,
    this.showDiagonals = true,
    this.showGoldenRatio = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _CompositionPainter(
          showThirds: showThirds,
          showDiagonals: showDiagonals,
          showGoldenRatio: showGoldenRatio,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _CompositionPainter extends CustomPainter {
  final bool showThirds;
  final bool showDiagonals;
  final bool showGoldenRatio;

  _CompositionPainter({
    required this.showThirds,
    required this.showDiagonals,
    required this.showGoldenRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final thirdsPaint = Paint()
      ..color = Colors.amber.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final diagonalsPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final goldenPaint = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Rule of Thirds
    if (showThirds) {
      final w3 = size.width / 3;
      final h3 = size.height / 3;

      // Vertical thirds
      canvas.drawLine(Offset(w3, 0), Offset(w3, size.height), thirdsPaint);
      canvas.drawLine(Offset(w3 * 2, 0), Offset(w3 * 2, size.height), thirdsPaint);

      // Horizontal thirds
      canvas.drawLine(Offset(0, h3), Offset(size.width, h3), thirdsPaint);
      canvas.drawLine(Offset(0, h3 * 2), Offset(size.width, h3 * 2), thirdsPaint);

      // Focal intersection dots
      final dotPaint = Paint()..color = Colors.amber;
      for (int x = 1; x <= 2; x++) {
        for (int y = 1; y <= 2; y++) {
          canvas.drawCircle(Offset(w3 * x, h3 * y), 4.0, dotPaint);
        }
      }
    }

    // 2. Harmonic Diagonals (Rabattement / Dynamic symmetry)
    if (showDiagonals) {
      // Main diagonals
      canvas.drawLine(Offset.zero, Offset(size.width, size.height), diagonalsPaint);
      canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), diagonalsPaint);

      // Perpendicular reciprocal diagonals
      canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), diagonalsPaint);
      canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), diagonalsPaint);
    }

    // 3. Golden Ratio (Phi approx 0.618 and 0.382)
    if (showGoldenRatio) {
      final phi1 = size.width * 0.382;
      final phi2 = size.width * 0.618;
      final phiY1 = size.height * 0.382;
      final phiY2 = size.height * 0.618;

      canvas.drawLine(Offset(phi1, 0), Offset(phi1, size.height), goldenPaint);
      canvas.drawLine(Offset(phi2, 0), Offset(phi2, size.height), goldenPaint);
      canvas.drawLine(Offset(0, phiY1), Offset(size.width, phiY1), goldenPaint);
      canvas.drawLine(Offset(0, phiY2), Offset(size.width, phiY2), goldenPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompositionPainter oldDelegate) {
    return oldDelegate.showThirds != showThirds ||
        oldDelegate.showDiagonals != showDiagonals ||
        oldDelegate.showGoldenRatio != showGoldenRatio;
  }
}
