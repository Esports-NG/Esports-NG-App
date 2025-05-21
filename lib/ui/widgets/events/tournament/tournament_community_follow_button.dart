import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TournamentCommunityFollowButton extends StatefulWidget {
  final EventModel eventDetails;
  final bool isFollowing;
  final Function onFollowChanged;

  const TournamentCommunityFollowButton({
    Key? key,
    required this.eventDetails,
    required this.isFollowing,
    required this.onFollowChanged,
  }) : super(key: key);

  @override
  State<TournamentCommunityFollowButton> createState() =>
      _TournamentCommunityFollowButtonState();
}

class _TournamentCommunityFollowButtonState
    extends State<TournamentCommunityFollowButton> {
  final authController = Get.put(AuthRepository());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomFillOption(
      buttonColor: AppColor().primaryBackGroundColor.withOpacity(0.7),
      borderColor: AppColor().greyEight,
      onTap: _handleFollowCommunity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _isLoading
            ? [
                Center(
                  child: SizedBox(
                    width: Get.height * 0.03,
                    height: Get.height * 0.03,
                    child: CircularProgressIndicator(
                      color: AppColor().primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              ]
            : [
                CustomText(
                  title: widget.isFollowing ? "Unfollow" : "Follow Community",
                  size: 14,
                  fontFamily: 'Inter',
                  color: AppColor().primaryWhite,
                ),
              ],
      ),
    );
  }

  Future<void> _handleFollowCommunity() async {
    setState(() {
      _isLoading = true;
    });

    String message = await authController
        .followCommunity(widget.eventDetails.community!.slug!);

    setState(() {
      _isLoading = false;
    });

    if (message == "followed" || message == "unfollowed") {
      widget.onFollowChanged(message == "followed");
    }
  }
}
