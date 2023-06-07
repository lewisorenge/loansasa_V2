import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loansasa/constants/constClass.dart';
import '../../constants/ad_units.dart';
import '../../constants/colors.dart';
import '../../constants/regular_text.dart';
import 'package:loansasa/constants/button.dart';

import 'claim.dart';

class ApplicationProgressPage extends StatefulWidget {
  ApplicationProgressPage({Key? key, this.claim}) : super(key: key);

  Claim? claim;

  @override
  State<ApplicationProgressPage> createState() =>
      _ApplicationProgressPageState();
}

class _ApplicationProgressPageState extends State<ApplicationProgressPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdLoaded = false;

  @override
  void initState() {
    _initBannerAd1();
    _initRewardedAd();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initBannerAd1() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdUnitStrings.banner_ad,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isBannerAdLoaded = true;
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
              _isRewardedAdLoaded = true;

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
    final Map arguments =
        (ModalRoute.of(context)!.settings.arguments ?? {}) as Map;

    print(arguments['totalRepayment']);

    return Scaffold(
      appBar: AppBar(
        title: regularText('Loan Progress',
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17.0),
        backgroundColor: AppColors.primary,
        elevation: 1,
        centerTitle: true,
        actions: [],
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: AppColors.white,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: regularText("Important information",
                      fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: regularText(
                      "To get updated details for this loan, click on refresh button and keep checking here."),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: regularText(
                      "To improve your chances of loan approval, we highly recommend getting your CRB report by following the steps on CRB page below."),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: button('Refresh Page', () {},
                          width: 163.w, backgroundColor: AppColors.primary),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        child: button('Check CRB Score', () {
                      if (_isRewardedAdLoaded) {
                        _rewardedAd.show(onUserEarnedReward: (ad, item) {});
                      }

                      Navigator.pushNamed(context, 'crb');
                    },
                            backgroundColor: AppColors.gray300,
                            labelColor: AppColors.black,
                            width: 163.w))
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
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
                              "${ConstClass.currencySymbol} ${widget.claim?.amount}",
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
                              "${ConstClass.currencySymbol} ${widget.claim?.monthlyRepayment}",
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
                          regularText("${widget.claim?.rate}%",
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
                          regularText("${widget.claim?.repaymentPeriod} Months",
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
                              "${ConstClass.currencySymbol} ${widget.claim?.totalRepayment}",
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
              ],
            ),
          ),
          new Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            alignment: Alignment.center,
            child: button("Apply New Loan", () {
              if (_isRewardedAdLoaded) {
                _rewardedAd.show(onUserEarnedReward: (ad, item) {
                  Navigator.pushNamed(context, 'apply');
                });
              } else {
                Navigator.pushNamed(context, 'apply');
              }
            }),
          ),
        ],
      ),
      bottomNavigationBar: _isBannerAdLoaded
          ? Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox(),
    );
  }
}
