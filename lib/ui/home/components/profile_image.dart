import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileImage extends StatefulWidget {
  final double? itemSize;
  final String? image;
  const ProfileImage({super.key, this.itemSize, required this.image});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.image == null
          ? Container(
              height: widget.itemSize ?? Get.height * 0.05,
              width: widget.itemSize ?? Get.height * 0.05,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/images/svg/people.svg',
              ),
            )
          : CachedNetworkImage(
              height: widget.itemSize ?? Get.height * 0.05,
              width: widget.itemSize ?? Get.height * 0.05,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: widget.image!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.image!), fit: BoxFit.cover),
                ),
              ),
            );
    });
  }
}

class OtherImage extends StatefulWidget {
  final double? itemSize;
  final String? image;
  final double? width;
  final double? height;
  final String? asset;
  final bool? isCover;
  const OtherImage(
      {super.key,
      this.itemSize,
      this.asset,
      this.width,
      this.height,
      this.isCover,
      required this.image});

  @override
  State<OtherImage> createState() => _OtherImageState();
}

class _OtherImageState extends State<OtherImage> {
  @override
  Widget build(BuildContext context) {
    return (widget.image == null)
        ? Container(
            height: widget.height ?? widget.itemSize ?? Get.height * 0.05,
            width: widget.width ?? widget.itemSize ?? Get.height * 0.05,
            decoration: BoxDecoration(
                shape:
                    widget.asset != null ? BoxShape.rectangle : BoxShape.circle,
                image: widget.asset != null
                    ? DecorationImage(
                        image: AssetImage(widget.asset!), fit: BoxFit.cover)
                    : null,
                borderRadius:
                    widget.asset != null ? BorderRadius.circular(10) : null),
            child: widget.asset != null
                ? null
                : SvgPicture.asset(
                    'assets/images/svg/people.svg',
                  ),
          )
        : CachedNetworkImage(
            height: widget.height ?? widget.itemSize ?? Get.height * 0.05,
            width: widget.width ?? widget.itemSize ?? Get.height * 0.05,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageUrl: widget.image!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius:
                    widget.isCover == true ? BorderRadius.circular(10) : null,
                shape: widget.isCover == true
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(widget.image!), fit: BoxFit.cover),
              ),
            ),
          );
  }
}
