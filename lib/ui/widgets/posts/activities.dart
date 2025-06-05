import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
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
  late final PagingController<int, ActivityModel> _pagingController;

  @override
  void initState() {
    _pagingController = PagingController<int, ActivityModel>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchPage(pageKey),
    );
    super.initState();
  }

  List<ActivityModel> _activities = [];

  bool _isLoading = false;
  String _nextLink = '';

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
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await tournamentController.dio.get(ApiLink.getActivities);
      final json = response.data;
      print(response.data);
      if (json['success'] == true) {
        _nextLink = json['data']['next'] ?? "";
        return activityModelFromJson(jsonEncode(json['data']['results']));
      } else {
        throw Exception(json['message'] ?? 'Failed to load activities');
      }
    } on DioException catch (e) {
      log('Error fetching activities: ${e.response?.data}');
      throw e;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<ActivityModel>> fetchNextActivities() async {
    if (_nextLink.isEmpty) {
      return [];
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await tournamentController.dio.get(_nextLink!);
      final json = response.data;
      if (json['success'] == true) {
        _nextLink = json['data']['next'] ?? "";
        return activityModelFromJson(jsonEncode(json['data']['results']));
      } else {
        throw Exception(json['message'] ?? 'Failed to load more activities');
      }
    } on DioException catch (e) {
      log('Error fetching next activities: ${e.response?.data}');
      throw e;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<ActivityModel>> _fetchPage(int pageKey) async {
    try {
      if (_nextLink != null && _nextLink != "" && pageKey > 1) {
        var activities = await fetchNextActivities();
        return activities;
      } else {
        if (pageKey == 1) {
          var activities = await fetchActivities();

          return activities;
        } else {
          return [];
        }
      }
    } catch (err) {
      // _pagingController.error = err;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2
        () => _pagingController.refresh(),
      ),
      child: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => PagedListView.separated(
          addAutomaticKeepAlives: true,
          cacheExtent: 9999,
          state: state,
          fetchNextPage: fetchNextPage,
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
      ),
    );
  }
}
