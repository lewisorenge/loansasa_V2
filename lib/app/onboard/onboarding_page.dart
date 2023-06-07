import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loansasa/app/onboard/onboarding_controller.dart';
import 'package:loansasa/constants/ad_units.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../constants/regular_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late OnboardingController onboardingController;
  late CarouselController carouselController;

  int currentIndex = 0;

  @override
  void initState() {
    carouselController = CarouselController();
    super.initState();

    _initBannerAd();
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
          onAdFailedToLoad: (ad, error) {}
        ),
        request: AdRequest()
    );

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    onboardingController = context.watch<OnboardingController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 0.8.sh,
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: 3,
                options: CarouselOptions(
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 30),
                  height: 0.8.sh,
                  disableCenter: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                      setState(() {});
                      // ref.read(currentIndex.notifier).setCurrent(index);
                    });
                  }
                ),
                itemBuilder: ((context, index, realIndex) {
                  return Column(
                    children: [
                      _buildImage(onboardingController.onboardingItems[index]['image']!),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                          child: regularText(
                            onboardingController.onboardingItems[index]['title']!,
                            fontSize: 24.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: regularText(
                            onboardingController.onboardingItems[index]['subTitle']!,
                            fontSize: 14.sp,
                            color: AppColors.black,
                            textAlign: TextAlign.center
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    InkWell(
                      onTap: () async{
                        //save user onboarded

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isOnboarded', true);

                        Navigator.pushNamed(context, 'privacypolicy');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Center(
                            child: regularText(
                              'Apply Now',
                              fontSize: 16.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (currentIndex == 0)
                            ? Center()
                            : InkWell(
                                onTap: () {
                                  currentIndex--;

                                  carouselController.jumpToPage(currentIndex);
                                },
                                child: regularText('Previous',
                                    fontSize: 15.sp,
                                    color: AppColors.primary),
                              ),
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children:
                                  onboardingController.onboardingItems.map((slide) {
                                int index = onboardingController.onboardingItems
                                    .indexOf(slide);
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentIndex == index
                                          ? AppColors.primary
                                          : AppColors.primary
                                              .withOpacity(0.7)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        (currentIndex == 2)
                          ? Center()
                          : InkWell(
                            onTap: () {
                              currentIndex++;

                              carouselController.jumpToPage(currentIndex);
                            },
                            child: regularText(
                              'Next ',
                              fontSize: 15.sp,
                              color: AppColors.primary),
                          ),
                      ],
                    )
                  ],
              ),
            )
          ]
        ),
      ),
      bottomNavigationBar: _isAdLoaded ? Container(
        height: _bannerAd.size.height.toDouble(),
        width: double.infinity,
        child: AdWidget(ad: _bannerAd),
      ) : SizedBox(),
    );
  }

  _buildImage(String imageUrl) {
    return Image.asset(
      imageUrl,
      height: 0.58.sh,
      width: 1.sw,
      fit: BoxFit.fitWidth,
    );
  }
}
