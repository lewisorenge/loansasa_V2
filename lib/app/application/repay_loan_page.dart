import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/ad_units.dart';
import '../../constants/colors.dart';
import '../../constants/regular_text.dart';
import 'package:loansasa/constants/button.dart';

class RepayLoanPage extends StatefulWidget {
  const RepayLoanPage({Key? key}) : super(key: key);

  @override
  State<RepayLoanPage> createState() => _RepayLoanPageState();
}

class _RepayLoanPageState extends State<RepayLoanPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdLoaded = false;

  @override
  void initState() {
    _initBannerAd();
    _initRewardedAd();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdUnitStrings.banner_ad,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isBannerAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}
        ),
        request: AdRequest()
    );

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
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    _rewardedAd.dispose();
                    _initRewardedAd();
                  }
              );
            },
            onAdFailedToLoad: (error) {}
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: regularText(
            'Repay Loan',
            color: AppColors.black,
            fontWeight: FontWeight.w700,
            fontSize: 17.0
        ),
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        actions: [],
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: AppColors.black,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(top: 40.h),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Icon(
                Icons.warning_rounded,
                size: 50,
                color: AppColors.gray400,
              )
          ),
          Container(
            alignment: Alignment.center,
            child: regularText(
                'No loans found!',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
            child: regularText(
                "You dont have any loans at the moment. When your loan is approved, visit this page to make your payment.",
                color: AppColors.gray500,
                textAlign: TextAlign.center,
            )
          ),
          new Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            alignment: Alignment.center,
            child: button("Get New Loan",  () {
                if (_isRewardedAdLoaded) {
                  _rewardedAd.show(onUserEarnedReward: (ad, item) {});
                }

                Navigator.pushNamed(context, 'apply');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isBannerAdLoaded ? Container(
        height: _bannerAd.size.height.toDouble(),
        width: _bannerAd.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd),
      ) : SizedBox(),
    );
  }
}
