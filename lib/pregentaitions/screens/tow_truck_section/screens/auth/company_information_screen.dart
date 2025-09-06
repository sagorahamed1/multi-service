import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
import 'package:autorevive/pregentaitions/widgets/custom_phone_number_picker.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../controllers/towTrack/registration_tow_track_controller.dart';
import '../../../../widgets/Custom_Ein_number.dart';

class CompanyInformationScreen extends StatefulWidget {
  const CompanyInformationScreen({super.key});

  @override
  State<CompanyInformationScreen> createState() =>
      _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformationScreen> {

  TowTrackController towTrackController = Get.put(TowTrackController());

  final TextEditingController _companyNameTEController = TextEditingController();
  final TextEditingController _ownerNameTEController = TextEditingController();
  final TextEditingController _businessPhoneTEController = TextEditingController();
  final TextEditingController _businessEmailTEController = TextEditingController();
  final TextEditingController _companyAddressTEController = TextEditingController();
  final TextEditingController _websiteURLTEController = TextEditingController();
  final TextEditingController _businessYearTEController = TextEditingController();
  final TextEditingController _towTrucksTEController = TextEditingController();
  final TextEditingController _eINTEController = TextEditingController();


  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};

      _companyNameTEController.text = routeData['companyName'] ?? '';
      _ownerNameTEController.text = routeData['companyOwner'] ?? '';
      _businessPhoneTEController.text = routeData['companyPhone'] ?? '';
      _websiteURLTEController.text = routeData['website'] ?? '';
      _businessYearTEController.text = routeData['yearsInBusiness']?.toString() ?? '';
      _towTrucksTEController.text = routeData['totalTows']?.toString() ?? '';
      _eINTEController.text = routeData['einNo'] ?? '';
      _businessEmailTEController.text = routeData['companyEmail'] ?? '';
      _companyAddressTEController.text = routeData['companyAddress'] ?? '';

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isLoading = false;
        });
      });


    });
    towTrackController.getTowTrackProfile();
  }



  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final Map routeData = extra is Map ? extra : {};
    final bool isEdit = routeData['isEdit'] ?? false;
    return CustomScaffold(
      appBar: AppBar(
          centerTitle: false,
          title: CustomText(
            text: "Company Information",
            fontsize: 20.sp,
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child:isLoading
              ? Column(
            children: List.generate(2, (_) => _buildShimmerCompanyInformation()),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEdit) CustomLinearIndicator(
                progressValue: 0.1,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _companyNameTEController,
                labelText: 'Company Name',
                hintText: 'Enter Company name',
              ),


              CustomTextField(
                controller: _ownerNameTEController,
                labelText: 'Owner / Manager Name',
                hintText: 'Owner / Manager Name',
              ),


              /// ++++++++++++++++++++++  phone number  ==================>
              CustomPhoneNumberPicker(
                lebelText : 'Business Phone No.',
                controller: _businessPhoneTEController,),


              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                controller: _businessEmailTEController,
                labelText: 'Business Email Address',
                hintText: 'Business Email Address',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),


              CustomTextField(
                controller: _companyAddressTEController,
                labelText: 'Company Address',
                hintText: 'Company Address',
              ),


              CustomTextField(
                controller: _websiteURLTEController,
                labelText: 'Website URL',
                hintText: 'David William LLC',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Website URL is required';
                  }
                  final urlRegex = RegExp(
                      r'^(https?:\/\/)?' // optional scheme
                      r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // domain
                      r'(\/[^\s]*)?$' // optional path
                  );
                  if (!urlRegex.hasMatch(value.trim())) {
                    return 'Enter a valid URL';
                  }
                  return null;
                },
              ),


              CustomTextField(
                keyboardType: TextInputType.number,
                controller: _businessYearTEController,
                labelText: 'Years in Businees',
                hintText: 'Years in Businees',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: _towTrucksTEController,
                      labelText: 'Number of Tow Trucks in Fleet',
                      hintText: 'Number of Tow Trucks in Fleet',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 134.w,
                    child: CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: _eINTEController,
                      labelText: 'Enter EIN number',
                      hintText: 'Enter EIN number',
                      inputFormatters: [
                        EINInputFormatter(),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter EIN number';
                        if (value.length != 10) return 'EIN must be 10 digits';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 44.h),
              Obx(()=>
              CustomButton(
                loading: towTrackController.companyInfoLoading.value,
                    title: isEdit ? "Edit" : "Save and Next",
                    onpress: () async {
                      if(_globalKey.currentState!.validate()){
                        final int? yearsInBusiness = int.tryParse(_businessYearTEController.text.trim());
                        final int? totalTows = int.tryParse(_towTrucksTEController.text.trim());
                        final success = await towTrackController.companyInformation(
                          companyName: _companyNameTEController.text.trim(),
                            companyOwner: _ownerNameTEController.text.trim(),
                            companyPhone: _businessPhoneTEController.text.trim(),
                            companyEmail: _businessEmailTEController.text.trim(),
                            companyAddress: _companyAddressTEController.text.trim(),
                            website: _websiteURLTEController.text.trim(),
                            yearsInBusiness: yearsInBusiness,
                            totalTows: totalTows,
                            einNo: _eINTEController.text.trim(),
                            context: context);
                        if (success) {
                          isEdit
                              ? context.pop(true)
                              :  context.pushNamed(AppRoutes.licensingAndComplianceScreen);
                        }
                      }

                    }),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCompanyInformation() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 20.h), // space for appbar

            // Company Name field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Owner / Manager Name field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Business Phone Number picker shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Business Email Address field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Company Address field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Website URL field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Years in Business field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Number of Tow Trucks and EIN number row shimmer
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 134.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),

            // Save and Next button shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }





}


