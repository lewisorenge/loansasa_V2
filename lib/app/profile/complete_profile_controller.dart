import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfileController extends ChangeNotifier {
  bool _isCompleteProfile = false;
  bool get isCompleteProfile => _isCompleteProfile;

  String _name = "";
  String get  name => _name;

  phoneDetails(String ownPhone, String newOrUsed) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('ownPhone', ownPhone);
    _prefs.setString('newOrUsed', newOrUsed);

    return true;
  }

  aboutYouDetails(String knowAboutUs, String haveOutstandingLoans) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('knowAboutUs', knowAboutUs);
    _prefs.setString('haveOutstandingLoans', haveOutstandingLoans);

    return true;
  }

  personalDetails(String idNumber, String dob) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('idNumber', idNumber);
    _prefs.setString('dob', dob);

    return true;
  }

  educationDetails(String educationLevel) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('educationLevel', educationLevel);

    return true;
  }

  loanPurposeDetails(String loanPurpose) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('loanPurpose', loanPurpose);

    return true;
  }

  yourIncomeDetails(String earnSameAmount, String otherSourceOfIncome) async {
    await Future.delayed(Duration(seconds: 4));

    return true;
  }

  financialDetails(String workStatus, String placeOfWork, monthlySalary) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('workStatus', workStatus);
    _prefs.setString('placeOfWork', placeOfWork);
    _prefs.setString('monthlySalary', monthlySalary);

    return true;
  }

  nextOfKinDetails(String nextOfKinName, String nextOfKinRelationship,
      nextOfKinMobileNumber) async {
    var _prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 4));

    _prefs.setString('nextOfKinName', nextOfKinName);
    _prefs.setString('nextOfKinRelationship', nextOfKinRelationship);
    _prefs.setString('nextOfKinMobileNumber', nextOfKinMobileNumber);

    return true;
  }

  completeProfile() async {
    var _prefs = await SharedPreferences.getInstance();

    _prefs.setBool('isProfileComplete', true);

    await Future.delayed(Duration(seconds: 4));

    return true;
  }

  checkProfileCompletion() async {
    var _prefs = await SharedPreferences.getInstance();

    bool complete = _prefs.getBool('isProfileComplete') ?? false;

    print("completion==> $complete");

    _isCompleteProfile = complete;

    notifyListeners();
  }

  fetchName() async {
    var _prefs = await SharedPreferences.getInstance();

    _name = _prefs.getString('name') ?? "";

    notifyListeners();
  }
}
