import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_container.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/mechanic_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../services/api_constants.dart';
import '../../../../widgets/cachanetwork_image.dart';
import '../../../../widgets/custom_upload_button.dart';
import 'package:intl/intl.dart';


class MechanicProfileInformationScreen extends StatefulWidget {
   const MechanicProfileInformationScreen({super.key});

  @override
  State<MechanicProfileInformationScreen> createState() => _MechanicProfileInformationScreenState();
}

class _MechanicProfileInformationScreenState extends State<MechanicProfileInformationScreen> {

  MechanicController mechanicController = Get.put(MechanicController());


  @override
  void initState() {
    mechanicController.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CustomText(
          textAlign: TextAlign.start,
          text: "Profile Information",
          fontsize: 20.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(()=>

            Column(
              children: [
                /// ==================================> Profile ====================================>
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomNetworkImage(
                      boxShape: BoxShape.circle,
                      imageUrl:
                      mechanicController.profile.value.profileImage == null ||  mechanicController.profile.value.profileImage == "" ?
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png" :
                      "${ApiConstants.imageBaseUrl}/${mechanicController.profile.value.profileImage}",
                      height: 128.h,
                      width: 128.w,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: mechanicController.profile.value.name ?? 'N/A',
                                  fontsize: 25.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor151515,
                                ),
                              ),
                              SizedBox(width: 4.w),

                              GestureDetector(
                                onTap: () async {
                                  await mechanicController.getProfile(); // Ensure profile loaded
                                  context.pushNamed(
                                    AppRoutes.mechanicPersonalInformationScreen,
                                    extra: {
                                      "title": "Personal Information",
                                      "isEdit": true,
                                      "name": mechanicController.profile.value.name ?? '',
                                      "phone": mechanicController.profile.value.phone ?? '',
                                      "address": mechanicController.profile.value.address ?? '',
                                      "haveLicense": mechanicController.profile.value.haveLicense,
                                      "haveCdl": mechanicController.profile.value.haveCdl,
                                      "platform": mechanicController.profile.value.platform ?? '',
                                      "image": mechanicController.profile.value.profileImage != null ? "${ApiConstants.imageBaseUrl}/${mechanicController.profile.value.profileImage}": "",
                                    },
                                  ).then((_) {
                                    print('===========================================test');
                                    mechanicController.getProfile();
                                  });
                                  // if (result == true) {
                                  //   await mechanicController.getProfile();
                                  // }
                                },
                                child: Assets.icons.editIcon.svg(),
                              ),

                              // GestureDetector(
                              //   onTap: () {
                              //     print('======================================Tappppp');
                              //     context.pushNamed(AppRoutes.mechanicPersonalInformationScreen,
                              //       extra: {
                              //         "title" : "Personal Information",
                              //         "name" : mechanicController.profile.value.name ?? '',
                              //         "phone" : mechanicController.profile.value.phone ?? '',
                              //         "address": mechanicController.profile.value.address ?? '',
                              //         "haveLicense": mechanicController.profile.value.haveLicense,
                              //         "haveCdl": mechanicController.profile.value.haveCdl,
                              //         "image": mechanicController.profile.value.profileImage != null ? "${ApiConstants.imageBaseUrl}/${mechanicController.profile.value.profileImage}": "",
                              //       }
                              //     ).then((_) {
                              //       print('===========================================test');
                              //       mechanicController.getProfile();
                              //     });
                              //   },
                              //   child: Assets.icons.editIcon.svg(),
                              // ),

                            ],
                          ),
                          SizedBox(height: 4.h),
                          CustomText(text:
                            mechanicController.profile.value.role ?? 'N/A',
                            fontsize: 15.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColor151515,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                           text:  '${mechanicController.profile.value.phone ?? 'N/A'}  |  ${mechanicController.profile.value.email ?? 'N/A'}',
                            fontsize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor151515,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(text:
                            mechanicController.profile.value.address ?? 'N/A',
                           fontsize: 12.sp,
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: 'Have:',
                            fontsize: 14.sp,
                            color: AppColors.textColor151515,
                          ),
                          SizedBox(height: 4.h),
                          // Have section below address
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (mechanicController.profile.value.haveLicense == true)
                                _buildTag('License'),
                              if (mechanicController.profile.value.haveCdl == true)
                                ...[
                                  SizedBox(width: 10.w),
                                  _buildTag('CDL'),
                                ],
                              if (mechanicController.profile.value.haveLicense != true &&
                                  mechanicController.profile.value.haveCdl != true)
                                _buildTag('N/A'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                CustomContainer(
                  paddingAll: 16.h,
                  radiusAll: 8.r,
                  bordersColor: AppColors.borderColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Wrap(
                        spacing: 20.w,
                        runSpacing: 15.h,
                        children: [

                          /// ============================================> Certificate Section =================================>

                          if (mechanicController.profile.value.certifications != null &&
                              mechanicController.profile.value.certifications!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      text: 'Certificate:',
                                      fontsize: 16.sp,
                                      color: AppColors.textColor151515,
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: ()  {
                                         context.pushNamed(
                                          AppRoutes.mechanicExperienceSkillScreen,
                                          extra: {
                                            "title": "Experience and Skill",
                                            "isEdit": true,
                                            "certifications": mechanicController.profile.value.certifications ?? [],
                                            "experiences": mechanicController.profile.value.experiences ?? [],
                                          },
                                        ).then((_) {
                                          print('===========================================test');
                                            mechanicController.getProfile();
                                         });
                                      },
                                      child: Assets.icons.editIcon.svg(),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 13.h),
                                Wrap(
                                  spacing: 10.w,
                                  children: mechanicController.profile.value.certifications!
                                      .map((cert) => _buildTag(cert))
                                      .toList(),
                                ),
                              ],
                            ),

                        ],
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                          text:
                          'Comfortable working on-site (roadside, fleet yards, job sites)'),
                      SizedBox(height: 15.h),
                      /// ==================================> Experience and More ====================================>
                      CustomText(
                        text: 'Experience and More',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 10.h),
                      /// ======================================> ListView to display the experience items =============================>
                      SizedBox(
                        height: 120.h,
                        child: (mechanicController.profile.value.experiences == null ||
                            mechanicController.profile.value.experiences!.isEmpty)
                            ? Center(
                          child: Text(
                            "No experience data available",
                            style: TextStyle(fontSize: 14.sp, color: Colors.black),
                          ),
                        )
                            : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mechanicController.profile.value.experiences!.length,
                          itemBuilder: (context, index) {
                            var experience = mechanicController.profile.value.experiences![index];
                            String title = experience.experienceId?.name ?? 'N/A';
                            String location = experience.platform ?? 'N/A';
                            String duration = '${experience.time} year';
                            return _buildExperienceRow(title, location, duration);
                          },
                        ),
                      ),





                      /// ==================================> Tools and Equipment ====================================>


                      Row(
                        children: [
                          CustomText(text: 'Tools and Equipment',fontsize: 16.sp,color: AppColors.textColor151515,),
                          const Spacer(),
                          GestureDetector(
                            onTap: ()  {
                              context.pushNamed(
                                AppRoutes.mechanicToolsEquipmentScreen,
                                extra: {
                                  "title": "Tools and Equipment",
                                  "isEdit": true,
                                  "toolsGroup": mechanicController.profile.value.toolsGroup,
                                  "toolsCustom": mechanicController.profile.value.toolsCustom,
                                },
                              ).then((_) {
                                print('===========================================test');
                                mechanicController.getProfile();
                              });
                            },
                            child: Assets.icons.editIcon.svg(),
                          ),
                        ],
                      ),
                      SizedBox(height: 13.h),
                      Obx(() {
                        final toolsGroup = mechanicController.profile.value.toolsGroup;

                        if (toolsGroup == null || toolsGroup.groups.isEmpty) {
                          return const SizedBox();
                        }

                        final groupNames = toolsGroup.groups.keys.toList();

                        return ListView.builder(
                          itemCount: groupNames.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, groupIndex) {
                            final groupName = groupNames[groupIndex];
                            final tools = toolsGroup.groups[groupName]!;

                            if (groupIndex == groupNames.length - 1) {
                            final toolsCustom = mechanicController.profile.value.toolsCustom;
                            if (toolsCustom != null) {
                            tools.addAll(toolsCustom);
                            }}

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: groupName,
                                  fontWeight: FontWeight.bold,
                                  fontsize: 16.sp,
                                ),
                                SizedBox(height: 8.h),
                                ListView.builder(
                                  itemCount: tools.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, toolIndex) {
                                    final tool = tools[toolIndex];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 6.h),
                                      child: CustomText(
                                        textAlign: TextAlign.start,
                                        text: '- $tool',
                                        fontsize: 12.sp,
                                      ),

                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                              ],
                            );
                          },
                        );
                      }),

                      SizedBox(height: 15.h),

                      /// ==================================> Employment History ====================================>

                      ListView.builder(
                        itemCount: mechanicController.profile.value.employmentHistories?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final history = mechanicController.profile.value.employmentHistories![index];

                          final fromDate = DateFormat('dd MMM yyyy').format(DateTime.parse('${history.durationFrom}'));
                          final toDate = DateFormat('dd MMM yyyy').format(DateTime.parse('${history.durationTo}'));

                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      textAlign: TextAlign.start,
                                      text: history.companyName ?? 'N/A',
                                      fontWeight: FontWeight.bold,
                                      fontsize: 18.sp,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                          context.pushNamed(
                                          AppRoutes.mechanicEmploymentHistoryScreen,
                                          extra: {
                                            "title": "Employment History",
                                            "isEdit": true,
                                            "data": mechanicController.profile.value.employmentHistories?[index],
                                          },
                                        ).then((_) {
                                          print('===========================================test');
                                          mechanicController.getProfile();
                                        });
                                      },
                                      child: Assets.icons.editIcon.svg(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      textAlign: TextAlign.start,
                                      text: '${history.jobName}, ',
                                      fontsize: 10.sp,
                                    ),
                                    CustomText(
                                      textAlign: TextAlign.start,
                                      text: '${history.platform}',
                                      fontsize: 10.sp,
                                    ),
                                  ],
                                ),
                                CustomText(
                                  textAlign: TextAlign.start,
                                  text: history.supervisorsName ?? 'N/A',
                                  fontsize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  textAlign: TextAlign.start,
                                  text: '${history.supervisorsContact ?? 'N/A'}'
                                      '\n$fromDate to $toDate'
                                      '\n${history.reason}',
                                  fontsize: 10.sp,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15.h),

                      /// ==================================> Reference =============================================>
                      ListView.builder(
                        itemCount: mechanicController.profile.value.references?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final reference = mechanicController.profile.value.references![index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: 'Reference ${index + 1}',
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    if (index == 0)
                                      GestureDetector(
                                        onTap: () async {
                                          await context
                                              .pushNamed(
                                            AppRoutes.mechanicReferenceScreen,
                                            extra: {
                                              "title": "Reference",
                                              "isEdit": true,
                                              "data": mechanicController.profile.value.references,
                                            },
                                          )
                                              .then((_) => mechanicController.getProfile());
                                        },
                                        child: Assets.icons.editIcon.svg(),
                                      ),
                                  ],
                                ),
                                CustomText(
                                  textAlign: TextAlign.start,
                                  text: reference.name ?? 'N/A',
                                  fontsize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  textAlign: TextAlign.start,
                                  text: '${reference.phone ?? 'N/A'}\n${reference.relation ?? 'N/A'}',
                                  fontsize: 10.sp,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // ListView.builder(
                      //   itemCount: mechanicController.profile.value.references?.length ?? 0,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     final reference = mechanicController.profile.value.references![index];
                      //     return Padding(
                      //       padding: EdgeInsets.only(bottom: 15.h),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               CustomText(
                      //                 text: 'Reference ${index + 1}',
                      //                 fontsize: 16.sp,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //               GestureDetector(
                      //                 onTap: () async {
                      //                    await context.pushNamed(
                      //                     AppRoutes.mechanicReferenceScreen,
                      //                     extra: {
                      //                       "title": "Reference",
                      //                       "isEdit": true,
                      //                       "data": reference,
                      //
                      //                     },
                      //                   ).then((_) {
                      //                     print('===========================================test');
                      //                     mechanicController.getProfile();
                      //                   });
                      //
                      //                 },
                      //                 child: Assets.icons.editIcon.svg(),
                      //               ),
                      //             ],
                      //           ),
                      //           CustomText(
                      //             textAlign: TextAlign.start,
                      //             text: reference.name ?? 'N/A',
                      //             fontsize: 18.sp,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //           CustomText(
                      //             textAlign: TextAlign.start,
                      //             text: '${reference.phone ?? 'N/A'}\n${reference.relation ?? 'N/A'}',
                      //             fontsize: 10.sp,
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      SizedBox(height: 15.h),

                      /// ==========================================> Additional Information ==================================>
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {
                            context.pushNamed(
                              AppRoutes.mechanicAdditionalInformationScreen,
                              extra: {
                                "title": "Additional Information",
                                "isEdit": true,
                                "data": mechanicController.profile.value.whyOnSite,

                              },
                            ).then((_) {
                              print('===========================================test');
                              mechanicController.getProfile();
                            });

                          },
                          child: Assets.icons.editIcon.svg(),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomText(
                        textAlign: TextAlign.start,
                        maxline: 2,
                        text: 'Why do I want to work at On-Site Fleet Services?',
                        color: AppColors.textColor151515,fontsize: 18.sp),
                      SizedBox(height: 10.h),
                      CustomText(
                        textAlign: TextAlign.start,
                          maxline: 10,
                          text: mechanicController.profile.value.whyOnSite ?? 'N/A',
                          fontsize: 10.sp,
                          color: AppColors.textColor151515),
                      SizedBox(height: 50.h),

                      /// ================================> Pdf Button ==============================================>

                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {
                          context.pushNamed(
                              AppRoutes.mechanicResumeCertificateScreen,
                              extra: {
                                "title": "Resume and Certificate",
                                "isEdit": true,
                              },
                            ).then((_) {
                              print('===========================================test');
                              mechanicController.getProfile();
                            });
                          },
                          child: Assets.icons.editIcon.svg(),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomUploadButton(
                        title: mechanicController.profile.value.resume != null && mechanicController.profile.value.resume!.isNotEmpty
                            ? 'Resume.pdf'
                            : 'Upload resume',
                        onTap: () {},
                        showUploadIcon: false,
                      ),

                      SizedBox(height: 12.h),
                      CustomUploadButton(
                        title: mechanicController.profile.value.certificate != null && mechanicController.profile.value.certificate!.isNotEmpty
                        ? 'Certificate .pdf'
                        : 'Upload certificate',
                        onTap: () {},
                        showUploadIcon: false,
                      ),

                      /// ==============================================> Go to Home Button ============================================>

                      SizedBox(height: 16.h),
                      CustomButton(
                        title: "Go To Home Screen",
                        onpress: () {
                          context.pushNamed(AppRoutes.mechanicBottomNavBar);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }





  String getFileName(String? path) {
    if (path == null || path.trim().isEmpty) return 'Not uploaded';
    path = path.replaceAll('\\', '/');
    return path.split('/').last;
  }


  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.borderColorE6E6FF,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: text,
        fontsize: 12.sp,
        color: AppColors.textColor151515,
      ),
    );
  }


  Widget _buildExperienceRow(String title, String location, String duration) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              location,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textColor151515),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              duration,
              style: TextStyle(fontSize: 13.sp, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }


}
