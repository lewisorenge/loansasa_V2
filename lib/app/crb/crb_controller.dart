import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrbController extends ChangeNotifier {
  int _crbCharge = 95;
  int get crbCharge => _crbCharge;

  checkScore(String mpesaCode) async {
    await Future.delayed(Duration(seconds: 5));

    var re = RegExp(r'(?<=quick)(.*)(?=over)');
    String data = "the quick brown fox jumps over the lazy dog";
    var match = re.firstMatch(data);
    if (match != null) {
      print(match.group(0));
    }

    if (mpesaCode.length < 10) {
      return 'Invalid message';
    }
  }

  fetchCrbCharge() async {
    var _prefs = await SharedPreferences.getInstance();

    int complete = _prefs.getInt('crbCharge') ?? 95;

    _crbCharge = complete;

    notifyListeners();
  }
}
