import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/trending_games_item.dart';

class TrendingGames extends StatefulWidget {
  const TrendingGames({super.key});

  @override
  State<TrendingGames> createState() => _TrendingGamesState();
}

class _TrendingGamesState extends State<TrendingGames> {
  final eventController = Get.put(EventRepository());
  final playerController = Get.put(PlayerRepository());
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: GoBackButton(onPressed: () => Get.back()),
        title: CustomText(
          title: 'Trending Games',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),

      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.06,
                child: CustomTextField(
                  hint: "Search for gaming news, competitions...",
                  fontFamily: 'GilroyMedium',
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: AppColor().lightItemsColor,
                  ),
                  textEditingController: eventController.searchController,
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
              GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 * 0.8,
                  ),
                  itemCount: playerController.allPlayer.length,
                  itemBuilder: (context, index) {
                    var item = playerController.allPlayer[index];
                    return TrendingGamesItem(item: item);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
