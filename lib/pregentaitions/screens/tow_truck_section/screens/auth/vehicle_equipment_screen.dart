import 'dart:io';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_container.dart';
import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
import 'package:autorevive/pregentaitions/widgets/custom_popup_menu.dart';
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
import '../../../../../core/constants/app_colors.dart';
import '../../../../../helpers/toast_message_helper.dart';
import '../../../../../models/car_model.dart';

class VehicleEquipmentScreen extends StatefulWidget {
  const VehicleEquipmentScreen({super.key});

  @override
  State<VehicleEquipmentScreen> createState() => _VehicleEquipmentScreenState();
}

class VehicleEntry {
  final TextEditingController makingYearController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelNumberController = TextEditingController();
  final TextEditingController vehicleWeightController = TextEditingController();
  final TextEditingController towTruckTypeController = TextEditingController();
  RxString videoUrl = ''.obs;

  void dispose() {
    makingYearController.dispose();
    manufacturerController.dispose();
    modelNumberController.dispose();
    vehicleWeightController.dispose();
    towTruckTypeController.dispose();
  }
}

class _VehicleEquipmentScreenState extends State<VehicleEquipmentScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  TowTrackController towTrackController = Get.put(TowTrackController());
  UploadController uploadController = Get.put(UploadController());

  final List<VehicleEntry> vehicleEntries = [VehicleEntry()];

  final List<CarModel> typeTrack = [
    CarModel(id: '1', adminId: 'admin123', name: 'flatbed', v: 0),
    CarModel(id: '2', adminId: 'admin123', name: 'wrecker', v: 0),
    CarModel(id: '3', adminId: 'admin456', name: 'heavy-duty', v: 0),
    CarModel(id: '4', adminId: 'admin456', name: 'medium-duty', v: 0),
    CarModel(id: '5', adminId: 'admin456', name: 'light-duty', v: 0),
    CarModel(id: '6', adminId: 'admin456', name: 'other', v: 0),
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};

      if (routeData['isEdit'] == true && routeData['vehicles'] != null) {
        final List vehiclesData = routeData['vehicles'];
        vehicleEntries.clear();
        for (var vehicle in vehiclesData) {
          final entry = VehicleEntry();
          entry.makingYearController.text = vehicle['year']?.toString() ?? '';
          entry.manufacturerController.text = vehicle['brand'] ?? '';
          entry.modelNumberController.text = vehicle['modelNo'] ?? '';
          entry.vehicleWeightController.text = vehicle['gvwr']?.toString() ?? '';
          entry.towTruckTypeController.text = vehicle['type'] ?? '';
          entry.videoUrl.value = vehicle['video'] ?? '';
          vehicleEntries.add(entry);
        }
      }
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            isLoading = false;
          });
        });
      towTrackController.getTowTrackProfile();
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final extra = GoRouterState.of(context).extra;
    //   final Map routeData = extra is Map ? extra : {};
    //
    //   // If editing and have existing data, fill the first entry
    //   if (routeData.isNotEmpty && routeData['isEdit'] == true) {
    //     final data = routeData;
    //
    //     final VehicleEntry entry = vehicleEntries.first;
    //
    //     entry.makingYearController.text = data['year']?.toString() ?? '';
    //     entry.manufacturerController.text = data['brand'] ?? '';
    //     entry.modelNumberController.text = data['modelNo'] ?? '';
    //     entry.vehicleWeightController.text = data['gvwr']?.toString() ?? '';
    //     entry.towTruckTypeController.text = data['type'] ?? '';
    //     entry.videoUrl.value = data['video'] ?? '';
    //   }
    //
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   });
    //
    //   towTrackController.getTowTrackProfile();
    // });
  }

  @override
  void dispose() {
    for (var entry in vehicleEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void addVehicleEntry() {
    setState(() {
      vehicleEntries.add(VehicleEntry());
    });
  }

  void removeVehicleEntry(int index) {
    if (vehicleEntries.length <= 1) return; // At least one entry
    setState(() {
      vehicleEntries[index].dispose();
      vehicleEntries.removeAt(index);
    });
  }

  Future<void> importVideo(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedFile = File(result.files.single.path!);
      String? uploadedPath = await uploadController.uploadFile(file: selectedFile);
      if (uploadedPath != null) {
        vehicleEntries[index].videoUrl.value = uploadedPath;
      }
    } else {
      ToastMessageHelper.showToastMessage("No file selected.");
    }
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
            text: "Vehicle and Equipment Verification",
            fontsize: 20.sp,
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: isLoading
              ? Column(
            children: List.generate(2, (_) => _buildShimmerVehicle()),
          )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEdit) CustomLinearIndicator(progressValue: 0.3),
                SizedBox(height: 24.h),
                CustomText(
                  text: 'List of all tow trucks in your fleet.',
                  bottom: 6.h,
                ),

                ...List.generate(vehicleEntries.length, (index) {
                  final entry = vehicleEntries[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: _buildVehicleEntryForm(entry, index),
                  );
                }),

                GestureDetector(
                  onTap: addVehicleEntry,
                  child: CustomContainer(
                    bordersColor: AppColors.primaryColor,
                    radiusAll: 8.r,
                    width: double.infinity,
                    height: 108.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primaryColor, size: 32.r),
                        CustomText(text: 'Add more', top: 10.h),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 44.h),

                Obx(() => CustomButton(
                  loading: towTrackController.vehiclesEquipmentLoading.value,
                  title: isEdit ? "Edit" : "Save and Next",
                  onpress: () async {
                    if (_globalKey.currentState!.validate()) {
                      // Validate all entries
                      for (var entry in vehicleEntries) {
                        if (entry.videoUrl.value.isEmpty) {
                          ToastMessageHelper.showToastMessage(
                              "Please upload tow truck video for all entries",
                              title: 'Attention');
                          return;
                        }
                      }

                      // Collect all entries data
                      final success = await towTrackController.vehiclesEquipmentMultiple(
                        vehicles: vehicleEntries.map((entry) {
                          final int? gvwr = int.tryParse(entry.vehicleWeightController.text.trim());
                          final int? year = int.tryParse(entry.makingYearController.text.trim());
                          return {
                            'year': year,
                            'brand': entry.manufacturerController.text.trim(),
                            'modelNo': entry.modelNumberController.text.trim(),
                            'gvwr': gvwr,
                            'type': entry.towTruckTypeController.text.trim(),
                            'video': entry.videoUrl.value,
                          };
                        }).toList(),
                        context: context,
                      );

                      if (success) {
                        if (isEdit) {
                          context.pop(true);
                        } else {
                          context.pushNamed(AppRoutes.serviceCoverageScreen);
                        }
                      }
                    }
                  },
                )),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleEntryForm(VehicleEntry entry, int index) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vehicleEntries.length > 1)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => removeVehicleEntry(index),
                child: Icon(Icons.close, color: Colors.red, size: 24.r),
              ),
            ),
          CustomTextField(
            keyboardType: TextInputType.number,
            controller: entry.makingYearController,
            labelText: 'Making of the year',
            hintText: 'Making of the year',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter year';
              if (value.length != 4) return 'Year must be 4 digits';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: entry.manufacturerController,
            labelText: 'Brand of manufacturer',
            hintText: 'Brand of manufacturer',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter manufacturer';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: entry.modelNumberController,
            labelText: 'Model number of truck',
            hintText: 'Model number of truck',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter model number';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            keyboardType: TextInputType.number,
            controller: entry.vehicleWeightController,
            labelText: 'Gross Vehicle Weight Rating (GVWR)',
            hintText: 'Gross Vehicle Weight Rating (GVWR)',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter GVWR';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            readOnly: true,
            controller: entry.towTruckTypeController,
            labelText: 'Type of tow truck',
            hintText: 'Type of tow truck',
            suffixIcon: CustomPopupMenu(
              items: typeTrack,
              onSelected: (p0) {
                final selectCarThis = typeTrack.firstWhere((x) => x.id == p0);
                setState(() {
                  entry.towTruckTypeController.text = selectCarThis.name!;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please select tow truck type';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Obx(() => CustomUploadButton(
            topLabel: 'Upload walk around video of your tow truck',
            title: entry.videoUrl.value.isEmpty ? 'towtruck.mp4' : 'Video Uploaded',
            icon: Icons.upload,
            onTap: () => importVideo(index),
          )),
        ],
      ),
    );
  }

  Widget _buildShimmerVehicle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 20.h), // space for appbar

            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 40.h),
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





















