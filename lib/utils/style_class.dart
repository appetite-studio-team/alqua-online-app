// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:souq_alqua/utils/color_class.dart';

const String PrimaryFontName = 'Proxima Nova';

final BoxDecoration kBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    color: ColorClass.grayColor,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: const Offset(0.0, 0.0),
        blurRadius: 2.0,
        spreadRadius: 1.0,
      ),
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0,
      ),
    ]);

class TextStyleClass {
  static TextStyle kTextgrey1 = const TextStyle(
    fontFamily: PrimaryFontName,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    fontSize: 9,
  );
  // font size 09
  static TextStyle text09White = GoogleFonts.poppins(
    fontSize: 09,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text09Black = GoogleFonts.poppins(
    fontSize: 09,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text09Grey = GoogleFonts.poppins(
    fontSize: 09,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
  // font size 10
  static TextStyle text10White = GoogleFonts.poppins(
    fontSize: 10,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text10Black = GoogleFonts.poppins(
    fontSize: 10,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text10Grey = GoogleFonts.poppins(
    fontSize: 10,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
  // font size 12
  static TextStyle text12White = GoogleFonts.poppins(
    fontSize: 12,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text12Black = GoogleFonts.poppins(
    fontSize: 12,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text12Grey = GoogleFonts.poppins(
    fontSize: 12,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
  // font size 14
  static TextStyle text14White = GoogleFonts.poppins(
    fontSize: 14,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text14Black = GoogleFonts.poppins(
    fontSize: 14,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text14Grey = GoogleFonts.poppins(
    fontSize: 14,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );

  static TextStyle text14GreyAr = GoogleFonts.notoSansArabic(
    fontSize: 14,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
  // font size 16
  static TextStyle text16White = GoogleFonts.poppins(
    fontSize: 16,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text16Black = GoogleFonts.poppins(
    fontSize: 16,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text16BlackAr = GoogleFonts.notoSansArabic(
    fontSize: 16,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text16Grey = GoogleFonts.poppins(
    fontSize: 16,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text16Primary = GoogleFonts.poppins(
    fontSize: 16,
    color: ColorClass.kPrimaryColor,
  );
  static TextStyle text16PrimarySemiBold = GoogleFonts.poppins(
    fontSize: 16,
    color: ColorClass.kPrimaryColor,
    fontWeight: FontWeight.w600,
  );
  // font size 18
  static TextStyle text18White = GoogleFonts.poppins(
    fontSize: 18,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text18Black = GoogleFonts.poppins(
    fontSize: 18,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text18Grey = GoogleFonts.poppins(
    fontSize: 18,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );

  // font size 20
  static TextStyle text20White = GoogleFonts.poppins(
    fontSize: 20,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text20Black = GoogleFonts.poppins(
    fontSize: 20,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text20Grey = GoogleFonts.poppins(
    fontSize: 20,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
  // font size 22
  static TextStyle text22White = GoogleFonts.poppins(
    fontSize: 22,
    color: ColorClass.white,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text22Black = GoogleFonts.poppins(
    fontSize: 22,
    color: ColorClass.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle text22Grey = GoogleFonts.poppins(
    fontSize: 22,
    color: ColorClass.grayColor,
    fontWeight: FontWeight.w600,
  );
}
