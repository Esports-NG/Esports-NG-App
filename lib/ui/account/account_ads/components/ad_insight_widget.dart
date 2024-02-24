import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/account/account_ads/components/overview_widget.dart';
import 'package:e_sport/ui/home/post/components/repost_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/ui/home/post/components/repost_details.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdInsight extends StatefulWidget {
  const AdInsight({super.key, required this.item});
  final PostModel item;

  @override
  State<AdInsight> createState() => _AdInsightState();
}

class _AdInsightState extends State<AdInsight> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          textAlign: TextAlign.center,
          title: 'Ad Insight',
          fontFamily: "GilroySemiBold",
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
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: CustomText(
              title: widget.item.body,
              color: AppColor().primaryWhite,
            ),
          ),
          Gap(Get.height * 0.01),
          (widget.item.repost != null)
              ? InkWell(
                  onTap: () {
                    debugPrint('okay');
                    Get.to(() => RepostDetails(item: widget.item));
                  },
                  child: RepostItem(item: widget.item))
              : Stack(
                  children: [
                    widget.item.image == null
                        ? Container()
                        : CachedNetworkImage(
                            height: Get.height * 0.25,
                            width: double.infinity,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: SizedBox(
                                height: Get.height * 0.05,
                                width: Get.height * 0.05,
                                child: CircularProgressIndicator(
                                    color: AppColor().primaryWhite,
                                    value: progress.progress),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: AppColor().primaryWhite),
                            imageUrl: widget.item.image!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.item.image!),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                    Positioned.fill(
                      left: Get.height * 0.02,
                      bottom: Get.height * 0.02,
                      top: Get.height * 0.19,
                      child: SizedBox(
                        height: Get.height * 0.03,
                        child: ListView.separated(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.item.tags!.length,
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.01),
                            itemBuilder: (context, index) {
                              var items = widget.item.tags![index];
                              return Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      AppColor().primaryDark.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColor()
                                        .primaryColor
                                        .withOpacity(0.05),
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: CustomText(
                                    title: items.title,
                                    color: AppColor().primaryWhite,
                                    textAlign: TextAlign.center,
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyBold',
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
          Container(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "September 27th - October 3rd 2023",
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                  size: 18,
                ),
                Gap(Get.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          color: AppColor().primaryWhite,
                        ),
                        const Gap(5),
                        CustomText(
                          title: "${widget.item.likeCount}",
                          color: AppColor().primaryWhite,
                          size: 16,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.message_outlined,
                          color: AppColor().primaryWhite,
                        ),
                        const Gap(5),
                        CustomText(
                          title: "${widget.item.comment?.length}",
                          color: AppColor().primaryWhite,
                          size: 16,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: AppColor().primaryWhite,
                        ),
                        const Gap(5),
                        CustomText(
                          title: "5",
                          color: AppColor().primaryWhite,
                          size: 16,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          color: AppColor().primaryWhite,
                        ),
                        const Gap(5),
                        CustomText(
                          title: "10",
                          color: AppColor().primaryWhite,
                          size: 16,
                        )
                      ],
                    ),
                  ],
                ),
                Gap(Get.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        title: "Promoted to:",
                        color: AppColor().primaryWhite,
                        size: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor().primaryGreen),
                          borderRadius: BorderRadius.circular(999)),
                      child: CustomText(
                        title: "Notification",
                        fontFamily: "GilroySemiBold",
                        color: AppColor().primaryGreen,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor().primaryGreen),
                          borderRadius: BorderRadius.circular(999)),
                      child: CustomText(
                        title: "Messages",
                        fontFamily: "GilroySemiBold",
                        color: AppColor().primaryGreen,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor().primaryGreen),
                          borderRadius: BorderRadius.circular(999)),
                      child: CustomText(
                        title: "Comments",
                        fontFamily: "GilroySemiBold",
                        color: AppColor().primaryGreen,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Gap(Get.height * 0.01),
          const Overview(),
          Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              children: [
                Center(
                  child: CustomText(
                    title: "Are you satisfied with the results of this ad?",
                    color: AppColor().primaryWhite,
                  ),
                ),
                Gap(Get.height * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: AppColor().primaryColor,
                                borderRadius: BorderRadius.circular(999)),
                            child: Center(
                              child: CustomText(
                                  title: "Yes",
                                  fontFamily: "GilroySemibold",
                                  size: 18,
                                  color: AppColor().primaryWhite),
                            )),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Expanded(
                      child: InkWell(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColor().primaryColor),
                                borderRadius: BorderRadius.circular(999)),
                            child: Center(
                              child: CustomText(
                                  title: "No",
                                  fontFamily: "GilroySemibold",
                                  size: 18,
                                  color: AppColor().primaryColor),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
