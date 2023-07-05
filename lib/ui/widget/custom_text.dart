import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String? title;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  const CustomText({
    Key? key,
    this.title,
    this.size,
    this.color,
    this.weight,
    this.height,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title!,
        textAlign: textAlign ?? TextAlign.left,
        style: GoogleFonts.inter(
            textStyle: TextStyle(
          color: color ?? Colors.black,
          fontSize: size,
          fontWeight: weight ?? FontWeight.normal,
          overflow: overflow,
        )));
  }
}

class CustomTextRoboto extends StatelessWidget {
  final String? title;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  const CustomTextRoboto({
    Key? key,
    this.title,
    this.size,
    this.color,
    this.weight,
    this.height,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title ?? "",
        textAlign: textAlign ?? TextAlign.left,
        style: GoogleFonts.roboto(
            textStyle: TextStyle(
          color: color ?? Colors.black,
          fontSize: size,
          fontWeight: weight ?? FontWeight.normal,
          overflow: overflow,
        )));
  }
}

class CustomTextRobotoSlab extends StatelessWidget {
  final String? title;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  const CustomTextRobotoSlab({
    Key? key,
    this.title,
    this.size,
    this.color,
    this.weight,
    this.height,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title ?? "",
        textAlign: textAlign ?? TextAlign.left,
        style: GoogleFonts.robotoSlab(
            textStyle: TextStyle(
          color: color ?? Colors.black,
          fontSize: size,
          fontWeight: weight ?? FontWeight.normal,
          overflow: overflow,
        )));
  }
}
