import 'dart:io';
import 'package:autorevive/pregentaitions/widgets/CustomChecked.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:autorevive/pregentaitions/widgets/custom_upload_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controllers/towTrack/registration_tow_track_controller.dart';
import '../../../../../controllers/upload_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../helpers/toast_message_helper.dart';
import 'package:path/path.dart' as path;

class LicensingAndComplianceScreen extends StatefulWidget {
  const LicensingAndComplianceScreen({super.key});

  @override
  State<LicensingAndComplianceScreen> createState() =>
      _LicensingAndComplianceScreenState();
}

class _LicensingAndComplianceScreenState extends State<LicensingAndComplianceScreen> {

  TowTrackController towTrackController = Get.put(TowTrackController());
  UploadController uploadController = Get.put(UploadController());

  final TextEditingController _uSDOTNumberTEController = TextEditingController();
  final TextEditingController _policyNumberTEController = TextEditingController();
  final TextEditingController _coverageLimitsTEController = TextEditingController();
  final TextEditingController _mCNumberTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  RxString registrationUrl = ''.obs;
  RxString insurancePolicyUrl = ''.obs;
  RxString mcUrl = ''.obs;

  RxString registrationFileName = ''.obs;
  RxString insurancePolicyFileName = ''.obs;
  RxString mcFileName = ''.obs;


