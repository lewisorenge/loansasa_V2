import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget regularText(String text,
    {Color? color,
    double? fontSize,
    FontWeight? fontWeight,

    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.openSans(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
  );
}
