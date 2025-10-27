import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/constant/app_font_style.dart';
import 'package:marble_grouping_game/features/home/home_controller.dart';
import 'package:marble_grouping_game/features/home/widgets/button_check_answer.dart';
import 'package:marble_grouping_game/features/home/widgets/math_area_painter.dart';
import 'package:marble_grouping_game/features/home/widgets/playground_painter.dart';
import 'package:marble_grouping_game/utils/app_util.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();

    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 8, left: 20, right: 20, bottom: 24),
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.secondaryShadow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      'Find the result of the division',
                      style: AppFontStyle.primaryText
                          .copyWith(color: Colors.white),
                    )),
                  ),
                  CustomPaint(
                    painter: MathAreaPainter(
                        dividen: controller.dividen,
                        divisor: controller.divisor),
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height / 8),
                  ),
                  Expanded(
                    child: Obx(() {
                      final marbles = controller.marbles;
                      final draggingIndex = controller.draggingIndex;

                      return GestureDetector(
                        onPanStart: (details) {
                          controller.onTouchStart(details);
                        },
                        onPanUpdate: (details) {
                          controller.onDragUpdate(details);
                        },
                        onPanEnd: (_) {
                          final draggedIndex = draggingIndex.value;
                          if (draggedIndex == null) return;

                          // Sticky Marble Logic
                          controller.marbleStick(draggedIndex);

                          // Boxes Check Sticky Logic
                          controller.boxCheck(draggedIndex);
                        },
                        child: SizedBox.expand(
                          child: CustomPaint(
                              painter: PlaygroundPainter(
                                  marbles: marbles.value,
                                  boxes: controller.boxes,
                                  boxesBaseColor: controller.boxesBaseColor,
                                  boxesFillColor: controller.boxesFillColor,
                                  marbleFill: controller.marbleColorFill.value,
                                  marbleOutline:
                                      controller.marbleColorOutline.value)),
                        ),
                      );
                    }),
                  ),
                  ButtonCheckAnswer(controller: controller),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              ConfettiWidget(
                confettiController: controller.confettiController,
                shouldLoop: true,

                // set direction
                blastDirectionality: BlastDirectionality.explosive,

                // set emission count
                emissionFrequency: 0.2,

                numberOfParticles: 20,
                minBlastForce: 10,
                maxBlastForce: 60,
              ),
            ],
          ),
        ));
  }
}
