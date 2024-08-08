import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/home/community/components/community_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunitySearch extends StatefulWidget {
  const CommunitySearch({super.key});

  @override
  State<CommunitySearch> createState() => _CommunitySearchState();
}

class _CommunitySearchState extends State<CommunitySearch> {
  final communityController = Get.put(CommunityRepository());
  final authController = Get.put(AuthRepository());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: authController.searchLoading.value
              ? const Center(child: ButtonLoader())
              : communityController.searchedCommunities.isEmpty
                  ? Center(
                      child: CustomText(
                        title: "No community found.",
                        color: AppColor().primaryWhite,
                      ),
                    )
                  : Column(
                      children: [
                        ListView.separated(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.02),
                            itemCount:
                                communityController.searchedCommunities.length,
                            itemBuilder: (context, index) {
                              var item = communityController
                                  .searchedCommunities[index];
                              return GestureDetector(
                                  onTap: () => Get.to(
                                      () => AccountCommunityDetail(item: item)),
                                  child: AllCommunityItem(item: item));
                            })
                      ],
                    ),
        ),
      ),
    );
  }
}
