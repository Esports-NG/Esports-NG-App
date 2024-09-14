import 'dart:convert';

import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final int? maxLines;
  const CustomText(
      {Key? key,
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
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Linkify(
        onOpen: (link) async {
          await launchUrl(Uri.parse(link.url));
        },
        linkStyle: TextStyle(
          color: AppColor().primaryColor,
          fontFamily: fontFamily ?? 'Inter',
          fontSize: size,
          fontWeight: weight ?? FontWeight.normal,
          overflow: overflow,
          // height: height ?? 1.2,
          decorationColor: decorationColor,
          decoration: underline ?? TextDecoration.none,
        ),
        text: utf8.decode(title!.runes.toList(), allowMalformed: true),
        textAlign: textAlign ?? TextAlign.left,
        maxLines: maxLines,
        style: TextStyle(
          color: color ?? Colors.black,
          fontFamily: fontFamily ?? 'Inter',
          fontSize: size,
          fontWeight: weight ?? FontWeight.normal,
          overflow: overflow,
          height: height ?? 1.2,
          decorationColor: decorationColor,
          decoration: underline ?? TextDecoration.none,
        ));
  }
}
