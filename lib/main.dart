import 'dart:ui';
import 'package:autorevive/helpers/dependancy_injaction.dart';
import 'package:autorevive/pregentaitions/widgets/no_internet_screen.dart';
import 'package:autorevive/services/firebase_notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'core/config/app_routes/app_routes.dart';
import 'core/config/app_themes/app_themes.dart';

void main() async{


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance;
  FirebaseNotificationService.instance;
  FirebaseNotificationService.getFCMToken();
  FirebaseNotificationService.printFCMToken();

  PlatformDispatcher.instance.onAccessibilityFeaturesChanged = (){};
  DependencyInjection di = DependencyInjection();
  di.dependencies();


  di.lockDevicePortrait();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
         return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Auto Revive',
            theme: Themes().lightTheme,
            darkTheme: Themes().lightTheme,
           routeInformationParser: AppRoutes.goRouter.routeInformationParser,
           routeInformationProvider: AppRoutes.goRouter.routeInformationProvider,
           routerDelegate: AppRoutes.goRouter.routerDelegate,
           builder: (context, child) {
             return Scaffold(body: NoInterNetScreen(child: child!));
           },
          );
        }
      ),
    );
  }
}











//sagor_dev