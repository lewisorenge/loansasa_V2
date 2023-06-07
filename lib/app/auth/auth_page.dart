import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loansasa/app/auth/auth_controller.dart';
import 'package:loansasa/constants/ad_units.dart';
import 'package:loansasa/constants/alert_dialog.dart';
import 'package:loansasa/constants/button.dart';
import 'package:loansasa/constants/colors.dart';
import 'package:loansasa/constants/constClass.dart';
import 'package:loansasa/constants/edit_text.dart';
import 'package:loansasa/constants/regular_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late TapGestureRecognizer tapGestureRecognizer;

  GlobalKey<FormState> signInForm = GlobalKey<FormState>();
  GlobalKey<FormState> signUpForm = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late AuthController authController;

  late SharedPreferences preferences;

  String mobileNumber = "";

  // PhoneNumber number = PhoneNumber(isoCode: preferences.getString(key));

  bool isSignUp = true;

  int _interstitialRetryAttempt = 0;

  PhoneNumber phoneNumber = PhoneNumber(isoCode: ConstClass.countryCode);

  @override
  void initState() {
    super.initState();

    initSharedPref();
    _initBannerAd();
    attachAdListeners();

    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        //
      };
  }

  @override
  void dispose() {
    super.dispose();
    tapGestureRecognizer.dispose();
  }

  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
  }

  void attachAdListeners() {
    /// Interstitial Ad Listeners
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialAdReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ${ad.networkName}');

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();
        print(
            'Interstitial ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial('ee145f2cf65fc96f');
        });
      },
      onAdDisplayedCallback: (ad) {
        print('Interstitial ad displayed');
      },
      onAdDisplayFailedCallback: (ad, error) {
        // _interstitialLoadState = AdLoadState.notLoaded;
        print(
            'Interstitial ad failed to display with code ${error.code} and message ${error.message}');
      },
      onAdClickedCallback: (ad) {
        print('Interstitial ad clicked');
      },
      onAdHiddenCallback: (ad) {
        // _interstitialLoadState = AdLoadState.notLoaded;
        print('Interstitial ad hidden');
      },
      onAdRevenuePaidCallback: (ad) {
        print('Interstitial ad revenue paid: $ad.revenue');
      },
    ));

    /// Rewarded Ad Listeners
    // AppLovinMAX.setRewardedAdListener(RewardedAdListener(onAdLoadedCallback: (ad) {
    //   _rewardedAdLoadState = AdLoadState.loaded;
    //
    //   // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'
    //   logStatus('Rewarded ad loaded from ${ad.networkName}');
    //
    //   // Reset retry attempt
    //   _rewardedAdRetryAttempt = 0;
    // }, onAdLoadFailedCallback: (adUnitId, error) {
    //   _rewardedAdLoadState = AdLoadState.notLoaded;
    //
    //   // Rewarded ad failed to load
    //   // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    //   _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;
    //
    //   int retryDelay = pow(2, min(6, _rewardedAdRetryAttempt)).toInt();
    //   logStatus('Rewarded ad failed to load with code ${error.code} - retrying in ${retryDelay}s');
    //
    //   Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
    //     AppLovinMAX.loadRewardedAd(_rewardedAdUnitId);
    //   });
    // }, onAdDisplayedCallback: (ad) {
    //   logStatus('Rewarded ad displayed');
    // }, onAdDisplayFailedCallback: (ad, error) {
    //   _rewardedAdLoadState = AdLoadState.notLoaded;
    //   logStatus('Rewarded ad failed to display with code ${error.code} and message ${error.message}');
    // }, onAdClickedCallback: (ad) {
    //   logStatus('Rewarded ad clicked');
    // }, onAdHiddenCallback: (ad) {
    //   _rewardedAdLoadState = AdLoadState.notLoaded;
    //   logStatus('Rewarded ad hidden');
    // }, onAdReceivedRewardCallback: (ad, reward) {
    //   logStatus('Rewarded ad granted reward');
    // }, onAdRevenuePaidCallback: (ad) {
    //   logStatus('Rewarded ad revenue paid: $ad.revenue');
    // }));

    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      printStatus("ad=> ${ad.toString()}");
      print('Banner ad loaded from ${ad.networkName}');
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print(
          'Banner ad failed to load with error code ${error.code} and message: ${error.message}');
    }, onAdClickedCallback: (ad) {
      print('Banner ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('Banner ad expanded');
    }, onAdCollapsedCallback: (ad) {
      printStatus('Banner ad collapsed');
    }, onAdRevenuePaidCallback: (ad) {
      print('Banner ad revenue paid: $ad.revenue');
    }));

    /// MREC Ad Listeners
    // AppLovinMAX.setMRecListener(AdViewAdListener(onAdLoadedCallback: (ad) {
    //   logStatus('MREC ad loaded from ${ad.networkName}');
    // }, onAdLoadFailedCallback: (adUnitId, error) {
    //   logStatus('MREC ad failed to load with error code ${error.code} and message: ${error.message}');
    // }, onAdClickedCallback: (ad) {
    //   logStatus('MREC ad clicked');
    // }, onAdExpandedCallback: (ad) {
    //   logStatus('MREC ad expanded');
    // }, onAdCollapsedCallback: (ad) {
    //   logStatus('MREC ad collapsed');
    // }, onAdRevenuePaidCallback: (ad) {
    //   logStatus('MREC ad revenue paid: $ad.revenue');
    // }));

    //app lovin
    AppLovinMAX.createBanner(
        AdUnitStrings.applovinBanner_ad, AdViewPosition.topCenter);

    // Set banner background color to black - PLEASE USE HEX STRINGS ONLY
    AppLovinMAX.setBannerBackgroundColor(
        AdUnitStrings.applovinBanner_ad, '#FFFFFF');
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdUnitStrings.banner_ad,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: AdRequest());

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    authController = context.watch<AuthController>();

    return Container(
      child: isSignUp ? signUp() : signIn(),
    );
  }

  Widget signIn() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: kToolbarHeight.h,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: Image.asset(
              'assets/images/logo_dark.png',
              height: 44.h,
              width: 44.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          regularText('Welcome back',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black),
          SizedBox(
            height: 25.h,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: regularText('Phone', color: AppColors.black)),
          phoneInput(),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              alignment: Alignment.centerLeft,
              child: regularText('Password')),
          EditText(
            hintText: 'Password',
            obscurity: true,
            controller: passController,
          ),
          Spacer(),
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: button('Login', () async {
              context.loaderOverlay.show();
              var res = await authController.signInUser(
                  mobileNumber, passController.text);

              if (res is bool && res) {
                preferences.setBool('authenticated', true);
                Navigator.pushNamed(context, 'home');
              } else {
                preferences.setBool('authenticated', false);
                alertDialog('An error occurred', res, context);
              }
              context.loaderOverlay.hide();
            }),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 20.h),
            child: InkWell(
              onTap: () {
                setState(() {
                  isSignUp = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  regularText(
                    'Don\'t have an account?\t',
                  ),
                  regularText('Register',
                      color: AppColors.blue, fontWeight: FontWeight.w600)
                ],
              ),
            ),
          ),
        ]),
      ),
      // bottomNavigationBar: _isAdLoaded ? Container(
      //   height: _bannerAd.size.height.toDouble(),
      //   width: _bannerAd.size.width.toDouble(),
      //   child: AdWidget(ad: _bannerAd),
      // ) : SizedBox(),
    );
  }

  Container phoneInput() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          border:
              new Border.fromBorderSide(BorderSide(color: AppColors.gray300)),
          borderRadius: BorderRadius.circular(5),
          color: AppColors.gray200),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          setState(() {
            mobileNumber = number.phoneNumber!;
          });
        },
        onInputValidated: (bool value) {},
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          setSelectorButtonAsPrefixIcon: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        initialValue: phoneNumber,
        inputBorder: const OutlineInputBorder(),
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintText: 'Phone number',
          border: OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: AppColors.gray200,
        ),
        textFieldController: phoneController,
        formatInput: false,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        onSaved: (PhoneNumber number) {},
      ),
    );
  }

  Widget signUp() {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.sp),
          child: SingleChildScrollView(
            child: Form(
              key: signUpForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight.h,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Image.asset(
                      'assets/images/logo_dark.png',
                      height: 44.h,
                      width: 44.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  regularText('Create your free account',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: regularText('First Name')),
                  EditText(
                      hintText: 'Your first name',
                      obscurity: false,
                      controller: firstController),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: regularText('Last Name')),
                  EditText(
                      hintText: 'Your last name',
                      obscurity: false,
                      controller: lastController),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: regularText('Phone')),
                  phoneInput(),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      alignment: Alignment.centerLeft,
                      child: regularText('Password')),
                  EditText(
                    hintText: 'Password',
                    obscurity: true,
                    controller: passController,
                  ),
                  SizedBox(height: 15.h),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By proceeding, you agree to our ',
                          style:
                              TextStyle(color: AppColors.black, fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms of Use ',
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => {},
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                )),
                            TextSpan(text: 'and our '),
                            TextSpan(
                                text: 'Privacy Policy',
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => {},
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                    height: 1.75)),
                          ],
                        ),
                      )),
                  button('Create Account', () async {
                    context.loaderOverlay.show();
                    if (signUpForm.currentState!.validate()) {
                      await authController.signUpUser(
                          firstController.text,
                          lastController.text,
                          mobileNumber,
                          passController.text);

                      preferences.setBool('authenticated', true);

                      Navigator.pushNamed(context, 'home');
                    } else {
                      alertDialog('Error', 'Entries cannot be null', context);
                    }
                    context.loaderOverlay.hide();
                  }),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isSignUp = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          regularText(
                            'Already have an account?\t',
                          ),
                          regularText('Login',
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      bottomNavigationBar: _isAdLoaded
          ? Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox(),
    );
  }
}
