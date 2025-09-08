import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/auth_controller.dart';
import '../../../core/app_constants/app_constants.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(text: "Settings", fontsize: 20.h),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),

            ///==============Change password===============>>>

            GestureDetector(
                onTap: (){
                  context.pushNamed(AppRoutes.changePasswordScreen);
                },
                child:_customTile(
                    Assets.icons.changePass.svg(),
                    Assets.icons.arrowRight.svg(),
                    "Change Password")
            ),

            ///=============Privacy app===============>>>
            GestureDetector(
              onTap: (){
                context.pushNamed(AppRoutes.privacyAllScreen, extra: "Privacy Policy");
              },
              child:    _customTile(
                  Assets.icons.privacy.svg(),
                  Assets.icons.arrowRight.svg(),
                  "Privacy Policy"),
            ),




            ///==============Terms & Conditions===============>>>

            GestureDetector(
              onTap: (){
                context.pushNamed(AppRoutes.privacyAllScreen, extra: "Terms & Conditions");
              },
              child: _customTile(
                  Assets.icons.terms.svg(),
                  Assets.icons.arrowRight.svg(),
                  "Terms of service"),
            ),





            ///==============About===============>>>

            GestureDetector(
              onTap: (){
                 context.pushNamed(AppRoutes.privacyAllScreen, extra: "About Us");
              },
              child: _customTile(
                  Assets.icons.about.svg(),
                  Assets.icons.arrowRight.svg(),
                  "About Us"),
            ),


            SizedBox(height: 330.h),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              textAlign: TextAlign.center,
                              text: 'Delete Account',
                              fontsize: 20.sp,
                              color: AppColors.logColor,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 10.h),
                            Divider(thickness: 1, color: Colors.grey.withOpacity(0.4)),
                            SizedBox(height: 24.h),
                            Text(
                              "Are you sure you want to delete your account?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Cancel Button
                                SizedBox(
                                  width: 110.w,
                                  height: 44.h,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.r),
                                      ),
                                      side: BorderSide(color: Colors.pinkAccent, width: 1.5),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                // Confirm Delete Button
                                SizedBox(
                                  width: 110.w,
                                  height: 44.h,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.r),
                                      ),
                                      side: BorderSide(color: Colors.black, width: 1.5.w),
                                    ),
                                    onPressed: () {
                                      _authController.userDelete(
                                      );

                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Assets.icons.delete.svg(width: 20.w, height: 20.h),
              label: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
            ),
            SizedBox(height: 40.h),





          ],
        ),
      ),
    );
  }


  _customTile(Widget leading, Widget trailing, String title) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18.5.h, bottom: 12.h),
            child: Row(
              children: [
                leading,
                CustomText(text: title, left: 18.w, fontsize: 16.h),
                const Spacer(),
                trailing,
                SizedBox(width: 25.w),
              ],
            ),
          ),
          Divider(
            color: AppColors.borderColor.withOpacity(0.3),
            thickness: 1,
            height: 0,
          ),
        ],
      ),
    );
  }

}
