import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/data/model/user_profile.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';

class ProfileHeader extends StatelessWidget {
  final UserDataWithFollowers userData;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;

  const ProfileHeader({
    Key? key,
    required this.userData,
    required this.onBackPressed,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        _buildCoverImage(),
        _buildProfilePicture(),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildCoverImage() {
    return userData.profile?.cover == null
        ? Container(
            height: Get.height * 0.15,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/png/account_header.png'),
                  opacity: 0.2),
            ),
          )
        : GestureDetector(
            onTap: () => Helpers()
                .showImagePopup(Get.context!, "${userData.profile!.cover}"),
            child: CachedNetworkImage(
              height: Get.height * 0.15,
              width: double.infinity,
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: SizedBox(
                  height: Get.height * 0.05,
                  width: Get.height * 0.05,
                  child: CircularProgressIndicator(
                      color: AppColor().primaryWhite, value: progress.progress),
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: AppColor().primaryColor),
              imageUrl: '${userData.profile!.cover}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover, opacity: 0.6),
                ),
              ),
            ),
          );
  }

  Widget _buildProfilePicture() {
    return Positioned(
      top: Get.height * 0.11,
      child: GestureDetector(
        onTap: () => Helpers().showImagePopup(
            Get.context!, "${userData.profile!.profilePicture}"),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            OtherImage(
              itemSize: Get.height * 0.11,
              image: userData.profile!.profilePicture,
            ),
            if (userData.isVerified! == true)
              SvgPicture.asset("assets/images/svg/check_badge.svg")
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Positioned(
      right: Get.height * 0.03,
      left: Get.height * 0.03,
      top: Get.height * 0.02,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBackPressed,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColor().primaryWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: AppColor().primaryWhite,
              ),
            ),
          ),
          InkWell(
            onTap: onMenuPressed,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColor().primaryWhite.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.more_vert,
                size: 20,
                color: AppColor().primaryWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileUserInfo extends StatelessWidget {
  final UserDataWithFollowers userData;

  const ProfileUserInfo({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(Get.height * 0.09),
        CustomText(
          title: '@ ${userData.userName}',
          size: 16,
          fontFamily: 'Inter',
          textAlign: TextAlign.start,
          color: AppColor().lightItemsColor,
        ),
        Gap(Get.height * 0.01),
        CustomText(
          title: userData.fullName!.toCapitalCase(),
          size: 20,
          fontFamily: 'InterBold',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.02),
      ],
    );
  }
}
