import 'package:e_sport/data/model/transaction_model.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'deposit.dart';
import '../../widgets/wallet/transaction_history_item.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: GoBackButton(onPressed: () => Get.back()),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/png/wallettopbg.png',
                      ),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.15,
                    left: Get.height * 0.02,
                    right: Get.height * 0.02,
                    bottom: Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        title: "Total Balance",
                        size: 18,
                        color: AppColor().greyTwo,
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Center(
                      child: CustomText(
                        size: 32,
                        fontFamily: "InterSemiBold",
                        color: AppColor().primaryWhite,
                        title: "N3,543,090.00",
                      ),
                    ),
                    Gap(Get.height * 0.04),
                    Row(
                      children: [
                        options(
                            title: 'Deposit',
                            color: Colors.white.withOpacity(0.05),
                            onTap: () => Get.to(() => const Deposit())),
                        Gap(Get.height * 0.02),
                        options(
                          title: 'Withdraw',
                          color: Colors.white.withOpacity(0.05),
                        ),
                        Gap(Get.height * 0.02),
                        options(
                          title: 'Transfer',
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap(Get.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: 'Transaction History',
                    color: AppColor().greyTwo,
                    size: 18,
                    fontFamily: 'InterSemiBold',
                  ),
                  Gap(Get.height * 0.02),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactionHistory.length,
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.01),
                    itemBuilder: (context, index) {
                      var item = transactionHistory[index];
                      return InkWell(
                        onTap: () {
                          // Get.to(
                          //   () => PostDetails(
                          //     item: item,
                          //   ),
                          // );
                        },
                        child: TransactionHistoryItem(item: item),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  options(
      {String? title, Color? color, BoxBorder? border, VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: Get.height * 0.06,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color,
              border: border ?? Border.all(color: AppColor().greyEight)),
          child: Center(
            child: CustomText(
              title: title,
              color: AppColor().primaryWhite,
              size: Get.height * 0.016,
              fontFamily: 'InterSemiBold',
            ),
          ),
        ),
      ),
    );
  }
}
