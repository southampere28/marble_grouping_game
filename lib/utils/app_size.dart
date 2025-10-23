import 'dart:math';
import 'package:flutter/material.dart';

class AppSize {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double parentWidth = 0;
  static double parentHeight = 0;
  static bool isTablet = false;

  static double scaleFactorWidth = 1.0;
  static double scaleFactorHeight = 1.0;
  static double scaleFactorFont = 1.0;

  static double rawScaleFactorWidth = 1.0;
  static double rawScaleFactorHeight = 1.0;
  static double rawScaleFactorFont = 1.0;

  static const double defaultMinScale = 0.5;
  static const double defaultMaxScale = 1.5;

  // Reference design size (Pixel 8)
  static const double refWidth = 412.0;
  static const double refHeight = 890.0;

  // Variabel untuk ukuran width
  static late double sizeSuperSmall;
  static late double sizeExtraSmall;
  static late double sizeSmall;
  static late double sizeSmallMedium;
  static late double sizeMedium;
  static late double sizeMediumLarge;
  static late double sizeLarge;
  static late double sizeExtraLarge;
  static late double sizeSuperLarge;

  // Variabel untuk ukuran font
  // static late TextStyle bodySmall;
  // static late TextStyle bodyMedium;
  // static late TextStyle bodyLarge;
  // static late TextStyle titleSmall;
  // static late TextStyle titleMedium;
  // static late TextStyle titleLarge;
  // static late TextStyle headlineSmall;
  // static late TextStyle headlineMedium;
  // static late TextStyle headlineLarge;

  // Variabel untuk padding
  static late EdgeInsets paddingSuperSmall;
  static late EdgeInsets paddingExtraSmall;
  static late EdgeInsets paddingSmall;
  static late EdgeInsets paddingSmallMedium;
  static late EdgeInsets paddingMedium;
  static late EdgeInsets paddingLarge;
  static late EdgeInsets paddingMediumLarge;
  static late EdgeInsets paddingExtraLarge;
  static late EdgeInsets paddingSuperLarge;
  static late EdgeInsets paddingBottom;

  static late BorderRadius radiusSuperSmall;
  static late BorderRadius radiusExtraSmall;
  static late BorderRadius radiusSmall;
  static late BorderRadius radiusSmallMedium;
  static late BorderRadius radiusMedium;
  static late BorderRadius radiusLarge;
  static late BorderRadius radiusMediumLarge;
  static late BorderRadius radiusExtraLarge;
  static late BorderRadius radiusSuperLarge;
  static late double w100;
  static late Border borderSmallBlack;
  static late Border borderSmallMediumBlack;
  static late Border borderMediumBlack;
  static late double operationNumberSize;

  static void init(
    BuildContext context, {
    double? containerWidth,
    double? containerHeight,
  }) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isTablet = MediaQuery.of(context).size.width > 600;

    parentWidth = containerWidth ?? screenWidth;
    parentHeight = containerHeight ?? screenHeight;

    rawScaleFactorWidth = parentWidth / refWidth;
    rawScaleFactorHeight = parentHeight / refHeight;
    rawScaleFactorFont = sqrt(rawScaleFactorWidth * rawScaleFactorHeight);

    // Calculate DEFAULT CLAMPED scale factors
    scaleFactorWidth =
        _applyClamping(rawScaleFactorWidth, defaultMinScale, defaultMaxScale);
    scaleFactorHeight =
        _applyClamping(rawScaleFactorHeight, defaultMinScale, defaultMaxScale);
    scaleFactorFont =
        _applyClamping(rawScaleFactorFont, defaultMinScale, defaultMaxScale);

