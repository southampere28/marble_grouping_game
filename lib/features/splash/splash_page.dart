import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/constant/app_font_style.dart';
import 'package:marble_grouping_game/features/splash/splash_controller.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.find<SplashController>();

    return Scaffold(
      body:SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Expanded(
            child: SizedBox(),
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 100,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Marble Grouping Game',
            style: AppFontStyle.titleText,
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Text(
            'Copyright@2025 pramudya',
            style: AppFontStyle.smallText,
          ),
          const SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }
}
