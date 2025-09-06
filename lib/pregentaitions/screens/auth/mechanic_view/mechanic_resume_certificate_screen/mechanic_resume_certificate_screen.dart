import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controllers/mechanic_controller.dart';
import '../../../../../controllers/upload_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../helpers/toast_message_helper.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_linear_indicator.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/custom_upload_button.dart';
import 'package:path/path.dart' as path;


class MechanicResumeCertificateScreen extends StatefulWidget {
  const MechanicResumeCertificateScreen({super.key});

  @override
  State<MechanicResumeCertificateScreen> createState() => _MechanicResumeCertificateScreenState();
}

class _MechanicResumeCertificateScreenState extends State<MechanicResumeCertificateScreen> {

  UploadController uploadController = Get.put(UploadController());
  MechanicController mechanicController = Get.put(MechanicController());
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  RxString resumeUrl = ''.obs;
  RxString certificateUrl = ''.obs;


  RxString resumeFileName = ''.obs;
  RxString certificateFileName = ''.obs;



  late final bool isEdit;



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final Map routeData = GoRouterState.of(context).extra as Map;
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};
      isEdit = routeData['isEdit'] ?? false;

      if (isEdit) {
        resumeUrl.value = mechanicController.profile.value.resume ?? '';
        certificateUrl.value = mechanicController.profile.value.certificate ?? '';
      }


      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isLoading = false;
        });
      });

    });


  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final Map routeData = extra is Map ? extra : {};
    final bool isEdit = routeData['isEdit'] ?? false;


    return Scaffold(
      resizeToAvoidBottomInset: false,


      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(
          text: "Resume and Certificate",
          fontsize: 20.sp,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ),
      body:isLoading
          ? SingleChildScrollView(
        child: Column(
          children: List.generate(4, (_) => _buildShimmerCertificate()),
        ),
      )

          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                ///<<<=============>>> LinearIndicator <<<===============>>>
                if (!isEdit) CustomLinearIndicator(
                  progressValue: 0.9,
                ),
                SizedBox(height: 20.h),
                CustomText(text: "Upload your resume and certificates to complete your mechanic profile. Showcase your skills, experience, and certifications to attract more customers. A complete profile increases trust and boosts your chances of getting hired. Get started now and stand out as a professional mechanic! ",
                    maxline: 15,
                    textAlign: TextAlign.start,
                    fontsize: 13.sp,
                    color: AppColors.textColor151515),
                SizedBox(height: 29.h),
                Obx(() => CustomUploadButton(
                  title: resumeFileName.value.isNotEmpty ? resumeFileName.value : 'Upload Resume',
                  icon: Icons.upload,
                  onTap: () => importPdf(isResume: true),
                )),
                // CustomUploadButton(
                //   // topLabel: 'Upload Resume',
                //   title: 'Upload Resume',
                //   icon: Icons.upload,
                //   onTap: () => importPdf(isResume: true),
                // ),
                SizedBox(height: 5.h),
                Obx(() => CustomUploadButton(
                  title: certificateFileName.value.isNotEmpty ? certificateFileName.value : 'Upload Certificate',
                  icon: Icons.upload,
                  onTap: () => importPdf(isResume: false),
                )),
                // CustomUploadButton(
                //   // topLabel: 'Upload Resume',
                //   title: 'Upload Certificate',
                //   icon: Icons.upload,
                //   onTap: () => importPdf(isResume: false),
                // ),
                SizedBox(height: 330.h),

                /// ================================>>>>  Save and Next button    <<<<<<=============================>>>
                Obx(() => CustomButton(
                loading: mechanicController.resumeCertificateLoading.value,
                title: isEdit ? "Edit" : "Save and Next",
                onpress: () async {
                  if (fromKey.currentState!.validate()) {
                    if (resumeUrl.value.isEmpty || certificateUrl.value.isEmpty) {
                      ToastMessageHelper.showToastMessage("Please upload both resume and certificate", title: 'Attention');
                      return;
                    }
                    final success = await mechanicController.resumeCertificate(
                      resume: resumeUrl.value,
                      certificate: certificateUrl.value,
                      context: context,
                    );

                    if (success) {
                      if (isEdit) {
                        context.pop(true);
                      } else {
                        context.pushNamed(AppRoutes.mechanicProfileInformationScreen);
                      }
                    }
                  }
                },
              )),
                // Obx(() => CustomButton(
                //   loading: mechanicController.resumeCertificateLoading.value,
                //   title: isEdit ? "Edit" : "Save and Next",
                //   onpress: () async {
                //     if (fromKey.currentState!.validate()) {
                //       if (resumeUrl.value.isEmpty || certificateUrl.value.isEmpty) {
                //         ToastMessageHelper.showToastMessage("Please upload both resume and certificate.");
                //         return;
                //       }
                //
                //  await mechanicController.resumeCertificate(
                //         resume: resumeUrl.value,
                //         certificate: certificateUrl.value,
                //         context: context,
                //       );
                //
                //       // context.pop(true);
                //
                //
                //     }
                //   },
                // )),


                // Obx(() => CustomButton(
                //   loading: mechanicController.resumeCertificateLoading.value,
                //   title: "Submit",
                //     onpress: () async {
                //       if (fromKey.currentState!.validate()) {
                //         if (resumeUrl.value.isEmpty || certificateUrl.value.isEmpty) {
                //           ToastMessageHelper.showToastMessage("Please upload both resume and certificate.");
                //           return;
                //         }
                //
                //         await mechanicController.resumeCertificate(
                //           resume: resumeUrl.value,
                //           certificate: certificateUrl.value,
                //           context: context,
                //         );
                //                context.pop(true);
                //
                //
                //       }
                //     }
                //
                //   // onpress: () {
                //   //   if (fromKey.currentState!.validate()) {
                //   //     if (resumeUrl.value.isEmpty || certificateUrl.value.isEmpty) {
                //   //       ToastMessageHelper.showToastMessage("Please upload both resume and certificate.");
                //   //       return;
                //   //     }
                //   //
                //   //     mechanicController.resumeCertificate(
                //   //       resume: resumeUrl.value,
                //   //       certificate: certificateUrl.value,
                //   //       context: context,
                //   //     );
                //   //   }
                //   // },
                // )),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> importPdf({required bool isResume}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedFile = File(result.files.single.path!);
      String fileName = path.basename(selectedFile.path);
      String? uploadedPath = await uploadController.uploadFile(file: selectedFile);
      if (uploadedPath != null) {
        if (isResume) {
          resumeUrl.value = uploadedPath;
          resumeFileName.value = fileName;
        } else {
          certificateUrl.value = uploadedPath;
          certificateFileName.value = fileName;
        }
      } else {
        ToastMessageHelper.showToastMessage("File upload failed.");
      }
    } else {
      ToastMessageHelper.showToastMessage("No file selected.");
    }
  }


  Widget _buildShimmerCertificate() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 16.h), // space for AppBar

            // Linear progress indicator placeholder
            Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Info text placeholder: multiple lines of varying width
            Container(height: 12.h, width: double.infinity, color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Container(height: 12.h, width: 0.9.sw, color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Container(height: 12.h, width: 0.85.sw, color: Colors.grey.shade300),
            SizedBox(height: 8.h),
            Container(height: 12.h, width: 0.75.sw, color: Colors.grey.shade300),
            SizedBox(height: 29.h),

            // Upload Resume button placeholder
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 5.h),

            // Upload Certificate button placeholder
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 330.h),

            // Save / Edit button placeholder
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

}
