import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? title;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final String? fontFamily;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDecoration? underline;
  final Color? decorationColor;
  const CustomText({
    Key? key,
    this.title,
    this.size,
    this.color,
    this.weight,
    this.height,
    this.textAlign,
    this.overflow,
    this.fontFamily,
    this.underline,
    this.decorationColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title!,
        textAlign: textAlign ?? TextAlign.left,
        style: TextStyle(
          color: color ?? Colors.black,
          fontFamily: fontFamily ?? 'GilroyRegular',
          fontSize: size,
          fontWeight: weight ?? FontWeight.normal,
          overflow: overflow,
          height: height ?? 1.2,
          decorationColor: decorationColor,
          decoration: underline ?? TextDecoration.none,
        ));
  }
}
