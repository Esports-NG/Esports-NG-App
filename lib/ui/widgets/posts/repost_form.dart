import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RepostForm extends StatelessWidget {
  final int postId;
  final AuthRepository authController;
  final PostRepository postController;
  final GlobalKey<FormState> formKey;
  final Function() onCancel;

  const RepostForm({
    Key? key,
    required this.postId,
    required this.authController,
    required this.postController,
    required this.formKey,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onCancel,
              child: Icon(
                Icons.close,
                color: AppColor().primaryWhite,
              ),
            ),
            CustomFillButton(
              buttonText: 'Repost',
              textSize: Get.height * 0.015,
              width: Get.width * 0.25,
              height: Get.height * 0.04,
              onTap: () {
                if (formKey.currentState!.validate() &&
                    postController.postStatus != PostStatus.loading) {
                  postController.rePost(postId, 'quote').then((value) {
                    onCancel();
                  });
                }
              },
              isLoading: false,
            ),
          ],
        ),
        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomTextField(
            hint: "Add your comment",
            textEditingController: authController.commentController,
            fillColor: AppColor().primaryBackGroundColor,
            colors: AppColor().primaryBackGroundColor,
            keyType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            keyAction: TextInputAction.newline,
            validate: Validator.isName,
          ),
        )
      ],
    );
  }
}
