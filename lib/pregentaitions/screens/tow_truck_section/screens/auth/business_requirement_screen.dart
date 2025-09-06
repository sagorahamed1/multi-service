import 'dart:io';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_checkbox_list.dart';
import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:autorevive/pregentaitions/widgets/custom_upload_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controllers/towTrack/registration_tow_track_controller.dart';
import '../../../../../controllers/upload_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../helpers/toast_message_helper.dart';
import 'package:path/path.dart' as path;

class BusinessRequirementScreen extends StatefulWidget {
  const BusinessRequirementScreen({super.key});

  @override
  State<BusinessRequirementScreen> createState() => _BusinessRequirementScreenState();
}

class _BusinessRequirementScreenState extends State<BusinessRequirementScreen> {

  UploadController uploadController = Get.put(UploadController());
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _dateTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TowTrackController towTrackController = Get.put(TowTrackController());

  RxString signatureUrl = ''.obs;

  RxString signatureFileName = ''.obs;

  final Map<String, bool> _services = {
    'Maintain active DOT registration & insurance coverage at all times.': false,
    'Adhere to all local, state, and federal regulations for towing operations.': false,
    'Provide timely and professional service': false,
    'Maintain clean and well-maintained tow trucks and equipment.': false,
    'Communicate accurate ETAs and service updates.': false,
    'Submit a live walk-around video showing that all trucks meet operational standards.': false,
    'I certify that the information provided is accurate and that my company meets all requirements for partnering with Fix It LLC.': false,
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};

      _nameTEController.text = routeData['authName'] ?? '';
      _titleTEController.text = routeData['authTitle'] ?? '';
      _dateTEController.text = routeData['authDate'] != null
          ? DateTime.parse(routeData['authDate'].toString())
          .toIso8601String()
          .split('T')
          .first
          : '';
      signatureUrl.value = routeData['authSignature'] ?? '';



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
            textAlign: TextAlign.start,
            maxline: 2,
            text: "Business requirements and agreements",
            fontsize: 20.sp,
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: isLoading
              ? Column(
            children: List.generate(2, (_) => _buildShimmerBusiness()),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEdit) CustomLinearIndicator(
                progressValue: 0.94,
                label: 100,
              ),
              SizedBox(height: 24.h),
              CustomText(
                textAlign: TextAlign.start,
                maxline: 2,
                text: 'By applying to work with Fix It LLC, you agree to the following..',
                bottom: 6.h,
              ),
              if (!isEdit)
                CustomCheckboxList(
                  isAllChecked: true,
                  items: _services,
                ),


              SizedBox(height: 10.h),

              CustomTextField(
                controller: _nameTEController,
                labelText: 'Authorized or Representative name',
                hintText: 'Authorized or Representative name',
              ),

              CustomTextField(
                controller: _titleTEController,
                labelText: 'Authorized or Representative title',
                hintText: 'Authorized or Representative title',
              ),
              Obx(() => CustomUploadButton(
                topLabel: 'Signature',
                title: signatureFileName.value.isNotEmpty ? signatureFileName.value : 'Upload signature',
                icon: Icons.upload,
                onTap: () => importPdf(isSignature: true),
              )),

              // Obx(() =>
              //     CustomUploadButton(
              //       topLabel: 'Signature',
              //       title: signatureUrl.value.isNotEmpty
              //           ? 'signature.jpg'
              //           : 'Upload signature',
              //       icon: Icons.upload,
              //       onTap: () => importPdf(isSignature: true),
              //     ),
              // ),

              CustomTextField(
                readOnly: true,
                onTap: _selectDate,
                controller: _dateTEController,
                labelText: 'Date',
                hintText: 'Date',
                suffixIcon: const Icon(Icons.date_range_outlined),
              ),

              SizedBox(height: 44.h),
              Obx(()=>
                CustomButton(
                  loading: towTrackController.businessRequirementsLoading.value,
                    title:  isEdit ? "Edit" : "Submit",
                    onpress: ()async {
                      if(_globalKey.currentState!.validate()){

                        if (signatureUrl.value.isEmpty) {
                          ToastMessageHelper.showToastMessage("Please upload Signature", title: 'Attention');
                          return;
                        }
                        if (!isEdit && _services.values.any((v) => v == false)) {
                          ToastMessageHelper.showToastMessage("Please check all agreements", title: 'Attention');
                          return;
                        }




                        final success = await towTrackController.businessRequirements(
                          authName: _nameTEController.text.trim(),
                            authTitle: _titleTEController.text.trim(),
                            authSignature: signatureUrl.value,
                            authDate: _dateTEController.text.trim(),
                            context: context);
                        if (success) {
                          isEdit
                              ? context.pop(true)
                              :    context.pushNamed(AppRoutes.towTruckBottomNavBar);
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





  Widget _buildShimmerBusiness() {
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


  Future<void> importPdf({required bool isSignature}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedFile = File(result.files.single.path!);
      String fileName = path.basename(selectedFile.path);
      String? uploadedPath = await uploadController.uploadFile(file: selectedFile);
      if (uploadedPath != null) {
        if (isSignature) {
          signatureUrl.value = uploadedPath;
          signatureFileName.value = fileName;
        }
      }
    } else {
      ToastMessageHelper.showToastMessage("No file selected.");
    }
  }
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        _dateTEController.text = formattedDate;
      });
    }
  }

}
