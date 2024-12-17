import 'dart:convert';
import 'dart:developer';

import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class NotificationRepository extends GetxController {
  final authController = Get.put(AuthRepository());

  RxList<NotificationModel> notifications = RxList([]);
  RxString nextLink = RxString("");

  @override
  void onInit() {
    listenForNotifications();
    getNotifications();
    super.onInit();
  }

  Future listenForNotifications() async {
    var channel = IOWebSocketChannel.connect(
        Uri.parse(
            'wss://api.esportsng.com/ws/notifications/${authController.user!.id!}/'),
        headers: {'Origin': ApiLink.baseurl});
    channel.stream.listen(
      (event) => print(event),
      onDone: () => print('done'),
    );
  }

  Future getNotifications() async {
    var response = await http.get(
        Uri.parse(ApiLink.getNotifications(authController.user!.id!)),
        headers: {"Authorization": "JWT ${authController.token}"});

    log('notification' + response.body);
    var json = jsonDecode(response.body);
    nextLink.value = json["next"] ?? "";
    var notificationList =
        notificationModelFromJson(jsonEncode(json['results']));
    notifications.assignAll(notificationList);
    return notificationList;
  }

  Future getNext() async {
    var response = await http.get(Uri.parse(nextLink.value),
        headers: {"Authorization": "JWT ${authController.token}"});

    log('next notification' + response.body);
    var json = jsonDecode(response.body);
    nextLink.value = json["next"] ?? "";
    var notificationList =
        notificationModelFromJson(jsonEncode(json['results']));
    notifications.assignAll(notificationList);
    return notificationList;
  }
}
