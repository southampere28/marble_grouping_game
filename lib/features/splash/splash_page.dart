import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/features/splash/splash_controller.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Text('Splash Screen Page'),
      ),
    );
  }
}
