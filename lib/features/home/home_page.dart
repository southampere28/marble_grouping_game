import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                painter: MathAreaPainter(
                    dividen: controller.dividen, divisor: controller.divisor),
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
                          // if dragged marble in group, it will break
                          if (controller.marbleBoxIndex.value[i] != null) {
                            break;
                          } else {
                            controller.draggingIndex.value = i;
                            break;
                          }
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
                          // check if marble connect to marble that have box
                          bool isOtherposInGroup =
                              controller.marbleBoxIndex.value[i] != null;

                          if (isOtherposInGroup) {
                            int boxesIdxOtherpos =
                                controller.marbleBoxIndex.value[i]!;

                            var box = controller.boxes[boxesIdxOtherpos];

                            // joinn in other group
                            final newGroupId =
                                groupIds.value[i]; // grup si other

                            // ubah semua marble yang 1 grup sama dragged menjadi grupnya other
                            for (int j = 0; j < groupIds.value.length; j++) {
                              if (groupIds.value[j] == draggedGroup) {
                                groupIds.value[j] = newGroupId;
                              }
                            }

                            final dir = (draggedPos - otherPos).direction;

                            marbles.value[draggingIndex.value!] =
                                otherPos + Offset(35 * cos(dir), 35 * sin(dir));

                            final marbleGroupIndices = controller.groupIds.value
                                .asMap()
                                .entries
                                .where((e) => e.value == newGroupId)
                                .map((e) => e.key)
                                .toList();

                            // make the marbleboxindex join
                            for (var idx in marbleGroupIndices) {
                              controller.marbleBoxIndex.value[idx] =
                                  boxesIdxOtherpos;

                              // update fill color and outline color of marble too based on boxes theme
                              controller.marbleColorFill.value[idx] =
                                  controller.boxesFillColor[boxesIdxOtherpos];
                              controller.marbleColorOutline.value[idx] =
                                  controller.boxesBaseColor[boxesIdxOtherpos];
                            }

                            // refresh
                            controller.marbleBoxIndex.refresh();
                            controller.marbleColorFill.refresh();
                            controller.marbleColorOutline.refresh();

                            // arrange circles in 2 row horizontal on the right side box
                            const spacing = 35.0;
                            const offsetFromBox = 20.0;
                            for (int j = 0;
                                j < marbleGroupIndices.length;
                                j++) {
                              final rowIndex = j % 2;
                              final colIndex = j ~/ 2;

                              final newPos = Offset(
                                box.right + offsetFromBox + colIndex * spacing,
                                box.top +
                                    box.height / 2 -
                                    spacing / 2 +
                                    rowIndex * spacing,
                              );

                              marbles.value[marbleGroupIndices[j]] = newPos;
                            }
                          } else {
                            // create new group
                            final newGroupId = groupIds.value[i];
                            for (int j = 0; j < groupIds.value.length; j++) {
                              if (groupIds.value[j] == newGroupId) {
                                groupIds.value[j] = draggedGroup;
                              }
                            }

                            final dir = (otherPos - draggedPos).direction;
                            marbles.value[i] = draggedPos +
                                Offset(35 * cos(dir), 35 * sin(dir));
                          }
                        }
                      }

                      controller.resolveOverlap();
                      marbles.refresh();
                      groupIds.refresh();
                      controller.draggingIndex.value = null;

                      // Boxes Check Logic
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.reset();
                      },
                      child: Text('Reset')),
                  TextButton(
                      onPressed: () {
                        bool resultCheck = controller.resultCheck();

                        if (resultCheck) {
                          Fluttertoast.showToast(msg: 'Your answer is correct');
                        } else {
                          Fluttertoast.showToast(msg: 'Wrong, try again!');
                        }
                      },
                      child: Text('Count Boxes')),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}
