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
import 'package:number_display/number_display.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final authController = Get.put(AuthRepository());
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _cardNoFocusNode = FocusNode();
  final FocusNode _cardExpiryFocusNode = FocusNode();
  final FocusNode _cvvFocusNode = FocusNode();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isAmount = false, isCardNo = false, isCardExpiry = false, isCvv = false;
  int? cardSelect;
  int pageCount = 0;

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _cardNoFocusNode.dispose();
    _cardExpiryFocusNode.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'amount') {
      setState(() {
        isAmount = true;
      });
    } else if (title == 'cardNo') {
      setState(() {
        isCardNo = true;
      });
    } else if (title == 'cardExpiry') {
      setState(() {
        isCardExpiry = true;
      });
    } else {
      setState(() {
        isCvv = true;
      });
    }
  }

  final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Deposit',
          fontFamily: "InterSemiBold",
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            if (pageCount > 0) {
              setState(() {
                --pageCount;
                debugPrint('PageCount: $pageCount');
              });
            } else {
              Get.back();
              authController.amountController.clear();
              authController.cardExpiryController.clear();
              authController.cardNoController.clear();
              authController.cvvController.clear();
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().primaryWhite,
          ),
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
              if (pageCount == 0) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hint: "Enter Amount",
                      textEditingController: authController.amountController,
                      hasText: isAmount,
                      focusNode: _amountFocusNode,
                      onTap: () {
                        handleTap('amount');
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
                        } else if (!RegExp(r'^[0-9]+$')
                            .hasMatch(value.trim())) {
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
                      fontFamily: 'InterMedium',
                      size: Get.height * 0.019,
                    ),
                    Gap(Get.height * 0.02),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: paymentMethodItem.length,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.02),
                      itemBuilder: (context, index) {
                        var item = paymentMethodItem[index];
                        return InkWell(
                          onTap: () {
                            if (authController.amountController.text == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomText(
                                    title: 'enter amount to proceed!',
                                    size: Get.height * 0.02,
                                    color: AppColor().primaryWhite,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                cardSelect = index;
                                pageCount++;
                              });
                            }
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
                                right:
                                    cardSelect == index ? Get.height * 0.02 : 0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        fontFamily: 'InterMedium',
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
                ),
              ] else if (pageCount == 1) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Card Number',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "0000 0000 0000 0000",
                        textEditingController: authController.cardNoController,
                        hasText: isCardNo,
                        focusNode: _cardNoFocusNode,
                        onTap: () {
                          handleTap('cardNo');
                        },
                        onSubmited: (_) {
                          _cardNoFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isCardNo = value.isNotEmpty;
                          });
                        },
                        validate: (value) {
                          if (value!.trim().isEmpty) {
                            return 'card no must not be empty';
                          } else if (!RegExp(r'^[0-9]+$')
                              .hasMatch(value.trim())) {
                            return "Please enter only digits";
                          }
                          return null;
                        },
                      ),
                      Gap(Get.height * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: 'Card Expiry',
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'Inter',
                                  size: Get.height * 0.017,
                                ),
                                Gap(Get.height * 0.01),
                                CustomTextField(
                                  hint: "MM / YY",
                                  textEditingController:
                                      authController.cardExpiryController,
                                  hasText: isCardExpiry,
                                  focusNode: _cardExpiryFocusNode,
                                  onTap: () {
                                    handleTap('cardExpiry');
                                  },
                                  onSubmited: (_) {
                                    _cardExpiryFocusNode.unfocus();
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      isCardExpiry = value.isNotEmpty;
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'field must not be empty';
                                    } else if (!RegExp(r'^[0-9]+$')
                                        .hasMatch(value.trim())) {
                                      return "Please enter only digits";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Gap(Get.height * 0.02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: 'CVV',
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'Inter',
                                  size: Get.height * 0.017,
                                ),
                                Gap(Get.height * 0.01),
                                CustomTextField(
                                  hint: "123",
                                  textEditingController:
                                      authController.cvvController,
                                  hasText: isCvv,
                                  focusNode: _cvvFocusNode,
                                  onTap: () {
                                    handleTap('cvv');
                                  },
                                  onSubmited: (_) {
                                    _cvvFocusNode.unfocus();
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      isCvv = value.isNotEmpty;
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'cvv must not be empty';
                                    } else if (!RegExp(r'^[0-9]+$')
                                        .hasMatch(value.trim())) {
                                      return "Please enter only digits";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.03),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()
                              // &&
                              //     authController.signInStatus != SignInStatus.loading
                              ) {
                            setState(() {
                              pageCount++;
                            });
                            // Get.offAll(() => const Dashboard());
                          }
                        },
                        child: Container(
                          height: Get.height * 0.07,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor().primaryColor,
                          ),
                          child:

                              // (authController.signInStatus == SignInStatus.loading)
                              //     ? const LoadingWidget()
                              //     :
                              Center(
                                  child: CustomText(
                            title:
                                'Pay N${display(int.tryParse(authController.amountController.text))}',
                            color: AppColor().primaryWhite,
                            fontFamily: "InterSemiBold",
                            size: Get.height * 0.018,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      title:
                          'Transfer N${display(int.tryParse(authController.amountController.text))} to Wema Payment Checkout',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'InterMedium',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.02),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Get.height * 0.03),
                      decoration: BoxDecoration(
                        color: AppColor().primaryModalColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: 'BANK NAME',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'Inter',
                            size: Get.height * 0.01,
                          ),
                          Gap(Get.height * 0.01),
                          CustomText(
                            title: 'Wema Bank',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'InterMedium',
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: 'ACCOUNT NUMBER',
                                    color: AppColor().primaryWhite,
                                    textAlign: TextAlign.center,
                                    fontFamily: 'Inter',
                                    size: Get.height * 0.01,
                                  ),
                                  Gap(Get.height * 0.01),
                                  CustomText(
                                    title: '01234567890',
                                    color: AppColor().primaryWhite,
                                    textAlign: TextAlign.center,
                                    fontFamily: 'InterMedium',
                                    size: Get.height * 0.017,
                                  ),
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/images/svg/copy-linear.svg',
                                height: Get.height * 0.03,
                              )
                            ],
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'AMOUNT',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'Inter',
                            size: Get.height * 0.01,
                          ),
                          Gap(Get.height * 0.01),
                          CustomText(
                            title:
                                'N${display(int.tryParse(authController.amountController.text))}',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'InterMedium',
                            size: Get.height * 0.017,
                          ),
                        ],
                      ),
                    ),
                    Gap(Get.height * 0.03),
                    SvgPicture.asset(
                      'assets/images/svg/transfer.svg',
                      height: Get.height * 0.06,
                    ),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: 'Expires in 15:00',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'Inter',
                      size: Get.height * 0.01,
                    ),
                    Gap(Get.height * 0.03),
                    InkWell(
                      onTap: () {
                        Get.back();
                        authController.amountController.clear();
                        authController.cardExpiryController.clear();
                        authController.cardNoController.clear();
                        authController.cvvController.clear();
                      },
                      child: Container(
                        height: Get.height * 0.07,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor().primaryColor,
                        ),
                        child: Center(
                            child: CustomText(
                          title: 'I’ve sent the money',
                          color: AppColor().primaryWhite,
                          fontFamily: 'Inter',
                          size: Get.height * 0.015,
                        )),
                      ),
                    )
                  ],
                )
              ],
            ],
          )),
    );
  }
}
