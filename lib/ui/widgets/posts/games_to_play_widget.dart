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
  late final PagingController<int, GameToPlay> _pagingController;
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
    _pagingController = PagingController<int, GameToPlay>(
      fetchPage: (pageKey) => _fetchPage(pageKey),
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    );
    super.initState();
    // _scrollController.addListener(_loadMore);
  }

  Future<List<GameToPlay>> _fetchPage(int pageKey) async {
    try {
      if (widget.nextLink != null && widget.nextLink != "" && pageKey > 1) {
        var posts = await widget.getNext!();
        return posts;
      } else {
        if (widget.refresh != null && pageKey == 1) {
          var posts = await widget.refresh!(false);

          return posts;
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
        // 2
        () => _pagingController.refresh(),
      ),
      child: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => PagedListView.separated(
          padding: EdgeInsets.only(top: 10, bottom: 50),
          state: state,
          fetchNextPage: fetchNextPage,
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          builderDelegate: PagedChildBuilderDelegate<GameToPlay>(
              itemBuilder: (context, feed, index) {
                return GestureDetector(
                    onTap: () => Get.to(() => GameProfile(
                        game: GamePlayed.fromJson({"id": feed.id}))),
                    child: GamesToPlayItem(item: feed, index: index));
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
// Visibility(
//   visible: widget.nextLink != null && widget.nextLink != "",
//   child: Padding(
//     padding: const EdgeInsets.only(top: 30),
//     child: Center(child: ButtonLoader()),
//   ),
// )
