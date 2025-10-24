import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marble_grouping_game/constant/app_color.dart';

class AppFontStyle {
  static TextStyle titleText = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColor.textPrimary,
  );

  static TextStyle primaryText = GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.normal, color: AppColor.textPrimary);

  static TextStyle smallText = GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.normal, color: AppColor.textPrimary);

  static TextStyle secondaryText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF757575),
  );

  static TextStyle bigText = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );
}
