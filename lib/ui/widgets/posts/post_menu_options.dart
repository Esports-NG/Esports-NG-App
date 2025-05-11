import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/screens/post/edit_post.dart';
import 'package:e_sport/ui/screens/post/report_page.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostMenuOptions extends StatelessWidget {
  final PostModel post;
  final AuthRepository authController;
  final PostRepository postController;

  const PostMenuOptions({
    Key? key,
    required this.post,
    required this.authController,
    required this.postController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        alignment: Alignment.bottomLeft,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide.none,
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(AppColor().primaryMenu),
      ),
      menuChildren: _buildMenuItems(context),
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(Icons.more_vert),
          color: AppColor().primaryWhite.withOpacity(0.7),
        );
      },
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final isAuthor = authController.user!.id! == post.author!.id!;

    if (isAuthor) {
      return [
        _buildMenuItem(
          icon: CupertinoIcons.pen,
          title: 'Edit Post',
          color: AppColor().primaryWhite,
          onPressed: () => Get.to(() => EditPost(item: post)),
        ),
        _buildMenuItem(
          icon: CupertinoIcons.delete,
          title: 'Delete Post',
          color: AppColor().primaryRed,
          onPressed: () => _showDeleteDialog(context),
        ),
      ];
    } else {
      return [
        _buildMenuItem(
          icon: Icons.bookmark_outline,
          title: 'Bookmark',
          onPressed: () async => await postController.bookmarkPost(post.id!),
        ),
        _buildMenuItem(
          icon: Icons.thumb_down_alt_outlined,
          title: 'Not interested in this post',
          onPressed: () async =>
              await postController.blockUserOrPost(post.id!, 'uninterested'),
        ),
        _buildMenuItem(
          icon: Icons.person_add_alt_outlined,
          title: 'Follow/Unfollow @${post.author!.userName}',
          onPressed: () async =>
              await authController.followUser(post.author!.slug!),
        ),
        _buildMenuItem(
          icon: Icons.notifications_off_outlined,
          title: 'Turn on/Turn off Notifications',
          onPressed: () async =>
              await authController.turnNotification(post.author!.id.toString()),
        ),
        _buildMenuItem(
          icon: Icons.block_outlined,
          title: 'Block @${post.author!.userName}',
          onPressed: () async =>
              await postController.blockUserOrPost(post.author!.id!, 'block'),
        ),
        _buildMenuItem(
          icon: Icons.flag,
          title: 'Report Post',
          onPressed: () => _showReportDialog(context),
        ),
      ];
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return MenuItemButton(
      leadingIcon: Icon(
        icon,
        color: color,
        size: 18,
      ),
      onPressed: onPressed,
      child: CustomText(
        title: title,
        size: 12,
        fontFamily: 'InterMedium',
        textAlign: TextAlign.start,
        color: color,
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          titleTextStyle: TextStyle(
            color: AppColor().primaryWhite,
            fontFamily: "InterSemiBold",
            fontSize: 20,
          ),
          backgroundColor: AppColor().primaryMenu,
          content: CustomText(
            title: "Are you sure you want to delete this post?",
            color: AppColor().primaryWhite,
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(
                title: 'Yes',
                color: AppColor().primaryRed,
              ),
              onPressed: () {
                postController.deletePost(post.id!);
                Get.back();
              },
            ),
            TextButton(
              child: CustomText(
                title: 'No',
                color: AppColor().primaryWhite,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColor().primaryBgColor,
        content: Padding(
          padding: EdgeInsets.all(Get.height * 0.08),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => ReportPage(type: "post", id: post.id!));
                },
                child: CustomText(
                  title: 'Report Post by ${post.author!.userName}',
                  color: AppColor().primaryWhite,
                  fontFamily: 'InterBold',
                  size: Get.height * 0.015,
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => ReportPage(type: "user", id: post.author!.id!));
                },
                child: CustomText(
                  title: 'Report ${post.author!.userName}',
                  color: AppColor().primaryWhite,
                  fontFamily: 'InterBold',
                  size: Get.height * 0.015,
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  postController.blockUserOrPost(post.author!.id!, "block");
                },
                child: CustomText(
                  title: 'Block ${post.author!.userName}',
                  color: AppColor().primaryWhite,
                  fontFamily: 'InterBold',
                  size: Get.height * 0.015,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
