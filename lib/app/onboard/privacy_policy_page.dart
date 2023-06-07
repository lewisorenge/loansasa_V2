import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loansasa/constants/ad_units.dart';
import '../../constants/colors.dart';
import '../../constants/regular_text.dart';
import 'package:loansasa/constants/button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPage();
}

class _PrivacyPolicyPage extends State<PrivacyPolicyPage> {
  late InterstitialAd _interstitialAd;
  bool _isInterstialAdLoaded = false;

   String appName = "";

  @override
  void initState() {
    _initInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdUnitStrings.interstial_privacy_ad,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback (
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstialAdLoaded = true;

          _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _interstitialAd.dispose();
              _initInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _interstitialAd.dispose();
              _initInterstitialAd();
            }
          );
        },
        onAdFailedToLoad: (error) {}
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
    });

    List<dynamic> adSources = [
      'Google Play Services',
      'AppLovin',
      'AdMob'
    ];

    List<dynamic> serviceProviderReasons = [
      'To facilitate our Service',
      'To perform Service-related services, or',
      'To assist us in analyzing how our Service is used.',
      'To assist us in analyzing how our Service is used.'
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: regularText(
            'Privacy Policy',
            color: AppColors.black,
            fontWeight: FontWeight.w700,
            fontSize: 17.0
        ),
        backgroundColor: AppColors.gray100,
        centerTitle: true,
        actions: [],
        elevation: 0
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        child: ListView(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 18.h, vertical: 10.h),
                child: Column(
                  textDirection: TextDirection.ltr,
                  children: [
                    regularText(
                      "This Privacy policy determines manner in which ${appName!} collects,uses,maintains and discloses the information we collect from users.",
                    ),
                   SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at ${appName!} app unless otherwise defined in this Privacy Policy.",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:regularText(
                          "Information Collection and Use",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.left
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "For a better experience, wa le using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to contacts,name,email,phone number,location. The information that we request will be retained by us and used as described in this privacy policy.",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "The data collect are not shared with any third party but rather secured in our servers.",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "We serve ads from term party sites which are listed below;",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [1, 2, 3]
                          .map((e) => ListTile(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                        minLeadingWidth: 0,
                        leading: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: AppColors.gray700,
                            shape: BoxShape.rectangle,
                          ),
                          child: Center(
                            child: regularText(
                              e.toString(),
                              color: AppColors.gray900,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        title: regularText(
                          adSources[e - 1],
                          color: AppColors.black,
                          fontSize: 14.0
                        ),
                      ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: regularText(
                        "Log Data",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "This Log Data may include information such as your device Internet Protocol (IP) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: regularText(
                        "Cookies",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "This Service does not us hese 'cookies' explicitly. However, the app may use third-party code and libraries that use 'cookie' to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: regularText(
                        "Service Providers",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "We may employ third-party companies and individuals due to the following reasons:",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [1, 2, 3, 4]
                        .map((e) => ListTile(
                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                          minLeadingWidth: 0,
                          leading: Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: AppColors.gray700,
                              shape: BoxShape.rectangle,
                            ),
                            child: Center(
                              child: regularText(
                                  "",
                                  color: AppColors.gray900,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          title: regularText(
                            serviceProviderReasons[e - 1],
                            color: AppColors.black,
                            fontSize: 14
                          ),
                        )
                      ).toList(),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: regularText(
                        "Changes to Privacy Policy",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    regularText(
                      "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: regularText(
                        "This policy is effective as of 3rd June, 2021",
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                )
            ),
             SizedBox(
               height: 30.h,
             ),
        ],
      ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button('Decline', () {
                if (_isInterstialAdLoaded) {
                  _interstitialAd.show();
                  Navigator.pushNamed(context, 'onboard');
                } else {
                  Navigator.pushNamed(context, 'onboard');
                }
              },
              backgroundColor: AppColors.gray300,
              labelColor: AppColors.black,
              width: 163.w
            ),
            SizedBox(
              width: 8.w,
            ),
            button('Accept', () {
                if (_isInterstialAdLoaded) {
                  _interstitialAd.show();
                  Navigator.pushNamed(context, 'auth');
                } else {
                  Navigator.pushNamed(context, 'auth');
                }
              },
              width: 163.w,
              backgroundColor: AppColors.bannerGradEnd
            ),
          ],
        ),
      ),
    );
  }
}
