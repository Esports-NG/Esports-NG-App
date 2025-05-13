import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widgets/posts/ad_list.dart';
import 'package:e_sport/ui/screens/post/post_details.dart';
import 'package:e_sport/ui/widgets/posts/post_item.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostWidget extends StatefulWidget {
  final List<PostModel>? posts;
  final String? nextLink;
  final Future Function()? getNext;
  final Future Function(bool)? refresh;
  final String? type;
  const PostWidget(
      {super.key,
      this.posts,
      this.nextLink,
      this.getNext,
      this.refresh,
      this.type});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with AutomaticKeepAliveClientMixin<PostWidget> {
  @override
  bool get wantKeepAlive => true;

  var _scrollController = ScrollController();
  late final PagingController<int, PostModel> _pagingController;

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pagingController = PagingController<int, PostModel>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchPage(pageKey),
    );
    super.initState();
  }

  Future<List<PostModel>> _fetchPage(int pageKey) async {
    try {
      if (widget.nextLink != null && widget.nextLink != "" && pageKey > 1) {
        var posts = await widget.getNext!();
        return posts;
      } else {
        if (widget.refresh != null && pageKey == 1) {
          var posts = await widget.refresh!(false);
          print(posts);
          if (widget.type == "announcement") {
            return posts.where((e) => e.announcement! == true).toList();
          } else if (widget.type == "participant") {
            return posts
                .where((e) => e.participantAnnouncement! == true)
                .toList();
          } else {
            return posts;
          }
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
    super.build(context);
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
          separatorBuilder: (context, index) =>
              index != 0 && state.items?[index - 1].owner != null
                  ? Gap(0)
                  : Gap(Get.height * 0.015),
          builderDelegate: PagedChildBuilderDelegate<PostModel>(
              firstPageErrorIndicatorBuilder: (context) => PageErrorWidget(
                  // onRetry: () => _pagingController.retryLastFailedRequest()),
                  // newPageErrorIndicatorBuilder: (context) => PageErrorWidget(
                  // onRetry: () => _pagingController.retryLastFailedRequest(),
                  ),
              noItemsFoundIndicatorBuilder: (context) => PageErrorWidget(
                    title: 'No Posts Found',
                    message: 'There are no posts available at the moment.',
                    onRetry: () => _pagingController.refresh(),
                  ),
              itemBuilder: (context, post, index) {
                return index != 0 && state.items![index - 1].owner != null
                    ? Gap(0)
                    : post.owner != null
                        ? AdList(ads: parseAds(index, widget.posts!))
                        : GestureDetector(
                            onTap: () {
                              // print(post);
                              Get.to(() => PostDetails(item: post));
                            },
                            child: PostItem(item: post));
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
