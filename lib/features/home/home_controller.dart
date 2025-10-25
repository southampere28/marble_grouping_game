import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/features/home/core/dummy_marble.dart';

class HomeController extends GetxController {
  // question formula
  var dividen = 24; // I use integer instead of observable cause static value
  var divisor = 3; // -------------------------------------------------

  // index marble while drag
  final RxnInt draggingIndex = RxnInt(null);

  // list position offset of marbles
  final marbles = Rx<List<Offset>>([]);

  // marble color fill
  final marbleColorFill = Rx<List<Color?>>(
    List.filled(24, null),
  );

  final marbleColorOutline = Rx<List<Color?>>(
    List.filled(24, null),
  );

  // list group marbles in i
  final groupIds = Rx<List<int>>([
    for (int i = 0; i < 24; i++) i,
  ]);

  // marblebox index to define number of box every marble
  final marbleBoxIndex = Rx<List<int?>>(
    List.filled(24, null),
  );

  // number count of each boxes
  final countBox = Rx<List<int>>([0, 0, 0]);

  // rect boxes with position included
  final boxes = [
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 60, 50, 80),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 170, 50, 80),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 280, 50, 80),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
  ];

  final boxesFillColor = <Color>[
    AppColor.fillC,
    AppColor.fillB,
    AppColor.fillA,
  ];

  final boxesBaseColor = <Color>[
    AppColor.baseC,
    AppColor.baseB,
    AppColor.baseA,
  ];

  // === function logic game ===

  // checkbox if any marble trying connect box
  void boxCheck(int draggedIndex) {
    for (int i = 0; i < boxes.length; i++) {
      final box = boxes[i];
      if (box.contains(marbles.value[draggedIndex])) {
        // grab all marble that in same group
        final draggedGroup = groupIds.value[draggedIndex];
        final marbleGroupIndices = groupIds.value
            .asMap()
            .entries
            .where((e) => e.value == draggedGroup)
            .map((e) => e.key)
            .toList();

        // Update marbleBoxIndex for all marble in group
        for (var idx in marbleGroupIndices) {
          marbleBoxIndex.value[idx] = i;

          // update fill color and outline color of marble too based on boxes theme
          marbleColorFill.value[idx] = boxesFillColor[i];
          marbleColorOutline.value[idx] = boxesBaseColor[i];
        }

        // arrange circles in 2 row horizontal on the right side box
        const spacing = 35.0;
        const offsetFromBox = 20.0;
        for (int j = 0; j < marbleGroupIndices.length; j++) {
          final rowIndex = j % 2;
          final colIndex = j ~/ 2;

          final newPos = Offset(
            box.right + offsetFromBox + colIndex * spacing,
            box.top + box.height / 2 - spacing / 2 + rowIndex * spacing,
          );

          marbles.value[marbleGroupIndices[j]] = newPos;
        }

        marbles.refresh();
        marbleBoxIndex.refresh();
        break;
      }
    }
  }

  // resolve overlap marble
  void resolveOverlap() {
    const minDist = 35.0;
    for (int i = 0; i < marbles.value.length; i++) {
      for (int j = i + 1; j < marbles.value.length; j++) {
        final diff = marbles.value[j] - marbles.value[i];
        final dist = diff.distance;
        if (dist < minDist) {
          final push = (minDist - dist) / 2;
          final dir = diff.direction;

          marbles.value[i] -= Offset(push * cos(dir), push * sin(dir));
          marbles.value[j] += Offset(push * cos(dir), push * sin(dir));
        }
      }
    }
  }

  // ===========================

  bool resultCheck() {
    // divider result
    int result = (dividen / divisor).toInt();

    for (int i = 0; i < boxes.length; i++) {
      final countInBox = marbleBoxIndex.value.where((idx) => idx == i).length;
      countBox.value[i] = countInBox;
    }

    countBox.refresh();

    bool allCorrect = countBox.value.every((count) => count == result);

    // testing data
    print('marble in boxes count -> ${countBox.value}');

    return allCorrect;
  }

  void reset() {
    // index marble while drag
    draggingIndex.value = null;

    // list position offset of marbles
    marbles.value =
        DummyMarble.dummyOffsetMarbles.map((e) => Offset(e.dx, e.dy)).toList();

    // marble color fill reset
    marbleColorFill.value = List.filled(24, null);
    marbleColorOutline.value = List.filled(24, null);

    // list group marbles in i reset
    groupIds.value = [
      for (int i = 0; i < 24; i++) i,
    ];

    // number count of each boxes reset
    countBox.value = [0, 0, 0];

    // marblebox index to define number of box every marble
    marbleBoxIndex.value = List.filled(24, null);

    marbles.refresh();
    marbleColorFill.refresh();
    marbleColorOutline.refresh();
    groupIds.refresh();
    countBox.refresh();
    marbleBoxIndex.refresh();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    marbles.value =
        DummyMarble.dummyOffsetMarbles.map((e) => Offset(e.dx, e.dy)).toList();
  }
}
