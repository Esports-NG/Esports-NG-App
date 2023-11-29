import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileImage extends StatefulWidget {
  final double? itemSize;
  const ProfileImage({super.key, this.itemSize});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return authController.user!.profile!.profilePicture == null
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
              imageUrl: authController.user!.profile!.profilePicture,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          authController.user!.profile!.profilePicture),
                      fit: BoxFit.cover),
                ),
              ),
            );
    });
  }
}
