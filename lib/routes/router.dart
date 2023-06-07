import 'package:flutter/material.dart';
import 'package:loansasa/app/application/apply_page.dart';
import 'package:loansasa/app/application/repay_loan_page.dart';
import 'package:loansasa/app/auth/auth_page.dart';
import 'package:loansasa/app/crb/crb_success_page.dart';
import 'package:loansasa/app/onboard/onboarding_page.dart';
import 'package:loansasa/app/onboard/splash_page.dart';
import 'package:loansasa/app/profile/complete_profile_page.dart';
import 'package:loansasa/app/profile/profile_page.dart';
import '../app/application/claim.dart';
import '../app/application/single_application_page.dart';
import '../app/crb/crb_page.dart';
import '../app/home/home_page.dart';
import '../app/onboard/privacy_policy_page.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => SplashPage());
    case 'auth':
      return MaterialPageRoute(builder: (context) => Auth());
    case 'privacypolicy':
      return MaterialPageRoute(builder: (context) => PrivacyPolicyPage());
    case 'home':
      return MaterialPageRoute(builder: (context) => HomePage());
    case 'completeProfile':
      return MaterialPageRoute(builder: (context) => CompleteProfile());
    case 'profile':
      return MaterialPageRoute(builder: (context) => ProfilePage());
    case 'apply':
      return MaterialPageRoute(builder: (context) => Apply());
    case 'applicationprogress':
      Claim _claim = settings.arguments as Claim;

      return MaterialPageRoute(builder: (context) => ApplicationProgressPage(
          claim: _claim
      ));
    case 'onboard':
      return MaterialPageRoute(builder: (context) => OnboardingPage());
    case 'crb':
      return MaterialPageRoute(builder: (context) => CrbPage());
    case 'repay':
      return MaterialPageRoute(builder: (context) => RepayLoanPage());
    case 'crbsuccess':
      return MaterialPageRoute(builder: (context) => CrbSuccessPage());
  }
}
