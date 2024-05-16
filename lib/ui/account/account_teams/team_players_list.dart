import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamPlayersList extends StatefulWidget {
  const TeamPlayersList({super.key, required this.item});

  final TeamModel item;

  @override
  State<TeamPlayersList> createState() => _TeamPlayersListState();
}

class _TeamPlayersListState extends State<TeamPlayersList> {
  List<bool> _isOpen = [false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            CachedNetworkImage(
              imageUrl: widget.item.profilePicture!,
              imageBuilder: (context, imageProvider) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                    borderRadius: BorderRadius.circular(999)),
              ),
            ),
            Gap(Get.height * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: widget.item.name,
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                  size: 16,
                ),
                CustomText(
                  title: "Players",
                  color: AppColor().primaryWhite.withOpacity(0.5),
                  // fontFamily: "GilroySemiBold",
                  size: 14,
                )
              ],
            )
          ]),
          leading: GoBackButton(
            onPressed: () => Get.back(),
          )),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
        child: Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) => setState(() {
                _isOpen[panelIndex] = isExpanded;
              }),
              expandIconColor: AppColor().primaryColor,
              children: [
                ExpansionPanel(
                    isExpanded: _isOpen[0],
                    backgroundColor: AppColor().primaryBackGroundColor,
                    headerBuilder: (context, isExpanded) => Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: ApiLink.imageUrl +
                                  widget.item.gamePlayed!.profilePicture!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                        color: AppColor()
                                            .primaryWhite
                                            .withOpacity(0.5)),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: widget.item.gamePlayed!.name!,
                              color: AppColor().primaryWhite,
                              fontFamily: "GilroySemiBold",
                              size: 16,
                            )
                          ],
                        ),
                    body: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                title: "S/N",
                                color: AppColor().primaryWhite,
                                fontFamily: "GilroyMedium",
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Center(
                                  child: CustomText(
                                    title: "PP",
                                    color: AppColor().primaryWhite,
                                  ),
                                )),
                            Expanded(
                              flex: 8,
                              child: CustomText(
                                title: "PlayerName",
                                color: AppColor().primaryWhite,
                                fontFamily: "GilroyMedium",
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.edit_square,
                                  color: AppColor().primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 0.3,
                          color: AppColor().darkGrey,
                        ),
                        PlayerRow(),
                        Gap(Get.height * 0.01),
                        PlayerRow(),
                        Gap(Get.height * 0.01),
                        PlayerRow(),
                        Gap(Get.height * 0.02),
                        CustomText(
                          title: "See more",
                          underline: TextDecoration.underline,
                          color: AppColor().primaryColor,
                          decorationColor: AppColor().primaryColor,
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }
}

class PlayerRow extends StatelessWidget {
  const PlayerRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomText(
            title: 1.toString(),
            color: AppColor().primaryWhite,
            fontFamily: "GilroyMedium",
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            // width: 30,
            height: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(99),
                color: AppColor().greySix),
          ),
        ),
        Expanded(
          flex: 8,
          child: CustomText(
            title: "Alucard234",
            color: AppColor().primaryWhite,
            fontFamily: "GilroyMedium",
          ),
        ),
        Expanded(
          flex: 0,
          child: GestureDetector(
            child: Icon(
              Icons.edit_square,
              color: AppColor().primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
