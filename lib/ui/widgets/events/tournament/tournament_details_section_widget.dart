import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/screens/account/events/components/tournament_details.dart';
import 'package:e_sport/ui/screens/event/participant_list.dart';
import 'package:e_sport/ui/screens/team/team_participant_list.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDetailsSection extends StatelessWidget {
  final EventModel eventDetails;

  const TournamentDetailsSection({
    Key? key,
    required this.eventDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'Tournament Details',
          fontFamily: 'InterSemiBold',
          size: 16,
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: Column(
            children: [
              _buildDetailItem(
                title: 'Participants List',
                routeName: eventDetails.tournamentType == "team"
                    ? TeamParticipantList(event: eventDetails)
                    : ParticipantList(event: eventDetails),
              ),
              _buildDivider(),
              _buildDetailItem(
                title: 'Tournament Structure',
                routeName: TournamentDetails(
                  title: "Tournament Structure",
                  value: eventDetails.structure!,
                ),
              ),
              _buildDivider(),
              _buildDetailItem(
                title: 'Rules and regulations',
                routeName: TournamentDetails(
                  title: "Rules and Regulations",
                  value: eventDetails.rulesRegs!,
                ),
              ),
              _buildDivider(),
              _buildDetailItem(
                title: 'Tournament Requirements',
                routeName: TournamentDetails(
                  title: "Tournament Requirements",
                  value: eventDetails.requirements!,
                ),
              ),
              Gap(Get.height * 0.01),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({required String title, required Widget routeName}) {
    return GestureDetector(
      onTap: () => Get.to(() => routeName),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: title,
              size: 14,
              fontFamily: 'InterMedium',
              color: AppColor().greySix,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor().primaryColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColor().lightItemsColor.withOpacity(0.3),
      thickness: 0.5,
    );
  }
}
