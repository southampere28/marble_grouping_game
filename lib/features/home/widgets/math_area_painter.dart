import 'package:flutter/material.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/constant/app_font_style.dart';

class MathAreaPainter extends CustomPainter {
  final int dividen;
  final int divisor;

  MathAreaPainter({super.repaint, required this.dividen, required this.divisor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColor.thirdColor;

    final shadowPaint = Paint()
      ..color = AppColor.thirdShadow
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);

    final equalPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColor.forthColor;

    // offset of primary container
    Offset c = Offset(size.width / 2, size.height / 2);

    Rect primaryRect = Rect.fromCenter(
        center: c, width: size.width - 60, height: size.height - 20);

    RRect primaryRRect = RRect.fromRectAndCorners(primaryRect,
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12));

    // rrect shift container
    final shadowRectPrimary = primaryRRect.shift(Offset(6, 6));

    // shadow and primary container
    canvas.drawRRect(shadowRectPrimary, shadowPaint);
    canvas.drawRRect(primaryRRect, paint);

    // Offset of Equal Container
    Offset equalOffset = Offset(size.width / 2, size.height - 10);

    Rect equalRect =
        Rect.fromCenter(center: equalOffset, width: 100, height: 30);

    RRect equalRRect = RRect.fromRectAndCorners(equalRect,
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8));

    // rrect shift container
    final shadowRectEqual = equalRRect.shift(Offset(4, 4));

    canvas.drawRRect(shadowRectEqual, shadowPaint);
    canvas.drawRRect(equalRRect, equalPaint);

    // ==== text painter ====
    final textSpanQuestionFormula = TextSpan(
        text: "$dividen \u00F7 $divisor",
        style: AppFontStyle.bigText.copyWith(
          color: Colors.white,
        ));
    final textPainterQuestionFormula = TextPainter(
      text: textSpanQuestionFormula,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainterQuestionFormula.layout();

    final Offset formulaPosition = Offset(
        (size.width - textPainterQuestionFormula.width) / 2,
        (size.height - textPainterQuestionFormula.height) / 2);

    textPainterQuestionFormula.paint(canvas, formulaPosition);

    // ==== text painter equal ====
    final textSpanEqual = TextSpan(
        text: "=",
        style:
            AppFontStyle.titleText.copyWith(color: Colors.white, fontSize: 26));
    final textPainterEqual = TextPainter(
      text: textSpanEqual,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainterEqual.layout();

    final Offset equalPosition = Offset(
        (equalOffset.dx - textPainterEqual.width / 2),
        (equalOffset.dy - textPainterEqual.height / 2));

    textPainterEqual.paint(canvas, equalPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
