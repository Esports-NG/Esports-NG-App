import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/components/error_page.dart';
import 'package:e_sport/ui/components/no_item_page.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/trending_team_item.dart';

class TrendingTeam extends StatefulWidget {
  const TrendingTeam({super.key});

  @override
  State<TrendingTeam> createState() => _TrendingTeamState();
}

class _TrendingTeamState extends State<TrendingTeam> {
  final eventController = Get.put(EventRepository());
  final teamController = Get.put(TeamRepository());
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
          title: 'Trending Team',
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
              (teamController.teamStatus == TeamStatus.loading)
                  ? LoadingWidget(color: AppColor().primaryColor)
                  : (teamController.teamStatus == TeamStatus.available)
                      ? GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1 * 0.68,
                          ),
                          itemCount: teamController.allTeam.length,
                          itemBuilder: (context, index) {
                            var item = teamController.allTeam[index];
                            return InkWell(
                                onTap: () => Get.to(
                                    () => AccountTeamsDetail(item: item)),
                                child: TrendingTeamsItem(item: item));
                          })
                      : (teamController.teamStatus == TeamStatus.empty)
                          ? const NoItemPage(title: 'Teams')
                          : const ErrorPage(),
            ],
          ),
        ),
      ),
    );
  }
}
