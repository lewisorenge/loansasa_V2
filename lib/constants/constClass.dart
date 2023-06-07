import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConstClass {
  static String countryCode = '';
  static String currencySymbol = '';

  static Future<void> getCountryData() async {
    var resonse = await http.post(Uri.parse('http://ip-api.com/json'));
    if (resonse.statusCode == 200) {
      var jsonDecode = json.decode(resonse.body);
      countryCode = jsonDecode['countryCode'];
      var format = NumberFormat.compactSimpleCurrency(
        locale: jsonDecode['regionName'],
      );
      currencySymbol = format.currencySymbol;
    }
  }
}
