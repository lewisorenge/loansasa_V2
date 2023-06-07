import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loansasa/constants/regular_text.dart';

import 'colors.dart';

Widget button(String label, VoidCallback onPressed, {
    Color? backgroundColor,
    double? height,
    double? width,
    Color? labelColor
  }) {

  return Container(
    width: width,
    height: height ?? 50.h,
    margin: EdgeInsets.symmetric(vertical: 15.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      color: backgroundColor ?? AppColors.primary,
    ),
    child: InkWell(
        onTap: () => onPressed(),
        child: Center(child: regularText(label, color: labelColor ?? AppColors.white))),
  );
}
