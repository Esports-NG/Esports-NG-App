import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/ui/account/games_played/edit_player_profile.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GamesPlayedItem extends StatefulWidget {
  final PlayerModel item;
  const GamesPlayedItem({super.key, required this.item});

  @override
  State<GamesPlayedItem> createState() => _GamesPlayedItemState();
}

class _GamesPlayedItemState extends State<GamesPlayedItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.item.profile == null)
              ? Container(
                  height: Get.height * 0.15,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/png/placeholder.png'),
                        fit: BoxFit.cover),
                  ),
                )
              : CachedNetworkImage(
                  height: Get.height * 0.15,
                  width: double.infinity,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: Get.height * 0.05,
                      width: Get.height * 0.05,
                      child: CircularProgressIndicator(
                          color: AppColor().primaryColor,
                          value: progress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: AppColor().primaryColor),
                  imageUrl: widget.item.profile,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: DecorationImage(
                          image: NetworkImage(widget.item.profile),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Stack(
              children: [
                Column(
                  children: [
                    textItem(
                        title: 'Game: ',
                        subTitle: widget.item.gamePlayed!.name
                    ),
                    Gap(Get.height * 0.01),
                    textItem(
                      title: 'IGN: ',
                      subTitle: widget.item.inGameName ?? "",
                    ),
                    Gap(Get.height * 0.01),
                    textItem(
                      title: 'Game ID: ',
                      subTitle: widget.item.inGameId ?? "",
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CustomFillButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      EditPlayerProfile(player: widget.item)));
                        },
                        buttonText: 'Edit',
                        width: 80,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row textItem({String? title, subTitle}) {
    return Row(
      children: [
        CustomText(
          title: title,
          size: 12,
          fontFamily: 'Inter',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
        CustomText(
          title: subTitle,
          size: 12,
          fontFamily: 'InterSemiBold',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
      ],
    );
  }
}
