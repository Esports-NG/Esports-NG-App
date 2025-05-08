import 'package:e_sport/data/model/games_played_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widgets/posts/games_to_play_item.dart';
import 'package:e_sport/ui/screens/game/game_profile.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GamesToPlayWidget extends StatefulWidget {
  final List<GameToPlay>? gameFeed;
  final String? nextLink;
  final Future Function()? getNext;
  final Future Function(bool)? refresh;
  final String? type;
  const GamesToPlayWidget(
      {super.key,
      this.gameFeed,
      this.nextLink,
      this.getNext,
      this.refresh,
      this.type});

  @override
  State<GamesToPlayWidget> createState() => _GamesToPlayWidgetState();
}

class _GamesToPlayWidgetState extends State<GamesToPlayWidget>
    with AutomaticKeepAliveClientMixin<GamesToPlayWidget> {
  @override
  bool get wantKeepAlive => true;

  var _scrollController = ScrollController();
  PagingController<int, GameToPlay> _pagingController =
      PagingController<int, GameToPlay>(firstPageKey: 1);
  List<PostModel> parseAds(int initial, List<PostModel> posts) {
    List<PostModel> result = [];

    for (var i = initial; i < posts.length; i++) {
      if (posts[i].owner == null) {
        break;
      }
      result.add(posts[i]);
    }
    return result;
  }

  // void _loadMore() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     widget.getNext!();
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    // _scrollController.addListener(_loadMore);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (widget.nextLink != null && widget.nextLink != "" && pageKey > 1) {
        var posts = await widget.getNext!();
        _pagingController.appendPage(posts, pageKey + 1);
      } else {
        if (widget.refresh != null && pageKey == 1) {
          var posts = await widget.refresh!(false);
          if (widget.type == "announcement") {
            _pagingController.appendPage(
                posts.where((e) => e.announcement! == true).toList(),
                pageKey + 1);
          } else if (widget.type == "participant") {
            _pagingController.appendPage(
                posts.where((e) => e.participantAnnouncement! == true).toList(),
                pageKey + 1);
          } else {
            _pagingController.appendPage(posts, pageKey + 1);
          }
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
      onRefresh: () => Future.sync(
        // 2
        () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        pagingController: _pagingController,
        padding: EdgeInsets.only(top: 10, bottom: 50),
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        builderDelegate: PagedChildBuilderDelegate<GameToPlay>(
            itemBuilder: (context, feed, index) {
              return GestureDetector(
                  onTap: () => Get.to(() =>
                      GameProfile(game: GamePlayed.fromJson({"id": feed.id}))),
                  child: GamesToPlayItem(item: feed, index: index));
            },
            firstPageProgressIndicatorBuilder: (context) =>
                Center(child: ButtonLoader()),
            newPageProgressIndicatorBuilder: (context) =>
                Center(child: ButtonLoader())),
      ),
    );
  }
}
// Visibility(
//   visible: widget.nextLink != null && widget.nextLink != "",
//   child: Padding(
//     padding: const EdgeInsets.only(top: 30),
//     child: Center(child: ButtonLoader()),
//   ),
// )
