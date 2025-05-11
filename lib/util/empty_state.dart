import 'package:flutter/material.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:gap/gap.dart';

/// A reusable empty state widget that can be used throughout the app
/// to display a consistent "no items" UI when a list is empty.
class EmptyStateBuilder {
  /// Builds a standard empty state widget with an icon and message
  static Widget build({
    String message = 'No items available',
    IconData icon = Icons.inbox_outlined,
    double iconSize = 32,
    double fontSize = 14,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColor().lightItemsColor,
            size: iconSize,
          ),
          const Gap(8),
          CustomText(
            title: message,
            size: fontSize,
            color: textColor ?? AppColor().lightItemsColor,
            textAlign: TextAlign.center,
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
