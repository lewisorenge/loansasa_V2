import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loansasa/app/home/application_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loansasa/app/application/claim.dart';

class ApplyController extends ChangeNotifier {
  List<Claim> _claims = [];
  List<Claim> get claims => _claims;

  String _loanLimit = "2,800";
  String get loanLimit => _loanLimit;

  int ratePercentage = 1; // In percentage
  int get rate => ratePercentage;

  int repaymentPeriod = 3;

  int limitOperand = 0;

  String _monthlyRepayment = "150";
  String get monthlyRepayment => _monthlyRepayment;

  String _totalRepayment = "";
  String get totalRepayment => _totalRepayment;

  static ApplyController? _instance;

  factory ApplyController() => _instance ??= ApplyController._init();

  ApplyController._init(){
    fetchLoanLimit();
  }


  NumberFormat formatter = NumberFormat("#,###");

  fetchApplications() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String claimsString = await _prefs.getString('claims').toString();

    if (_prefs.containsKey('claims')) {
      _claims = Claim.decode(claimsString);
    }

    notifyListeners();
  }

  fetchLoanLimit() async {
    var _prefs = await SharedPreferences.getInstance();

    int limit = _prefs.getInt('loanLimit') ?? 5000;

    limitOperand = limit;

    _loanLimit = format(limit);

    notifyListeners();
  }

  format(int value) {
    return formatter.format(value);
  }

  calculateMonthlyRepayment() {
      double interest = limitOperand *
          (ratePercentage / 100); // Convert to decimal

      double repayment = (limitOperand + interest) / repaymentPeriod;

      _monthlyRepayment = format(repayment.toInt());

      _totalRepayment = format((limitOperand + interest).toInt());

      notifyListeners();
  }

  apply(bool? termsAccepted) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 5));

    List<Claim> claims = [];

    Claim myClaim = Claim(
        amount: limitOperand,
        monthlyRepayment: monthlyRepayment,
        rate: rate,
        repaymentPeriod: repaymentPeriod,
        totalRepayment: totalRepayment
    );

    // Fetch and decode data
    final String claimsString = await _prefs.getString('claims').toString();

    if (_prefs.containsKey('claims')) {
     claims = [...Claim.decode(claimsString)];
    }

    claims.add(myClaim);

    final String encodedData = Claim.encode(claims);

    await _prefs.setString('claims', encodedData);

    return true;
  }
}
