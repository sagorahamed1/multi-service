import 'dart:io';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controllers/mechanic_controller.dart';
import '../../../../../controllers/upload_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../helpers/toast_message_helper.dart';
import '../../../../../models/car_model.dart';
import '../../../../widgets/CustomChecked.dart';
import '../../../../widgets/cachanetwork_image.dart';
import '../../../../widgets/custom_linear_indicator.dart';
import '../../../../widgets/custom_phone_number_picker.dart';
import '../../../../widgets/custom_popup_menu.dart';

class MechanicPersonalInformationScreen extends StatefulWidget {
  const MechanicPersonalInformationScreen({super.key});
  @override
  State<MechanicPersonalInformationScreen> createState() => _MechanicPersonalInformationScreenState();
}
class _MechanicPersonalInformationScreenState extends State<MechanicPersonalInformationScreen> {


  UploadController uploadController = Get.put(UploadController());
  MechanicController mechanicController = Get.put(MechanicController());

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController platformCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneNoCtrl = TextEditingController();
  final TextEditingController currentAddressCtrl = TextEditingController();

  bool hasDriversLicense = false;
  bool hasCDL = false;

  bool isEditMode = false;

  final List<CarModel> platForm =  [
    CarModel(id: '1', adminId: 'admin123', name: 'in shop', v: 0),
    CarModel(id: '2', adminId: 'admin123', name: 'on site', v: 0),
    CarModel(id: '3', adminId: 'admin456', name: 'both', v: 0),
  ];

  bool isLoading = true;

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    mechanicController.getProfile().then((_) {
      final profile = mechanicController.profile.value;
      // fullNameCtrl.text = profile.name ?? '';
      emailCtrl.text = profile.email ?? '';


      WidgetsBinding.instance.addPostFrameCallback((_) {
        // final routeData = GoRouterState.of(context).extra as Map;

        final extra = GoRouterState.of(context).extra;
        final Map routeData = extra is Map ? extra : {};

        // fullNameCtrl.text = routeData['name'] ?? '';
        fullNameCtrl.text = routeData['name'] ?? profile.name ?? '';
        phoneNoCtrl.text = routeData['phone'] ?? '';
        currentAddressCtrl.text = routeData['address'] ?? '';
        platformCtrl.text = routeData['platform'] ?? '';
        hasDriversLicense = routeData['haveLicense'] ?? false;
        hasCDL = routeData['haveCdl'] ?? false;
        uploadedUrl = routeData['image'] ?? '';
        print("Received gfjhhg Image: ${routeData['image']}");
        setState(() {
          isLoading = false;
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final Map routeData = extra is Map ? extra : {};
    final bool isEdit = routeData['isEdit'] ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(
          text: "Personal Information",
          fontsize: 20.sp,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child:   isLoading
              ? Column(
            children: List.generate(4, (_) => _buildShimmerProfile()),
          )

              :Obx(()=>
           Form(
             key: fromKey,
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  ///<<<=============>>> LinearIndicator <<<===============>>>
                  if (!isEdit) CustomLinearIndicator(
                    progressValue: 0.03,
                    label: 0,
                  ),
                  SizedBox(height: 30.h),
                  /// <<<=============>>> Image and camera upload section <<<=============>>>
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showImagePickerOption(context);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// ================================================>  Profile image with border ===============================================>
                          Container(
                            width: 104.w,
                            height: 104.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 3,
                              ),
                            ),
                            child: selectedImage != null
                                ? ClipOval(child: Image.file(selectedImage!, fit: BoxFit.cover))
                                : CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                              height: 128.h,
                              width: 128.w,
                            ),
                          ),
                          /// <<<<=========================>>>> Camera icon on top of the image <<<=======================================>>
                          Positioned(
                            top: 67.h,
                            left: 42.w,
                            child: Container(
                              width: 26.58.w,
                              height: 26.58.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color:AppColors.fontColorFFFFFF,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  ///<<<=============>>> Name Filed <<<===============>>>
                  CustomTextField(
                    // readOnly: !isEdit,
                    hintText: 'name',
                      controller: fullNameCtrl,
                      labelText: "Full Name"),

                  ///<<<=============>>> Platform Filed <<<===============>>>

                  CustomTextField(
                    labelText: "Platform",
                    readOnly: true,
                    hintText: 'platform',
                    controller: platformCtrl,
                    suffixIcon: CustomPopupMenu(
                        items: platForm,
                        onSelected: (p0) {
                          final selectCarThis = platForm.firstWhere((x) => x.id == p0);
                          platformCtrl.text = selectCarThis.name!;
                          setState(() {

                          });
                        }),
                  ),



                  ///<<<=============>>> Email Failed <<<===============>>>

                  CustomTextField(
                    readOnly: true,
                      controller: emailCtrl,
                      hintText: "${mechanicController.profile.value.email}",
                      labelText: "Email",
                      // prefixIcon: Assets.icons.mail.svg(),
                      isEmail: true),


                  ///<<<=============>>> Phone Filed <<<===============>>>
                  CustomPhoneNumberPicker(
                    controller: phoneNoCtrl,
                    lebelText: 'Phone No.',),
                  SizedBox(height: 11.h),

                  ///<<<=============>>> Address Filed <<<===============>>>

                  CustomTextField(
                    controller: currentAddressCtrl,
                    hintText: "Enter Current Address",
                    labelText: "Current Address",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 19.h),
                  ///<<<=============>>> Checked <<<===============>>>
                  CustomText(text: 'Do you have a valid driver’s license?'),
                  CustomChecked(
                    selected: hasDriversLicense,
                    onChanged: (val) {
                      setState(() {
                        hasDriversLicense  = val!;
                      });
                    },
                  ),
                  SizedBox(height: 11.h),
                  CustomText(text: 'Do you have a CDL?'),
                  CustomChecked(
                    selected: hasCDL,
                    onChanged: (val) {
                      setState(() {
                        hasCDL = val!;
                      });
                    },
                  ),
                  SizedBox(height: 31.h),

                  /// ================================>>>>  Save and Next button    <<<<<<=============================>>>



                  Obx(() => CustomButton(
                    loading: mechanicController.basicInfoLoading.value,
                    title: isEdit ? "Edit" : "Save and Next",
                    onpress: () async {
                      if (fromKey.currentState!.validate()) {
                        final success = await mechanicController.mechanicBasicInfo(
                          profileImage: uploadedUrl,
                          name: fullNameCtrl.text,
                          platform: platformCtrl.text.trim().toLowerCase(),
                          phone: phoneNoCtrl.text,
                          address: currentAddressCtrl.text,
                          haveLicense: hasDriversLicense,
                          haveCdl: hasCDL,
                          context: context,
                        );
                        if (success) {
                          if (isEdit) {
                            context.pop(true);
                          } else {
                            context.pushNamed(AppRoutes.mechanicExperienceSkillScreen);
                          }
                        }
                      }
                    },
                  )),

                  // Obx(()=>
                  //     CustomButton(
                  //       loading: mechanicController.basicInfoLoading.value,
                  //       title: "Save and Next",
                  //       onpress: () {
                  //         if (fromKey.currentState!.validate()) {
                  //           mechanicController.mechanicBasicInfo(
                  //               profileImage: uploadedUrl,
                  //               platform: platformCtrl.text.trim().toLowerCase(),
                  //               phone: phoneNoCtrl.text,
                  //               address: currentAddressCtrl.text,
                  //               haveLicense: hasDriversLicense,
                  //               haveCdl: hasCDL,
                  //               context: context,
                  //           );
                  //         } else {
                  //           ToastMessageHelper.showToastMessage("Please fill all required fields");
                  //         }
                  //       },
                  //     ),),
                  SizedBox(height: 80.h),
                ],
              ),
           ),
          ),
        ),
      ),
    );
  }



  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image Shimmer
          Center(
            child: Container(
              width: 104.w,
              height: 104.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Name field shimmer
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 15.h),

          // Platform field shimmer
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 15.h),

