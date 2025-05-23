import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/notification_repository.dart';
import 'package:e_sport/ui/widgets/notification/notification_item.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AllNotification extends StatefulWidget {
  const AllNotification({super.key});

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification> {
  late final PagingController<int, NotificationModel> _pagingController;
  final notificationController = Get.put(NotificationRepository());

  Future<List<NotificationModel>> _fetchPage(int pageKey) async {
    try {
      if (notificationController.nextLink.value != "" && pageKey > 1) {
        print("fetching next page");
        var notifications = await notificationController.getNext();
        return notifications;
      } else {
        if (pageKey == 1) {
          var notifications = await notificationController.getNotifications();

          return notifications;
        } else {
          return [];
        }
      }
    } catch (err) {
      return [];
    }
  }

  @override
  void initState() {
    _pagingController = PagingController<int, NotificationModel>(
      fetchPage: (pageKey) => _fetchPage(pageKey),
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationRepository());
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => PagedListView.separated(
          state: state,
          fetchNextPage: fetchNextPage,
          padding: EdgeInsets.only(bottom: 16.r, top: 18.r),
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
