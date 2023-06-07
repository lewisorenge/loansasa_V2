import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loansasa/app/profile/complete_profile_controller.dart';
import 'package:provider/provider.dart';

import '../../constants/ad_units.dart';
import '../../constants/colors.dart';
import '../../constants/regular_text.dart';
import 'package:loansasa/constants/button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstialAdLoaded = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdLoaded = false;

  late CompleteProfileController completeProfileController;

  @override
  void initState() {
    Future.microtask(() => context.read<CompleteProfileController>().fetchName());

    _initBannerAd();
    _initInterstitialAd();
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
                _isBannerAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}
        ),
        request: AdRequest()
    );

    _bannerAd.load();
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdUnitStrings.interstial_ad,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isInterstialAdLoaded = true;

            _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  _interstitialAd.dispose();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  _interstitialAd.dispose();
                }
            );
          },
          onAdFailedToLoad: (error) {}
      ),
    );
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

    completeProfileController = context.watch<CompleteProfileController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        actions: [],
        elevation: 0,
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
            color: AppColors.primary,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(
              Icons.person,
              size: 50,
              color: AppColors.white,
            )
          ),
          Container(
            color: AppColors.primary,
            alignment: Alignment.center,
            child: regularText(
                '${completeProfileController.name}',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white
            ),
          ),
          Container(
            color: AppColors.primary,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 10.0),
            child: button('Edit Profile', () {
                  if (_isRewardedAdLoaded) {
                    _rewardedAd.show(onUserEarnedReward: (ad, item) {
                      Navigator.pushNamed(context, "completeProfile");
                    });
                  } else {
                    Navigator.pushNamed(context, "completeProfile");
                  }
                },
                width: 163.w,
                backgroundColor: AppColors.white,
                labelColor: AppColors.primary
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray300),
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.gray300))
                  ),
                  child: ListTile(
                    onTap: () {
                      if (_isInterstialAdLoaded) {
                        _interstitialAd.show();
                      }
                    },
                    minLeadingWidth: 0,
                    leading: Icon(
                      Icons.settings,
                      color: AppColors.gray400,
                    ),
                    title: regularText(
                        'Settings',
                        fontSize: 12.sp,
                        color: AppColors.black
                    ),
                    trailing:  Icon(
                      Icons.chevron_right,
                      color: AppColors.gray400,
                    ),
                  ),
                ),
                Container(
                  child: ListTile(
                    onTap: () {
                      if (_isInterstialAdLoaded) {
                        _interstitialAd.show();
                      }
                    },
                    minLeadingWidth: 0,
                    leading: Icon(
                      Icons.doorbell,
                      color: AppColors.gray400,
                    ),
                    title: regularText(
                        'Push Notifications',
                        fontSize: 12.sp,
                        color: AppColors.black
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColors.gray400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: SizedBox(
            height: 50,
            child:OutlinedButton(
                onPressed: () {
                  if (_isRewardedAdLoaded) {
                    _rewardedAd.show(onUserEarnedReward: (ad, item) {
                      Navigator.pushNamed(context, "onboard");
                    });
                  } else {
                    Navigator.pushNamed(context, "onboard");
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: new Text("Logout", style: TextStyle(color: AppColors.primary)),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 20.0),
            child: regularText(
                'Version 6.3.0(5)',
                fontWeight: FontWeight.w500,
                color: AppColors.primary
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
