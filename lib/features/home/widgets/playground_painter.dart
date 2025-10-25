import 'package:flutter/material.dart';
import 'package:marble_grouping_game/constant/app_color.dart';

class PlaygroundPainter extends CustomPainter {
  final List<Offset> marbles;
  List<Color?> marbleFill;
  List<Color?> marbleOutline;
  final List<RRect> boxes;
  final List<Color> boxesBaseColor;
  final List<Color> boxesFillColor;
  PlaygroundPainter(
      {super.repaint,
      required this.marbles,
      required this.marbleFill,
      required this.marbleOutline,
      required this.boxes,
      required this.boxesBaseColor,
      required this.boxesFillColor});

  @override
  void paint(Canvas canvas, Size size) {

    // draw boxes
    for (int i = 0; i < boxes.length; i++) {
      final box = boxes[i];

      final shadowBox = box.shift(const Offset(4, 4));

      final shadowPaint = Paint()
        ..color = boxesBaseColor[i]
        ..style = PaintingStyle.fill;

      final fillPaint = Paint()
        ..color = boxesFillColor[i]
        ..style = PaintingStyle.fill;

      canvas.drawRRect(shadowBox, shadowPaint);
      canvas.drawRRect(box, fillPaint);
    }

    // draw marble
    for (int i = 0; i < marbles.length; i++) {
      final fillPaint = Paint()
        ..color = marbleFill[i]?? AppColor.thirdColor
        ..style = PaintingStyle.fill;
      final outlinePaint = Paint()
        ..color = marbleOutline[i] ?? AppColor.thirdShadow
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(marbles[i], 20, fillPaint);
      canvas.drawCircle(marbles[i], 20, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PlaygroundPainter oldDelegate) {
    return true;
  }
}
