import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loansasa/constants/constClass.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loansasa/app/crb/crb_controller.dart';
import 'package:loansasa/constants/button.dart';
import 'package:loansasa/constants/colors.dart';
import 'package:loansasa/constants/edit_text.dart';
import 'package:loansasa/constants/regular_text.dart';
import 'package:loansasa/constants/alert_dialog.dart';
import '../../constants/ad_units.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';

class CrbPage extends StatefulWidget {
  const CrbPage({Key? key}) : super(key: key);

  @override
  State<CrbPage> createState() => _CrbPageState();
}

class _CrbPageState extends State<CrbPage> {
  String packageName = "";

  bool isBusy = true;

  late Map tillDetails;
  String tillNumber = "";

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAd1Loaded = false;

  late CrbController crbController;

  final checkCrbForm = GlobalKey<FormState>();

  TextEditingController mpesaCodeController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() => context.read<CrbController>().fetchCrbCharge());

    apiCall();

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

  Future apiCall() async {
    http.Response response;
    response = await http.get(Uri.parse(
        "https://capricorncapital.co.ke/api/mobile-apps/$packageName?package_name=$packageName"));

    if (response.statusCode == 200) {
      setState(() {
        isBusy = false;
        tillDetails = json.decode(response.body);
        tillNumber = tillDetails['till_number'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      packageName = packageInfo.packageName;
      apiCall();
    });

    ScreenUtil.init(context);

    crbController = context.watch<CrbController>();

    List<String> procedure = [
      "Go to M-PESA",
      "Buy Goods and Services",
      "Enter TILL number $tillNumber",
      "Enter amount: ${ConstClass.currencySymbol} ${crbController.crbCharge}",
      "Wait for confirmation message"
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: regularText('Get your CRB Report',
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Form(
            key: checkCrbForm,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                regularText(
                    'A credit report will tell you why your credit status is in default or good standing.\n\nGetting your CRB report which will enable your LOAN APPROVAL costs only ${ConstClass.currencySymbol} ${crbController.crbCharge}',
                    color: AppColors.gray800,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal),
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: regularText('Procedure',
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                new Divider(
                  color: AppColors.gray300,
                  thickness: 1,
                ),
                isBusy
                    ? CircularProgressIndicator()
                    : Column(children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [1, 2, 3, 4, 5]
                              .map((e) => ListTile(
                                    visualDensity: VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    contentPadding:
                                        EdgeInsets.only(left: 0.0, right: 0.0),
                                    minLeadingWidth: 0,
                                    leading: Container(
                                      width: 24.w,
                                      height: 24.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: regularText(e.toString(),
                                            color: AppColors.white,
                                            fontSize: 12.sp),
                                      ),
                                    ),
                                    title: regularText(procedure[e - 1],
                                        color: AppColors.black),
                                  ))
                              .toList(),
                        ),
                        new Divider(
                          color: AppColors.gray300,
                          thickness: 1,
                        ),
                        Image.network(
                          tillDetails['till_poster_url'],
                          width: 0.5.sw,
                          height: 0.2.sh,
                        ),
                        new Divider(
                          color: AppColors.gray300,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: regularText(
                              'M-PESA Confirmation Code',
                              color: AppColors.black,
                              fontWeight: FontWeight.normal,
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        EditText(
                            controller: mpesaCodeController,
                            hintText: 'QMOK4L30',
                            obscurity: false,
                            errorText: "You must provide the M-PESA message"),
                        button('Get CRB Report', () async {
                          context.loaderOverlay.show();

                          if (checkCrbForm.currentState!.validate()) {
                            await crbController
                                .checkScore(mpesaCodeController.text);

                            if (_isRewardedAd1Loaded) {
                              _rewardedAd.show(
                                  onUserEarnedReward: (ad, item) {});
                            }

                            Navigator.pushNamed(context, 'crbsuccess');
                          } else {
                            alertDialog(
                                'Error', 'Entries cannot be null', context);
                          }

                          context.loaderOverlay.hide();
                        })
                      ]),
              ],
            ),
          ),
        ),
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
