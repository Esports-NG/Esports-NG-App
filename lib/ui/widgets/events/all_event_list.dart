import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/screens/account/events/account_events_item.dart';
import 'package:e_sport/ui/screens/event/account_tournament_detail.dart';
import 'package:e_sport/ui/screens/event/social_event_details.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
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
    _pagingController = PagingController<int, EventModel>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchPage(pageKey),
    );
    super.initState();
  }

  late final PagingController<int, EventModel> _pagingController;

  Future<List<EventModel>> _fetchPage(int pageKey) async {
    try {
      if (widget.nextLink != null && widget.nextLink != "" && pageKey > 1) {
        var events = await widget.getNext!();
        return events;
      } else {
        if (widget.refresh != null && pageKey == 1) {
          var events = await widget.refresh!(false);
          return events;
        } else {
          return [];
        }
      }
    } catch (err) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => PagedListView.separated(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            // shrinkWrap: true,
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
      ),
    );
  }
}
