import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/notification_repository.dart';
import 'package:e_sport/ui/notification/notification_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AllNotification extends StatefulWidget {
  const AllNotification({super.key});

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification> {
  final PagingController<int, NotificationModel> _pagingController =
      PagingController<int, NotificationModel>(firstPageKey: 1);
  final notificationController = Get.put(NotificationRepository());

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (notificationController.nextLink.value != "" && pageKey > 1) {
        var posts = await notificationController.getNext();
        _pagingController.appendPage(posts, pageKey + 1);
      } else {
        if (pageKey == 1) {
          var notifications = await notificationController.getNotifications();

          _pagingController.appendPage(notifications, pageKey + 1);
        } else {
          _pagingController.appendLastPage([]);
        }
      }
    } catch (err) {
      _pagingController.error = err;
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationRepository());
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 18),
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView.separated(
          pagingController: _pagingController,
          padding: EdgeInsets.zero,
          // shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 0.5,
          ),
          builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
              itemBuilder: (context, notification, index) {
                return GestureDetector(
                  child: NotificationItem(
                    notification: notification,
                  ),
                );
              },
              firstPageProgressIndicatorBuilder: (context) =>
                  Center(child: ButtonLoader()),
              newPageProgressIndicatorBuilder: (context) =>
                  Center(child: ButtonLoader())),
        ),
      ),
    );
  }
}
