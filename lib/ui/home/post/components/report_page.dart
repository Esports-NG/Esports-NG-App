import 'package:change_case/change_case.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, required this.id, required this.type});

  final String type;
  final int id;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController offenseTitleController = TextEditingController();
  TextEditingController offenseDescriptionController = TextEditingController();
  final postController = Get.put(PostRepository());
  final authController = Get.put(AuthRepository());
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          title: "Report ${widget.type.toCapitalCase()}",
          color: AppColor().primaryWhite,
          weight: FontWeight.w600,
          size: 20,
        ),
        centerTitle: true,
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: "Title of Offense",
              color: AppColor().primaryWhite,
              weight: FontWeight.w600,
              size: 16,
            ),
            const Gap(10),
            CustomTextField(
              textEditingController: offenseTitleController,
              hint: "Abusive Post",
            ),
            const Gap(20),
            CustomText(
              title: "Offense Description",
              color: AppColor().primaryWhite,
              weight: FontWeight.w600,
              size: 16,
            ),
            const Gap(10),
            CustomTextField(
              textEditingController: offenseDescriptionController,
              hint: "Describe the offense",
              maxLines: 4,
              minLines: 4,
            ),
            const Gap(30),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isSubmitting = true;
                });
                await postController.reportPost(
                    authController.user!.id!,
                    widget.id,
                    offenseTitleController.text,
                    offenseDescriptionController.text,
                    widget.type,
                    "user");
                setState(() {
                  _isSubmitting = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: _isSubmitting ? null : AppColor().primaryColor,
                    borderRadius: BorderRadius.circular(90)),
                child: Center(
                  child: _isSubmitting
                      ? const ButtonLoader()
                      : CustomText(
                          title: "Submit Report",
                          color: AppColor().primaryWhite,
                          weight: FontWeight.w600,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
