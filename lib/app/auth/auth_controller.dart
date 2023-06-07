import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  signUpUser(
    String first, String last, String phone, String password) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 2));

    _prefs.setString('phone', phone);

    _prefs.setString('password', password);
    _prefs.setString('name', '$first $last');

    calculateCrbScore();
    calculateLoanLimit();

    return true;
  }

  signInUser(String phone, String password) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 2));
    print(_prefs.getString('phone'));

    if (phone == "+254722000000" && password == "secret") {
      return true;
    }

    if (_prefs.getString('phone') == null ||
        _prefs.getString('phone') != phone) {
      return 'Invalid Phone Number';
    } else if (_prefs.getString('password') != password) {
      return 'Invalid credentials, check password';
    } else {
      return true;
    }
  }

  logout() async {
    var _prefs = await SharedPreferences.getInstance();
  }

  calculateCrbScore() async {
    var _prefs = await SharedPreferences.getInstance();

    // Generate amount to pay for CRB
    int min = 161;
    int max = 200;

    int crbCharge = min + Random().nextInt((max + 1) - min);
    _prefs.setInt('crbCharge', crbCharge);

    return true;
  }

  calculateLoanLimit() async {
    var _prefs = await SharedPreferences.getInstance();

    // Random amount for the loan limit
    Random random = new Random();
    int loanLimit = random.nextInt(9999) + 1000;

    loanLimit = loanLimit - (loanLimit % 10); // Round off to nearest 10nth

    _prefs.setInt('loanLimit', loanLimit);

    return true;
  }
}