  bool? validUSDOTNumber;
  bool? coverageNumber;
  bool? mCNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};

      _uSDOTNumberTEController.text = routeData['usDotNo'] ?? '';
      _policyNumberTEController.text = routeData['policyNo'] ?? '';
      _coverageLimitsTEController.text = routeData['policyLimit']?.toString() ?? '';
      _mCNumberTEController.text = routeData['mcNo'] ?? '';

      registrationUrl.value = routeData['usDotFile'] ?? '';
      insurancePolicyUrl.value = routeData['policyFile'] ?? '';
      mcUrl.value = routeData['mcFile'] ?? '';

      validUSDOTNumber = (routeData['usDotNo'] ?? '').toString().isNotEmpty;
      coverageNumber = (routeData['policyNo'] ?? '').toString().isNotEmpty;
      mCNumber = (routeData['mcNo'] ?? '').toString().isNotEmpty;

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
            text: "Licensing and Compliance",
            fontsize: 20.sp,
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: isLoading
              ? Column(
            children: List.generate(2, (_) => _buildShimmerLicensing()),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEdit) CustomLinearIndicator(
                progressValue: 0.2,
              ),
              SizedBox(height: 16.h),

              /// =======================================> Dot Number ===================================>
              CustomChecked(
                title: 'Do you have a valid US-DOT number? *',
                selected: validUSDOTNumber,
                onChanged: (val) {
                  setState(() {
                    validUSDOTNumber = val;
                  });
                },
              ),
             if (validUSDOTNumber == true) ...[ CustomTextField(
              keyboardType: TextInputType.text,
                controller: _uSDOTNumberTEController,
                labelText: 'US-DOT Number',
                hintText: 'US-DOT Number',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                ],
              validator: (value) {
                if (validUSDOTNumber != true) return null;
                if (value == null || value.isEmpty) {
                  return 'US-DOT Number is required';
                }

                final pattern = RegExp(r'^USDOT\d{7}$');
                if (!pattern.hasMatch(value)) {
                  return 'Enter valid US-DOT number (e.g., USDOT1523020)';
                }

                return null;
              },
              ),

              Obx(() => CustomUploadButton(
                topLabel: 'Do you have commercial insurance coverage?*',
                title: registrationFileName.value.isNotEmpty ? registrationFileName.value : 'Upload DOT registration',
                icon: Icons.upload,
                onTap: () => importPdf(target: 'dot'),
              )),
              // CustomUploadButton(
              //   topLabel: 'Do you have commercial insurance coverage?*',
              //   title: registrationUrl.value.isNotEmpty
              //       ? 'DOT registration.pdf'
              //       : 'Upload DOT registration',
              //   icon: Icons.upload,
              //   onTap: () => importPdf(target: 'dot'),
              // ),
            ],

              /// =======================================> Commercial Insurance ===================================>

              CustomChecked(
                title: 'Do you have commercial insurance coverage?*',
                selected: coverageNumber,
                onChanged: (val) {
                  setState(() {
                    coverageNumber = val;
                  });
                },
              ),
              if (coverageNumber == true) ...[
                CustomTextField(
                keyboardType: TextInputType.text,
                controller: _policyNumberTEController,
                labelText: 'Policy Number',
                hintText: 'Policy Number',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                ],
                  validator: (value) {
                    if (coverageNumber != true) return null;
                    if (value == null || value.isEmpty) {
                      return 'Policy number is required';
                    }

                    final pattern = RegExp(r'^[A-Z0-9\-]{6,30}$');
                    if (!pattern.hasMatch(value)) {
                      return 'Policy number must be 6–30 characters, uppercase letters, numbers or dashes only';
                    }

                    return null;
                  },
              ),
              CustomTextField(
                keyboardType: TextInputType.number,
                controller: _coverageLimitsTEController,
                labelText: 'Coverage Limits',
                hintText: 'Coverage Limits',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
              ),
                Obx(() => CustomUploadButton(
                  title: insurancePolicyFileName.value.isNotEmpty ? insurancePolicyFileName.value : 'Upload insurance policy',
                  icon: Icons.upload,
                  onTap: () => importPdf(target: 'insurance'),
                )),
                // CustomUploadButton(
                //   topLabel: 'Upload Proof of a Active insurance policy.',
                //   title: insurancePolicyUrl.value.isNotEmpty
                //       ? 'insurancePolicy.pdf'
                //       : 'Upload insurance policy',
                //   icon: Icons.upload,
                //   onTap: () => importPdf(target: 'insurance'),
                // ),
              ],

              /// =======================================> MC Number ===================================>
              CustomChecked(
                title: 'Do you have a valid Motor Carrier (MC) number?*',
                selected: mCNumber,
                onChanged: (val) {
                  setState(() {
                    mCNumber = val;
                  });
                },
              ),
              if (mCNumber == true) ...[
              CustomTextField(
                keyboardType: TextInputType.text,
                controller: _mCNumberTEController,
                labelText: 'MC Number',
                hintText: 'MC Number',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: (value) {
                  if (mCNumber != true) return null;
                if (value == null || value.isEmpty) {
            return 'MC Number is required';
          }

                final pattern = RegExp(r'^MC\d{6}$');
                if (!pattern.hasMatch(value)) {
            return 'MC Number must be in the format MC followed by 6 digits';
          }
                return null;
              },
              ),

              Obx(() => CustomUploadButton(
        title: mcFileName.value.isNotEmpty ? mcFileName.value : 'Upload mc',
        icon: Icons.upload,
        onTap: () => importPdf(target: 'mc'),
      )),
              // CustomUploadButton(
      //   topLabel: 'Upload Proof of MC authority',
      //   title: mcUrl.value.isNotEmpty
      //       ? 'mc.pdf'
      //       : 'Upload mc',
      //   icon: Icons.upload,
      //   onTap: () => importPdf(target: 'mc'),
      // ),

    ],



              SizedBox(height: 44.h),
              Obx(()=>
                CustomButton(
                  loading: towTrackController.licensingComplianceLoading.value,
                    title: isEdit ? "Edit" : "Save and Next",
                    onpress: () async{
                      if(_globalKey.currentState!.validate()){
                        if (validUSDOTNumber == true && registrationUrl.value.isEmpty) {
                          ToastMessageHelper.showToastMessage("Please upload DOT registration.", title: 'Attention');
                          return;
                        }
                        if (coverageNumber == true && insurancePolicyUrl.value.isEmpty) {
                          ToastMessageHelper.showToastMessage("Please upload insurance policy.", title: 'Attention');
                          return;
                        }
                        if (mCNumber == true && mcUrl.value.isEmpty) {
                          ToastMessageHelper.showToastMessage("Please upload MC file.", title: 'Attention');
                          return;
                        }

                        final int? policyLimit = int.tryParse(_coverageLimitsTEController.text.trim());
                        final success = await  towTrackController.licensingCompliance(
                            policyNo: _policyNumberTEController.text.trim(),
                            policyLimit: policyLimit,
                            usDotFile: registrationUrl.value,
                            policyFile: insurancePolicyUrl.value,
                            mcNo: _mCNumberTEController.text.trim(),
                            usDotNo: _uSDOTNumberTEController.text.trim(),
                            mcFile: mcUrl.value,
                            context: context);
                        if (success) {
                          isEdit
                              ? context.pop(true)
                              :  context.pushNamed(AppRoutes.vehicleEquipmentScreen);
                        }
                      }

                    }


                    ),),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLicensing() {
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


  Future<void> importPdf({required String target}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedFile = File(result.files.single.path!);
      String fileName = path.basename(selectedFile.path);
      String? uploadedPath = await uploadController.uploadFile(file: selectedFile);

      if (uploadedPath != null) {
        if (target == 'dot') {
          registrationUrl.value = uploadedPath;
          registrationFileName.value = fileName;
        } else if (target == 'insurance') {
          insurancePolicyUrl.value = uploadedPath;
          insurancePolicyFileName.value = fileName;
        } else if (target == 'mc') {
          mcUrl.value = uploadedPath;
          mcFileName.value = fileName;
        }
      } else {
        ToastMessageHelper.showToastMessage("File upload failed.");
      }
    } else {
      ToastMessageHelper.showToastMessage("No file selected.");
    }
  }


// Future<void> importPdf({required bool isRegistration}) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //
  //   if (result != null && result.files.isNotEmpty) {
  //     File selectedFile = File(result.files.single.path!);
  //     String? uploadedPath = await uploadController.uploadFile(file: selectedFile);
  //     if (uploadedPath != null) {
  //       if (isRegistration) {
  //         registrationUrl.value = uploadedPath;
  //       } else  {
  //         insurancePolicyUrl.value = uploadedPath;
  //       }
  //     } else {
  //       mcUrl.value = uploadedPath!;
  //     }
  //   } else {
  //     ToastMessageHelper.showToastMessage("No file selected.");
  //   }
  // }


}
