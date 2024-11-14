import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/home/post/components/ad_list.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
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
  PagingController<int, PostModel> _pagingController =
      PagingController<int, PostModel>(firstPageKey: 1);
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
        separatorBuilder: (context, index) =>
            index != 0 && widget.posts![index - 1].owner != null
                ? Gap(0)
                : Gap(Get.height * 0.02),
        builderDelegate: PagedChildBuilderDelegate<PostModel>(
            itemBuilder: (context, post, index) {
              return index != 0 && post.owner != null
                  ? Gap(0)
                  : post.owner != null
                      ? AdList(ads: parseAds(index, widget.posts!))
                      : GestureDetector(
                          onTap: () => Get.to(() => PostDetails(item: post)),
                          child: PostItem(item: post));
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
