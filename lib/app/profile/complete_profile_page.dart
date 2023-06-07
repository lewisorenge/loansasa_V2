import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loansasa/constants/ad_units.dart';
import 'package:loansasa/constants/constClass.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loansasa/constants/regular_text.dart';
import 'package:loansasa/constants/colors.dart';
import 'package:loansasa/constants/edit_text.dart';
import 'package:loansasa/constants/button.dart';
import 'package:loansasa/constants/alert_dialog.dart';
import 'package:loansasa/app/profile/complete_profile_controller.dart';
import '../../constants/date_input.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _StackOverState createState() => _StackOverState();
}

class _StackOverState extends State<CompleteProfile>
    with SingleTickerProviderStateMixin {
  late BannerAd _bannerAd;
  bool _isBannerAd1Loaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstialAdLoaded = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdLoaded = false;

  late CompleteProfileController completeProfileController;
  late TabController _tabController;

  final phoneDetailsForm = GlobalKey<FormState>();
  final aboutYouForm = GlobalKey<FormState>();
  final personalDetailsForm = GlobalKey<FormState>();
  final educationDetailsForm = GlobalKey<FormState>();
  final loanPurposeDetailsForm = GlobalKey<FormState>();
  final financialDetailsForm = GlobalKey<FormState>();
  final yourIncomeDetailsForm = GlobalKey<FormState>();
  final nextOfKinForm = GlobalKey<FormState>();

  bool isProfileComplete = false;

  String ownPhone = "Yes";
  String newOrUsed = "New";

  // About Us
  String knowAboutUsController = "Social Media";
  String haveOutstandingLoans = "No";

  // Personal Details
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  // Education Level
  String edcationLevel = "Secondary School";

  String workStatusController = "Employed";
  TextEditingController placeOfWorkController = TextEditingController();
  String monthlySalaryController = "0 - 10,000 ${ConstClass.currencySymbol}";

  //Loan Purpose
  String loanPurpose = "Personal Loan";

  // Your Income
  String earnSameAmount = "Yes";
  String otherSourceOfIncome = "No";

  TextEditingController nextOfKinNameController = TextEditingController();
  TextEditingController nextOfKinRelationshipController =
      TextEditingController();
  PhoneNumber mobileNumberDialCode =
      PhoneNumber(isoCode: ConstClass.countryCode);
  String nextOfKinMobileNumber = "";
  TextEditingController nextOfKinMobileNumberController =
      TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 9, vsync: this);
    super.initState();
    _initBannerAd();
    _initInterstitialAd();
    _initRewardedAd();
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
                _isBannerAd1Loaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: AdRequest());

    _bannerAd.load();
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdUnitStrings.interstial_profile_ad,
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
        adUnitId: AdUnitStrings.rewarded_profile_ad,
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
    ScreenUtil.init(context);

    completeProfileController = context.watch<CompleteProfileController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        actions: [],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: AppColors.white,
          ),
        ),
        title: regularText('Complete Profile',
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
                physics: AlwaysScrollableScrollPhysics(),
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
                    text: 'Phone Details',
                  ),
                  Tab(
                    text: 'About You',
                  ),
                  Tab(
                    text: 'Personal Details',
                  ),
                  Tab(
                    text: 'Education Level',
                  ),
                  Tab(
                    text: 'Financial Details',
                  ),
                  Tab(
                    text: 'Loan Purpose',
                  ),
                  Tab(
                    text: 'Your Income',
                  ),
                  Tab(
                    text: 'Next of Kin',
                  ),
                  Tab(
                    text: 'Complete',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  phoneDetailsStep(),
                  aboutYouStep(),
                  personalDetailsStep(),
                  educationDetailsStep(),
                  financialDetailsStep(),
                  loanPurposeDetailsStep(),
                  yourIncomeStep(),
                  nextOfKinStep(),
                  profileSuccessStep()
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isBannerAd1Loaded
          ? Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox(),
    );
  }

  phoneDetailsStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Form(
        key: phoneDetailsForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText(
                  'Do you own this phone?',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("Yes, this phone is mine", fontSize: 16.0),
              leading: Radio(
                value: "Yes",
                groupValue: ownPhone,
                onChanged: (String? value) {
                  setState(() {
                    ownPhone = value!;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("No, someone else owns this phone",
                  fontSize: 16.0),
              leading: Radio(
                value: "No",
                groupValue: ownPhone,
                onChanged: (String? value) {
                  setState(() {
                    ownPhone = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText(
                  'Did you get it new or used?',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("New", fontSize: 16.0),
              leading: Radio(
                value: "New",
                groupValue: newOrUsed,
                onChanged: (String? value) {
                  setState(() {
                    newOrUsed = value!;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("Used", fontSize: 16.0),
              leading: Radio(
                value: "Used",
                groupValue: newOrUsed,
                onChanged: (String? value) {
                  setState(() {
                    newOrUsed = value!;
                  });
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (phoneDetailsForm.currentState!.validate()) {
                  await completeProfileController.phoneDetails(
                      ownPhone, newOrUsed);

                  if (_isInterstialAdLoaded) {
                    _interstitialAd.show();
                  }

                  _tabController.animateTo((_tabController.index + 1) % 2);
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  aboutYouStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Form(
        key: aboutYouForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('How did you hear about us?')),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: AppColors.gray200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 17.0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
              validator: (value) =>
                  value == null ? "Let us know how you heard about us" : null,
              dropdownColor: AppColors.gray200,
              value: knowAboutUsController,
              onChanged: (String? newValue) {
                knowAboutUsController = newValue!;
              },
              items: <String>[
                'Social Media',
                'Play Store',
                'Youtube',
                'Friend',
                'Other'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText(
                  'Do you have outstanding loans?',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("Yes", fontSize: 16.0),
              leading: Radio(
                value: "Yes",
                groupValue: haveOutstandingLoans,
                onChanged: (String? value) {
                  setState(() {
                    haveOutstandingLoans = value!;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("No", fontSize: 16.0),
              leading: Radio(
                value: "No",
                groupValue: haveOutstandingLoans,
                onChanged: (String? value) {
                  setState(() {
                    haveOutstandingLoans = value!;
                  });
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (aboutYouForm.currentState!.validate()) {
                  await completeProfileController.aboutYouDetails(
                      knowAboutUsController, haveOutstandingLoans);

                  _tabController.animateTo((_tabController.index + 1));
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  personalDetailsStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Form(
        key: personalDetailsForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText('ID Number')),
            EditText(
              hintText: 'Your ID Number',
              obscurity: false,
              controller: idController,
              lengthLimitingTextInputFormatter: 8,
              errorText: "You must provide your national ID number",
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText('Date of Birth')),
            DateInput(
              hintText: 'Date of birth',
              controller: dobController,
              errorText: "You must provide your DOB",
            ),
            const Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (personalDetailsForm.currentState!.validate()) {
                  await completeProfileController.personalDetails(
                      idController.text, dobController.text);

                  if (_isRewardedAdLoaded) {
                    _rewardedAd.show(onUserEarnedReward: (ad, item) {});
                  }

                  _tabController.animateTo((_tabController.index + 1));
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  educationDetailsStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Form(
        key: educationDetailsForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('What is your highest level of education?')),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: AppColors.gray200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 17.0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
              validator: (value) => value == null
                  ? "You need to provide your education level"
                  : null,
              dropdownColor: AppColors.gray200,
              value: edcationLevel,
              onChanged: (String? newValue) {
                edcationLevel = newValue!;
              },
              items: <String>[
                'None',
                'Primary School',
                'Secondary School',
                'College/University'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10.h),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText('Your grade (Optional)')),
            EditText(
              hintText: 'Optional',
              obscurity: false,
            ),
            const Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (educationDetailsForm.currentState!.validate()) {
                  await completeProfileController
                      .educationDetails(edcationLevel);

                  if (_isInterstialAdLoaded) {
                    _interstitialAd.show();
                  }

                  _tabController.animateTo((_tabController.index + 1));
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  financialDetailsStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Form(
        key: financialDetailsForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('Work Status')),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: AppColors.gray200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 17.0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
              validator: (value) =>
                  value == null ? "You need to provide your work status" : null,
              dropdownColor: AppColors.gray200,
              value: workStatusController,
              onChanged: (String? newValue) {
                workStatusController = newValue!;
              },
              items: <String>['Employed', 'Unemployed', 'Student', 'Other']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('Place of Work (Optional)')),
            EditText(
                hintText: 'E.g School, Self Employed',
                obscurity: false,
                controller: placeOfWorkController),
            Container(
                margin: EdgeInsets.only(top: 25.h, bottom: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText(
                    'Monthly Income (${ConstClass.currencySymbol})')),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: AppColors.gray200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 17.0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
              validator: (value) => value == null
                  ? "You need to provide your monthly incomd"
                  : null,
              dropdownColor: AppColors.gray200,
              value: monthlySalaryController,
              onChanged: (String? newValue) {
                monthlySalaryController = newValue!;
              },
              items: <String>[
                '0 - 10,000 ${ConstClass.currencySymbol}',
                '10,000 - 25,000 ${ConstClass.currencySymbol}',
                '25,000 - 40,000 ${ConstClass.currencySymbol}',
                '40,000 - 80,000 ${ConstClass.currencySymbol}',
                '80,000 and above ${ConstClass.currencySymbol}'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: regularText(value),
                );
              }).toList(),
            ),
            new Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (financialDetailsForm.currentState!.validate()) {
                  await completeProfileController.financialDetails(
                    workStatusController,
                    placeOfWorkController.text,
                    monthlySalaryController,
                  );

                  if (_isRewardedAdLoaded) {
                    _rewardedAd.show(onUserEarnedReward: (ad, item) {});
                  }

                  _tabController.animateTo((_tabController.index + 1));
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  loanPurposeDetailsStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Form(
        key: loanPurposeDetailsForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('What is the purpose of the loan?')),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: AppColors.gray200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 17.0),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
              validator: (value) => value == null
                  ? "You need to provide your loan purpose"
                  : null,
              dropdownColor: AppColors.gray200,
              value: loanPurpose,
              onChanged: (String? newValue) {
                loanPurpose = newValue!;
              },
              items: <String>[
                'Personal Loan',
                'Business Loan',
                'Emergency Loan',
                'Other'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (loanPurposeDetailsForm.currentState!.validate()) {
                  await completeProfileController
                      .loanPurposeDetails(loanPurpose);

                  _tabController.animateTo((_tabController.index + 1));
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  yourIncomeStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Form(
        key: yourIncomeDetailsForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText(
                  'Do you always earn the same amount?',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("Yes, I always earn the same amount",
                  fontSize: 16.0),
              leading: Radio(
                value: "Yes",
                groupValue: earnSameAmount,
                onChanged: (String? value) {
                  setState(() {
                    earnSameAmount = value!;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("No, the amount I earn sometimes changes",
                  fontSize: 16.0),
              leading: Radio(
                value: "No",
                groupValue: earnSameAmount,
                onChanged: (String? value) {
                  setState(() {
                    earnSameAmount = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.centerLeft,
                child: regularText(
                  'Do you any other source of income?',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("Yes", fontSize: 16.0),
              leading: Radio(
                value: "Yes",
                groupValue: otherSourceOfIncome,
                onChanged: (String? value) {
                  setState(() {
                    otherSourceOfIncome = value!;
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              title: regularText("No", fontSize: 16.0),
              leading: Radio(
                value: "No",
                groupValue: otherSourceOfIncome,
                onChanged: (String? value) {
                  setState(() {
                    otherSourceOfIncome = value!;
                  });
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: button('Continue', () async {
                context.loaderOverlay.show();
                if (yourIncomeDetailsForm.currentState!.validate()) {
                  await completeProfileController.yourIncomeDetails(
                      earnSameAmount, otherSourceOfIncome);

                  _tabController.animateTo((_tabController.index + 1));
                } else {
                  alertDialog('Error', 'Entries cannot be null', context);
                }
                context.loaderOverlay.hide();
              }),
            )
          ],
        ),
      ),
    );
  }

  nextOfKinStep() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Form(
        key: nextOfKinForm,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('Next of kin name')),
            EditText(
              hintText: 'Name',
              obscurity: false,
              controller: nextOfKinNameController,
              errorText: "You must provide a valid name",
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.centerLeft,
                child: regularText('Relationship with next of kin')),
            EditText(
              hintText: 'E.g Parent/Relative/Friend',
              obscurity: false,
              controller: nextOfKinRelationshipController,
              errorText: "You must provide a valid relationship",
            ),
            Container(
                alignment: Alignment.centerLeft, child: regularText('Phone')),
            phoneInput(),
            const Spacer(),
            button('Continue', () async {
              context.loaderOverlay.show();
              if (nextOfKinForm.currentState!.validate()) {
                await completeProfileController.nextOfKinDetails(
                  nextOfKinNameController.text,
                  nextOfKinRelationshipController.text,
                  nextOfKinMobileNumberController.text,
                );

                if (_isInterstialAdLoaded) {
                  _interstitialAd.show();
                }

                _tabController.animateTo((_tabController.index + 1));
              } else {
                alertDialog('Error', 'Entries cannot be null', context);
              }
              context.loaderOverlay.hide();
            })
          ],
        ),
      ),
    );
  }

  profileSuccessStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 40.h),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Icon(
              Icons.check_circle,
              size: 50,
              color: AppColors.success,
            )),
        Container(
          alignment: Alignment.center,
          child: regularText('Profile Success!',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black),
        ),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 36.h, vertical: 10.h),
            child: regularText(
              "You have successfully completed your profile. Go to your dashboard and apply for a loan.",
              color: AppColors.gray500,
              textAlign: TextAlign.center,
            )),
        new Spacer(),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            alignment: Alignment.center,
            child: button('Apply Loan', () async {
              context.loaderOverlay.show();
              await completeProfileController.completeProfile();

              if (_isRewardedAdLoaded) {
                _rewardedAd.show(onUserEarnedReward: (ad, item) {});
              }

              Navigator.pushNamed(context, "apply");

              context.loaderOverlay.hide();
            })),
      ],
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
        onInputChanged: (PhoneNumber mobileNumberDialCode) {
          nextOfKinMobileNumber = mobileNumberDialCode.phoneNumber!;
        },
        onInputValidated: (bool value) {},
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          setSelectorButtonAsPrefixIcon: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        initialValue: mobileNumberDialCode,
        inputBorder: const OutlineInputBorder(),
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintText: 'Kin phone number',
          border: OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: AppColors.gray200,
        ),
        textFieldController: nextOfKinMobileNumberController,
        formatInput: false,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        onSaved: (PhoneNumber mobileNumberDialCode) {
          print('On Saved: $mobileNumberDialCode');
        },
      ),
    );
  }
}
