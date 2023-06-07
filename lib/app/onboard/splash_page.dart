import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loansasa/constants/constClass.dart';
import 'package:loansasa/constants/regular_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../constants/network_connectivity.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  var connectivityResult;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    ConstClass.getCountryData();
    checkConnection().then((_) {
      if (_) nav();
    });
  }

  nav() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (preferences.getBool('isOnboarded') ?? false) {
        //check auth
        if (preferences.getBool('authenticated') ?? false) {
          Navigator.pushNamed(context, 'home');
          return;
        }
        Navigator.pushNamed(context, 'auth');
      } else {
        Navigator.pushNamed(context, 'onboard');
      }
    });
  }

  Future<bool> checkConnection() async {
    //use stream to listen
    _networkConnectivity.initialise();

    //one time check
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }

    return isConnected;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: isConnected
            ? Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 86.w,
                  height: 86.h,
                ),
              )
            : Center(child: regularText('No Internet Connection')));
  }
}
