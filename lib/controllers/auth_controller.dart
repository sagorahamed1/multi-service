import 'dart:async';
import 'dart:convert';
import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../core/app_constants/app_constants.dart';
import '../core/constants/app_colors.dart';
import '../helpers/prefs_helper.dart';
import '../helpers/toast_message_helper.dart';
import '../pregentaitions/widgets/custom_button.dart';
import '../pregentaitions/widgets/custom_text.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';



class AuthController extends GetxController {

  bool isChecked = false;
  bool isCheckboxError = false;
  RxBool isObscure = true.obs;
  RxBool isObscureConfirmPassword = true.obs;

  toggleIsObscure() {
    isObscure.value = !isObscure.value;
  }

  toggleIsObscureConfirmPassword() {
    isObscureConfirmPassword.value = !isObscureConfirmPassword.value;
  }




  RxBool signUpLoading = false.obs;

  ///========================================== Sing up ==================================<>

  handleSignUp({String? name, email, phone, password,confirmPassword,filePath,required BuildContext context, required String screenType}) async {
    String role = await PrefsHelper.getString(AppConstants.role);

    List<MultipartBody> multipartBody =
    filePath == null ? [] : [MultipartBody("file", filePath)];

    signUpLoading(true);
    var body = {
      "name": "$name",
      "email": "$email",
      "phone": "$phone",
      "password": "$password",
      "confirmPassword": "$confirmPassword",
      "role": "$role",
    };

    var response = await ApiClient.postMultipartData(ApiConstants.signUpEndPoint, body, multipartBody: multipartBody);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["verificationToken"]);
       if(screenType == "user"){
        context.pushNamed(AppRoutes.otpScreen, extra: {
          "screenType" : "user",
          "email" : ""
        });
       }else if(screenType == "mechanic"){
         context.pushNamed(AppRoutes.otpScreen, extra: {
           "screenType" : "mechanic",
           "email" : ""
         });

       }else{
         context.pushNamed(AppRoutes.otpScreen, extra: {
           "screenType" : "track",
           "email" : ""
         });
       }


