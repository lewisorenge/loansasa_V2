import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loansasa/constants/colors.dart';

class EditText extends StatefulWidget {
  final String hintText;
  final bool obscurity;
  bool? isReadOnly;
  final controller;
  final errorText;
  int? lengthLimitingTextInputFormatter;

  EditText({
    required this.hintText,
    required this.obscurity,
    this.lengthLimitingTextInputFormatter = 199,
    this.isReadOnly = false,
    this.controller,
    this.errorText,
  });

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  var labelText = '';

  @override
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isReadOnly!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.errorText;
        }
        return null;
      },
      inputFormatters: [
        new LengthLimitingTextInputFormatter(widget.lengthLimitingTextInputFormatter),
      ],
      obscureText: widget.obscurity,
      controller: widget.controller,
      style: TextStyle(color: AppColors.gray900),
      onChanged: (v) {
        setState(() {
          if (v.isNotEmpty) {
            labelText = widget.hintText;
          } else {
            labelText = '';
          }
        });
      },
      keyboardType: (widget.hintText.toLowerCase().contains("number"))
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        labelStyle: GoogleFonts.openSans(color: AppColors.gray500),
        labelText: widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.0
          ),
        ),
        border: new OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.gray400,
            ),
            borderRadius: const BorderRadius.all(const Radius.circular(8.0))
        ),
        filled: true,
        // hintText: widget.hintText,
        hintStyle: GoogleFonts.openSans(color: AppColors.gray400),
        fillColor: AppColors.gray200,
      ),
      cursorColor: AppColors.primary,
    );
  }
}
