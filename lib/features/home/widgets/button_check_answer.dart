import 'package:flutter/material.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/constant/app_font_style.dart';
import 'package:marble_grouping_game/features/home/home_controller.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ButtonCheckAnswer extends StatelessWidget {
  const ButtonCheckAnswer({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: ZoomTapAnimation(
          onTap: () {
            controller.checkAnswer(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor.successColor,
                border: Border.all(
                    color: AppColor.successShadow, width: 1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.successShadow,
                    blurRadius: 0,
                    offset: Offset(4, 3),
                  ),
                ]),
            child: Center(
              child: Text(
                'Check Answer!',
                style: AppFontStyle.primaryText.copyWith(
                    color: AppColor.darkGreen,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ),
    );
  }
}
