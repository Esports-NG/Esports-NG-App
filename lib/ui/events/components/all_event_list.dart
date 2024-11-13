import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AllEventList extends StatefulWidget {
  const AllEventList(
      {super.key, this.eventList, this.refresh, this.getNext, this.nextLink});
  final List<EventModel>? eventList;
  final Future Function(bool?)? refresh;
  final Future Function()? getNext;
  final String? nextLink;

  @override
  State<AllEventList> createState() => _AllEventListState();
}

class _AllEventListState extends State<AllEventList> {
  var eventController = Get.put(EventRepository());

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  final PagingController<int, EventModel> _pagingController =
      PagingController<int, EventModel>(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (widget.nextLink != null && widget.nextLink != "" && pageKey > 1) {
        var events = await widget.getNext!();
        _pagingController.appendPage(events, pageKey + 1);
      } else {
        if (widget.refresh != null && pageKey == 1) {
          var events = await widget.refresh!(false);
          _pagingController.appendPage(events, pageKey + 1);
        } else {
          _pagingController.appendLastPage([]);
        }
      }
    } catch (err) {
      _pagingController.error = err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // notificationPredicate: (notification) => notification.depth == 1,
      onRefresh: () => Future.sync(
        // 2
        () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
          pagingController: _pagingController,
          padding: const EdgeInsets.only(top: 20),
          shrinkWrap: true,
          builderDelegate: PagedChildBuilderDelegate<EventModel>(
            itemBuilder: (context, event, index) => GestureDetector(
                onTap: () {
                  if (event.type == "tournament") {
                    Get.to(() => AccountTournamentDetail(item: event));
                  } else {
                    Get.to(() => SocialEventDetails(item: event));
                  }
                },
                child: AccountEventsItem(item: event)),
            newPageProgressIndicatorBuilder: (context) =>
                Center(child: ButtonLoader()),
            firstPageProgressIndicatorBuilder: (context) =>
                Center(child: ButtonLoader()),
          ),
          separatorBuilder: (context, index) => Gap(Get.height * 0.02)),
    );
  }
}
