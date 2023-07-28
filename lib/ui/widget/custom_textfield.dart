import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomTextField({
    this.hint,
    this.label,
    this.pretext,
    this.sufText,
    this.maxLength,
    this.obscure,
    this.maxLines,
    this.minLines,
    this.initialValue,
    this.hintColor,
    this.icon,
    this.enabled,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyType,
    this.keyAction,
    this.textEditingController,
    this.onSubmited,
    this.onTap,
    this.validate,
    this.inputformater,
    this.onChanged,
    this.validatorText,
    this.onClick,
    this.AllowClickable = false,
    this.color,
    this.fillColor,
    this.borderColor,
    this.colors,
    this.enableColor,
    this.labelSize,
    this.radius,
  });

  final VoidCallback? onClick;
  final bool? AllowClickable;
  final bool? obscure;
  final String? hint;
  final String? label;
  final Color? color;
  final Color? colors;
  final Color? fillColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? enableColor;
  final String? pretext;
  final String? sufText;
  final String? initialValue;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? labelSize, radius;
  final bool? enabled;
  final bool readOnly;
  final Widget? icon, prefixIcon, suffixIcon;
  final TextInputType? keyType;
  final TextEditingController? textEditingController;
  final TextInputAction? keyAction;
  final String? Function(String?)? validate;
  final ValueChanged<String>? onSubmited;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? validatorText;
  final List<TextInputFormatter>? inputformater;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputformater ?? [],
      autofocus: false,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      minLines: minLines,
      controller: textEditingController,
      enabled: enabled,
      keyboardType: keyType,
      textInputAction: keyAction,
      readOnly: readOnly,
      validator: validate ??
          (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            } else if (value != null) {
              return null;
            }
            return null;
          },
      initialValue: initialValue,
      obscureText: obscure ?? false,
      style: TextStyle(
          color: hintColor ?? AppColor().lightItemsColor,
          fontSize: 13,
          fontStyle: FontStyle.normal,
          fontFamily: 'GilroyBold',
          fontWeight: FontWeight.w400,
          height: 1.7),
      decoration: InputDecoration(
        fillColor: fillColor ?? AppColor().pureBlackColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        filled: true,
        isDense: true,
        prefixText: pretext,
        suffixText: sufText,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors ?? AppColor().lightItemsColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(radius ?? 10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: enableColor ?? AppColor().lightItemsColor, width: 1),
            borderRadius: BorderRadius.circular(radius ?? 10)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: borderColor ?? AppColor().lightItemsColor, width: 1),
            borderRadius: BorderRadius.circular(radius ?? 10)),
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
            color: hintColor ?? Colors.black,
            fontSize: 13,
            fontStyle: FontStyle.normal,
            fontFamily: 'GilroyMedium',
            fontWeight: FontWeight.w400,
            height: 1.7),
        hintStyle: TextStyle(
            color: hintColor ?? AppColor().lightItemsColor,
            fontSize: 13,
            fontStyle: FontStyle.normal,
            fontFamily: 'GilroyBold',
            fontWeight: FontWeight.w400,
            height: 1.7),
      ),
      // validator: validate,
      onFieldSubmitted: onSubmited,
      onTap: onTap,
    );
  }
}
