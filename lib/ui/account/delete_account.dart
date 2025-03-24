import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widget/back_button.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});

  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(
        'https://nexalgamingcommunity.com/delete-my-esports-ng-account/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor().primaryBackGroundColor,
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: AppColor().primaryBackGroundColor,
          centerTitle: true,
          title: CustomText(
            title: 'Delete your Account',
            fontFamily: 'InterSemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: GoBackButton(onPressed: () => Get.back()),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: AppColor().primaryWhite,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WebViewWidget(controller: webViewController),
        ));
  }
}
