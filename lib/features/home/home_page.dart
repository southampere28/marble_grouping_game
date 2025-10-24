import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/constant/app_font_style.dart';
import 'package:marble_grouping_game/features/home/home_controller.dart';
import 'package:marble_grouping_game/features/home/widgets/math_area_painter.dart';
import 'package:marble_grouping_game/features/home/widgets/playground_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();

    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 24),
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.secondaryShadow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  'Find the result of the division',
                  style: AppFontStyle.primaryText.copyWith(color: Colors.white),
                )),
              ),
              CustomPaint(
                painter: MathAreaPainter(),
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height / 8),
              ),
              Expanded(
                child: Obx(() {
                  final marbles = controller.marbles;
                  final draggingIndex = controller.draggingIndex;
                  final groupIds = controller.groupIds;

                  return GestureDetector(
                    onPanStart: (details) {
                      final touch = details.localPosition;
                      for (int i = 0; i < marbles.value.length; i++) {
                        if ((touch - marbles.value[i]).distance < 20) {
                          controller.draggingIndex.value = i;
                          break;
                        }
                      }
                    },
                    onPanUpdate: (details) {
                      final idx = draggingIndex.value;
                      if (idx == null) return;

                      final groupId = groupIds.value[idx];
                      final delta = details.delta;

                      for (int i = 0; i < marbles.value.length; i++) {
                        if (groupIds.value[i] == groupId) {
                          marbles.value[i] += delta;
                        }
                      }
                      marbles.refresh();
                    },
                    onPanEnd: (_) {
                      final draggedIndex = draggingIndex.value;
                      if (draggedIndex == null) return;

                      // Sticky Marble Logic
                      const stickyThreshold = 50.0;
                      final draggedPos = marbles.value[draggedIndex];
                      final draggedGroup = groupIds.value[draggedIndex];

                      for (int i = 0; i < marbles.value.length; i++) {
                        if (i == draggedIndex) continue;

                        final otherPos = marbles.value[i];
                        final distance = (draggedPos - otherPos).distance;

                        if (distance < stickyThreshold) {
                          final newGroupId = groupIds.value[i];
                          for (int j = 0; j < groupIds.value.length; j++) {
                            if (groupIds.value[j] == newGroupId) {
                              groupIds.value[j] = draggedGroup;
                            }
                          }

                          final dir = (otherPos - draggedPos).direction;
                          marbles.value[i] =
                              draggedPos + Offset(35 * cos(dir), 35 * sin(dir));
                        }
                      }

                      controller.resolveOverlap();
                      marbles.refresh();
                      groupIds.refresh();
                      controller.draggingIndex.value = null;

                      // Boxes Check Logic
                      // next...
                    },
                    child: SizedBox.expand(
                      child: CustomPaint(
                        painter: PlaygroundPainter(marbles.value),
                      ),
                    ),
                  );
                }),
              ),
              Text('Button'),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
