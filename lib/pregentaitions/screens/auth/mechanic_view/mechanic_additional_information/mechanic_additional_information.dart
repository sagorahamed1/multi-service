import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controllers/mechanic_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../helpers/toast_message_helper.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_linear_indicator.dart';
import '../../../../widgets/custom_text.dart';

class MechanicAdditionalInformationScreen extends StatefulWidget {
  const MechanicAdditionalInformationScreen({super.key});

  @override
  State<MechanicAdditionalInformationScreen> createState() => _MechanicAdditionalInformationScreenState();
}


final TextEditingController additionController = TextEditingController();
MechanicController mechanicController = Get.put(MechanicController());
final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

class _MechanicAdditionalInformationScreenState extends State<MechanicAdditionalInformationScreen> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final routeData = GoRouterState.of(context).extra as Map;
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};
      final isEdit = routeData['isEdit'] ?? false;
      final data = routeData['data'];

      if (isEdit && data != null) {
        additionController.text = data.toString();

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

    // Map routeData = GoRouterState.of(context).extra as Map;
    // final bool isEdit = (GoRouterState.of(context).extra as Map)['isEdit'] ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: CustomAppBar(
      //     title: "${routeData["title"]}"),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(
          text: "Additional Information",
          fontsize: 20.sp,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ),
      body: isLoading
          ? SingleChildScrollView(child: _buildShimmerAdditional())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                ///<<<=============>>> LinearIndicator <<<===============>>>
                if (!isEdit)  CustomLinearIndicator(progressValue: 0.8),
                SizedBox(height: 20.h),
                CustomText(text: "Why do you want to work with Fix It Pros LLC.",
                    maxline: 2,
                    textAlign: TextAlign.start,
                    fontsize: 20.sp,
                    color: AppColors.textColor151515),
                SizedBox(height: 25.h),
                Container(
                  width: 342,
                  height: 107,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryShade300, width: 0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: TextFormField(
                      controller: additionController,
                      maxLines: 15,
                      style: TextStyle(fontSize: 14.sp,color: AppColors.textColor151515),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write some things...',
                        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textColor151515),
                        isCollapsed: true,


                      ),
                    ),

                  ),
                ),

                SizedBox(height: 400.h),

                /// ================================>>>>  Save and Next button    <<<<<<=============================>>>


                Obx(() =>
                    CustomButton(
                      loading: mechanicController.additionalInformationLoading.value,
                      title: isEdit ? "Edit" : "Save and Next",
                      onpress: () async {
                        if (fromKey.currentState!.validate()) {
                          final additionalInfo = additionController.text.trim();

                          if (additionalInfo.isEmpty) {
                            ToastMessageHelper.showToastMessage('Enter your additional information!', title: 'Attention');
                            return;
                          }

                          final success = await mechanicController.additionalInformation(
                            whyOnSite: additionalInfo,
                            context: context,
                          );

                          if (success) {
                            isEdit
                                ? context.pop(true)
                                : context.pushNamed(AppRoutes.mechanicResumeCertificateScreen);
                          }
                        }
                      },
                    ),
                ),






                // Obx(()=>
                //    CustomButton(
                //      loading: mechanicController.additionalInformationLoading.value,
                //     title: "Save and Next",
                //     onpress: () {
                //       if(fromKey.currentState!.validate()){
                //         mechanicController.additionalInformation(
                //           whyOnSite: additionController.text.toString(),
                //             context: context
                //         );
                //       }
                //
                //     },
                //   )),


                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerAdditional() {
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

            // Title text placeholder
            Container(
              width: 280.w,
              height: 24.h,
              color: Colors.grey.shade300,
              margin: EdgeInsets.only(bottom: 25.h),
            ),

            // TextField container placeholder
            Container(
              width: 342.w,
              height: 107.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.only(bottom: 400.h),
            ),

            // Save and Next button placeholder
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
