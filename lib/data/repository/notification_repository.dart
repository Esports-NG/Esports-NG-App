import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/util/api_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class NotificationRepository extends GetxController {
  final authController = Get.put(AuthRepository());

  RxList<NotificationModel> notifications = RxList([]);
  RxString nextLink = RxString("");

  // Dio instance for using ApiHelpers
  late Dio _dio;

  @override
  void onInit() {
    _initDio();
    listenForNotifications();
    getNotifications();
    super.onInit();
  }

  // Initialize Dio with auth interceptor
  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiLink.baseurl,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));

    // Add an interceptor to handle authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to header if it exists
        if (authController.token.isNotEmpty && authController.token != "0") {
          options.headers['Authorization'] = 'JWT ${authController.token}';
        }
        return handler.next(options);
      },
    ));
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
    try {
      final response =
          await _dio.get(ApiLink.getNotifications(authController.user!.id!));

      log('notification: ${response.data}');
      print(response.data);
      var json = response.data['data'];
      nextLink.value = json["next"] ?? "";
      var notificationList = List<NotificationModel>.from(
          json['results'].map((x) => NotificationModel.fromJson(x)));
      notifications.assignAll(notificationList);
      return notificationList;
    } catch (error) {
      debugPrint("Error getting notifications: $error");
      ApiHelpers.handleApiError(error);
      return [];
    }
  }

  Future getNext() async {
    try {
      if (nextLink.value.isEmpty) return [];

      final response = await _dio.get(nextLink.value);
      print(response.data);

      log('next notification: ${response.data}');
      var json = response.data['data'];
      nextLink.value = json["next"] ?? "";
      var notificationList = List<NotificationModel>.from(
          json['results'].map((x) => NotificationModel.fromJson(x)));
      notifications.addAll(notificationList);
      return notificationList;
    } catch (error) {
      debugPrint("Error getting next notifications: $error");
      ApiHelpers.handleApiError(error);
      return [];
    }
  }
}
