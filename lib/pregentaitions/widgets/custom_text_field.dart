import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Color? borderColor;
  final Color? hintextColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final int? maxLine;
  final double? hintextSize;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final double? borderRadio;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;


  const CustomTextField(
      {super.key,
        this.contentPaddingHorizontal,
        this.contentPaddingVertical,
        this.hintText,
        this.prefixIcon,
        this.suffixIcon,
        this.maxLine,
        this.validator,
        this.hintextColor,
        this.borderColor,
        this.isEmail = false,
        required this.controller,
        this.keyboardType = TextInputType.text,
        this.isObscureText = false,
        this.obscure = '*',
        this.filColor,
        this.hintextSize,
        this.labelText,
        this.isPassword = false,
        this.readOnly = false, this.borderRadio, this.onTap, this.onChanged,
        this.maxLength,
        this.inputFormatters,
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.labelText != null)
          CustomText(text: widget.labelText ?? '',bottom: 6.h,left: 2.w,color: Colors.black,),
          TextFormField(
            onChanged: widget.onChanged,
            onTap:widget. onTap,
            readOnly: widget.readOnly!,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscuringCharacter: widget.obscure!,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLine ?? 1,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            // validator: widget.validator,
            validator: widget.validator ??
                    (value) {
                  if (widget.isEmail == false) {
                    if (value!.isEmpty) {
                      return "Please ${widget.hintText?.toLowerCase()}";
                    } else if (widget.isPassword) {
                      if (value.isEmpty) {
                        return "Please ${widget.hintText?.toLowerCase()}";
                      } else if (value.length < 8 || !AppConstants.validatePassword(value)) {
                        return "Password: 8 characters min, letters & digits \nrequired";
                      }
                    }
                  } else {
                    bool data = AppConstants.emailValidate.hasMatch(value!);
                    if (value.isEmpty) {
                      return "Please ${widget.hintText!.toLowerCase()}";
                    } else if (!data) {
                      return "Please check your email!";
                    }
                  }
                  return null;
                },

        cursorColor: Colors.black,
        obscureText: widget.isPassword ? obscureText : false,
        style: TextStyle(color: widget.hintextColor ?? Colors.black, fontSize: widget.hintextSize ?? 12.h),
        decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.symmetric(
                horizontal: widget.contentPaddingHorizontal ?? 20.w,
                vertical: widget.contentPaddingVertical ?? 10.h),
            fillColor: const Color(0xffFAFAFA),
            filled: true,
            prefixIcon: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w),
              child: widget.prefixIcon,
            ),
            suffixIcon: widget.isPassword
                ? GestureDetector(
              onTap: toggle,
              child: _suffixIcon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
            )
                : widget.suffixIcon,
            prefixIconConstraints: BoxConstraints(minHeight: 24.w, minWidth: 24.w),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: widget.hintextColor ?? AppColors.textColor808080, fontSize: widget.hintextSize ?? 12.h,fontWeight: FontWeight.w400),
            focusedBorder: focusedBorder(),
            enabledBorder: enabledBorder(),
            errorBorder: errorBorder(),
            border: focusedBorder(),
            errorStyle: TextStyle(fontSize: 12.h, fontWeight: FontWeight.w400)
        ),

          ),
        ],
      ),
    );
  }

  _suffixIcon(IconData icon) {
    return Padding(padding: const EdgeInsets.all(12.0), child: Icon(icon,color:AppColors.textColor808080));
  }

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular( widget.borderRadio?.r ?? 16.r),
      borderSide:BorderSide(
          color: widget.borderColor ??AppColors.borderColor
      ),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 16.r),
      borderSide:BorderSide(
          color: widget.borderColor ?? AppColors.borderColor
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 16.r),
      borderSide: const BorderSide(
          color: Colors.red,width: 0.5
      ),
    );
  }
}