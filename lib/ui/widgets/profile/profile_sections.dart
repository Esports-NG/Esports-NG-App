import 'package:flutter/material.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/empty_state.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileExpandableSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final Widget expandedContent;
  final String? count;
  final bool isEmpty;
  final String emptyMessage;

  const ProfileExpandableSection({
    Key? key,
    required this.title,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.expandedContent,
    this.count,
    this.isEmpty = false,
    this.emptyMessage = 'No items available',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) =>
            onExpansionChanged(isExpanded),
        expandIconColor: AppColor().primaryColor,
        children: [
          ExpansionPanel(
            isExpanded: isExpanded,
            backgroundColor: AppColor().primaryBackGroundColor,
            headerBuilder: (context, isExpanded) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: count != null ? "$title ($count)" : title,
                  size: 14,
                  color: AppColor().primaryWhite,
                ),
              ],
            ),
            body: isEmpty
                ? EmptyStateBuilder.build(message: emptyMessage)
                : expandedContent,
          )
        ],
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  final double thickness;
  final double opacity;

  const SectionDivider({
    Key? key,
    this.thickness = 4.0,
    this.opacity = 0.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColor().lightItemsColor.withOpacity(opacity),
      height: Get.height * 0.05,
      thickness: thickness,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title: title,
            size: 16,
            color: AppColor().primaryWhite,
            fontFamily: "InterSemiBold",
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  CustomText(
                    title: "See all",
                    size: 12,
                    color: AppColor().primaryColor,
                    fontFamily: "InterMedium",
                  ),
                  Gap(5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColor().primaryColor,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
