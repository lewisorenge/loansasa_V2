import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loansasa/constants/button.dart';
import 'package:loansasa/constants/regular_text.dart';

alertDialog(
    String title, String message, BuildContext context) {
 return showDialog(context: context,
  builder: (context){
    return AlertDialog(
      title: regularText(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: regularText(message),
          ),
          button('Okay', () {
            Navigator.pop(context);
          })
        ],
      ),
    );
  });
}
