import 'package:autorevive/controllers/payment_controller.dart';
import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:autorevive/global/custom_assets/assets.gen.dart';
import 'package:autorevive/pregentaitions/widgets/custom_container.dart';
import 'package:autorevive/pregentaitions/widgets/custom_listview_shimmer.dart';
import 'package:autorevive/pregentaitions/widgets/custom_scaffold.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/payment_history_model.dart';
import '../../../../services/api_constants.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/earning_history_card.dart';
import '../../../widgets/no_data_found_card.dart';
import 'package:intl/intl.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  PaymentController paymentController = Get.put(PaymentController());

  bool isLoading = true;

  @override
  void initState() {
    paymentController.getPaymentHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: CustomText(
          color: AppColors.primaryColor,
          text: "Earnings",
          fontsize: 16.sp,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          /// ++++++++++++++++ balance ==================>
          Stack(
            alignment: Alignment.center,
            children: [
              Assets.images.balanceBg.image(
                  height: 220.h, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 44.w),
                child: Column(
                  children: [
                    CustomText(
                      text: 'Your balance',
                      color: Colors.white,
                      fontsize: 20.sp,
                      top: 20,
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => CustomText(
                        text:
                            '\$${paymentController.paymentHistory.value.wallet?.toStringAsFixed(2) ?? 'N/A'}',
                        color: Colors.white,
                        fontsize: 32.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomContainer(
                      paddingAll: 8.h,
                      radiusAll: 100.r,
                      color: AppColors.bgColorWhite,
                      width: double.infinity,
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.withdrawScreen,
                          extra: paymentController.paymentHistory.value.wallet,
                        );
                      },
                      child: CustomText(
                        text: 'Withdraw Now',
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomContainer(
                      paddingAll: 8.h,
                      radiusAll: 100.r,
                      color: AppColors.bgColorWhite,
                      width: double.infinity,
                      onTap: () {
                        context.pushNamed(AppRoutes.addBalanceScreen);
                      },
                      child: CustomText(
                        text: 'Add Balance',
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 30.h)
                  ],
                ),
              ),
            ],
          ),

          /// ====================== Earnings History ======================
          CustomText(
            top: 10.h,
            bottom: 10.h,
            textAlign: TextAlign.start,
            text: 'Earnings History',
            fontsize: 24.sp,
          ),
          Obx(
            () => paymentController.paymentHistoryLoading.value

                ? const CustomLoader()
                : (paymentController.paymentHistory.value.history?.isEmpty ?? true)
                    ? const Center(child: NoDataFoundCard())
                    : SizedBox(
              height: 400.h,
                        child: ListView.builder(
                            itemCount: paymentController.paymentHistory.value.history?.length ?? 0,
                            itemBuilder: (context, index) {
                              var item = paymentController
                                  .paymentHistory.value.history![index];
                              return EarningHistoryCard(
                                userName: item.title != null
                                    ? titleValues.reverse[item.title] ?? ''
                                    : item.rawTitle ?? '',
                                transactionId: item.trId ?? 'N/A',
                                // date: item.createdAt != null
                                //     ? DateTime.parse('${item.createdAt!}')
                                //     .toIso8601String()
                                //     .split('T')
                                //     .first
                                //     : 'N/A',
                                date: item.createdAt != null
                                    ? DateFormat('dd MMM yyyy')
                                        .format(item.createdAt!)
                                    : 'N/A',
                                amount: item.amount != null
                                    ? '${item.amount?.toStringAsFixed(2)}'
                                    : 'N/A',
                                status: '${item.status ?? 'N/A'}',
                                image:
                                    '${ApiConstants.imageBaseUrl}/${item.image != null ? imageValues.reverse[item.image] : item.rawImage}',
                              );
                            }),
                      ),
          )
        ],
      ),
    );
  }
}
