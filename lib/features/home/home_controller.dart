import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/features/home/core/dummy_marble.dart';
import 'package:marble_grouping_game/utils/app_util.dart';

class HomeController extends GetxController {
  // question formula
  var dividen = 24; // I use integer instead of observable cause static value
  var divisor = 3; // -------------------------------------------------

  // answer
  var correctAnswer = 0.obs;

  // confetti controller
  final isPlaying = false.obs;
  final confettiController = ConfettiController();

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
      Rect.fromLTWH(0, 50, 50, 100),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 170, 50, 100),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 290, 50, 100),
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

  // flag audio for play sfx once
  RxBool audioFlag = false.obs;
  final stickyPlayer = AudioPlayer();
  final stickyBoxPlayer = AudioPlayer();
  final successBoxPlayer = AudioPlayer();
  final failBoxPlayer = AudioPlayer();

  Future<void> playStickySfx() async {
    await stickyPlayer.stop();
    await stickyPlayer.play(AssetSource('audio/stickysfx.mp3'));
  }

  Future<void> playStickyBoxSfx() async {
    await stickyBoxPlayer.stop();
    await stickyBoxPlayer.play(AssetSource('audio/stickyboxsfx.mp3'));
  }

  Future<void> playSuccessSfx() async {
    await successBoxPlayer.stop();
    await successBoxPlayer.play(AssetSource('audio/success.mp3'));
  }

  Future<void> playFailedSfx() async {
    await failBoxPlayer.stop();
    await failBoxPlayer.play(AssetSource('audio/failedsfx.mp3'));
  }

  // on touch start (choose index marble)
  void onTouchStart(DragStartDetails details) {
    final touch = details.localPosition;
    for (int i = 0; i < marbles.value.length; i++) {
      if ((touch - marbles.value[i]).distance < 20) {
        // if dragged marble in group, it will break
        if (marbleBoxIndex.value[i] != null) {
          break;
        } else {
          draggingIndex.value = i;
          break;
        }
      }
    }
  }

  // on pan update (drag marble logic)
  void onDragUpdate(DragUpdateDetails details, Size areaSize) {
    final idx = draggingIndex.value;
    if (idx == null) return;

    final groupId = groupIds.value[idx];
    final delta = details.delta;

    for (int i = 0; i < marbles.value.length; i++) {
      if (groupIds.value[i] == groupId) {
        final newOffset = marbles.value[i] + delta;

        const double radius = 20;
        final double minX = radius;
        final double minY = radius;
        final double maxX = areaSize.width - radius;
        final double maxY = areaSize.height - radius;

        final constrainedOffset = Offset(
          newOffset.dx.clamp(minX, maxX),
          newOffset.dy.clamp(minY, maxY),
        );

        marbles.value[i] = constrainedOffset;
      }
    }
    marbles.refresh();
  }

  // sticky marble logic
  void marbleStick(int draggedIndex) {
    audioFlag.value = true;
    const stickyThreshold = 50.0;
    final draggedPos = marbles.value[draggedIndex];
    final draggedGroup = groupIds.value[draggedIndex];

    for (int i = 0; i < marbles.value.length; i++) {
      if (i == draggedIndex) continue;

      final otherPos = marbles.value[i];
      final distance = (draggedPos - otherPos).distance;

      if (distance < stickyThreshold) {
        // check if marble connect to marble that have box
        bool isOtherposInGroup = marbleBoxIndex.value[i] != null;

        // is dragged index in group
        bool isDraggedIndexInGroup =
            groupIds.value.where((g) => g == draggedGroup).length > 1;

        if (isOtherposInGroup) {
          // play audio
          if (audioFlag.value) {
            playStickyBoxSfx();
            audioFlag.value = false;
          }

          int boxesIdxOtherpos = marbleBoxIndex.value[i]!;

          var box = boxes[boxesIdxOtherpos];

          // joinn in other group
          final newGroupId = groupIds.value[i];

          // change all marble group into the other's marble group
          for (int j = 0; j < groupIds.value.length; j++) {
            if (groupIds.value[j] == draggedGroup) {
              groupIds.value[j] = newGroupId;
            }
          }

          final dir = (draggedPos - otherPos).direction;

          marbles.value[draggingIndex.value!] =
              otherPos + Offset(35 * cos(dir), 35 * sin(dir));

          final marbleGroupIndices = groupIds.value
              .asMap()
              .entries
              .where((e) => e.value == newGroupId)
              .map((e) => e.key)
              .toList();

          // make the marbleboxindex join
          for (var idx in marbleGroupIndices) {
            marbleBoxIndex.value[idx] = boxesIdxOtherpos;

            // update fill color and outline color of marble too based on boxes theme
            marbleColorFill.value[idx] = boxesFillColor[boxesIdxOtherpos];
            marbleColorOutline.value[idx] = boxesBaseColor[boxesIdxOtherpos];
          }

          // refresh
          marbleBoxIndex.refresh();
          marbleColorFill.refresh();
          marbleColorOutline.refresh();

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
        } else {
          if (isDraggedIndexInGroup) {
            audioFlag.value = false;
          }

          if (audioFlag.value) {
            playStickySfx();
            audioFlag.value = false;
          }

          // create new group
          final newGroupId = groupIds.value[i];
          for (int j = 0; j < groupIds.value.length; j++) {
            if (groupIds.value[j] == newGroupId) {
              groupIds.value[j] = draggedGroup;
            }
          }

          final dir = (otherPos - draggedPos).direction;
          marbles.value[i] = draggedPos + Offset(35 * cos(dir), 35 * sin(dir));
        }
      }
    }

    resolveOverlap();
    marbles.refresh();
    groupIds.refresh();
    draggingIndex.value = null;
  }

  void checkAnswer(BuildContext context) async {
    var result = resultCheck();

    if (result) {
      confettiController.play();
    }

    await AppUtil.dialogResult(context, result,
        countBox: countBox.value,
        correctAnswer: correctAnswer.value,
        reset: reset);

    confettiController.stop();
  }

  // checkbox if any marble trying connect box
  void boxCheck(int draggedIndex) {
    for (int i = 0; i < boxes.length; i++) {
      final box = boxes[i];
      if (box.contains(marbles.value[draggedIndex])) {
        audioFlag.value = true;
        if (audioFlag.value) {
          playStickyBoxSfx();
          audioFlag.value = false;
        }

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

  // === function logic game END ===

  // === additional logic ===

  // answer check
  bool resultCheck() {
    // divider result
    int result = (dividen / divisor).toInt();

    // assign to global variable
    correctAnswer.value = result;

    for (int i = 0; i < boxes.length; i++) {
      final countInBox = marbleBoxIndex.value.where((idx) => idx == i).length;
      countBox.value[i] = countInBox;
    }

    countBox.refresh();

    bool allCorrect = countBox.value.every((count) => count == result);

    if (allCorrect) {
      playSuccessSfx();
    } else {
      playFailedSfx();
    }

    // testing data
    print('marble in boxes count -> ${countBox.value}');

    return allCorrect;
  }

  // reset state
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
    correctAnswer.value = 0;

    marbles.refresh();
    marbleColorFill.refresh();
    marbleColorOutline.refresh();
    groupIds.refresh();
    countBox.refresh();
    marbleBoxIndex.refresh();
  }

  // === additional logic END ===

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
    marbles.value =
        DummyMarble.dummyOffsetMarbles.map((e) => Offset(e.dx, e.dy)).toList();

    confettiController.addListener(() {
      isPlaying.value =
          confettiController.state == ConfettiControllerState.playing;
    });
  }
}