          // Email field shimmer
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 15.h),

          // Phone field shimmer
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 15.h),

          // Address field shimmer
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 15.h),

          // Checkbox placeholders (driver license, CDL)
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 150.w,
                height: 20.h,
                color: Colors.grey[300],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 100.w,
                height: 20.h,
                color: Colors.grey[300],
              ),
            ],
          ),
          SizedBox(height: 40.h),

          // Button shimmer
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }




//==================================> ShowImagePickerOption Function <===============================

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        elevation: 3,
        context: context,
        builder: (builder) {
          return Container(
            decoration: BoxDecoration(
              border: const Border(top: BorderSide(color: AppColors.primaryColor, width: 0.25)),
              borderRadius: BorderRadius.circular(20.r),

            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 9.2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _pickImageFromGallery();
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 50.w,
                              ),
                              CustomText(text: 'Gallery')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 50.w,
                              ),
                              CustomText(text: 'Camera')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }


  File? selectedImage;
  String? uploadedUrl;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String? path = await uploadController.uploadFile(file: file);
      if (path != null) {
        setState(() {
          selectedImage = file;
          uploadedUrl = path;
        });
      } else {
        ToastMessageHelper.showToastMessage("File upload failed.");
      }
      Navigator.pop(context);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String? path = await uploadController.uploadFile(file: file);
      if (path != null) {
        setState(() {
          selectedImage = file;
          uploadedUrl = path;
        });
      } else {
        ToastMessageHelper.showToastMessage("File upload failed.");
      }
      Navigator.pop(context);
    }
  }




}

