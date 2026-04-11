import 'package:autorevive/core/config/app_routes/app_routes.dart';
import 'package:autorevive/global/custom_assets/assets.gen.dart';
import 'package:autorevive/pregentaitions/widgets/custom_button.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text.dart';
import 'package:autorevive/pregentaitions/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../helpers/toast_message_helper.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _logKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: _logKey,
            child: Column(
              children: [
                SizedBox(height: 138.h),

                ///<<<=============>>>   Logo Icon   <<<===============>>>

                Assets.icons.logoSVG.svg(),


                SizedBox(height: 38.h),


                ///<<<=============>>>   Email Filed   <<<===============>>>

                CustomTextField(
                    controller: emailCtrl,
                    hintText: "Enter E-mail",
                    prefixIcon: Assets.icons.mail.svg(),
                    isEmail: true),



                ///<<<=============>>>   Password Filed   <<<===============>>>

                CustomTextField(
                    controller: passCtrl,
                    hintText: "Enter Password",
                    prefixIcon: Assets.icons.key.svg(),
                    isPassword: true),


                ///<<<=============>>> Forgot filed <<<===============>>>

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        if(emailCtrl.text.isEmpty){
                          ToastMessageHelper.showToastMessage("Please enter your email",title: 'Attention');
                        }else{
                          context.pushNamed(AppRoutes.emailVerifyScreen, extra: emailCtrl.text);
                        }
                      },
                      child: CustomText(text: "Forgot Password", color: Colors.red, bottom: 20.h, top: 8.h)),
                ),



                ///<<<=============>>> BUTTON <<<===============>>>

                Obx(()=>
                   CustomButton(
                       loading: authController.logInLoading.value,
                       title: "Let's Go", onpress: (){
                     if (_logKey.currentState!.validate()) {
                       authController.handleLogIn(
                           emailCtrl.text.trim(), passCtrl.text.trim(), context: context);
                     }



                  }),
                ),


                SizedBox(height: 40.h),

                ///<<<=============>>> DO NOT HAVE ACCOUNT <<<===============>>>

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: "Don't have an account?"),
                    GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.roleScreen);
                        },
                        child: CustomText(text: "  Sign Up", color: AppColors.primaryColor)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
