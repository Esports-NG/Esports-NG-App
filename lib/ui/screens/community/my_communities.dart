import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widgets/community/account_community_widget.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities({super.key});

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  final communityController = Get.put(CommunityRepository());
  bool _loading = true;
  Future getMyCommunities() async {
    await communityController.getUserCommunity();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyCommunities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            title: "My Communities",
            fontFamily: 'InterSemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: GoBackButton(onPressed: () => Get.back()),
        ),
        body: _loading ? LoadingWidget() : AccountCommunityWidget());
  }
}
