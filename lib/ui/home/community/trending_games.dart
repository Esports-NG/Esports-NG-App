import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/suggested_profile_item.dart';
import 'components/trending_games_item.dart';

class TrendingGames extends StatefulWidget {
  const TrendingGames({super.key});

  @override
  State<TrendingGames> createState() => _TrendingGamesState();
}

class _TrendingGamesState extends State<TrendingGames> {
  final eventController = Get.put(EventRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
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
              GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 * 0.8,
                  ),
                  itemCount: suggestedProfileItems.length,
                  itemBuilder: (context, index) {
                    var item = suggestedProfileItems[index];
                    return TrendingGamesItem(item: item);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
