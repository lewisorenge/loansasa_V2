import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loansasa/app/application/apply_controller.dart';
import 'package:loansasa/app/crb/crb_controller.dart';
import 'package:loansasa/app/profile/complete_profile_controller.dart';
import 'package:loansasa/app/auth/auth_controller.dart';
import 'package:loansasa/routes/router.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';
import 'app/onboard/onboarding_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  Map? sdkConfiguration = await AppLovinMAX.initialize(
      '8m5gEnDaKbsFsFwVaFkDF0MVxHDanziUOp7qW180TG8ySRAIkukVt21Zrxd3KT5qq3ZTTcaSGsOJuX_TgKXwpt');

  if (sdkConfiguration != null) {
    print(sdkConfiguration);
  }

  FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      iOSAdvertiserTrackingEnabled: true //default false
      );

  AwesomeNotifications().initialize('resource://midmap-mdpi/ic_launcher', [
    NotificationChannel(
      channelKey: 'key1',
      channelName: 'Loans App',
      channelDescription: 'Loans approvals',
      playSound: true,
      enableVibration: true,
      enableLights: true,
    )
  ]);

  final cron = Cron();
  cron.schedule(
      Schedule.parse('* * */1 * * *'),
      () async => {
            await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: 'key1',
                  title: 'LOAN APPROVED TAP HERE ✅',
                  body:
                      'GOOD NEWS!! We are now disbursing some of the Applied Loans.Review your loan status to check if you have qualified'),
            )
          });

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: Provider(
        create: (BuildContext context) => AuthController(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthController()),
            ChangeNotifierProvider(create: (_) => OnboardingController()),
            ChangeNotifierProvider(create: (_) => CompleteProfileController()),
            ChangeNotifierProvider(create: (_) => ApplyController()),
            ChangeNotifierProvider(create: (_) => CrbController()),
          ],
          child: Builder(
            // ignore: prefer_const_constructors
            builder: ((context) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Loans App',
                  initialRoute: '/',
                  onGenerateRoute: generateRoute,
                )),
          ),
        ),
      ),
    );
  }
}
