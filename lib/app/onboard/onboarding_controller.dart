import 'package:flutter/cupertino.dart';

class OnboardingController extends ChangeNotifier {
  final List<Map<String, String>> _onboardingItems = [
    {
      "title": "Instant loan approvals",
      "subTitle": "Get your loan instantly processed and the amount sent to your M-PESA",
      "image": "assets/images/onboard_one.png",
    },
    {
      "title": "No Repayment Penalties",
      "subTitle": "We will not charge you prepayment penalties when you repay your loan before the scheduled loan term.",
      "image": "assets/images/onboard_two.png",
    },
    {
      "title": "Low Interest Rates",
      "subTitle": "The tenor for repaying amount you borrow is 91 days. If you want to buy more time, you can pay back the money in 365 days.",
      "image": "assets/images/onboard_three.png",
    },
  ];

  List<Map<String,String>>  get onboardingItems => _onboardingItems;
}
