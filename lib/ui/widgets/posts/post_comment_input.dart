import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class PostCommentInput extends StatefulWidget {
  final String slug;
  final AuthRepository authController;
  final PostRepository postController;

  const PostCommentInput({
    Key? key,
    required this.slug,
    required this.authController,
    required this.postController,
  }) : super(key: key);

  @override
  State<PostCommentInput> createState() => _PostCommentInputState();
}

class _PostCommentInputState extends State<PostCommentInput> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      color: AppColor().chatArea,
      child: Row(
        children: [
          OtherImage(
            itemSize: Get.height * 0.03,
            image: widget.authController.user!.profile!.profilePicture,
          ),
          Gap(Get.height * 0.01),
          Expanded(
              child: ChatCustomTextField(
            textEditingController: widget.authController.chatController,
            decoration: InputDecoration(
              hintText: "Leave your thoughts here...",
              fillColor: Colors.transparent,
              filled: true,
              isDense: true,
              border: InputBorder.none,
              labelStyle: TextStyle(
                color: AppColor().primaryWhite,
                fontSize: 12.sp,
                letterSpacing: -0.32,
                fontFamily: 'Inter',
              ),
              hintStyle: TextStyle(
                color: AppColor().primaryWhite,
                fontSize: 12.sp,
                letterSpacing: -0.32,
                fontFamily: 'Inter',
              ),
            ),
          )),
          Gap(Get.height * 0.01),
          InkWell(
            onTap: _isLoading
                ? null
                : () {
                    if (widget.authController.chatController.text != '') {
                      setState(() {
                        _isLoading = true;
                      });

                      widget.postController
                          .commentOnPost(widget.slug)
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });

                        if (widget.postController.postStatus ==
                            PostStatus.success) {
                          widget.authController.chatController.clear();
                        }
                      });
                    }
                  },
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor().primaryColor,
                    ),
                  )
                : Icon(IconsaxPlusLinear.send_1,
                    color: AppColor().primaryColor),
          ),
        ],
      ),
    );
  }
}
