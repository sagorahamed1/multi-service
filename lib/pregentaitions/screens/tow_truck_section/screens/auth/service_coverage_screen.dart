import 'package:autorevive/controllers/towTrack/registration_tow_track_controller.dart';
import 'package:autorevive/pregentaitions/widgets/CustomChecked.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_checkbox_list.dart';
import 'package:autorevive/pregentaitions/widgets/custom_linear_indicator.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/config/app_routes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../helpers/toast_message_helper.dart';

class ServiceCoverageScreen extends StatefulWidget {
  const ServiceCoverageScreen({super.key});

  @override
  State<ServiceCoverageScreen> createState() => _ServiceCoverageScreenState();
}

class _ServiceCoverageScreenState extends State<ServiceCoverageScreen> {

  TowTrackController towTrackController = Get.put(TowTrackController());

  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  final TextEditingController _regionsCoveredTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final Map<String, bool> _services = {
    'Light-Duty Towing (Cars & Small Trucks)': false,
    'Medium-Duty Towing (Box Trucks & RVs)': false,
    'Heavy-Duty Towing (Semis & Large Trucks)': false,
    'Roadside Assistance (Jump-starts, Lockouts, Fuel Delivery).': false,
    'Winch-Out & Recovery Services': false,
    'Equipment Transport': false,
  };
  final Map<String, bool> checkboxOptions = {
    'Under 30 minutes': false,
    '30-60 minutes': false,
    'Over 1 hour': false,
  };
  bool? _emergencyTowingChecked;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      final Map routeData = extra is Map ? extra : {};

      final List<String> servicesList = (routeData['services'] as List?)?.cast<String>() ?? [];
      for (var key in _services.keys) {
        _services[key] = servicesList.contains(key);
      }

      final List<String> etaList = (routeData['eta'] as String?)?.replaceAll('[', '').replaceAll(']', '').split(',') ?? [];
      for (var key in checkboxOptions.keys) {
        checkboxOptions[key] = etaList.contains(key.trim());
      }

      country.text = routeData['country'] ?? '';
      state.text = routeData['state'] ?? '';
      city.text = routeData['city'] ?? '';
      _regionsCoveredTEController.text = routeData['regionsCovered'] ?? '';
      _emergencyTowingChecked = routeData['emergency247'] ?? false;

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
            text: "Service and Coverage Area..",
            fontsize: 20.sp,
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: isLoading
              ? Column(
            children: List.generate(2, (_) => _buildShimmerService()),)
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEdit) CustomLinearIndicator(
                progressValue: 0.8,
              ),
              SizedBox(height: 24.h),
              CustomText(
                text: 'What types of towing services do you offer',
                bottom: 6.h,
              ),
              CustomCheckboxList(
                isAllChecked: true,
                items: _services,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: 'What is your primary service area?',
                bottom: 6.h,
              ),
              /// ====================================> CountryStateCityPicker Widget initialize ====================================>
              CountryStateCityPicker(
                country: country,
                state: state,
                city: city,
                dialogColor: Colors.grey.shade200,
                textFieldDecoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24.sp,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(16.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(16.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
              SizedBox(height: 16.h),

              CustomTextField(
                controller: _regionsCoveredTEController,
                labelText: 'Regions Covered..',
                hintText: 'Regions Covered..',
              ),

              CustomChecked(
                  title: 'Do you offer 24/7 emergency towing?',
                  selected: _emergencyTowingChecked,
                  onChanged: (val) {
                    _emergencyTowingChecked = val;
                    setState(() {});
                  }),

              CustomText(
                top: 8.h,
                text: 'Average ETA for service calls.',
              ),

              CustomCheckboxList(
                items: checkboxOptions,
              ),
              SizedBox(height: 44.h),
              Obx(()=>
               CustomButton(
                 loading: towTrackController.serviceCoverageLoading.value,
                    title:  isEdit ? "Edit" : "Save and Next",
                   onpress: () async {
                     if (_globalKey.currentState!.validate()) {

                       final selectedServices = _services.entries
                           .where((element) => element.value)
                           .map((e) => e.key)
                           .toList();

                       final selectedETA = checkboxOptions.entries
                           .where((element) => element.value)
                           .map((e) => e.key)
                           .toList();

                       if (country.text.isEmpty || state.text.isEmpty || city.text.isEmpty) {
                         ToastMessageHelper.showToastMessage('Please select country, state, and city',title: 'Attention');
                         return;
                       }

                       if (_services.values.any((selected) => !selected)) {
                         ToastMessageHelper.showToastMessage('Please select all towing services', title: 'Attention');
                         return;
                       }

                       // if (selectedServices.isEmpty) {
                       //   ToastMessageHelper.showToastMessage('Please select at least one towing service',title: 'Attention');
                       //   return;
                       // }

                       if (selectedETA.isEmpty) {
                         ToastMessageHelper.showToastMessage('Please select at least one ETA option',title: 'Attention');
                         return;
                       }

                       final success = await towTrackController.serviceCoverage(
                         services: selectedServices,
                         primaryCountry: country.text.trim(),
                         primaryState: state.text.trim(),
                         primaryCity: city.text.trim(),
                         regionsCovered: _regionsCoveredTEController.text.trim(),
                         emergency24_7: _emergencyTowingChecked ?? false,
                         eta: selectedETA.toString(),
                         context: context,
                       );
                       if (success) {
                         isEdit
                             ? context.pop(true)
                             :   context.pushNamed(AppRoutes.businessRequirementScreen);
                       }
                     }
                   }
               )
               ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerService() {
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