    // Inisialisasi ukuran font
    // bodySmall = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(6),
    //     fontWeight: FontWeight.normal,
    //     color: Colors.white);
    // bodyMedium = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(8),
    //     fontWeight: FontWeight.normal,
    //     color: Colors.white);
    // bodyLarge = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(10),
    //     fontWeight: FontWeight.normal,
    //     color: Colors.white);
    // titleSmall = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(12),
    //     fontWeight: FontWeight.normal,
    //     color: Colors.white);
    // titleMedium = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(14),
    //     fontWeight: FontWeight.normal,
    //     color: Colors.white);
    // titleLarge = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(16),
    //     fontWeight: FontWeight.normal,
    //     color: Colors.white);
    // headlineSmall = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(20),
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white);
    // headlineMedium = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(24),
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white);
    // headlineLarge = TextStyle(
    //     fontFamily: FontThemes.mainFont,
    //     fontSize: fontSize(28),
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white);

    // Inisialisasi ukuran padding
    paddingSuperSmall = paddingAll(2);
    paddingExtraSmall = paddingAll(4);
    paddingSmall = paddingAll(8);
    paddingSmallMedium = paddingAll(12);
    paddingMedium = paddingAll(16);
    paddingLarge = paddingAll(20);
    paddingMediumLarge = paddingAll(24);
    paddingExtraLarge = paddingAll(28);
    paddingSuperLarge = paddingAll(32);

    radiusSuperSmall = borderRadius(2);
    radiusExtraSmall = borderRadius(4);
    radiusSmall = borderRadius(8);
    radiusSmallMedium = borderRadius(12);
    radiusMedium = borderRadius(16);
    radiusLarge = borderRadius(20);
    radiusMediumLarge = borderRadius(24);
    radiusExtraLarge = borderRadius(28);
    radiusSuperLarge = borderRadius(32);
  }

  static double _applyClamping(double factor, double minVal, double maxVal) {
    final effectiveMin = min(minVal, maxVal);
    final effectiveMax = max(minVal, maxVal);
    return max(effectiveMin, min(effectiveMax, factor));
  }

  static double width(double width) => width * scaleFactorWidth;

  static double height(double height) => height * scaleFactorHeight;

  static double fontSize(double fontSize) => fontSize * scaleFactorFont;

  // static double scaledValue(
  //     double value, {
  //       required VerticalOperationScale scaleType,
  //       double minScale = defaultMinScale,
  //       double maxScale = defaultMaxScale,
  //     }) {
  //   double rawFactor;
  //   switch (scaleType) {
  //     case VerticalOperationScale.width:
  //       rawFactor = rawScaleFactorWidth;
  //       break;
  //     case VerticalOperationScale.height:
  //       rawFactor = rawScaleFactorHeight;
  //       break;
  //     case VerticalOperationScale.font:
  //       rawFactor = rawScaleFactorFont;
  //       break;
  //   }
  //   final clampedFactor = _applyClamping(rawFactor, minScale, maxScale);
  //   return value * clampedFactor;
  // }

  static EdgeInsets paddingAll(double all) {
    return EdgeInsets.all(width(all));
  }

  static EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: width(horizontal),
      vertical: height(vertical),
    );
  }

  static EdgeInsets paddingFromLTRB(
      double? left,
      double? top,
      double? right,
      double? bottom,
      ) {
    return EdgeInsets.fromLTRB(
      width(left ?? 0),
      height(top ?? 0),
      width(right ?? 0),
      height(bottom ?? 0),
    );
  }

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: width(left),
      top: height(top),
      right: width(right),
      bottom: height(bottom),
    );
  }

  static BorderRadius borderRadius(double value) {
    return BorderRadius.circular(height(value));
  }

  static Radius radius(double value) {
    return Radius.circular(height(value));
  }

  static Offset offset(double value) {
    return Offset(height(value), height(value));
  }

  static double responsiveRatio({
    required int itemCount,
    required double factor,
    required double min,
    required double max,
  }) {
    return (itemCount * factor / 10).clamp(min, max);
  }

  static SizedBox sizeBox({required SizedBox sizeBox}) {
    double? heightSize = sizeBox.height;
    double? widthSize = sizeBox.width;
    if (heightSize != null && widthSize != null) {
      return SizedBox(
        height: height(heightSize),
        width: width(widthSize),
      );
    } else if (heightSize != null) {
      return SizedBox(
        height: height(heightSize),
      );
    } else if (widthSize != null) {
      return SizedBox(
        width: width(widthSize),
      );
    } else {
      return const SizedBox();
    }
  }

  static SizedBox sizeBoxDouble({
    double? height,
    double? width,
  }) {
    return sizeBox(
        sizeBox: SizedBox(
          height: height,
          width: width,
        ));
  }
}
