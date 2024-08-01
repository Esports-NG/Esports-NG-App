import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddToRoster extends StatefulWidget {
  const AddToRoster({super.key, required this.roasterList, required this.team});
  final List<RoasterModel> roasterList;
  final TeamModel team;

  @override
  State<AddToRoster> createState() => _AddToRosterState();
}

class _AddToRosterState extends State<AddToRoster> {
  final teamController = Get.put(TeamRepository());
  UserModel? _player;
  RoasterModel? _roster;
  GamePlayed? _game;
  String? _playerString;
  String? _gameString;
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomText(
            title: "Add Player to Roster",
            color: AppColor().primaryWhite,
            weight: FontWeight.w600,
            size: 20,
          ),
          centerTitle: true,
          leading: GoBackButton(onPressed: () => Get.back())),
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomText(
              title: "Roster",
              color: AppColor().primaryWhite,
              size: 16,
            ),
            Gap(Get.height * 0.01),
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor().primaryDark,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor().lightItemsColor, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: AppColor().primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: AppColor().lightItemsColor),
                  value: _gameString,
                  items: widget.roasterList.map((rosterValue) {
                    return DropdownMenuItem(
                      value: rosterValue.game!.name,
                      onTap: () {
                        setState(() {
                          _roster = rosterValue;
                        });
                      },
                      child: CustomText(
                        title: rosterValue.game!.name,
                        color: AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gameString = value;
                    });
                  },
                  hint: CustomText(
                    title: "Select Roster",
                    color: AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 15,
                  ),
                ),
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: "Player",
              color: AppColor().primaryWhite,
              size: 16,
            ),
            Gap(Get.height * 0.01),
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor().primaryDark,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor().lightItemsColor, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: AppColor().primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: AppColor().lightItemsColor),
                  value: _playerString,
                  items: widget.team.players!.map((playerValue) {
                    return DropdownMenuItem<String>(
                      value: playerValue.userName,
                      onTap: () {
                        setState(() {
                          _player = playerValue;
                        });
                      },
                      child: CustomText(
                        title: playerValue.userName,
                        color: AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _playerString = value;
                    });
                  },
                  hint: CustomText(
                    title: "Select Player",
                    color: AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 15,
                  ),
                ),
              ),
            ),
            Gap(Get.height * 0.03),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isAdding = true;
                });
                await teamController.addPlayerToRoster(
                    widget.team.id!, _player!.id!, _roster!.id!);
                setState(() {
                  _isAdding = false;
                });
              },
              child: Container(
                height: Get.height * 0.07,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _isAdding ? null : AppColor().primaryColor,
                ),
                child: Center(
                    child: _isAdding
                        ? const ButtonLoader()
                        : CustomText(
                            title: 'Submit',
                            color: AppColor().primaryWhite,
                            weight: FontWeight.w600,
                            size: Get.height * 0.018,
                          )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
