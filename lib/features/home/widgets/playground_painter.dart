import 'package:flutter/material.dart';
import 'package:marble_grouping_game/constant/app_color.dart';

class PlaygroundPainter extends CustomPainter {
  final List<Offset> marbles;
  PlaygroundPainter(this.marbles);

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = AppColor.thirdColor
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = AppColor.thirdShadow
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final pos in marbles) {
      canvas.drawCircle(pos, 20, fillPaint);
      canvas.drawCircle(pos, 20, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PlaygroundPainter oldDelegate) {
    return true;
  }
}