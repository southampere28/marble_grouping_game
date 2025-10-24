import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final marbles = Rx<List<Offset>>([
    const Offset(30, 50),
    const Offset(100, 60),
    const Offset(180, 80),
    const Offset(260, 90),
    const Offset(50, 150),
    const Offset(130, 160),
    const Offset(210, 170),
    const Offset(290, 180),
    const Offset(40, 240),
    const Offset(120, 250),
    const Offset(200, 260),
    const Offset(280, 270),
    const Offset(60, 320),
    const Offset(140, 330),
    const Offset(220, 340),
    const Offset(300, 350),
    const Offset(80, 400),
    const Offset(160, 390),
    const Offset(240, 380),
    const Offset(280, 370),
    const Offset(100, 200),
    const Offset(150, 100),
    const Offset(200, 300),
    const Offset(250, 150),
  ]);

  final groupIds = Rx<List<int>>([
    for (int i = 0; i < 24; i++) i,
  ]);

  final RxnInt draggingIndex = RxnInt(null);

  void resolveOverlap() {
    const minDist = 40.0;
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
