import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final authController = Get.put(AuthRepository());
  final FocusNode _amountFocusNode = FocusNode();
  bool isAmount = false;
  int? cardSelect;

  @override
  void dispose() {
    _amountFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    setState(() {
      isAmount = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Deposit',
          weight: FontWeight.w600,
          size: 18,
          color: AppColor().primaryWhite,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColor().primaryWhite,
            ),
          ),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hint: "Enter Amount",
                textEditingController: authController.amountController,
                hasText: isAmount,
                focusNode: _amountFocusNode,
                onTap: () {
                  handleTap('email');
                },
                onSubmited: (_) {
                  _amountFocusNode.unfocus();
                },
                onChanged: (value) {
                  setState(() {
                    isAmount = value.isNotEmpty;
                  });
                },
                validate: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Phone no must not be empty';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return "Please enter only digits";
                  }
                  return null;
                },
              ),
              Gap(Get.height * 0.05),
              CustomText(
                title: 'Select Payment Method',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyMedium',
                size: Get.height * 0.019,
              ),
              Gap(Get.height * 0.02),
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: paymentMethodItem.length,
                separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                itemBuilder: (context, index) {
                  var item = paymentMethodItem[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        cardSelect = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(Get.height * 0.02),
                      decoration: BoxDecoration(
                          color: cardSelect == index
                              ? AppColor().primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: cardSelect == index ? Get.height * 0.02 : 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  item.image!,
                                  height: Get.height * 0.025,
                                ),
                                Gap(Get.height * 0.02),
                                CustomText(
                                  title: item.name,
                                  color: AppColor().greyTwo,
                                  weight: FontWeight.w400,
                                  fontFamily: 'GilroyMedium',
                                  size: Get.height * 0.015,
                                ),
                              ],
                            ),
                            if (cardSelect == index)
                              SmallCircle(
                                  size: Get.height * 0.015,
                                  color: AppColor().primaryWhite),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
