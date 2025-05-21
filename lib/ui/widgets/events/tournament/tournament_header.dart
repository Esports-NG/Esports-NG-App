import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TournamentHeader extends StatelessWidget {
  final EventModel event;

  const TournamentHeader({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helpers().showImagePopup(context, event.banner!),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          _buildBanner(),
          _buildProfileImage(context),
          _buildHeaderButtons(),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return event.banner == null
        ? Container(
            height: Get.height * 0.15,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/png/tournament_cover.png'),
                  opacity: 0.2),
            ),
          )
        : CachedNetworkImage(
            height: Get.height * 0.15,
            width: double.infinity,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.height * 0.05,
                child: CircularProgressIndicator(
                    color: AppColor().primaryWhite, value: progress.progress),
              ),
            ),
            errorWidget: (context, url, error) =>
                Icon(Icons.error, color: AppColor().primaryColor),
            imageUrl: event.banner!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: DecorationImage(
                    image: NetworkImage(event.banner!), fit: BoxFit.cover),
              ),
            ),
          );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Positioned(
      top: Get.height * 0.1,
      child: GestureDetector(
        onTap: () => Helpers().showImagePopup(context, "${event.profile}"),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            OtherImage(itemSize: Get.height * 0.1, image: '${event.profile}'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GoBackButton(onPressed: () => Get.back()),
          Padding(
            padding: EdgeInsets.only(right: Get.height * 0.02),
            child: InkWell(
              child: Icon(
                Icons.settings,
                color: AppColor().primaryWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
