import 'dart:io';
import 'package:flutter/material.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loansasa/app/application/apply_controller.dart';
import 'package:loansasa/app/profile/complete_profile_controller.dart';
import 'package:loansasa/constants/ad_units.dart';
import 'package:loansasa/constants/button.dart';
import 'package:loansasa/constants/colors.dart';
import 'package:loansasa/constants/constClass.dart';
import 'package:loansasa/constants/regular_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/title_scroll_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAd1Loaded = false;

  bool? isProfileComplete = true;

  late CompleteProfileController _completeProfileController;
  late ApplyController _applyController;

  @override
  void initState() {
    Future.microtask(() =>
        context.read<CompleteProfileController>().checkProfileCompletion());
    Future.microtask(() => context.read<ApplyController>().fetchApplications());

    _initBannerAd();
    _initRewardedAd();

    super.initState();
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

  void _initRewardedAd() {
    RewardedAd.load(
        adUnitId: AdUnitStrings.rewarded_ad,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _rewardedAd = ad;
              _isRewardedAd1Loaded = true;

              _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                _rewardedAd.dispose();
                _initRewardedAd();
              }, onAdFailedToShowFullScreenContent: (ad, error) {
                _rewardedAd.dispose();
                _initRewardedAd();
              });
            },
            onAdFailedToLoad: (error) {}));
  }

  @override
  Widget build(BuildContext context) {
    _completeProfileController = context.watch<CompleteProfileController>();
    _applyController = context.watch<ApplyController>();

    _applyController = context.watch<ApplyController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight.h - 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/logo_dark.png',
                    width: 44.w,
                    height: 44.h,
                  )),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'profile');
                },
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.075),
                    shape: BoxShape.circle,
                  ),
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      MdiIcons.account,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          incompleteProfile(),
          homeBanner(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button('Apply', () {
                if (_completeProfileController.isCompleteProfile) {
                  Navigator.pushNamed(context, 'apply');
                } else {
                  Navigator.pushNamed(context, 'completeProfile');
                }
              }, width: 163.w, backgroundColor: AppColors.bannerGradEnd),
              SizedBox(
                width: 10.w,
              ),
              button('Check CRB Score', () {
                Navigator.pushNamed(context, 'crb');
              },
                  backgroundColor: AppColors.gray300,
                  labelColor: AppColors.black,
                  width: 163.w),
            ],
          ),
          Expanded(
            child: TitleScrollNavigation(
              identiferStyle: NavigationIdentiferStyle(
                color: AppColors.primary,
              ),
              barStyle: TitleNavigationBarStyle(
                  elevation: 0.0,
                  activeColor: AppColors.primary,
                  deactiveColor: Theme.of(context).disabledColor,
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                  spaceBetween: 45,
                  background: AppColors.white),
              titles: [
                "Recent",
                "Services",
              ],
              pages: [applications(), services()],
            ),
          ),
          Container(
            alignment: Alignment(0.5, 1),
            child: FacebookBannerAd(
              placementId: Platform.isAndroid
                  ? "795654385013565"
                  : "YOUR_IOS_PLACEMENT_ID",
              bannerSize: BannerSize.STANDARD,
              listener: (result, value) {
                switch (result) {
                  case BannerAdResult.ERROR:
                    print("Error: $value");
                    break;
                  case BannerAdResult.LOADED:
                    print("Loaded: $value");
                    break;
                  case BannerAdResult.CLICKED:
                    print("Clicked: $value");
                    break;
                  case BannerAdResult.LOGGING_IMPRESSION:
                    print("Logging Impression: $value");
                    break;
                }
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: _isAdLoaded
          ? Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox(),
    );
  }

  incompleteProfile() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.blue.withOpacity(0.25)),
      child: ListTile(
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10.h),
        leading: new Icon(
          Icons.info,
          color: AppColors.blue,
          size: 30,
        ),
        title: regularText('Update profile and improve loan approval chances',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black),
        trailing: SizedBox(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, 'completeProfile');
            },
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: AppColors.white.withOpacity(0.5),
                elevation: 0.0),
            child: Icon(
              size: 20.0,
              Icons.chevron_right,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }

  homeBanner() {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(top: 10.h, right: 15.w, bottom: 0.h, left: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [AppColors.bannerGradStart, AppColors.bannerGradEnd]),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: regularText('GET A LOAN OF UP TO',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: regularText('${ConstClass.currencySymbol} 70,000',
                fontSize: 42.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: regularText('FROM AS LOW AS 1% A MONTH',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white),
          ),
        ],
      ),
    );
  }

  applications() {
    if (_applyController.claims.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray300),
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Icon(
                      Icons.info_outline,
                      size: 34,
                      color: AppColors.gray400,
                    )),
                regularText('You currently have no loan applications!',
                    textAlign: TextAlign.center),
                // Center(
                //   child: button('Apply for a Loan', () {
                //     Navigator.pushNamed(context, 'apply');
                //   }),
                // ),
              ],
            ),
          ),
        ],
      );
    }
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (_, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray300),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText("Amount",
                                      color: AppColors.gray400,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  regularText(
                                      "${ConstClass.currencySymbol} ${_applyController.claims[i].amount}",
                                      color: AppColors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText("Monthly Repayment",
                                      color: AppColors.gray400,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  regularText(
                                      "${ConstClass.currencySymbol} ${_applyController.claims[i].monthlyRepayment}",
                                      color: AppColors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText("Rate",
                                      color: AppColors.gray400,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  regularText(
                                      "${_applyController.claims[i].rate}%",
                                      color: AppColors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText("Payable Period",
                                      color: AppColors.gray400,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  regularText(
                                      "${_applyController.claims[i].repaymentPeriod} Months",
                                      color: AppColors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText("Total Repayment",
                                      color: AppColors.gray400,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  regularText(
                                      "${ConstClass.currencySymbol} ${_applyController.claims[i].totalRepayment}",
                                      color: AppColors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  regularText("Status",
                                      color: AppColors.gray400,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  SizedBox(
                                      height: 22,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            primary: AppColors.gray300,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: -10),
                                          ),
                                          child: regularText(
                                            "Processing",
                                            color: AppColors.gray900,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10.h,
                                          )))
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.all(0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: AppColors.primary,
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              if (_isRewardedAd1Loaded) {
                                _rewardedAd.show(
                                    onUserEarnedReward: (ad, item) {});
                              }

                              Navigator.pushNamed(
                                  context, 'applicationprogress',
                                  arguments: _applyController.claims[i]);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                regularText("Check Progress"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: _applyController.claims.length,
                shrinkWrap: true,
              ),
            )
          ],
        ));
  }

  services() {
    List<dynamic> servicesOffered = [
      {
        "icon": MdiIcons.fileDocument,
        "title": "Apply for CRB status report",
        "page": "crb"
      },
      {
        "icon": MdiIcons.creditCardCheck,
        "title": "Repay Loan",
        "page": "repay"
      },
      {
        "icon": MdiIcons.accountMultiple,
        "title": "Refer a friend",
        "page": "crb"
      },
      {"icon": MdiIcons.star, "title": "Rate Us", "page": "crb"},
      {"icon": MdiIcons.information, "title": "More info", "page": "crb"},
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: servicesOffered.length,
            itemBuilder: (_, i) {
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, servicesOffered[i]['page']);
                },
                leading: Icon(servicesOffered[i]['icon']),
                title: regularText(
                  servicesOffered[i]['title'],
                ),
                trailing: Icon(Icons.chevron_right),
              );
            },
            shrinkWrap: true,
          ),
        )
      ],
    );
  }
}
