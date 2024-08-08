import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/community/components/suggested_profile_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UsersSearch extends StatefulWidget {
  const UsersSearch({super.key});

  @override
  State<UsersSearch> createState() => _UsersSearchState();
}

class _UsersSearchState extends State<UsersSearch> {
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: authController.searchLoading.value
              ? const Center(child: const ButtonLoader())
              : authController.searchedUsers.isEmpty
                  ? Center(
                      child: CustomText(
                        title: "No User found.",
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
                              childAspectRatio: 1 * 0.8,
                            ),
                            itemCount: authController.searchedUsers.length,
                            itemBuilder: (context, index) {
                              var item = authController.searchedUsers[index];
                              return SuggestedProfileItem(item: item);
                            })
                      ],
                    ),
        ),
      ),
    );
  }
}
