import 'package:e_sport/data/db/chat_database.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/ui/screens/account/messages/message_type/chats/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProfileActionButtons extends StatelessWidget {
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback onFollowTap;
  final UserModel user;

  const ProfileActionButtons(
      {Key? key,
      required this.isFollowing,
      required this.isLoading,
      required this.onFollowTap,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFillOption(
            buttonColor: isLoading ? Colors.transparent : null,
            onTap: onFollowTap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isLoading
                    ? [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColor().primaryColor,
                            strokeCap: StrokeCap.round,
                            strokeWidth: 2,
                          ),
                        ),
                      ]
                    : [
                        Icon(
                          IconsaxPlusLinear.profile,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: isFollowing ? "Unfollow" : 'Follow',
                            size: 14,
                            fontFamily: 'Inter',
                            color: AppColor().primaryWhite),
                      ]),
          ),
        ),
        Gap(Get.height * 0.02),
        Expanded(
          child: CustomFillOption(
            buttonColor: AppColor().primaryBackGroundColor.withOpacity(0.7),
            borderColor: AppColor().greyEight,
            onTap: () => Get.to(() => ChatPage(
                chat: Chat(
                    name: user.fullName!,
                    slug: user.slug!,
                    image: user.profile?.profilePicture,
                    username: user.userName))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                IconsaxPlusLinear.message,
                color: AppColor().primaryWhite,
                size: 16,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                  title: 'Message',
                  size: 14,
                  fontFamily: 'Inter',
                  color: AppColor().primaryWhite),
            ]),
          ),
        ),
      ],
    );
  }
}
