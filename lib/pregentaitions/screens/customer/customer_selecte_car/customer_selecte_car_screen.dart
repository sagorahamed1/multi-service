import 'package:autorevive/controllers/customer/customer_home_controller.dart';
import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:autorevive/global/custom_assets/assets.gen.dart';
import 'package:autorevive/helpers/toast_message_helper.dart';
import 'package:autorevive/pregentaitions/widgets/custom_app_bar.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_popup_menu.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:location_picker_text_field/open_street_location_picker.dart';

import '../../../../controllers/current_location_controller.dart';
import '../../../../core/constants/app_colors.dart';


class CustomerSelectCarScreen extends StatefulWidget {
  const CustomerSelectCarScreen({super.key});

  @override
  State<CustomerSelectCarScreen> createState() =>
      _CustomerSelectCarScreenState();
}

class _CustomerSelectCarScreenState extends State<CustomerSelectCarScreen> {
  CustomerHomeController customerHomeController = Get.find<CustomerHomeController>();
  CurrentLocationController controller = Get.put(CurrentLocationController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    customerHomeController.fetchCarModel();
    super.initState();
  }

  String selectedType = 'Sedan';
  TextEditingController carCtrl = TextEditingController();
  TextEditingController carSelectIdCtrl = TextEditingController();
  TextEditingController timeCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController locationName = TextEditingController();

  double distance = 0;
  double lat = 0;
  double log = 0;

  final places = GoogleMapsPlaces(
      apiKey: "AIzaSyA-Iri6x5mzNv45XO3a-Ew3z4nvF4CdYo0");

