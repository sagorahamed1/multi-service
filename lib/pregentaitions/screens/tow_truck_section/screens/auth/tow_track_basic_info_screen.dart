import 'dart:io';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
import 'package:autorevive/pregentaitions/widgets/custom_phone_number_picker.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../controllers/mechanic_controller.dart';
import '../../../../../controllers/towTrack/registration_tow_track_controller.dart';
import '../../../../../controllers/upload_controller.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../helpers/toast_message_helper.dart';
import '../../../../widgets/cachanetwork_image.dart';

class TowTrackBasicInfoScreen extends StatefulWidget {
  const TowTrackBasicInfoScreen({super.key});

  @override
  State<TowTrackBasicInfoScreen> createState() => _TowTrackBasicInfoScreenState();
}

class _TowTrackBasicInfoScreenState extends State<TowTrackBasicInfoScreen> {

  UploadController uploadController = Get.put(UploadController());
  TowTrackController towTrackController = Get.put(TowTrackController());


  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _lLCTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    towTrackController.getTowTrackProfile().then((_) {
      final profile = towTrackController.trackProfile.value;
      // _nameTEController.text = profile.name ?? '';
      _emailTEController.text = profile.email ?? '';


      WidgetsBinding.instance.addPostFrameCallback((_) {

        final extra = GoRouterState.of(context).extra;
        final Map routeData = extra is Map ? extra : {};
            // _nameTEController.text = routeData['name'] ?? '';
            _nameTEController.text = routeData['name'] ?? profile.name ?? '';
            _phoneTEController.text = routeData['phone'] ?? '';
            _addressTEController.text = routeData['address'] ?? '';
            _lLCTEController.text = routeData['llc'] ?? '';
            _priceTEController.text = routeData['ppm']?.toString() ?? '';
            uploadedUrl = routeData['image'] ?? '';

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
    return CustomScaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: false,
          title: CustomText(
            text: "Basic Info...",
            fontsize: 20.sp,
          )),
      body:
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:isLoading
              ? Column(
            children: List.generate(2, (_) => _buildShimmerProfile()),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              CustomTextField(
                controller: _nameTEController,
                labelText: 'Full Name',
                hintText: 'name',
              ),


              CustomTextField(
                controller: _addressTEController,
                labelText: 'Business Address',
                hintText: 'USA, New York',
              ),


              CustomTextField(
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
                controller: _emailTEController,
                labelText: 'Email',
                hintText: 'email',
              ),


              CustomTextField(
                keyboardType: TextInputType.number,
                controller: _priceTEController,
                labelText: 'Price Per Mile',
                hintText: 'price',
              ),



              /// ++++++++++++++++++++++  phone number  ==================>
              CustomPhoneNumberPicker(controller: _phoneTEController, lebelText: 'Phone No.',),


              CustomTextField(
                controller: _lLCTEController,
                labelText: 'Partner with LLC for Reliable Towing Service',
                hintText: 'David William LLC',
              ),

              SizedBox(height: 44.h),


              Obx(()=>
              CustomButton(
                    loading: towTrackController.basicInfoLoading.value,
                    title:  isEdit ? "Edit" : "Save and Next",
                       onpress: () async {
                                if(_formKey.currentState!.validate()) {
                                  final int? ppm = int.tryParse(_priceTEController.text);
                                  final success = await towTrackController.towTrackBasicInfo(
                                    profileImage: uploadedUrl,
                                      address: _addressTEController.text,
                                      phone: _phoneTEController.text,
                                      ppm: ppm,
                                      llc: _lLCTEController.text,
                                      name: _nameTEController.text,
                                      context: context);
                                  if (success) {
                                    if (isEdit) {
                                      context.pop(true);
                                    } else {
                                      context.pushNamed(AppRoutes.companyInformationScreen);
                                    }
                                  }
                                } return;


                              })),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: kToolbarHeight + 20.h), // space for appbar

            // Profile Image Shimmer
            Center(
              child: Container(
                width: 104.w,
                height: 104.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // Name field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Business Address field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Email field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Price Per Mile field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // Phone Number field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),

            // LLC field shimmer
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Checkbox placeholders row 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 150.w,
                  height: 20.h,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Checkbox placeholders row 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 100.w,
                  height: 20.h,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            SizedBox(height: 40.h),

            // Save and Next button placeholder
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





/// ==================================> ShowImagePickerOption Function <===============================

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
        ToastMessageHelper.showToastMessage("File upload failed.",title: 'Attention');
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
