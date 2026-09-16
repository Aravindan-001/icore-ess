import 'package:flutter/material.dart';
import 'dart:math';

class DonutChart extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final double strokeWidth;

  const DonutChart({
    super.key,
    required this.values,
    required this.colors,
    this.strokeWidth = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: _DonutPainter(values, colors, strokeWidth),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double strokeWidth;

  _DonutPainter(this.values, this.colors, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.fold(0, (sum, item) => sum + item);
    double startAngle = -pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.values != values || 
           oldDelegate.colors != colors || 
           oldDelegate.strokeWidth != strokeWidth;
  }
}
