import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/features/home/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Content Here'),
      ),
    );
  }
}
