import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loansasa/app/application/apply_controller.dart';
import 'package:loansasa/constants/ad_units.dart';
import 'package:loansasa/constants/constClass.dart';
import 'package:provider/provider.dart';
import 'package:loansasa/constants/regular_text.dart';
import 'package:loansasa/constants/colors.dart';
import 'package:loansasa/constants/button.dart';
import 'package:loansasa/constants/alert_dialog.dart';
import '../profile/complete_profile_controller.dart';

class Apply extends StatefulWidget {
  @override
  _StackOverState createState() => _StackOverState();
}

class _StackOverState extends State<Apply> with SingleTickerProviderStateMixin {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstialAdLoaded = false;

  late RewardedAd _rewardedAd1;
  bool _isRewardedAd1Loaded = false;

  late ApplyController applyController;
  late TabController _tabController;

  final termsForm = GlobalKey<FormState>();

  bool? termsAccepted = false;

  late CompleteProfileController completeProfileController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);

    Future.microtask(() => context.read<ApplyController>().fetchLoanLimit());
    Future.microtask(
        () => context.read<ApplyController>().calculateMonthlyRepayment());
    Future.microtask(
        () => context.read<CompleteProfileController>().fetchName());

    _initBannerAd();
    _initInterstitialAd();
    _initRewardedAd();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdUnitStrings.interstial_application_ad,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isInterstialAdLoaded = true;

            _interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
              _interstitialAd.dispose();
              _isInterstialAdLoaded = false;
              _initInterstitialAd();
            }, onAdFailedToShowFullScreenContent: (ad, error) {
              _interstitialAd.dispose();
              _isInterstialAdLoaded = false;
              _initInterstitialAd();
            });
          },
          onAdFailedToLoad: (error) {}),
    );
  }

  void _initRewardedAd() {
    RewardedAd.load(
        adUnitId: AdUnitStrings.rewarded_application_ad,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _rewardedAd1 = ad;
              _isRewardedAd1Loaded = true;

              _rewardedAd1.fullScreenContentCallback =
                  FullScreenContentCallback(
                      onAdDismissedFullScreenContent: (ad) {
                _rewardedAd1.dispose();
                _initRewardedAd();
              }, onAdFailedToShowFullScreenContent: (ad, error) {
                _rewardedAd1.dispose();
                _initRewardedAd();
              });
            },
            onAdFailedToLoad: (error) {}));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    applyController = context.watch<ApplyController>();
    completeProfileController = context.watch<CompleteProfileController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        actions: [],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Icon(
            Icons.chevron_left,
            color: AppColors.white,
          ),
        ),
        title: regularText('Apply Loan',
            color: AppColors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16.0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.white,
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                physics: BouncingScrollPhysics(),
                indicatorColor: AppColors.primary,
                indicatorWeight: 4,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.gray600,
                labelPadding: EdgeInsets.symmetric(horizontal: 30.0),
                onTap: (index) {
                  _tabController.index = 0;
                },
                tabs: [
                  Tab(
                    text: 'Get your loan',
                  ),
                  Tab(
                    text: 'Loan Limit',
                  ),
                  Tab(
                    text: 'Confirm Details',
                  ),
                  Tab(
                    text: 'Approval',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  startApplicationStep(),
                  secondStep(),
                  thirdStep(),
                  lastStep(),
                ],
              ),
            ),
          ],
        ),
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

  startApplicationStep() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15.0),
            alignment: Alignment.centerLeft,
            child: regularText("Dear ${completeProfileController.name},",
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.0),
          regularText(
              "Considering your M-Pesa and other financial transactions history, your loan level is Gold. You qualify for a loan of upto KES 70,000"),
          SizedBox(height: 16.0),
          regularText(
              "For the first time application, we will offer you a lona of KES ${applyController.loanLimit}"),
          SizedBox(height: 16.0),
          regularText(
              "Please note that you have to honor repayment dates to get the maximum loan limit on your next application."),
          const Spacer(),
          button('Apply', () async {
            if (_isInterstialAdLoaded) {
              _interstitialAd.show();
            }

            _tabController.animateTo((_tabController.index + 1) % 2);
          })
        ],
      ),
    );
  }

  secondStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        children: [
          applyBanner(),
          const Spacer(),
          button('Get Loan', () async {
            if (_isRewardedAd1Loaded) {
              _rewardedAd1.show(onUserEarnedReward: (ad, item) {
                _tabController.animateTo((_tabController.index + 1));
              });
            } else {
              _tabController.animateTo((_tabController.index + 1));
            }
          })
        ],
      ),
    );
  }

  thirdStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          applyBanner(),
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
                        "${ConstClass.currencySymbol} ${applyController.loanLimit}",
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
                        "${ConstClass.currencySymbol} ${applyController.monthlyRepayment}",
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
                    regularText("${applyController.rate}%",
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
                    regularText("3 Months",
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
                        "${ConstClass.currencySymbol} ${applyController.totalRepayment}",
                        color: AppColors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ],
                ),
              ),
            ],
          ),
          new Spacer(),
          Form(
            key: termsForm,
            child: Column(
              children: [
                CheckboxListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 0.w),
                  title: regularText(
                      "By proceeding, you agree to your terms and conditions.",
                      fontSize: 14.h),
                  value: termsAccepted,
                  onChanged: (newValue) {
                    termsAccepted = newValue;
                    setState(() {});
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                button('Send Loan to M-PESA', () async {
                  context.loaderOverlay.show();

                  if (termsAccepted == true) {
                    await applyController.apply(termsAccepted);

                    _tabController.animateTo((_tabController.index + 1));
                  } else {
                    alertDialog('Error',
                        'You must accept our terms and conditions', context);
                  }

                  context.loaderOverlay.hide();
                },
                    backgroundColor: termsAccepted ?? false
                        ? null
                        : Theme.of(context).disabledColor)
              ],
            ),
          ),
        ],
      ),
    );
  }

  lastStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Column(
        children: [
          applyBanner(),
          SizedBox(height: 10.h),
          regularText(
              "On a closer look at your application, there are a few things you need to change to enable us dispatch ${ConstClass.currencySymbol} ${applyController.loanLimit} to your M-PESA account."),
          SizedBox(height: 15.h),
          regularText(
              "Lets get your CRB Report to evaluate your credit history and credit worthiness. The higher your score the better are the chances of your loan application getting approved."),
          const Spacer(),
          button('Get your CRB Report', () async {
            if (_isRewardedAd1Loaded) {
              _rewardedAd1.show(onUserEarnedReward: (ad, item) {
                Navigator.pushNamed(context, "crb");
              });
            } else {
              Navigator.pushNamed(context, "crb");
            }
          })
        ],
      ),
    );
  }

  applyBanner() {
    var parser = EmojiParser();

    var money_with_wings = parser.emojify(':money_with_wings:');

    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(top: 5.h, bottom: 20.h),
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
            child: regularText('YOU QUALIFY FOR',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: regularText(
                '${ConstClass.currencySymbol} ${applyController.loanLimit} $money_with_wings',
                fontSize: 42.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white),
          ),
          SizedBox(
            height: 10.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: regularText('REPAYMENT OF 3 MONTHS',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
