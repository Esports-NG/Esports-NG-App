import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/components/post_widget.dart';
import 'package:e_sport/ui/leaderboard/leaderboard.dart';
import 'package:e_sport/ui/messages/messages.dart';
import 'package:e_sport/ui/notification/notification.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? categoryType = 0;
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 2), () {
            postController.getAllPost();
          });
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(Get.height * 0.02),
              child: Column(
                children: [
                  Gap(Get.height * 0.06),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/png/account.png',
                            height: Get.height * 0.05,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => const Messages());
                            },
                            child: Badge(
                              label: CustomText(
                                title: '4',
                                weight: FontWeight.w500,
                                size: 10,
                                fontFamily: 'GilroyBold',
                                color: AppColor().primaryWhite,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/svg/chat.svg',
                                height: Get.height * 0.025,
                              ),
                            ),
                          ),
                          Gap(Get.height * 0.04),
                          InkWell(
                            onTap: () {
                              Get.to(() => const Leaderboard());
                            },
                            child: SvgPicture.asset(
                              'assets/images/svg/leaderboard.svg',
                              height: Get.height * 0.025,
                            ),
                          ),
                          Gap(Get.height * 0.04),
                          InkWell(
                            onTap: () {
                              Get.to(() => const NotificationPage());
                            },
                            child: Badge(
                              label: CustomText(
                                title: '10',
                                weight: FontWeight.w500,
                                size: 10,
                                fontFamily: 'GilroyBold',
                                color: AppColor().primaryWhite,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/svg/notification.svg',
                                height: Get.height * 0.025,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.025),
                  SizedBox(
                    height: Get.height * 0.06,
                    child: CustomTextField(
                      hint: "Search for gaming news, competitions...",
                      fontFamily: 'GilroyMedium',
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColor().lightItemsColor,
                      ),
                      textEditingController: authController.searchController,
                      hasText: isSearch!,
                      focusNode: _searchFocusNode,
                      onTap: handleTap,
                      onSubmited: (_) {
                        _searchFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isSearch = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Gap(Get.height * 0.025),
                  categoryWidget(),
                  Gap(Get.height * 0.02),
                  categoryType == 0 ? const PostWidget() : Container(),
                ],
              ),
            )),
      ),
    );
  }

  SizedBox categoryWidget() {
    return SizedBox(
      height: Get.height * 0.045,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        shrinkWrap: false,
        itemCount: categoryItem.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.05),
        itemBuilder: (context, index) {
          var item = categoryItem[index];
          return InkWell(
            onTap: () {
              setState(() {
                categoryType = index;
              });
            },
            child: Center(
              child: Column(
                children: [
                  CustomText(
                    title: item.title,
                    size: 13,
                    fontFamily:
                        categoryType == index ? 'GilroyBold' : 'GilroyMedium',
                    weight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    color: categoryType == index
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  Container(
                    width: Get.height * 0.08,
                    height: 1.5,
                    color: categoryType == index
                        ? AppColor().primaryColor
                        : AppColor().primaryBackGroundColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
