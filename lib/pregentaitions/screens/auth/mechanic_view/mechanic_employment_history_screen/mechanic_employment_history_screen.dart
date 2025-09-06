import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controllers/mechanic_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../widgets/certification_custom_checkbox_list.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_linear_indicator.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/custom_phone_number_picker.dart';


class MechanicEmploymentHistoryScreen extends StatefulWidget {
  const MechanicEmploymentHistoryScreen({super.key});
  @override
  State<MechanicEmploymentHistoryScreen> createState() => _MechanicEmploymentHistoryScreenState();
}
class _MechanicEmploymentHistoryScreenState extends State<MechanicEmploymentHistoryScreen> {


  final TextEditingController reasonLeavingCtrl = TextEditingController();

  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController jobTitleCtrl = TextEditingController();
  final TextEditingController supervisorsNameCtrl = TextEditingController();
  final TextEditingController supervisorsContactCtrl = TextEditingController();

  MechanicController mechanicController = Get.put(MechanicController());
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();


  TextEditingController dateCtrl = TextEditingController();

  final Map<String, bool> workSettingCheckbox = {
    'in shop': false,
    'on site': false,
    'both': false,
  };
  final TextEditingController fromDateCtrl = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};
      final data = routeData['data'];

      if (data != null) {
        companyNameCtrl.text = data.companyName ?? '';
        jobTitleCtrl.text = data.jobName ?? '';
        supervisorsNameCtrl.text = data.supervisorsName ?? '';
        supervisorsContactCtrl.text = data.supervisorsContact ?? '';

        if (data.durationFrom != null) {
          fromDateCtrl.text = data.durationFrom is DateTime
              ? DateFormat('yyyy-MM-dd').format(data.durationFrom)
              : data.durationFrom;
        }

        if (data.durationTo != null) {
          dateCtrl.text = data.durationTo is DateTime
              ? DateFormat('yyyy-MM-dd').format(data.durationTo)
              : data.durationTo;
        }

        reasonLeavingCtrl.text = data.reason ?? '';

        if (data.platform != null) {
          workSettingCheckbox.updateAll((key, value) => false);
          final key = data.platform.toString().toLowerCase();
          if (workSettingCheckbox.containsKey(key)) {
            workSettingCheckbox[key] = true;
          }
        }
      }
      Future.delayed(Duration(milliseconds: 500), () {
                setState(() {
                  isLoading = false;
                });
              });
    });
  }


  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // final routeData = GoRouterState.of(context).extra as Map;
  //     final extra = GoRouterState.of(context).extra;
  //     final Map routeData = extra is Map ? extra : {};
  //     final data = routeData['data'];
  //
  //     if (data != null) {
  //       companyNameCtrl.text = data.companyName ?? '';
  //       jobTitleCtrl.text = data.jobName ?? '';
  //       supervisorsNameCtrl.text = data.supervisorsName ?? '';
  //       supervisorsContactCtrl.text = data.supervisorsContact ?? '';
  //
  //       if (data.durationFrom != null) {
  //         fromDateCtrl.text = data.durationFrom is DateTime
  //             ? DateFormat('yyyy-MM-dd').format(data.durationFrom)
  //             : data.durationFrom;
  //       }
  //
  //       if (data.durationTo != null) {
  //         dateCtrl.text = data.durationTo is DateTime
  //             ? DateFormat('yyyy-MM-dd').format(data.durationTo)
  //             : data.durationTo;
  //       }
  //
  //       reasonLeavingCtrl.text = data.reason ?? '';
  //
  //       if (data.platform != null) {
  //         workSettingCheckbox.updateAll((key, value) => false);
  //         final key = data.platform.toString().toLowerCase();
  //         if (workSettingCheckbox.containsKey(key)) {
  //           workSettingCheckbox[key] = true;
  //         }
  //       }
  //
  //       Future.delayed(Duration(milliseconds: 500), () {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     }
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final Map routeData = extra is Map ? extra : {};
    final bool isEdit = routeData['isEdit'] ?? false;

    // Map routeData = GoRouterState.of(context).extra as Map;
    // final bool isEdit = (GoRouterState.of(context).extra as Map)['isEdit'] ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(
          text: "Employment History",
          fontsize: 20.sp,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ),
      // appBar: CustomAppBar(
      //     title: "${routeData["title"]}"),
      body: isLoading
          ? SingleChildScrollView(child: _buildShimmerEmploymentHistory())
          :Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Form(
              key: fromKey,
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    ///<<<=============>>> LinearIndicator <<<===============>>>
                    if (!isEdit) CustomLinearIndicator(
                      progressValue: 0.4,
                    ),
                    SizedBox(height: 20.h),
                    CustomText(text: "Most recent employers",
                        fontsize: 20.sp,
                        color: AppColors.textColor151515),
                    SizedBox(height: 8.h),
                    ///<<<=============>>> Company Name Field <<<===============>>>
                    CustomText(
                        text: "Company Name:",color: AppColors.textColor151515,fontsize: 14.sp),
                    SizedBox(height: 8.h),
                    CustomTextField(controller: companyNameCtrl, hintText: "Company name"),

                    ///<<<=============>>> Job Title Field <<<===============>>>
                    CustomText(
                        text: "Job Title:",color: AppColors.textColor151515,fontsize: 14.sp),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: jobTitleCtrl,
                      hintText: "Job Title",
                    ),
                    ///<<<=============>>> Supervisors Name Field <<<===============>>>
                    CustomText(
                        text: "Supervisors Name:",color: AppColors.textColor151515,fontsize: 14.sp),
                    SizedBox(height: 8.h),
                    CustomTextField(
                        controller: supervisorsNameCtrl,
                        hintText: "Supervisors Name"),
                    ///<<<=============>>> Supervisors Contact <<<===============>>>

                    ///<<<=============>>> Phone Filed <<<===============>>>
                    CustomPhoneNumberPicker(
                      controller: supervisorsContactCtrl,
                      lebelText: 'Supervisors Contact',),
                    // CustomText(
                    //     text: "Supervisors Contact:",
                    //     color: AppColors.textColor151515,
                    //     fontsize: 14.sp,
                    //
                    // ),
                    // SizedBox(height: 8.h),
                    // CustomTextField(
                    //   controller: supervisorsContactCtrl,
                    //   hintText: "Supervisors Contact",
                    //   keyboardType: TextInputType.phone,
                    //   maxLength: 11,
                    //   inputFormatters: [
                    //     LengthLimitingTextInputFormatter(11),
                    //     FilteringTextInputFormatter.digitsOnly,
                    //   ],
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter phone number';
                    //     } else if (value.length < 11) {
                    //       return 'Phone number must be 11 digits';
                    //     } else if (value.length > 11) {
                    //       return 'Phone number cannot exceed 11 digits';
                    //     }
                    //     return null;
                    //   },
                    // ),


                    ///<<<=============>>> Employment Duration <<<===============>>>
                    CustomText(text: 'Employment Duration:',color: AppColors.textColor151515,fontsize: 14.sp),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 18.h,horizontal: 23.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                      fromDateCtrl.text = formattedDate; // or dateCtrl.text = formattedDate
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      readOnly: true,
                                      controller: fromDateCtrl,
                                      hintText: "From Date",
                                      suffixIcon: const Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.h),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      final formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                      dateCtrl.text = formattedDate;
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      readOnly: true,
                                      controller: dateCtrl,
                                      hintText: "To Date",
                                      suffixIcon: const Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///<<<=============>>> Work Setting <<<===============>>>
                    CustomText(text: 'Work Setting:',color: AppColors.textColor151515,fontsize: 14.sp),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                      child: ExperienceCustomCheckboxList(
                        items: workSettingCheckbox,
                      ),
                    ),
                    ///<<<=============>>> Reason for leaving <<<===============>>>
                    CustomText(text: 'Reason for leaving:',color: AppColors.textColor151515,fontsize: 14.sp ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 342,
                      height: 107,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textColor151515, width: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.h),
                        child: TextField(
                          controller: reasonLeavingCtrl,
                          maxLines: 5,
                          style: TextStyle(fontSize: 10.sp,color: AppColors.textColor151515),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write leaving reason...',
                            hintStyle: TextStyle(fontSize: 10.sp, color:AppColors.textColor151515),
                            isCollapsed: true,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 77.h),

                    /// ================================>>>>  Save and Next button    <<<<<<=============================>>>
                    SizedBox(height: 50.h),
                    Obx(() => Row(
                      children: [
                        if (isEdit)
                          Expanded(
                            child: CustomButton(
                              title: "Edit",
                              loading: mechanicController.employmentHistoriesLoading.value,
                              onpress: () async {
                                if (fromKey.currentState!.validate()) {
                                  String? selectedPlatform;
                                  workSettingCheckbox.forEach((key, value) {
                                    if (value) selectedPlatform = key;
                                  });

                                  final success = await mechanicController.employmentHistories(
                                    companyName: companyNameCtrl.text,
                                    jobName: jobTitleCtrl.text,
                                    supervisorsName: supervisorsNameCtrl.text,
                                    supervisorsContact: supervisorsContactCtrl.text,
                                    durationFrom: fromDateCtrl.text,
                                    durationTo: dateCtrl.text,
                                    platform: selectedPlatform,
                                    reason: reasonLeavingCtrl.text,
                                    context: context,
                                  );
                                  if (success) {
                                    context.pop(true);
                                  }
                                }
                              },
                            ),
                          ),
                        if (!isEdit)
                          Expanded(
                            child: CustomButton(
                                loading: mechanicController.employmentHistoriesLoading.value,
                                title: "Save and Next",
                                onpress: () {
                                  if (fromKey.currentState!.validate()) {
                                    String? selectedPlatform;
                                    workSettingCheckbox.forEach((key, value) {
                                      if (value) selectedPlatform = key;
                                    });
                                    mechanicController.employmentHistories(
                                      companyName: companyNameCtrl.text,
                                      jobName: jobTitleCtrl.text,
                                      supervisorsName: supervisorsNameCtrl.text,
                                      supervisorsContact: supervisorsContactCtrl.text,
                                      durationFrom: fromDateCtrl.text,
                                      durationTo: dateCtrl.text,
                                      platform: selectedPlatform,
                                      reason: reasonLeavingCtrl.text,
                                      context: context,
                                    );
                                  }

                                }

                            ),
                          ),
                      ],
                    )),
                    SizedBox(height: 70.h),

                  ],
                ),

            ),
          ),
        ),
      ),
    );
  }


  // Shimmer Effect Widget
  Widget _buildShimmerEmploymentHistory() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 16.h), // Space for AppBar

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

            // Section title placeholder: "Most recent employers"
            Container(
              height: 24.h,
              width: 180.w,
              color: Colors.grey.shade300,
              margin: EdgeInsets.only(bottom: 20.h),
            ),

            // Text field placeholders (simulate 5 fields)
            ...List.generate(5, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label placeholder
                    Container(
                      height: 14.h,
                      width: 120.w,
                      color: Colors.grey.shade300,
                      margin: EdgeInsets.only(bottom: 8.h),
                    ),
                    // Input field placeholder
                    Container(
                      height: 40.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Employment Duration title placeholder
            Container(
              height: 14.h,
              width: 150.w,
              color: Colors.grey.shade300,
              margin: EdgeInsets.only(bottom: 12.h),
            ),

            // Date pickers row placeholders
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
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Work Setting title placeholder
            Container(
              height: 14.h,
              width: 120.w,
              color: Colors.grey.shade300,
              margin: EdgeInsets.only(bottom: 12.h),
            ),

            // Checkbox list placeholder (simulate 3 checkboxes horizontally)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (_) {
                return Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 80.w,
                      height: 18.h,
                      color: Colors.grey.shade300,
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 20.h),

            // Reason for leaving title placeholder
            Container(
              height: 14.h,
              width: 160.w,
              color: Colors.grey.shade300,
              margin: EdgeInsets.only(bottom: 10.h),
            ),

            // Multiline input placeholder
            Container(
              width: double.infinity,
              height: 110.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),

            SizedBox(height: 50.h),

            // Save and Next button placeholder
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),

            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }

}

