import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:autorevive/pregentaitions/widgets/booking_card_widget.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../controllers/mechanic_controller/mechanic_on_site_controller/booking_all_filters_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../services/api_constants.dart';
import '../../../../widgets/custom_listview_shimmer.dart';
import '../../../../widgets/custom_loader.dart';
import '../../../../widgets/no_data_found_card.dart';

class TowTrucksBookingsScreen extends StatefulWidget {
  const TowTrucksBookingsScreen({super.key});

  @override
  State<TowTrucksBookingsScreen> createState() =>
      _TowTrucksBookingsScreenState();
}

class _TowTrucksBookingsScreenState extends State<TowTrucksBookingsScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  MechanicBookingAllFiltersController mechanicBookingAllFiltersController = Get.put(MechanicBookingAllFiltersController());


  @override
  void initState() {

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      mechanicBookingAllFiltersController.bookingFilters.clear();
      if (_tabController.index == 0) {
        mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'requested');
      } else if (_tabController.index == 1) {
        mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'accepted');
      } else {
        mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'history');
      }
    });
    mechanicBookingAllFiltersController.bookingFilters.clear();
    mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'requested');
    super.initState();


  }







  @override
  Widget build(BuildContext context) {
    int rating = 4;
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: CustomText(
            maxline: 2,
            text: "Bookings",
            fontsize: 20.sp,
          ),
          bottom: TabBar(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            labelStyle: TextStyle(fontSize: 12.sp),
            dividerHeight: 0.5,
            dividerColor: AppColors.primaryShade300,
            labelColor: AppColors.primaryShade300,
            unselectedLabelColor: AppColors.primaryShade300,
            indicatorColor: AppColors.primaryShade300,
            controller: _tabController,
            onTap: (value) {
              print("-------------------------------status = $value");
              if (value == 0) {
                mechanicBookingAllFiltersController.bookingFilters.clear();
                mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'requested');
              } else if (value == 1) {
                mechanicBookingAllFiltersController.bookingFilters.clear();
                mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'accepted');
              } else {
                mechanicBookingAllFiltersController.mechanicBookingAllFilters(status: 'history');
              }
            },
            tabs: const [
              Tab(text: 'Requested'),
              Tab(text: 'Accepted'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: Padding(
          padding:  EdgeInsets.only(bottom: 100.h),
          child: TabBarView(
            controller: _tabController,
            children: [
              /// =================================> Requested Tab ===================================>
              Obx(()=>
              mechanicBookingAllFiltersController.loading.value ?  const CustomListviewShimmer() : mechanicBookingAllFiltersController.bookingFilters.isEmpty ?  const Center(child: NoDataFoundCard()) :
              ListView.builder(
                itemCount: mechanicBookingAllFiltersController.bookingFilters.length,
                padding: EdgeInsets.all(16.r),
                itemBuilder: (context, index) {
                  var bookingAllFilters = mechanicBookingAllFiltersController.bookingFilters[index];
                  return BookingCardWidget(
                    locationOnTap:  () {
                      context.pushNamed(AppRoutes.mechanicMapScreen, extra: {
                        "name" : bookingAllFilters.customerId!.name,
                        "address" :  bookingAllFilters.customerId!.address,
                        "lat" :  bookingAllFilters.customerId?.location?[1],
                        "log" : bookingAllFilters.customerId?.location?[0],
                        "image" :  bookingAllFilters.customerId!.profileImage,
                      });
                    },
                    isAccepted: true,
                    buttonLabel: 'Cancel',
                    onTapDetails: () {},
                    onTap: (){
                      mechanicBookingAllFiltersController.changeStatus(
                          status: 'request-canceled',
                          jobId: bookingAllFilters.id,
                          context: context);
                    },
                    name: bookingAllFilters.customerId?.name ?? 'N/A',
                    address: bookingAllFilters.customerId?.address ?? 'N/A',
                    subTitle: bookingAllFilters.carModel ?? 'N/A',
                    image: bookingAllFilters.customerId?.profileImage != null ? "${ApiConstants.imageBaseUrl}/${bookingAllFilters.customerId?.profileImage}": "",
                  );
                },
              )

              ),

              /// ===============================> Accepted Tab =======================================>

              Obx(()=>
              mechanicBookingAllFiltersController.loading.value ?  const CustomListviewShimmer() : mechanicBookingAllFiltersController.bookingFilters.isEmpty ?  const Center(child: NoDataFoundCard()) :

              ListView.builder(
                itemCount: mechanicBookingAllFiltersController.bookingFilters.length,
                padding: EdgeInsets.all(8.r),
                itemBuilder: (context, index) {
                  var bookingAllFilters = mechanicBookingAllFiltersController.bookingFilters[index];
                  return BookingCardWidget(
                    locationOnTap:  () {
                      context.pushNamed(AppRoutes.mechanicMapScreen,
                          extra: {
                        "name" : bookingAllFilters.customerId!.name,
                        "address" :  bookingAllFilters.customerId!.address,
                        "rating" : '0.0',
                        "lat" :  bookingAllFilters.customerId?.location?[1],
                        "log" : bookingAllFilters.customerId?.location?[0],
                        "image" :  bookingAllFilters.customerId!.profileImage,
                      });
                    },
                    isAccepted: true,
                    buttonLabel: 'Complete',
                    buttonColor: AppColors.primaryShade300,
                    onTapDetails: () {

                    },
                    onTap: () {
                      print('========================================== Complete Test${bookingAllFilters.jobId?.id}');
                      context.pushNamed(AppRoutes.towTruckDetailsScreen,
                          extra: {
                            "title" : "Details",
                            "name" :  bookingAllFilters.customerId?.name??"",
                            "address" :  bookingAllFilters.customerId?.address ?? "",
                            "image": bookingAllFilters.customerId?.profileImage != null ? "${ApiConstants.imageBaseUrl}/${bookingAllFilters.customerId?.profileImage}": "",
                            "id": bookingAllFilters.id,
                            "provideId": bookingAllFilters.customerId?.id,
                            "jobId": bookingAllFilters.jobId?.id


                          }
                      );

                    },
                    name: bookingAllFilters.customerId?.name ?? 'N/A',
                    address: bookingAllFilters.customerId?.address ?? 'N/A',
                    subTitle: bookingAllFilters.carModel ?? 'N/A',
                    image: bookingAllFilters.customerId?.profileImage != null ? "${ApiConstants.imageBaseUrl}/${bookingAllFilters.customerId?.profileImage}": "",
                  );
                },
              )
              ),


              /// ==================================> History Tab =====================================>

              Obx(()=>
              mechanicBookingAllFiltersController.loading.value ?  const CustomListviewShimmer() : mechanicBookingAllFiltersController.bookingFilters.isEmpty ?  const Center(child: NoDataFoundCard()) :
              ListView.builder(
                itemCount: mechanicBookingAllFiltersController.bookingFilters.length,
                padding: EdgeInsets.all(8.r),
                itemBuilder: (context, index) {
                  var bookingAllFilters = mechanicBookingAllFiltersController.bookingFilters[index];
                  return  BookingCardWidget(
                    locationOnTap:  () {
                      context.pushNamed(AppRoutes.mechanicMapScreen, extra: {
                        "name" : bookingAllFilters.customerId!.name,
                        "address" :  bookingAllFilters.customerId!.address,
                        "rating" : '0.0',
                        "lat" :  bookingAllFilters.customerId?.location?[1],
                        "log" : bookingAllFilters.customerId?.location?[0],
                        "image" :  bookingAllFilters.customerId!.profileImage,
                      });
                    },
                    onTapDetails: (){
                      // context.pushNamed(AppRoutes.mechanicBookingsDetailsScreen,);
                    },
                    historyButtonAction: (){

                    },
                    isHistory: true,
                    name: bookingAllFilters.customerId?.name ?? 'N/A',
                    address: bookingAllFilters.customerId?.address ?? 'N/A',
                    subTitle: bookingAllFilters.carModel ?? 'N/A',
                    status: bookingAllFilters.status ?? 'N/A',
                    image: bookingAllFilters.customerId?.profileImage != null ? "${ApiConstants.imageBaseUrl}/${bookingAllFilters.customerId?.profileImage}": "",
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
