import 'package:flutter/material.dart';
import 'package:marble_grouping_game/constant/app_color.dart';
import 'package:marble_grouping_game/constant/app_font_style.dart';

class AppUtil {
  static Future<void> dialogResult(BuildContext context, bool result, {
    required List<int> countBox,
    required int correctAnswer,
    required VoidCallback reset,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            child: result
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Awesome! 🎉",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Great job! You got it right!",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // todo
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Yay! Let's Go!",
                            style: AppFontStyle.primaryText
                                .copyWith(color: Colors.white)),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Oops! 😅",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "The correct answer is: $correctAnswer for each box.",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(countBox.length, (index) {
                          final boxColors = [
                            AppColor.baseC,
                            AppColor.baseB,
                            AppColor.baseA,
                          ];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration:
                                      BoxDecoration(color: boxColors[index]),
                                ),
                                const SizedBox(width: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Box ${index + 1} => ${countBox[index]}',
                                      style: AppFontStyle.titleText,
                                    ),
                                    Icon(
                                      countBox[index] ==
                                              correctAnswer
                                          ? Icons.check
                                          : Icons.close,
                                      color: countBox[index] ==
                                              correctAnswer
                                          ? AppColor.activeColor
                                          : AppColor.errorColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.inactiveColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Close",
                                style: AppFontStyle.primaryText
                                    .copyWith(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              reset();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Try Again",
                                style: AppFontStyle.primaryText
                                    .copyWith(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}