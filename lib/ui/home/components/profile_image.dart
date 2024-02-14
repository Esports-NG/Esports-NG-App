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
  const OtherImage({super.key, this.itemSize, required this.image});

  @override
  State<OtherImage> createState() => _OtherImageState();
}

class _OtherImageState extends State<OtherImage> {
  @override
  Widget build(BuildContext context) {
    return (widget.image == null)
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
  }
}

class CoverImage extends StatefulWidget {
  final double? height, width;
  final String? image;
  const CoverImage({super.key, this.height, this.width, required this.image});

  @override
  State<CoverImage> createState() => _CoverImageState();
}

class _CoverImageState extends State<CoverImage> {
  @override
  Widget build(BuildContext context) {
    return (widget.image == null)
        ? Container(
            height: widget.height ?? Get.height * 0.05,
            width: widget.width ?? Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/png/team_cover.png'),
                  fit: BoxFit.cover,
                  opacity: 0.2),
            ),
            // child: SvgPicture.asset(
            //   'assets/images/svg/people.svg',
            // ),
          )
        : CachedNetworkImage(
            height: widget.height ?? Get.height * 0.05,
            width: widget.width ?? Get.width,
            // placeholder: (context, url) => const CircularProgressIndicator(),
            // errorWidget: (context, url, error) => const Icon(Icons.error),
            imageUrl: widget.image!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image!),
                    fit: BoxFit.cover,
                    opacity: 0.2),
              ),
            ),
          );
  }
}
