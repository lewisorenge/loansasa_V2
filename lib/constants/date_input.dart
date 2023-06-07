import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loansasa/constants/colors.dart';

class DateInput extends StatefulWidget {
  final String hintText;
  bool? isReadOnly;
  final controller;
  final errorText;

  DateInput({
    required this.hintText,
    this.isReadOnly = false,
    this.controller,
    this.errorText,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  var labelText = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelStyle: GoogleFonts.openSans(color: AppColors.gray500),
        prefixIcon: Icon(Icons.calendar_today),
        prefixStyle: TextStyle(
          color: AppColors.primary
        ),
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
          borderRadius: const BorderRadius.all(const Radius.circular(4.0))
        ),
        filled: true,
          // hintText: widget.hintText,
          hintStyle: GoogleFonts.openSans(color: AppColors.gray400),
          fillColor: AppColors.gray200,
      ),
      readOnly: false,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2005),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100)
        );

        if (pickedDate != null) {

          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

          setState(() {
            widget.controller.text = formattedDate;
          });
        } else {}
      },
    );
  }
}