  @override
  Widget build(BuildContext context) {
    Map routerData = GoRouterState.of(context).extra as Map;
    print("===================address :::::: ${routerData["address"]}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: routerData["title"]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                routerData["title"] == "Tow Truck"
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Assets.icons.arrowLongDown.svg(),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  children: [
            
            
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color: AppColors.primaryShade300),
                                          color: const Color(0xffE6E6FF)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10.h),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 8.w),
                                            const Icon(Icons.location_on,
                                                color: AppColors.primaryShade300),
                                            Expanded(
                                              child: CustomText(
                                                textAlign: TextAlign.start,
                                                  text: "${routerData["address"]}",
                                                  color: AppColors.primaryShade300,
                                                  left: 8.w),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
            
            
            
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(10.r),
                                    //       color: const Color(0xffE6E6FF)
                                    //   ),
                                    //   child: LocationPicker(
                                    //     label: "",
                                    //     controller: locationName,
                                    //     onSelect: (data){
                                    //       locationName.text = data.displayname;
                                    //      distance =  controller.calculateDistanceInMiles(data.latitude, data.longitude);
                                    //      log = data.longitude;
                                    //      lat = data.latitude;
                                    //      setState(() {});
                                    //
                                    //     },
                                    //   ),
                                    // ),
                                    //


                                    GooglePlaceAutoCompleteTextField(
                                      focusNode: FocusNode(), // Add a focus node if needed
                                      textEditingController: locationName,
                                      googleAPIKey: "AIzaSyA-Iri6x5mzNv45XO3a-Ew3z4nvF4CdYo0",
                                      inputDecoration: InputDecoration(
                                        hintText: "Select location",
                                        filled: true,
                                        fillColor: const Color(0xffE6E6FF),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent, width: 0.05),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent, width: 0.05),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent, width: 0.05),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                      ),
                                      boxDecoration: BoxDecoration(
                                        color: const Color(0xffE6E6FF),
                                        border: Border.all(color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng: (prediction) async {
                                        // Get place details to extract lat/lng
                                        final detail = await places.getDetailsByPlaceId(prediction.placeId!);

                                        // Extract latitude and longitude
                                        final lat = detail.result.geometry?.location.lat;
                                        final lng = detail.result.geometry?.location.lng;

                                        if (lat != null && lng != null) {
                                          // Calculate distance using your existing method
                                          distance = controller.calculateDistanceInMiles(lat, lng);
                                          log = lng;
                                          this.lat = lat;
                                          setState(() {});
                                        }
                                      },
                                      itemClick: (prediction) {
                                        locationName.text = prediction.description ?? "";
                                        locationName.selection = TextSelection.fromPosition(
                                          TextPosition(offset: prediction.description?.length ?? 0),
                                        );
                                      },
                                      // Optional: Add validator if needed
                                      // validator: (value, prediction) {
                                      //   if (value == null || value.isEmpty) {
                                      //     return "Location required";
                                      //   }
                                      //   return null;
                                      // },
                                    ),
            
            
            
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 60.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.primaryColor),
                            child: Padding(
                              padding: EdgeInsets.all(50.r),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 12.h,
                                        width: 12.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          maxline: 2,
                                            textAlign: TextAlign.start,
                                            text: "${routerData["address"]}",
                                            color: Colors.white,
                                            left: 7.w),
                                      )
                                    ],
                                  ),
                                  Assets.icons.arrowLongDown.svg(height: 30.h, color: Colors.green),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 12.h,
                                        width: 12.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          textAlign: TextAlign.start,
                                            text: "${locationName.text}",
                                            color: Colors.white,
                                            maxline: 2,
                                            left: 7.w),
                                      )
                                    ],
                                  ),
                                  CustomText(
                                      text: "Total Distance: ${distance.toStringAsFixed(2)} Miles",
                                      color: Colors.white,
                                      fontsize: 16.h,
                                      top: 20.h)
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          CustomText(
                              text: "Select Your Car Type...", color: Colors.black),
                          SizedBox(height: 10.h),
                          CustomTextField(
                            readOnly: true,
                            hintText: "Select car",
                            controller: carCtrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select car';
                              }
                              return null;
                            },

                            suffixIcon: CustomPopupMenu(
                                items: customerHomeController.carModels,
                                onSelected: (p0) {
                                  carSelectIdCtrl.text = p0;
                                  final selectCarThis = customerHomeController
                                      .carModels
                                      .firstWhere((x) => x.id == p0);
                                  carCtrl.text = selectCarThis.name!;
                                  setState(() {});
                                }),
                          ),
                          if (routerData["title"] != "On Site")
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Time",
                                        fontsize: 16.h,
                                        bottom: 8.h,
                                        color: Colors.black,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (pickedTime != null) {
                                            final now = DateTime.now();
                                            final dt = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                pickedTime.hour,
                                                pickedTime.minute);
                                            final formattedTime =
                                                TimeOfDay.fromDateTime(dt)
                                                    .format(context);
                                            timeCtrl.text = formattedTime;
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            readOnly: true,
                                            controller: timeCtrl,
                                            hintText: "Select Time",
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Select Time!';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Date",
                                        fontsize: 16.h,
                                        color: Colors.black,
                                        bottom: 8.h,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (pickedDate != null) {
                                            final formattedDate =
                                                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                            dateCtrl.text = formattedDate;
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            readOnly: true,
                                            controller: dateCtrl,
                                            hintText: "Select Date",
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Select Date!';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
               
                
                SizedBox(height: routerData["title"] == "Tow Truck" ? 180.h : 350.h),
            
            
                CustomButton(
                    title: "Submit",
                    onpress: () {
            
                      print("-------------------------------${lat}");
            
                      if(routerData["title"] == "Tow Truck"){
                        if(lat == 0){
                          ToastMessageHelper.showToastMessage("Please select your location");
                        }else{
                          context.pushNamed(AppRoutes.customerMapScreen, extra: {
                            "title": routerData["title"],
                            "coordinates" : [controller.longitude, controller.latitude],
                            "destCoordinates" : [log, lat]
                          });
                        }
                      }else{
                        if(formKey.currentState!.validate()){
                            context.pushNamed(AppRoutes.customerMapScreen, extra: {
                              "title": routerData["title"],
                              "carModelId": carSelectIdCtrl.text,
                              "coordinates" : [controller.longitude, controller.latitude],
                              "time" : timeCtrl.text,
                              "date" : dateCtrl.text
                            });
            
                        } else {
                          ToastMessageHelper.showToastMessage("All field are required!");
                        }
                      }
            
            
                    }),
                SizedBox(height: 50.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
