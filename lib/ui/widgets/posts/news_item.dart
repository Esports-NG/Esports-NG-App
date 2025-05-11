// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:e_sport/data/model/news_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class NewsItem extends StatefulWidget {
  final NewsModel item;
  const NewsItem({super.key, required this.item});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final navController = Get.put(NavRepository());
  Author? author;
  Map<String, dynamic>? media;

  int? _selectedIndex;

  Future getAuthor() async {
    var response = await http.get(
        Uri.parse(
            "https://nexalgamingcommunity.com/wp-json/wp/v2/users/${widget.item.author}"),
        headers: {
          "Authorization":
              "Basic ${base64.encode(utf8.encode("zillalikestogame:zillalikesnexal"))}"
        });

    setState(() {
      author = Author.fromJson(jsonDecode(response.body));
    });
  }

  Future getMedia() async {
    var response = await http.get(
        Uri.parse(
            "https://nexalgamingcommunity.com/wp-json/wp/v2/media/${widget.item.featuredMedia}"),
        headers: {
          "Authorization":
              "Basic ${base64.encode(utf8.encode("zillalikestogame:zillalikesnexal"))}"
        });

    setState(() {
      media = jsonDecode(response.body);
    });
  }

  String timeAgo(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  @override
  void initState() {
    getAuthor();
    getMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor().darkGrey.withOpacity(0.8),
            AppColor().bgDark.withOpacity(0.005),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().greyEight.withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(Get.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    parse(widget.item.title!.rendered)
                        .documentElement!
                        .text
                        .toUpperCase(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InterMedium',
                      color: AppColor().primaryWhite,
                    )),
                Gap(Get.height * 0.005),
                Divider(
                  thickness: 0.4,
                  color: AppColor().lightItemsColor.withOpacity(0.5),
                ),
                Gap(Get.height * 0.005),
                Text(parse(widget.item.content!.rendered).documentElement!.text,
                    textAlign: TextAlign.start,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'InterMedium',
                      color: AppColor().lightItemsColor,
                    )),
                Gap(Get.height * 0.015),
                Row(
                  children: [
                    CustomText(
                      title: 'By ',
                      size: Get.height * 0.015,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    CustomText(
                      title: author != null ? author!.name : "",
                      size: Get.height * 0.015,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryGreen,
                    ),
                    Gap(Get.height * 0.01),
                    const SmallCircle(),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: timeAgo(DateTime.parse(widget.item.date!)),
                      size: Get.height * 0.015,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.01),
                    const SmallCircle(),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: 'Nexal Gaming',
                      size: Get.height * 0.015,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                  ],
                ),
                Gap(Get.height * 0.015),
              ],
            ),
          ),
          media != null
              ? media!["guid"] != null
                  ? GestureDetector(
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(media!["guid"]["rendered"]),
                                fit: BoxFit.contain)),
                      ),
                    )
                  : SizedBox()
              : SizedBox()
        ],
      ),
    );
  }
}
