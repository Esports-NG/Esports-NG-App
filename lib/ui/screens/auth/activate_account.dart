import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({super.key});

  @override
  State<ActivateAccount> createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  final authController = Get.put(AuthRepository());
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GoBackButton(onPressed: () => Get.back()),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Request Account Activation Link",
                      color: AppColor().primaryWhite,
                      fontFamily: "InterSemiBold",
                      size: 18,
                    ),
                    Gap(Get.height * 0.02),
                    CustomTextField(
                      textEditingController: _emailController,
                      hint: "Enter your email address",
                    ),
                    Gap(Get.height * 0.03),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isSending = true;
                        });
                        await authController
                            .sendActivationLink(_emailController.text);
                        setState(() {
                          _isSending = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor().primaryColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: _isSending
                            ? Center(
                                child: ButtonLoader(
                                color: AppColor().primaryWhite,
                              ))
                            : Center(
                                child: CustomText(
                                title: "Send Activation Email",
                                color: AppColor().primaryWhite,
                                size: 16,
                                fontFamily: "InterSemiBold",
                              )),
                      ),
                    )
                  ],
                ))));
  }
}