      ToastMessageHelper.showToastMessage("Account create successful.\n \nNow you have an one time code your email");
      signUpLoading(false);
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}",title:  'Fail');
      signUpLoading(false);
    }
  }




  RxBool mechanicSignUpLoading = false.obs;

  ///========================================== Mechanic Sing up ==================================<>

  mechanicHandleSignUp({String? name, email, password,confirmPassword,required BuildContext context}) async {
    String role = await PrefsHelper.getString(AppConstants.role);
    mechanicSignUpLoading(true);
    var body = {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "role": "$role",
    };

    var response = await ApiClient.postData(ApiConstants.signUpEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["verificationToken"]);
      if(role.toLowerCase() == "mechanic"){
        context.pushNamed(AppRoutes.otpScreen, extra: {
          "screenType" : "mechanic",
          "email" : ""
        });
      }else{
        context.pushNamed(AppRoutes.otpScreen, extra: {
          "screenType" : "tow_truck",
          "email" : ""
        });
      }
      ToastMessageHelper.showToastMessage("Account create successful.\n \nNow you have an one time code your email");
      mechanicSignUpLoading(false);
    } else if(response.statusCode == 1){
      mechanicSignUpLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      mechanicSignUpLoading(false);
    }
  }


  ///========================================Verify Email===========================================<>
  RxBool verfyLoading = false.obs;

  verfyEmail(String otpCode, {String screenType = '',String type = '', required BuildContext context}) async {
    verfyLoading(true);
    var body = {"otp": otpCode};
    var response = await ApiClient.postData(
        ApiConstants.verifyEmailEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      verfyLoading(false);
      if(screenType== 'forgot'){
        debugPrint("==========bearer token save done : ${response.body["data"]['token']}");
        await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]['token']);

      }else{
        debugPrint("==========bearer token save done : ${response.body["data"]['accessToken']}");
        await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]['accessToken']);
      }


      if (type == 'Sign Up') {
        print('================================ screenType received yjuikhujikgyhujvghg: $screenType');
        if(screenType == "user"){
          context.go(AppRoutes.logInScreen);
        } else if(screenType == "mechanic"){
          context.go(AppRoutes.mechanicPersonalInformationScreen);
        }else {
          context.go(AppRoutes.towTrackBasicInfoScreen);
        }
      }else{
        context.go(AppRoutes.resetPasswordScreen);
      }
      verfyLoading(false);
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    } else{
      verfyLoading(false);
      ToastMessageHelper.showToastMessage("${response.body["message"]}",title: 'attention');
      print('================================ screenType received yjuikhujikgyhujvghg: $screenType');
    }



  }





  final RxInt countdown = 60.obs;
  final RxBool isCountingDown = false.obs;


  void startCountdown() {
    isCountingDown.value = true;
    countdown.value = 60;
    update();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
        update();
      } else {
        timer.cancel();
        isCountingDown.value = false;
        update();
      }
    });
  }

  ///============================================= Log in ===============================================<>
  RxBool logInLoading = false.obs;

  handleLogIn(String email, String password, {required BuildContext context}) async {
    logInLoading.value = true;

    var headers = {'Content-Type': 'application/json'};
    var body = {
      "email": email,
      "password": password,
    };

    var response = await ApiClient.postData(
      ApiConstants.loginUpEndPoint,
      jsonEncode(body),
      headers: headers,
    );

    print("========================${response.statusCode} \n ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = response.body['data']["user"];
      await PrefsHelper.setString(AppConstants.role, data['role']);
      await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["tokens"]["accessToken"]);
      await PrefsHelper.setString(AppConstants.email, email);
      await PrefsHelper.setString(AppConstants.name, data['name']);
      await PrefsHelper.setString(AppConstants.userId, data['_id']);

      var role = data['role'];

      print("========================================= role : $role");

      if (role == "customer") {
        context.go(AppRoutes.customerBottomNavBar);
        await PrefsHelper.setBool(AppConstants.isLogged, true);
      } else if (role == "mechanic") {
        if (data["step"] == 1) {
          context.go(AppRoutes.mechanicPersonalInformationScreen);
        } else if (data["step"] == 2) {
          context.go(AppRoutes.mechanicExperienceSkillScreen);
        } else if (data["step"] == 3) {
          context.go(AppRoutes.mechanicToolsEquipmentScreen);
        } else if (data["step"] == 4) {
          context.go(AppRoutes.mechanicEmploymentHistoryScreen);
        } else if (data["step"] == 5) {
          context.go(AppRoutes.mechanicReferenceScreen);
        } else if (data["step"] == 6) {
          context.go(AppRoutes.mechanicAdditionalInformationScreen);
        } else if (data["step"] == 7) {
          context.go(AppRoutes.mechanicResumeCertificateScreen);
        } else {
          context.go(AppRoutes.mechanicBottomNavBar);
          await PrefsHelper.setBool(AppConstants.isLogged, true);
        }
      } else {
        if(data["step"]==1){
          context.go(AppRoutes.towTrackBasicInfoScreen);
        }else if (data["step"] == 2) {
          context.go(AppRoutes.companyInformationScreen);
        }else if (data["step"] == 3) {
          context.go(AppRoutes.licensingAndComplianceScreen);
        }else if (data["step"] == 4) {
          context.go(AppRoutes.vehicleEquipmentScreen);
        }else if (data["step"] == 5) {
          context.go(AppRoutes.serviceCoverageScreen);
        }else if (data["step"] == 6) {
          context.go(AppRoutes.businessRequirementScreen);
        }else{
          context.go(AppRoutes.towTruckBottomNavBar);
          await PrefsHelper.setBool(AppConstants.isLogged, true);
        }

      }

      ToastMessageHelper.showToastMessage('You are logged in');
      logInLoading(false);
    } else {
      logInLoading(false);
      if (response.body["message"] == "Email not verified. Please verify your email.") {
        context.go(AppRoutes.otpScreen, extra: {
          "screenType" : "",
          "email" : ""
        });
        await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]['tokens']);
        ToastMessageHelper.showToastMessage("We've sent an OTP to your email to verify your email.");
      } else if (response.body["message"] == "⛔ Wrong password! ⛔") {
        ToastMessageHelper.showToastMessage(response.body["message"]);
      } else {
        ToastMessageHelper.showToastMessage(response.body['message'],title: 'attention');
      }
    }
  }


  // RxBool logInLoading = false.obs;
  // handleLogIn(String email, String password, {required BuildContext context}) async {
  //   logInLoading.value = true;
  //   var headers = {'Content-Type': 'application/json'};
  //   var body = {
  //     "email": email,
  //     "password": password
  //   };
  //   var response = await ApiClient.postData(
  //       ApiConstants.loginUpEndPoint, jsonEncode(body),
  //       headers: headers);
  //   print("========================${response.statusCode} \n ${response.body}");
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var data = response.body['data']["user"];
  //     await PrefsHelper.setString(AppConstants.role, data['role']);
  //     await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["tokens"]["accessToken"]);
  //     await PrefsHelper.setString(AppConstants.email, email);
  //     await PrefsHelper.setString(AppConstants.name, data['name']);
  //     await PrefsHelper.setString(AppConstants.userId, data['_id']);
  //
  //
  //     var role = data['role'];
  //
  //     if (role == "customer") {
  //       context.go(AppRoutes.customerBottomNavBar);
  //       await PrefsHelper.setBool(AppConstants.isLogged, true);
  //     }
  //     else{
  //       if(data["step"] == 1){
  //         context.go(AppRoutes.mechanicPersonalInformationScreen);
  //       }else if(data["step"] ==  2){
  //         context.go(AppRoutes.mechanicExperienceSkillScreen);
  //       }else if(data["step"] ==  3){
  //         context.go(AppRoutes.mechanicToolsEquipmentScreen);
  //       }else if(data["step"] ==  4){
  //         context.go(AppRoutes.mechanicEmploymentHistoryScreen);
  //       }else if(data["step"] ==  5){
  //         context.go(AppRoutes.mechanicReferenceScreen);
  //       }else if(data["step"] ==  6){
  //         context.go(AppRoutes.mechanicAdditionalInformationScreen);
  //       }else if(data["step"] ==  7){
  //         context.go(AppRoutes.mechanicResumeCertificateScreen);
  //       } else{
  //         context.go(AppRoutes.mechanicBottomNavBar);
  //         await PrefsHelper.setBool(AppConstants.isLogged, true);
  //       }
  //     }
  //     ToastMessageHelper.showToastMessage('Your are logged in');
  //     logInLoading(false);
  //   }else{
  //     logInLoading(false);
  //     ///******** When user do not able to verify their account thay have to verify there account then they can go to the app********
  //     if (response.body["message"] == "Email not verified. Please verify your email.") {
  //       context.go(AppRoutes.otpScreen, extra: "");
  //       await PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]['tokens']);
  //       ToastMessageHelper.showToastMessage("We've sent an OTP to your email to verify your email.");
  //     }else if(response.body["message"] == "⛔ Wrong password! ⛔"){
  //       ToastMessageHelper.showToastMessage(response.body["message"]);
  //     }
  //     logInLoading(false);
  //     ToastMessageHelper.showToastMessage(response.body['message']);
  //   }
  // }


  ///===========================================> Forgot Password ====================================================<>
  RxBool forgotLoading = false.obs;
  handleForgot(String email, screenType, {required BuildContext context}) async {
    forgotLoading(true);
    var body = {"email": email};
    var response = await ApiClient.postData(
      ApiConstants.forgotPasswordEndPoint,
      jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final token = response.body["data"]["resetPasswordToken"] ?? response.body["data"]["verificationToken"];
      if (token != null) {
        await PrefsHelper.setString(AppConstants.bearerToken, token);
      } else {
        debugPrint("❌ Token missing in forgot response.");
      }

      if (screenType == "forgot") {
        context.pushNamed(AppRoutes.otpScreen, extra: {
          "screenType": "forgot",
          "email": email,
        });
      }

      forgotLoading(false);
    } else {
      forgotLoading(false);
      ToastMessageHelper.showToastMessage(response.body["message"]);
    }
  }

  // handleForgot(String email, screenType, {required BuildContext context}) async {
  //   forgotLoading(true);
  //   var body = {"email": email};
  //   var response = await ApiClient.postData(
  //       ApiConstants.forgotPasswordEndPoint,
  //       jsonEncode(body),
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //
  //     PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["resetPasswordToken"]);
  //
  //
  //     if(screenType == "forgot"){
  //       context.pushNamed(AppRoutes.otpScreen, extra: {
  //         "screenType": "forgot", "email" : email});
  //     }
  //
  //     forgotLoading(false);
  //   }  else {
  //     forgotLoading(false);
  //     ToastMessageHelper.showToastMessage(response.body["message"]);
  //   }
  // }





  ///===============Set Password================<>

  RxBool setPasswordLoading = false.obs;

  setPassword(String password,confirmPassword,{required BuildContext context}) async {
    setPasswordLoading(true);
    var body = {
      "password": password.toString().trim(),
      "confirmPassword": confirmPassword.toString().trim()
    };

    var response = await ApiClient.postData(
        ApiConstants.resetPasswordEndPoint, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      context.pushNamed(AppRoutes.logInScreen);
      ToastMessageHelper.showToastMessage('${response.body["message"]}');
      print("======>>> successful");
      setPasswordLoading(false);
    } else if(response.statusCode == 1){
      setPasswordLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      setPasswordLoading(false);
      ToastMessageHelper.showToastMessage('${response.body["message"]}',title: 'attention');
    }
  }


  ///===============Resend================<>

  RxBool resendLoading = false.obs;

  reSendOtp() async {
    resendLoading(true);
    String token = await PrefsHelper.getString(AppConstants.bearerToken);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = {};
    var response = await ApiClient.postData(
      ApiConstants.resendOtpEndPoint,
      jsonEncode(body),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final newToken = response.body["data"]["resetPasswordToken"] ?? response.body["data"]["verificationToken"];
      if (newToken != null) {
        await PrefsHelper.setString(AppConstants.bearerToken, newToken);
      } else {
        debugPrint("❌ Token missing in resendOtp response.");
      }

      ToastMessageHelper.showToastMessage('You have got an one time code to your email');
      print("======>>> successful");
      resendLoading(false);
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      resendLoading(false);
    }
  }


  // reSendOtp() async {
  //   resendLoading(true);
  //   String token = await PrefsHelper.getString(AppConstants.bearerToken);
  //   var headers = {
  //     'Content-Type': 'application/json',
  //   'Authorization': 'Bearer $token',
  //   };
  //   var body = {};
  //   var response = await ApiClient.postData(
  //       ApiConstants.resendOtpEndPoint,
  //       jsonEncode(body),
  //   headers: headers
  //   );
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     PrefsHelper.setString(AppConstants.bearerToken, response.body["data"]["verificationToken"]);
  //     ToastMessageHelper.showToastMessage(
  //         'You have got an one time code to your email');
  //     print("======>>> successful");
  //     resendLoading(false);
  //   }else{
  //     ToastMessageHelper.showToastMessage("${response.body["message"]}");
  //     resendLoading(false);
  //   }
  // }


  ///===============Change Password================<>

  RxBool changePasswordLoading = false.obs;
  changePassword(String currentPassword, password ,confirmPassword ) async {
    changePasswordLoading(true);
    var body = {
      "currentPassword": "$currentPassword",
      "password": "$password",
      "confirmPassword" : "$confirmPassword"
    };

    var response =
    await ApiClient.postData(ApiConstants.changePassword, jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage('Password Changed Successful');
      print("======>>> successful");
      changePasswordLoading(false);
    } else if(response.statusCode == 1){
      changePasswordLoading(false);
      ToastMessageHelper.showToastMessage("Server error! \n Please try later");
    } else {
      ToastMessageHelper.showToastMessage(response.body['message']);
      changePasswordLoading(false);
    }
  }

  ///=============== Delete Account ================<>


  var deleteLoading = false.obs;
  userDelete(BuildContext context) async {

    deleteLoading(true);
    var response = await ApiClient.deleteData(
        ApiConstants.deleteEndPoint);
    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage('Account Delete Successfully');
      context.pushNamed(AppRoutes.logInScreen);
    } else {
      deleteLoading(false);
    }

  }



  // final RxInt countdown = 180.obs;
  // final RxBool isCountingDown = false.obs;
  //
  //
  // void startCountdown() {
  //   isCountingDown.value = true;
  //   countdown.value = 180;
  //   update();
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (countdown.value > 0) {
  //       countdown.value--;
  //       update();
  //     } else {
  //       timer.cancel();
  //       isCountingDown.value = false;
  //       update();
  //     }
  //   });
  // }
  //
  //
  //
  //
  //


  void _dialog(BuildContext context, String role){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 24.w, vertical: 26.h),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Align(
                  //     alignment: Alignment.center,
                  //     child: Assets.lottie.success.lottie(height: 80.h, width: 80.w, fit: BoxFit.cover)),

                  CustomText(
                    text: "SUCCESS",
                    fontsize: 23.h,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    top: 16.h,
                    bottom: 8.h,
                  ),


                  CustomText(
                    text: "Thank you for your request.",
                    color: Colors.black,
                    fontsize: 20.h,
                  ),

                  CustomText(
                    text: "Shortly you will find a confirmation in your email.",
                    color: Colors.black,
                    maxline: 2,
                    bottom: 24.h,
                  ),

                  CustomButton(title: "Go to App", onpress: (){
                    if(role == "user"){
                      // context.go(AppRoutes.userHomeScreen);
                    }else{
                      // context.go(AppRoutes.managerHomeScreen);
                    }
                  })
                ],
              ),
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                      width: 1.w, color: AppColors.primaryColor)));
        });
  }


}