// import 'dart:io';
// import 'package:autorevive/core/constants/app_colors.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_container.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_popup_menu.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
// import 'package:autorevive/pregentaitions/widgets/custom_upload_button.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../../controllers/towTrack/registration_tow_track_controller.dart';
// import '../../../../../controllers/upload_controller.dart';
// import '../../../../../core/config/app_routes/app_routes.dart';
// import '../../../../../helpers/toast_message_helper.dart';
// import '../../../../../models/car_model.dart';
//
// class VehicleEquipmentScreen extends StatefulWidget {
//   const VehicleEquipmentScreen({super.key});
//
//   @override
//   State<VehicleEquipmentScreen> createState() => _VehicleEquipmentScreenState();
// }
//
// class _VehicleEquipmentScreenState extends State<VehicleEquipmentScreen> {
//
//   final TextEditingController _makingYearTEController = TextEditingController();
//   final TextEditingController _manufacturerTEController = TextEditingController();
//   final TextEditingController _modelNumberTEController = TextEditingController();
//   final TextEditingController _vehicleWeightTEController = TextEditingController();
//   final TextEditingController _typeTowTruckTEController = TextEditingController();
//   final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
//
//   TowTrackController towTrackController = Get.put(TowTrackController());
//   UploadController uploadController = Get.put(UploadController());
//
//   RxString videoUrl = ''.obs;
//
//   final List<CarModel> typeTrack =  [
//     CarModel(id: '1', adminId: 'admin123', name: 'flatbed', v: 0),
//     CarModel(id: '2', adminId: 'admin123', name: 'wrecker', v: 0),
//     CarModel(id: '3', adminId: 'admin456', name: 'heavy-duty', v: 0),
//     CarModel(id: '4', adminId: 'admin456', name: 'medium-duty', v: 0),
//     CarModel(id: '5', adminId: 'admin456', name: 'light-duty', v: 0),
//     CarModel(id: '6', adminId: 'admin456', name: 'other', v: 0),
//   ];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final extra = GoRouterState.of(context).extra;
//       final Map routeData = extra is Map ? extra : {};
//
//       _makingYearTEController.text = routeData['year']?.toString() ?? '';
//       _manufacturerTEController.text = routeData['brand'] ?? '';
//       _modelNumberTEController.text = routeData['modelNo'] ?? '';
//       _vehicleWeightTEController.text = routeData['gvwr']?.toString() ?? '';
//       _typeTowTruckTEController.text = routeData['type'] ?? '';
//       videoUrl.value = routeData['video'] ?? '';
//
//       Future.delayed(const Duration(milliseconds: 500), () {
//         setState(() {
//           isLoading = false;
//         });
//       });
//
//
//     });
//     towTrackController.getTowTrackProfile();
//   }
//
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final extra = GoRouterState.of(context).extra;
//     final Map routeData = extra is Map ? extra : {};
//     final bool isEdit = routeData['isEdit'] ?? false;
//     return CustomScaffold(
//       appBar: AppBar(
//           centerTitle: false,
//           title: CustomText(
//             text: "Vehicle and Equipment Verification",
//             fontsize: 20.sp,
//           )),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _globalKey,
//           child: isLoading
//               ? Column(
//             children: List.generate(2, (_) => _buildShimmerVehicle()),
//           ) : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CustomLinearIndicator(
//                 progressValue: 0.3,
//               ),
//               SizedBox(height: 24.h),
//               CustomText(
//                 text: 'List of all tow trucks in your fleet.',
//                 bottom: 6.h,
//               ),
//               CustomTextField(
//                 keyboardType: TextInputType.number,
//                 controller: _makingYearTEController,
//                 labelText: 'Making of the year..',
//                 hintText: 'Making of the year..',
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(4),
//                 ],
//               ),
//               CustomTextField(
//                 controller: _manufacturerTEController,
//                 labelText: 'The brand of manufacturer..',
//                 hintText: 'The brand of manufacturer..',
//               ),
//               CustomTextField(
//                 controller: _modelNumberTEController,
//                 labelText: 'Model number of truck..',
//                 hintText: 'Model number of truck..',
//               ),
//               CustomTextField(
//                 keyboardType: TextInputType.number,
//                 controller: _vehicleWeightTEController,
//                 labelText: 'Gross Vehicle Weight Rating (GVWR)',
//                 hintText: 'Gross Vehicle Weight Rating (GVWR)',
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(9),
//                 ],
//
//               ),
//         /// ===========================================> Type of Tow track ===================================>
//               CustomTextField(
//                 readOnly: true,
//                 controller: _typeTowTruckTEController,
//                 labelText: 'Type of tow truck',
//                 hintText: 'Type of tow truck',
//                 suffixIcon: CustomPopupMenu(
//                   items: typeTrack,
//                     onSelected: (p0) {
//                       final selectCarThis = typeTrack.firstWhere((x) => x.id == p0);
//                       _typeTowTruckTEController.text = selectCarThis.name!;
//                       setState(() {
//
//                       });
//                     }
//                 ),
//               ),
//
//               /// ======================================> Upload Video ==================================>
//               CustomUploadButton(
//                 topLabel: 'Upload walk around video of your tow truck',
//                 title: 'towtruck.mp4',
//                 icon: Icons.upload,
//                 onTap: () => importPdf(isTruckVideo: true),
//               ),
//               SizedBox(height: 16.h),
//
//               /// ++++++++++++++  Add more field ************************
//               CustomContainer(
//                 onTap: () {},
//                 bordersColor: AppColors.pdfButtonColor,
//                 radiusAll: 8.r,
//                 width: double.infinity,
//                 height: 108.h,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.add,
//                       color: AppColors.primaryColor,
//                       size: 32.r,
//                     ),
//                     CustomText(text: 'Add more', top: 10.h),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 44.h),
//               Obx(()=>
//                 CustomButton(
//                   loading: towTrackController.vehiclesEquipmentLoading.value,
//                     title:  isEdit ? "Edit" : "Save and Next",
//                     onpress: () async{
//                       if(_globalKey.currentState!.validate()){
//                         final int? gvwr = int.tryParse(_vehicleWeightTEController.text.trim());
//                         final int? year = int.tryParse(_makingYearTEController.text.trim());
//
//                         if (videoUrl.value.isEmpty) {
//                           ToastMessageHelper.showToastMessage("Please upload tow track video", title: 'Attention');
//                         }
//                         final success = await  towTrackController.vehiclesEquipment(
//                             year: year,
//                             brand: _manufacturerTEController.text.trim(),
//                             modelNo: _modelNumberTEController.text.trim(),
//                             gvwr: gvwr,
//                             type: _typeTowTruckTEController.text.trim(),
//                             video: videoUrl.value,
//                             context: context);
//                         if (success) {
//                           isEdit
//                               ? context.pop(true)
//                               :  context.pushNamed(AppRoutes.serviceCoverageScreen);
//                         }
//
//                       }
//
//                     }),),
//               SizedBox(height: 24.h),
//             ],
//           ),
//         ),
//       ),
//     );
//
//   }
//
//   Widget _buildShimmerVehicle() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: kToolbarHeight + 20.h), // space for appbar
//
//             // Company Name field shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Owner / Manager Name field shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Business Phone Number picker shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Business Email Address field shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Company Address field shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Website URL field shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Years in Business field shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 15.h),
//
//             // Number of Tow Trucks and EIN number row shimmer
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50.h,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16.w),
//                 Container(
//                   width: 134.w,
//                   height: 50.h,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 40.h),
//
//             // Save and Next button shimmer
//             Container(
//               width: double.infinity,
//               height: 50.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//             ),
//             SizedBox(height: 80.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Future<void> importPdf({required bool isTruckVideo}) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null && result.files.isNotEmpty) {
//       File selectedFile = File(result.files.single.path!);
//       String? uploadedPath = await uploadController.uploadFile(file: selectedFile);
//       if (uploadedPath != null) {
//         if (isTruckVideo) {
//           videoUrl.value = uploadedPath;
//         }
//       }
//     } else {
//       ToastMessageHelper.showToastMessage("No file selected.");
//     }
//   }
//
//
// }
