import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/community/community_item.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
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
                        GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1 * 0.67,
                            ),
                            itemCount:
                                communityController.searchedCommunities.length,
                            itemBuilder: (context, index) {
                              var item = communityController
                                  .searchedCommunities[index];
                              return GestureDetector(
                                  onTap: () => Get.to(
                                      () => AccountCommunityDetail(item: item)),
                                  child: CommunityItem(item: item));
                            })
                      ],
                    ),
        ),
      ),
    );
  }
}
