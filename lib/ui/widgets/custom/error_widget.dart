import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final bool showRetryButton;
  final double? iconSize;
  final Widget? customAction;

  const CustomErrorWidget({
    Key? key,
    this.title,
    this.message = 'Something went wrong. Please try again.',
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.showRetryButton = true,
    this.iconSize,
    this.customAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor().primaryColor,
            size: iconSize ?? Get.height * 0.08,
          ),
          Gap(Get.height * 0.025),
          if (title != null) ...[
            CustomText(
              title: title,
              size: 18,
              weight: FontWeight.w600,
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
            ),
            Gap(Get.height * 0.01),
          ],
          CustomText(
            title: message,
            size: 14,
            weight: FontWeight.w400,
            color: AppColor().lightItemsColor,
            textAlign: TextAlign.center,
          ),
          Gap(Get.height * 0.035),
          if (showRetryButton && onRetry != null)
            CustomFillButton(
              buttonText: retryButtonText,
              onTap: onRetry,
              width: Get.width * 0.5,
              height: 42.h,
            )
          else if (customAction != null)
            customAction!,
        ],
      ),
    );
  }
}

class PageErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final bool showRetryButton;

  const PageErrorWidget({
    Key? key,
    this.title = 'Oops!',
    this.message = 'Something went wrong. Please try again.',
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryButtonText = 'Try Again',
    this.showRetryButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomErrorWidget(
        title: title,
        message: message,
        icon: icon,
        onRetry: onRetry,
        retryButtonText: retryButtonText,
        showRetryButton: showRetryButton,
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionButtonText;
  final bool showActionButton;

  const EmptyStateWidget({
    Key? key,
    this.title = 'Nothing here yet',
    this.message = 'No items to display at the moment.',
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionButtonText = 'Refresh',
    this.showActionButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomErrorWidget(
        title: title,
        message: message,
        icon: icon,
        onRetry: onAction,
        retryButtonText: actionButtonText,
        showRetryButton: showActionButton,
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NoConnectionWidget({
    Key? key,
    this.onRetry,
    this.message =
        'No internet connection. Please check your network and try again.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'No Connection',
      message: message,
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
      retryButtonText: 'Retry',
    );
  }
}
