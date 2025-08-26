import 'package:dio/dio.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// A class that manages all dependencies for the app
class DependencyInjection {
  /// Initialize all dependencies
  static Future<void> init() async {
    // Initialize ApiService
    await Get.putAsync(() => ApiService().init());
  }
}

/// A singleton class that provides a configured Dio instance for API calls
class ApiService extends GetxService {
  static ApiService get to => Get.find<ApiService>();

  // Single Dio instance for all API calls
  final Dio _dio = Dio();

  // Getter for the Dio instance
  Dio get dio => _dio;

  // Initialize the API service
  Future<ApiService> init() async {
    // Configure default options
    _dio.options = BaseOptions(
      baseUrl: ApiLink.baseurl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    // Configure logging for debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }

    // Add authorization interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Try to get auth repository if it exists
        try {
          final authRepo = Get.find<AuthRepository>();
          if (authRepo.token.isNotEmpty && authRepo.token != "0") {
            options.headers['Authorization'] = 'JWT ${authRepo.token}';
          }
        } catch (e) {
          // AuthRepository not available yet, which is fine for unauthenticated requests
          debugPrint('AuthRepository not available yet: $e');
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle token refresh for 401 errors
        if (error.response?.statusCode == 401) {
          try {
            final authRepo = Get.find<AuthRepository>();
            await authRepo.refreshToken();

            // Retry the request with the new token
            final options = Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers
                ..['Authorization'] = 'JWT ${authRepo.token}',
            );

            final response = await _dio.request(
              error.requestOptions.path,
              options: options,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );

            return handler.resolve(response);
          } catch (e) {
            debugPrint('Error refreshing token: $e');
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));

    return this;
  }
}