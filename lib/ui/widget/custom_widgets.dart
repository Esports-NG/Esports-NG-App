import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_text.dart';

class CustomFillButton extends StatelessWidget {
  const CustomFillButton({
    Key? key,
    this.onTap,
    this.width,
    this.textColor,
    this.buttonColor,
    this.borderRadius,
    this.isLoading = false,
    required this.buttonText,
    this.boarderColor,
    this.height,
    this.textSize,
    this.fontWeight,
    this.child,
  }) : super(key: key);
  final double? width;
  final double? height;
  final double? textSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? buttonColor;
  final Color? boarderColor;
  final String? buttonText;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(30),
      child: Container(
        width: width ?? Get.width,
        height: height ?? Get.height * 0.06,
        decoration: BoxDecoration(
            color: buttonColor ?? AppColor().primaryColor,
            borderRadius: borderRadius ?? BorderRadius.circular(30),
            border: Border.all(
                color: boarderColor ?? AppColor().primaryColor, width: 1)),
        child: Center(
          child: (isLoading)
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : child ??
                  CustomText(
                    title: buttonText ?? '',
                    size: textSize ?? 16,
                    weight: fontWeight ?? FontWeight.w500,
                    fontFamily: 'InterMedium',
                    textAlign: TextAlign.center,
                    color: textColor ?? AppColor().primaryWhite,
                  ),
        ),
      ),
    );
  }
}

class CustomFillButtonOption extends StatelessWidget {
  const CustomFillButtonOption({
    Key? key,
    this.onTap,
    this.width,
    this.textColor,
    this.buttonColor,
    this.borderRadius,
    this.isLoading = false,
    required this.buttonText,
    this.boarderColor,
    this.height,
    this.textSize,
    this.fontWeight,
  }) : super(key: key);
  final double? width;
  final double? height;
  final double? textSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? buttonColor;
  final Color? boarderColor;
  final String? buttonText;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, right: 20),
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 45,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            border: Border.all(color: boarderColor ?? AppColor().primaryDark)),
        child: CustomText(
          title: buttonText!,
          size: textSize ?? 16,
          weight: fontWeight ?? FontWeight.w400,
          textAlign: TextAlign.start,
          color: textColor!,
        ),
      ),
    );
  }
}

class CustomFillOption extends StatelessWidget {
  const CustomFillOption({
    Key? key,
    this.onTap,
    this.width,
    this.buttonColor,
    this.borderRadius,
    this.height,
    this.child,
    this.borderColor,
  }) : super(key: key);
  final double? width;
  final double? height;
  final Color? buttonColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: Get.height * 0.015, right: Get.height * 0.015),
        width: width ?? Get.width,
        height: height ?? Get.height * 0.06,
        decoration: BoxDecoration(
            color: buttonColor ?? AppColor().primaryColor,
            borderRadius: borderRadius ?? BorderRadius.circular(30),
            border: Border.all(color: borderColor ?? AppColor().primaryDark)),
        child: child,
      ),
    );
  }
}
