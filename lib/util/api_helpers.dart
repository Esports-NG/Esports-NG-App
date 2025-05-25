// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';

/// Helper functions for handling API calls and errors
class ApiHelpers {
  /// Handles API error responses consistently
  static void handleApiError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      final path = error.requestOptions.path;
      print(path);
      print(error.response);
      if (response != null) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          // Helpers().showCustomSnackbar(message: data['message']);
          return;
        }
      }
      // Handle network errors
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        Helpers().showCustomSnackbar(
            message: 'Network error! Please check your connection.');
        return;
      }
    }
    print(error);
    // Fallback error message
    // Helpers().showCustomSnackbar(
    //     message: (error.toString().contains("esports-ng.vercel.app") ||
    //             error.toString().contains("Network is unreachable"))
    //         ? 'No internet connection!'
    //         : (error.toString().contains("FormatException"))
    //             ? 'Internal server error, contact admin!'
    //             : error.toString().replaceAll('(', '').replaceAll(')', ''));
  }

  /// Generic API call wrapper for handling errors and success consistently
  static Future<T?> safeApiCall<T>(Future<Response> Function() apiCall,
      {T Function(Map<String, dynamic>)? fromJson,
      Function(bool)? setStatus,
      Function(T?)? onSuccess}) async {
    try {
      if (setStatus != null) setStatus(true);
      final response = await apiCall();
      // print(response);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final apiResponse = ApiResponse.fromJson(
            response.data is Map<String, dynamic>
                ? response.data
                : {'success': true, 'data': response.data},
            fromJson);

        if (apiResponse.message != null) {
          Helpers().showCustomSnackbar(message: apiResponse.message!);
        }

        if (onSuccess != null) {
          onSuccess(apiResponse.data);
        }

        return apiResponse.data;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Unexpected status code: ${response.statusCode}');
      }
    } catch (error) {
      handleApiError(error);
      return null;
    } finally {
      if (setStatus != null) setStatus(false);
    }
  }

  /// Converts a file to a MultipartFile for API uploads
  static Future<MultipartFile?> fileToMultipart(File? file, String name) async {
    if (file == null) return null;
    return MultipartFile.fromFileSync(file.path, filename: name);
  }
}

/// Standard API response model for handling consistent response structure
class ApiResponse<T> {
  final String? message;
  final bool success;
  final T? data;

  ApiResponse({
    this.message,
    required this.success,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse(
      message: json['message'],
      success: json['success'] ?? false,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
    );
  }
}
