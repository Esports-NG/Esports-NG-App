import 'dart:convert';
import 'dart:developer';

import 'package:e_sport/data/model/activity_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/events/tournament/br_fixture_card.dart';
import 'package:e_sport/ui/widgets/events/tournament/fixture_item.dart';
import 'package:e_sport/ui/widgets/events/tournament/livestream_card.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var tournamentController = Get.put(TournamentRepository());

  final authController = Get.put(AuthRepository());
  PagingController<int, ActivityModel> _pagingController =
      PagingController<int, ActivityModel>(firstPageKey: 1);

  List<ActivityModel> _activities = [];

  bool _isLoading = false;
  String? _nextLink;

  final _colors = [
    LinearGradient(
      colors: [
        AppColor().fixturePurple,
        AppColor().fixturePurple,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: [
        AppColor().darkGrey.withOpacity(0.8),
        AppColor().bgDark.withOpacity(0.005),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
    ),
  ];

  Future<List<ActivityModel>> fetchActivities() async {
    var response = await http.get(Uri.parse(ApiLink.getActivities),
        headers: {"Authorization": "JWT ${authController.token}"});
    log(response.body);
    var json = jsonDecode(response.body);
    return activityModelFromJson(jsonEncode(json["results"]));
  }

  Future<List<ActivityModel>> fetchNextActivities() async {
    var response = await http.get(Uri.parse(_nextLink!),
        headers: {"Authorization": "JWT ${authController.token}"});
    log(response.body);
    var json = jsonDecode(response.body);
    return activityModelFromJson(jsonEncode(json["results"]));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_nextLink != null && _nextLink != "" && pageKey > 1) {
        var activities = await fetchNextActivities();
        _pagingController.appendPage(activities, pageKey + 1);
      } else {
        if (pageKey == 1) {
          var activities = await fetchActivities();

          _pagingController.appendPage(activities, pageKey + 1);
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
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2
        () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        addAutomaticKeepAlives: true,
        cacheExtent: 9999,
        pagingController: _pagingController,
        padding: EdgeInsets.only(top: 10, bottom: 50),
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        builderDelegate: PagedChildBuilderDelegate<ActivityModel>(
            itemBuilder: (context, activity, index) {
              return activity.livestream != null
                  ? LivestreamCard(
                      backgroundColor: _colors[index % _colors.length],
                      livestream: activity.livestream!,
                    )
                  : activity.fixture!.fixtureType == "BR"
                      ? BrFixtureCard(
                          backgroundColor: _colors[index % _colors.length],
                          fixture: activity.fixture!,
                          getFixtures: () => null,
                          event: activity.fixture!.tournament!)
                      : FixtureCard(
                          backgroundColor: _colors[index % _colors.length],
                          fixture: activity.fixture!);
            },
            firstPageProgressIndicatorBuilder: (context) =>
                Center(child: ButtonLoader()),
            newPageProgressIndicatorBuilder: (context) =>
                Center(child: ButtonLoader())),
      ),
    );
  }
}
