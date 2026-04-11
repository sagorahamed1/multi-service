import 'package:autorevive/controllers/chat_controller.dart';
import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:autorevive/global/custom_assets/assets.gen.dart';
import 'package:autorevive/helpers/quick_alert.dart';
import 'package:autorevive/pregentaitions/widgets/cachanetwork_image.dart';
import 'package:autorevive/pregentaitions/widgets/custom_app_bar.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_two_button.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/customer/customer_booking_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/vibration_service.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';



class CustomerBookingDetailsScreen extends StatefulWidget {
  CustomerBookingDetailsScreen({super.key});

  @override
  State<CustomerBookingDetailsScreen> createState() =>
      _CustomerBookingDetailsScreenState();
}

class _CustomerBookingDetailsScreenState
    extends State<CustomerBookingDetailsScreen> {
  CustomerBookingController bookingController = Get.find<CustomerBookingController>();
  ChatController chatController = Get.find<ChatController>();

  TextEditingController ratingCommentCtrl = TextEditingController();

  @override
  void initState() {
    bookingController.customerInitPaymentLoading.value = false;
    super.initState();
  }

  @override
  void dispose() {
    bookingController.services.clear();
    bookingController.totalPrice?.value = "";
    super.dispose();
  }

  double rating = 0;

  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    bookingController.getService(id: routeData['id']);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: "${routeData["title"]}"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomNetworkImage(
                      imageUrl: "${routeData["image"]}",
                      boxShape: BoxShape.circle,
                      height: 110.h,
                      width: 110.w,
                      border: Border.all(color: AppColors.primaryColor)),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                  text: "${routeData["name"]}",
                                  color: Colors.black,
                                  right: 30.w,
                                  textAlign: TextAlign.start,
                                  fontsize: 22.h,
                                 textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(AppRoutes.mechanicMapScreen,
                                    extra: {
                                      "name": routeData["name"],
                                      "address": routeData["address"],
                                      "rating": routeData["rating"],
                                      "lat": routeData["lat"],
                                      "log": routeData["log"],
                                      "image": routeData["image"]
                                    });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryShade300,
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.r),
                                    child: Icon(Icons.location_on,
                                        color: Colors.white, size: 16.r),
                                  )),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            CustomText(
                                text: "${routeData["address"]}",
                                color: Colors.black),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 13.h,
                                width: 1.w,
                                color: Colors.grey),
                            Icon(Icons.star, color: Colors.amber, size: 14.h),
                            CustomText(
                                text: "${routeData["rating"]}",
                                fontsize: 12.h,
                                color: Colors.black)
                          ],
                        ),
                        SizedBox(height: 8.h),
                        routeData["title"] == "Complete"
                            ? Wrap(
                                spacing: 10.w,
                                runSpacing: 6.h,
                                children: List.generate(
                                    routeData["certifications"].length, (index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFE6E6),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: CustomText(
                                      text: routeData["certifications"][index],
                                      fontsize: 10.sp,
                                    ),
                                  );
                                }),
                              )
                            : Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(AppRoutes.mechanicProfileInformationScreen);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryShade300,
                                          borderRadius: BorderRadius.circular(8.r)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.h, horizontal: 6.w),
                                        child: Row(
                                          children: [
                                            Assets.icons.profileIcon.svg(),
                                            SizedBox(width: 10.w),
                                            CustomText(
                                                text: "Profile",
                                                color: Colors.white,
                                                fontsize: 12.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(AppRoutes.messageChatScreen, extra: {
                                        "receiverId" : "${routeData["provideId"]}",
                                        "name" : "${routeData["name"]}"
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryShade300,
                                          borderRadius: BorderRadius.circular(8.r)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.h, horizontal: 6.w),
                                        child: Row(
                                          children: [
                                            Assets.icons.mail.svg(),
                                            SizedBox(width: 10.w),
                                            CustomText(
                                                text: "Message",
                                                color: Colors.white,
                                                fontsize: 12.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  )
                ],
              ),
              CustomText(
                  text: routeData["title"] == "Complete"
                      ? "Price need to pay..."
                      : "Payment amount due",
                  color: Colors.black,
                  fontsize: 20.h,
                  maxline: 2,
                  textAlign: TextAlign.start,
                  bottom: 8.h,
                  top: 30.h),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                height: 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColors.primaryShade300,
                ),
                child: Row(
                  children: [
                    routeData["title"] == "Complete"
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.all(4.r),
                            width: 157.w,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: CustomText(
                                  text: "Total Price",
                                  fontsize: 25.h,
                                  color: AppColors.primaryShade300),
                            ),
                          ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Obx(
                          () => CustomText(
                            text: bookingController.totalPrice?.value != "null"
                                ? bookingController.role == "tow_truck" ? "\$ 0" : "${double.tryParse(bookingController.totalPrice?.value ?? '0')?.toStringAsFixed(2) ?? '0.00'}"
                                : "\$${routeData['price']}",
                            fontsize: 30.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 11.h),
              routeData["title"] == "Complete"
                  ? const SizedBox()
                  : Obx(() => bookingController.servicesLoading.value
                      ? const RepairListWidget(services: [])
                      : RepairListWidget(
                          services: bookingController.services ?? [],
                        )),
              SizedBox(
                  height:
                      routeData["title"].toString().toLowerCase() == "details"
                          ? 30.h
                          : 350.h),
              routeData["title"] == "Complete"
                  ? !routeData["btnVisible"]
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: CustomText(
                              text: "You already accepted",
                              color: Colors.red.shade200))
                      : Obx(
                          () => CustomButton(
                              loading: bookingController.customerInitPaymentLoading.value,
                              title: routeData["price"] == 0
                                  ? "Accept"
                                  : "Pay Now",
                              onpress: () async {
                                var response =
                                    await bookingController.customerInitBooking(
                                        status: "accepted",
                                        id: routeData["id"],
                                        isToast: false, isBack: true, context: context);

                                if (response == "completed") {
                                  VibrationService.vibrateForDuration(2500);
                                  QuickAlertHelper.showSuccessAlert(context, "Your ${routeData["price"] == 0 ? "accept request" : "initial payment"} has been successfully processed.");

                                } else if (response == "fail") {
                                  VibrationService.vibrateForDuration(2500);
                                  QuickAlertHelper.showErrorAlert(context,
                                      "Sorry, something went wrong Please Try Again");
                                }
                              }),
                        )
                  : routeData["status"] != "serviced"
                      ? CustomTwoButon(
                          width: 163.w,
                          btnNameList: const ["Complete", "Cancel"],
                          rightBtnOnTap: () {
                            bookingController.customerInitBooking(
                                id: routeData["id"], status: "canceled");
                            context.pushNamed(
                                AppRoutes.customerBookingCancelScreen,
                                extra: {"id": routeData["id"]});
                          },
                          leftBtnOnTap: () async {
                            var response =
                                await bookingController.customerInitBooking(
                                    id: routeData["id"], status: "completed");

                            if (response == "completed") {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: CustomText(
                                                text: "Kindly Give Feedback",
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              child: RatingBar(
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star_border,
                                                onRatingChanged: (value) {
                                                  rating = value;
                                                  setState(() {});
                                                },
                                                initialRating: 0,
                                                maxRating: 5,
                                              ),
                                            ),
                                            SizedBox(height: 35.h),
                                            CustomText(
                                                text:
                                                    "Leave A Comment For User.",
                                                color: Colors.black),
                                            SizedBox(height: 15.h),
                                            CustomTextField(
                                              controller: ratingCommentCtrl,
                                              hintText:
                                                  "Enter Your Valuable Comment",
                                            ),
                                            SizedBox(height: 16.h),
                                            CustomButton(
                                              title: "Submit",
                                              onpress: () {
                                                bookingController
                                                    .customerFeedBack(
                                                        id: routeData["id"],
                                                        rating:
                                                            rating.toString(),
                                                        comment:
                                                            ratingCommentCtrl
                                                                .text);
                                                Navigator.of(context).pop();
                                                // Handle your submit logic
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                              context.pop();
                            } else {
                              QuickAlertHelper.showErrorAlert(context,
                                  "Your request was fail. \n \n Please try later");
                            }
                          },
                        )
                      : CustomButton(
                          title: "Pay Now",
                          onpress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 26.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                            textAlign: TextAlign.center,
                                            text: 'Complete',
                                            fontsize: 20.sp,
                                            fontWeight: FontWeight.w400),
                                        SizedBox(height: 24.h),
                                        Text(
                                          "Please complete your order and \nconfirm payment.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 30.h),
                                        CustomButton(
                                            title: "Pay Now",
                                            onpress: () async {
                                              var response = await bookingController.customerInitBooking(
                                                          id: routeData["id"],
                                                          status: "paid");
                                              print("---------------------------------payment status : $response");

                                              if (response?.toLowerCase() == "fail") {VibrationService.vibrateForDuration(2500);}

                                              if (response == "completed") {
                                                VibrationService.vibrateForDuration(2500);
                                                context.pop();
                                                context.pop();
                                                QuickAlertHelper.showSuccessAlert(context, "Your payment was successful and the offer has been accepted.");

                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

class RepairListWidget extends StatelessWidget {
  final List<ServicesModelCustomer> services;

  const RepairListWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 22.w),
      height: 317.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryShade300, width: 0.4),
      ),
      child: Scrollbar(
        thickness: 4.w,
        radius: Radius.circular(4.r),
        child: ListView.separated(
          padding: EdgeInsets.all(8.w),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: index == 0 ? 18.h : 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16.w,
                            height: 16.w,
                            margin: EdgeInsets.only(right: 8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryShade300,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Center(
                                child: Icon(Icons.check,
                                    color: Colors.white, size: 12.r)),
                          ),
                          CustomText(
                              text: services[index].service.toString(),
                              color: Colors.black),
                        ],
                      ),
                      CustomText(
                          text: "\$ ${services[index].amount}",
                          right: 22.w,
                          color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Divider(
                      color: AppColors.primaryShade300,
                      height: 8.h,
                      thickness: 0.2),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
        ),
      ),
    );
  }
}
