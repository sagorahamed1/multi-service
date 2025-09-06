
import 'dart:convert';
import 'dart:ui';
import 'package:autorevive/controllers/current_location_controller.dart';
import 'package:autorevive/controllers/live_location_change_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../../config.dart';
import '../../../../widgets/mechanic_profile_card.dart';

class MechanicMapScreen extends StatefulWidget {
  @override
  _MechanicMapScreenState createState() => _MechanicMapScreenState();
}

class _MechanicMapScreenState extends State<MechanicMapScreen> {
  LiveLocationChangeController liveLocationChangeController = Get.find<LiveLocationChangeController>();
  CurrentLocationController currentLocationController = Get.find<CurrentLocationController>();

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  Map routeData = {};
  LatLng userLatLng = const LatLng(23.7805733, 90.2792399);
  LatLng mechanicLatLng = const LatLng(23.7855733, 90.2852399);


  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    getMarkerFromAsset('assets/images/carImage.png').then((icon) {
      setState(() {
        carIcon = icon;
      });
    });

    loadRouteData();
  }



  void loadRouteData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra != null && extra is Map) {
        setState(() {
          routeData = extra;
        });

        if (currentLocationController.latitude.value != null) {
          userLatLng = LatLng(
            currentLocationController.latitude.value,
            currentLocationController.longitude.value,
          );
        }

        mechanicLatLng = LatLng(
          routeData["lat"] ?? 23.78,
          routeData["log"] ?? 90.28,
        );

        getRoutePolyline(userLatLng, mechanicLatLng);
      } else {
        // 🔁 Retry after 500 milliseconds
        Future.delayed(const Duration(milliseconds: 500), () {
          loadRouteData();
        });
      }
    });
  }



  Future<void> getRoutePolyline(LatLng origin, LatLng destination) async {
     String apiKey = "${Config.googleMapKey}";
    final String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data["routes"][0]["overview_polyline"]["points"];

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(points);

      polylineCoordinates.clear();
      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        polylines = {
          Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          )
        };
      });
    } else {
      print("Failed to load directions: ${response.body}");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<CurrentLocationController>(
            builder: (controller) {
              if (controller.isLoading.value || controller.initialCameraPosition == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: controller.initialCameraPosition!,
                markers: {
                  Marker(
                    markerId: const MarkerId("mechanic"),
                    position: mechanicLatLng,
                    infoWindow: InfoWindow(title: "${routeData["name"]}"),
                    icon: carIcon

                  ),
                  Marker(
                    markerId: const MarkerId("user"),
                    position: userLatLng,
                    infoWindow: const InfoWindow(title: "Your Location"),
                  ),
                },
                polylines: polylines,
                onMapCreated: (GoogleMapController mapCtrl) {
                  controller.mapController = mapCtrl;
                },
              );
            },
          ),

          Positioned(
            top: 60.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(Icons.arrow_back),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MechanicProfileCard(
              height: 200,
              image: '${routeData["image"] ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"}',
              name: '${routeData["name"] ?? "N/A"}',
              location: '${routeData["address"] ?? "N/A"}',
              rating: routeData["rating"]== "null" ?0.0: double.parse(routeData["rating"]?.toString()??'0.0'),
            ),
          ),

          SizedBox(height: 29.h),
        ],
      ),
    );
  }





  Future<BitmapDescriptor> getMarkerFromAsset(String assetPath, {int width = 50}) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }



}




