// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/notification_service.dart';
import 'package:e_sport/di/shared_pref.dart';
import 'package:e_sport/ui/screens/auth/first_screen.dart';
import 'package:e_sport/ui/screens/auth/login.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/ui/screens/nav/root.dart';
import 'package:e_sport/util/api_helpers.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as Get;
import 'package:web_socket_channel/io.dart';

// Status enums
enum DeliveryAddressStatus {
  empty,
  loading,
  error,
  success,
}

enum SignUpStatus {
  empty,
  loading,
  error,
  success,
}

enum OtpAuthStatus {
  empty,
  loading,
  error,
  success,
}

enum OtpValidateStatus {
  empty,
  loading,
  error,
  success,
}

enum UpdateProfileStatus {
  empty,
  loading,
  error,
  success,
}

enum OtpForgotVerifyStatus {
  empty,
  loading,
  error,
  success,
}

enum SignInStatus {
  empty,
  loading,
  error,
  success,
  invalidPinOrPhoneNumber,
  notVerified
}

enum ChangePasswordStatus {
  empty,
  loading,
  error,
  success,
  invalidPinOrPhoneNumber,
  notVerified
}

enum UserTransactionStatus {
  empty,
  loading,
  error,
  success,
}

enum FollowStatus {
  empty,
  loading,
  error,
  success,
}

enum AuthStatus {
  loading,
  authenticated,
  success,
  uninitialized,
  unAuthenticated,
  error,
  unknownError,
  empty,
  isFirstTime,
  phoneExist,
  emailExist,
  usernameExist,
  tokenExist,
  signedUp,
  validated,
}

// Response model to handle the new backend structure
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

class AuthRepository extends Get.GetxController {
  // Text controllers
  late final userNameController = TextEditingController();
  late final fullNameController = TextEditingController();
  late final emailController = TextEditingController();
  late final phoneNoController = TextEditingController();
  late final countryController = TextEditingController();
  late final countryCodeController = TextEditingController();
  late final stateController = TextEditingController();
  late final genderController = TextEditingController();
  late final dobController = TextEditingController();
  late final purposeController = TextEditingController();
  late final gameTypeController = TextEditingController();
  late final pictureController = TextEditingController();
  late final referralController = TextEditingController();
  late final passwordController = TextEditingController();
  late final confirmPasswordController = TextEditingController();
  late final commentController = TextEditingController();
  late final accountTypeController = TextEditingController();
  late final otpPin = TextEditingController();
  late final searchController = TextEditingController();
  late final amountController = TextEditingController();
  late final cardNoController = TextEditingController();
  late final cardExpiryController = TextEditingController();
  late final chatController = TextEditingController();
  late final cvvController = TextEditingController();
  late final bioController = TextEditingController();

  DateTime? date;

  // Status Observables
  final _authStatus = AuthStatus.empty.obs;
  final _signInStatus = SignInStatus.empty.obs;
  final _signUpStatus = SignUpStatus.empty.obs;
  final _otpAuthStatus = OtpAuthStatus.empty.obs;
  final _otpValidateStatus = OtpValidateStatus.empty.obs;
  final _updateProfileStatus = UpdateProfileStatus.empty.obs;
  final _otpForgotVerifyStatus = OtpForgotVerifyStatus.empty.obs;
  final _changePasswordStatus = ChangePasswordStatus.empty.obs;
  final _deliveryAddressStatus = DeliveryAddressStatus.empty.obs;
  final _userTransactionStatus = UserTransactionStatus.empty.obs;
  final _followStatus = FollowStatus.empty.obs;

  // Getters for status
  AuthStatus get authStatus => _authStatus.value;
  SignUpStatus get signUpStatus => _signUpStatus.value;
  SignInStatus get signInStatus => _signInStatus.value;
  OtpAuthStatus get otpAuthStatus => _otpAuthStatus.value;
  OtpValidateStatus get otpValidateStatus => _otpValidateStatus.value;
  UpdateProfileStatus get updateProfileStatus => _updateProfileStatus.value;
  ChangePasswordStatus get changePasswordStatus => _changePasswordStatus.value;
  DeliveryAddressStatus get deliveryAddressStatus =>
      _deliveryAddressStatus.value;
  OtpForgotVerifyStatus get otpForgotVerifyStatus =>
      _otpForgotVerifyStatus.value;
  UserTransactionStatus get transactionStatus => _userTransactionStatus.value;
  FollowStatus get followStatus => _followStatus.value;

  final status = AuthStatus.uninitialized.obs;

  // User and related observables
  final Get.Rx<UserModel?> mUser = Get.Rx(null);
  UserModel? get user => mUser.value;

  SharedPref? pref;

  Get.RxList<UserModel> searchedUsers = <UserModel>[].obs;

  Get.Rx<String> mToken = Get.Rx("");
  String get token => mToken.value;

  Get.RxBool mOnSelect = false.obs;
  Get.RxBool mGetCountryCode = false.obs;
  Get.RxBool mNetworkAvailable = false.obs;
  Get.RxBool isLoading = false.obs;
  Get.RxBool searchLoading = false.obs;

  Get.Rx<String> mFcmToken = Get.Rx("");
  String get fcmToken => mFcmToken.value;

  Get.Rx<File?> mUserImage = Get.Rx(null);
  Get.Rx<File?> mCoverImage = Get.Rx(null);
  File? get userImage => mUserImage.value;
  File? get coverImage => mCoverImage.value;

  // Password reset controllers
  TextEditingController resetPasswordEmailController = TextEditingController();
  TextEditingController resetPasswordConfirmController =
      TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController resetPasswordOtpController = TextEditingController();
  TextEditingController resetPasswordIdController = TextEditingController();

  Get.RxMap<String, dynamic>? sessionHeaders = Get.RxMap({});

  // Dio instance
  late Dio _dio;
  IOWebSocketChannel? channel;

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
        if (token.isNotEmpty && token != "0") {
          options.headers['Authorization'] = 'JWT $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle token refresh if 401 error occurs
        if (error.response?.statusCode == 401 &&
            user?.tokens?.refresh != null) {
          try {
            await refreshToken();
            // Retry the request with updated token
            final opts = Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers
                ..['Authorization'] = 'JWT $token',
            );
            final response = await _dio.request(
              error.requestOptions.path,
              options: opts,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );
            return handler.resolve(response);
          } catch (e) {
            // If refresh token fails, proceed with original error
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  @override
  void onInit() async {
    super.onInit();
    _initDio();

    pref = SharedPref();
    await pref!.init();

    if (pref!.getFirstTimeOpen()) {
      _authStatus(AuthStatus.isFirstTime);
      debugPrint(authStatus.name);
      debugPrint("My first time using this app");
    } else {
      debugPrint("Not my First Time Using this app");

      if (pref!.getUser() != null) {
        mUser(pref!.getUser()!);
        mToken(pref!.read());
        getUserInfo();
        _authStatus(AuthStatus.authenticated);
        if (mToken.value == "0") {
          _authStatus(AuthStatus.unAuthenticated);
        }
      } else {
        _authStatus(AuthStatus.unAuthenticated);
      }
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  // Upload files helper
  Future<MultipartFile?> _fileToMultipart(File? file, String name) async {
    return ApiHelpers.fileToMultipart(file, name);
  }

  Future<T?> _safeApiCall<T>(Future<Response> Function() apiCall,
      {T Function(Map<String, dynamic>)? fromJson,
      Function(bool)? setStatus,
      Function(T?)? onSuccess}) async {
    return ApiHelpers.safeApiCall(apiCall,
        fromJson: fromJson, setStatus: setStatus, onSuccess: onSuccess);
  }

  // Handle error responses consistently
  void _handleApiError(dynamic error) {
    ApiHelpers.handleApiError(error);
  }

  Future signUp(UserModel user, BuildContext context) async {
    _signUpStatus(SignUpStatus.loading);

    try {
      // Create form data for multipart request
      final formData = FormData.fromMap(user.toRequestJson());

      // Add game types
      for (int i = 0; i < user.profile!.igameType!.length; i++) {
        formData.fields.add(
            MapEntry('profile.igame_type[$i]', user.profile!.igameType![i]));
      }

      // Add purposes
      for (int i = 0; i < user.ipurpose!.length; i++) {
        formData.fields.add(MapEntry('ipurpose[$i]', user.ipurpose![i]));
      }

      // Add profile picture if exists
      if (userImage != null) {
        formData.files.add(MapEntry('profile.profile_picture',
            await MultipartFile.fromFile(userImage!.path)));
      }

      final response = await _dio.post(ApiLink.register, data: formData);

      if (response.statusCode == 201) {
        _signUpStatus(SignUpStatus.success);
        EasyLoading.showInfo(
                'Account created successfully!\nConfirmation email sent, Please check your email for further instructions!',
                duration: const Duration(seconds: 2))
            .then((value) async {
          await Future.delayed(const Duration(seconds: 2));
          Get.Get.offAll(() => const LoginScreen());
          clear();
          clearPhoto();
        });
        return response.data;
      } else {
        _signUpStatus(SignUpStatus.error);
        throw 'Failed to create account';
      }
    } catch (error) {
      _signUpStatus(SignUpStatus.error);
      _handleApiError(error);
      return null;
    }
  }

  Future login(BuildContext context) async {
    _signInStatus(SignInStatus.loading);
    final notificationService = NotificationService();
    final deviceInfo = DeviceInfoPlugin();

    try {
      var fcmToken = await notificationService.getFCMToken();
      debugPrint('login here...');

      var androidInfo =
          Platform.isAndroid ? await deviceInfo.androidInfo : null;
      var iosInfo = Platform.isIOS ? await deviceInfo.iosInfo : null;

      final data = {
        "email": emailController.text.trim().toLowerCase(),
        "password": passwordController.text.trim(),
        "token": fcmToken,
        "device_name": androidInfo != null ? androidInfo.device : iosInfo?.name,
        "device_type": Platform.isAndroid ? "android" : "ios"
      };

      final response = await _dio.post(ApiLink.login, data: data);
      final responseData = response.data;

      if (responseData['success'] == true && responseData['data'] != null) {
        if (responseData['data']['tokens'] != null) {
          var userModel = UserModel.fromJson(responseData['data']);
          mToken(userModel.tokens?.access ?? "");
          pref!.saveToken(token);
          mUser(userModel);
          pref!.setUser(userModel);
          _signInStatus(SignInStatus.success);
          _authStatus(AuthStatus.authenticated);

          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? "Login Successful");
          await Future.delayed(const Duration(seconds: 1));
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RootDashboard()));
        }
      } else {
        _signInStatus(SignInStatus.error);
        Helpers().showCustomSnackbar(
            message: responseData['message'] ?? 'Login failed');
      }

      return responseData;
    } catch (error) {
      _signInStatus(SignInStatus.error);
      _handleApiError(error);
      return null;
    }
  }

  Future getUserInfo() async {
    try {
      debugPrint('getting user info...');
      final response = await _dio.get(ApiLink.getUser);
      final responseData = response.data;
      print(responseData);

      if (responseData['success'] == true && responseData['data'] != null) {
        var userModel = UserModel.fromJson(responseData['data']);
        print("slug : ${userModel.slug}");
        mUser(userModel);
        pref!.setUser(userModel);
      } else {
        throw responseData['message'] ?? 'Failed to get user info';
      }

      return responseData;
    } catch (error) {
      debugPrint("getting user info error: ${error.toString()}");
      return null;
    }
  }

  Future updateUser() async {
    try {
      EasyLoading.show(status: 'Updating user info');
      _updateProfileStatus(UpdateProfileStatus.loading);

      final data = {
        "full_name": fullNameController.text.trim(),
        "user_name": userNameController.text.trim(),
        "phone_number": phoneNoController.text.trim(),
        "email": emailController.text.trim(),
        "bio": bioController.text.trim()
      };

      final response = await _dio.put(ApiLink.user, data: data);
      final responseData = response.data;

      if (responseData['success'] == true) {
        EasyLoading.dismiss();
        _updateProfileStatus(UpdateProfileStatus.success);
        Get.Get.to(() => const CreateSuccessPage(title: 'Profile Updated'));
        getUserInfo();
        clearPhoto();
      } else {
        throw responseData['message'] ?? 'Failed to update user';
      }

      return responseData;
    } catch (error) {
      _updateProfileStatus(UpdateProfileStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
      return null;
    }
  }

  void updateProfileImage() async {
    try {
      EasyLoading.show(status: 'Updating profile image');
      _updateProfileStatus(UpdateProfileStatus.loading);

      final formData = FormData.fromMap({});
      formData.files.add(MapEntry('profile.profile_picture',
          await MultipartFile.fromFile(userImage!.path)));

      final response =
          await _dio.put('${ApiLink.user}${user!.id}/update/', data: formData);

      EasyLoading.dismiss();
      if (response.data['success'] == true) {
        updateUser();
      } else {
        throw response.data['message'] ?? 'Failed to update profile image';
      }
    } catch (error) {
      EasyLoading.dismiss();
      _updateProfileStatus(UpdateProfileStatus.error);
      _handleApiError(error);
    }
  }

  void updateCoverImage() async {
    try {
      EasyLoading.show(status: 'Updating cover image');
      _updateProfileStatus(UpdateProfileStatus.loading);

      final formData = FormData.fromMap({});
      formData.files.add(MapEntry(
          'profile.cover', await MultipartFile.fromFile(coverImage!.path)));

      final response =
          await _dio.put('${ApiLink.user}${user!.id}/update/', data: formData);

      EasyLoading.dismiss();
      if (response.data['success'] == true) {
        updateUser();
      } else {
        throw response.data['message'] ?? 'Failed to update cover image';
      }
    } catch (error) {
      EasyLoading.dismiss();
      _updateProfileStatus(UpdateProfileStatus.error);
      _handleApiError(error);
    }
  }

  void updateBothImages() async {
    try {
      EasyLoading.show(status: 'Updating images');
      _updateProfileStatus(UpdateProfileStatus.loading);

      final formData = FormData.fromMap({});
      formData.files.add(MapEntry('profile.profile_picture',
          await MultipartFile.fromFile(userImage!.path)));
      formData.files.add(MapEntry(
          'profile.cover', await MultipartFile.fromFile(coverImage!.path)));

      final response =
          await _dio.put('${ApiLink.user}${user!.id}/update/', data: formData);

      EasyLoading.dismiss();
      if (response.data['success'] == true) {
        updateUser();
      } else {
        throw response.data['message'] ?? 'Failed to update images';
      }
    } catch (error) {
      EasyLoading.dismiss();
      _updateProfileStatus(UpdateProfileStatus.error);
      _handleApiError(error);
    }
  }

  Future followUser(String slug) async {
    _followStatus(FollowStatus.loading);

    try {
      debugPrint('following user...');
      final response = await _dio.post('${ApiLink.followUser}$slug/');
      final responseData = response.data;

      if (responseData['success'] == true) {
        _followStatus(FollowStatus.success);
        final message = responseData['message'] ?? '';
        if (message.toString().contains("unfollowed")) {
          return "unfollowed";
        } else {
          return "followed";
        }
      } else {
        _followStatus(FollowStatus.error);
        return "error";
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      _handleApiError(error);
      return "error";
    }
  }

  Future followOthers(String userId) async {
    try {
      EasyLoading.show(status: 'please wait...');
      _followStatus(FollowStatus.loading);

      debugPrint('following user...');
      final response = await _dio.post('${ApiLink.followUser}$userId/');
      final responseData = response.data;

      if (responseData['success'] == true) {
        EasyLoading.showInfo(responseData['message'] ?? 'Success');
        _followStatus(FollowStatus.success);
      } else {
        _followStatus(FollowStatus.error);
        EasyLoading.dismiss();
        throw responseData['message'] ?? 'Failed to follow user';
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
    }
  }

  Future turnNotification(String postId) async {
    try {
      EasyLoading.show(status: 'please wait...');
      _followStatus(FollowStatus.loading);

      debugPrint('turning notification');
      final response =
          await _dio.post('${ApiLink.turnNotification}?group_id=$postId/');
      final responseData = response.data;

      if (responseData['success'] == true) {
        EasyLoading.showInfo(
            responseData['message'] ?? 'Notification setting updated');
        _followStatus(FollowStatus.success);
      } else {
        _followStatus(FollowStatus.error);
        EasyLoading.dismiss();
        throw responseData['message'] ??
            'Failed to update notification settings';
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
    }
  }

  Future followTeam(String slug) async {
    _followStatus(FollowStatus.loading);

    try {
      debugPrint('following team...');
      final response = await _dio.post(ApiLink.followTeam(slug));
      final responseData = response.data;

      if (responseData['success'] == true) {
        _followStatus(FollowStatus.success);
        final message = responseData['message'] ?? '';
        if (message.toString().contains("unfollowed")) {
          return "unfollowed";
        } else {
          return "followed";
        }
      } else {
        _followStatus(FollowStatus.error);
        return "error";
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      _handleApiError(error);
      return "error";
    }
  }

  Future followCommunity(String slug) async {
    _followStatus(FollowStatus.loading);

    try {
      debugPrint('following community...');
      final response = await _dio.post(ApiLink.followCommunity(slug));
      final responseData = response.data;

      if (responseData['success'] == true) {
        _followStatus(FollowStatus.success);
        final message = responseData['message'] ?? '';
        if (message.toString().contains("unfollowed")) {
          return "unfollowed";
        } else {
          return "followed";
        }
      } else {
        _followStatus(FollowStatus.error);
        return "error";
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      _handleApiError(error);
      return "error";
    }
  }

  Future getProfileFollowerList(String slug) async {
    try {
      final response =
          await _dio.get(ApiLink.getProfileFollowersList(slug: slug));
      print(" followers ${response.data}");

      if (response.data is List) {
        return (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      } else if (response.data['success'] == true &&
          response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }

      return [];
    } catch (error) {
      _handleApiError(error);
      return [];
    }
  }

  Future refreshToken() async {
    try {
      if (user?.tokens?.refresh == null) {
        debugPrint("No refresh token available");
        return null;
      }

      final data = {"refresh": user!.tokens!.refresh};
      final response = await _dio.post(ApiLink.tokenRefresh, data: data);
      final responseData = response.data;

      if (responseData['success'] == true && responseData['data'] != null) {
        var tokens = Tokens.fromJson(responseData['data']);
        var userModel = UserModel();
        userModel.tokens = tokens;
        mToken(userModel.tokens!.access ?? "");
        pref!.saveToken(userModel.tokens!.access!);
        mUser(userModel);
        pref!.setUser(userModel);
        return responseData;
      } else {
        throw responseData['message'] ?? 'Failed to refresh token';
      }
    } catch (error) {
      debugPrint("refresh token error: ${error.toString()}");
      return null;
    }
  }

  Future getCountryCode() async {
    try {
      EasyLoading.show(status: 'Fetching country info');
      debugPrint('getting country data');

      final client = Dio();
      final response = await client
          .get('${ApiLink.getCountryCode}${countryController.text.trim()}');

      if (response.statusCode == 200 &&
          response.data is List &&
          response.data.isNotEmpty) {
        mGetCountryCode.value = true;
        final data = response.data[0];
        if (data['idd'] != null) {
          countryCodeController.text =
              '${data['idd']['root']}${data['idd']['suffixes'][0]}';
          debugPrint(
              "code: ${data['idd']['root']}${data['idd']['suffixes'][0]}");
          EasyLoading.showSuccess('Success');
        }
      }

      return response.data;
    } catch (error) {
      if (error.toString().contains('restcountries.com')) {
        EasyLoading.showInfo('Network error, try again');
      } else {
        EasyLoading.dismiss();
      }
      debugPrint("getting country code error: ${error.toString()}");
      return null;
    }
  }

  Future searchForUsers(String query) async {
    try {
      final response =
          await _dio.get(ApiLink.searchForPostsorUsers(query, "user"));
      final responseData = response.data;

      if (responseData['success'] == true && responseData['data'] is List) {
        final users = (responseData['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
        searchedUsers.assignAll(users);
      } else if (responseData is List) {
        final users =
            (responseData as List).map((e) => UserModel.fromJson(e)).toList();
        searchedUsers.assignAll(users);
      } else {
        searchedUsers.clear();
      }
    } catch (error) {
      debugPrint("search users error: ${error.toString()}");
      searchedUsers.clear();
    }
  }

  Future searchAll(String query) async {
    try {
      final response = await _dio.get(ApiLink.searchAll(query));
      return response.data;
    } catch (error) {
      _handleApiError(error);
      return null;
    }
  }

  Future sendActivationLink(String email) async {
    try {
      final response = await _dio.post(ApiLink.sendActivationEmail(email));
      final responseData = response.data;

      if (responseData['success'] == true) {
        Get.Get.back();
        Helpers().showCustomSnackbar(
            message:
                responseData['message'] ?? "Account activation email sent.");
        return true;
      } else {
        throw responseData['message'] ?? 'Failed to send activation email';
      }
    } catch (error) {
      _handleApiError(error);
      return false;
    }
  }

  Future requestPasswordOtp() async {
    try {
      final data = {"email": resetPasswordEmailController.text};
      final response = await _dio.post(ApiLink.requestPasswordOtp, data: data);
      final responseData = response.data;

      if (responseData['success'] == true) {
        Helpers().showCustomSnackbar(
            message: responseData['message'] ?? "OTP sent successfully");
        return true;
      } else {
        throw responseData['message'] ?? 'Failed to send OTP';
      }
    } catch (error) {
      _handleApiError(error);
      return false;
    }
  }

  Future verifyPasswordOtp() async {
    try {
      final data = {"otp": int.parse(resetPasswordOtpController.text)};
      final response = await _dio.post(ApiLink.verifyOtp, data: data);
      final responseData = response.data;

      if (responseData['success'] == true) {
        resetPasswordIdController.text = responseData['data']?.toString() ??
            responseData['message']?.toString() ??
            "";
        Helpers().showCustomSnackbar(message: "Verified OTP");
        return true;
      } else {
        throw responseData['message'] ?? 'Failed to verify OTP';
      }
    } catch (error) {
      _handleApiError(error);
      return false;
    }
  }

  Future resetPassword() async {
    try {
      final data = {
        "password": resetPasswordController.text,
        "password2": resetPasswordConfirmController.text
      };

      final response = await _dio.put(
          ApiLink.resetPassword(resetPasswordIdController.text),
          data: data);
      final responseData = response.data;

      if (responseData['success'] == true) {
        Helpers().showCustomSnackbar(
            message: responseData['message'] ?? "Your password has been reset");
        Get.Get.off(() => const LoginScreen());
        return true;
      } else {
        throw responseData['message'] ?? 'Failed to reset password';
      }
    } catch (error) {
      _handleApiError(error);
      return false;
    }
  }

  void getError(var error) {
    _handleApiError(error);
  }

  void clearPhoto() {
    debugPrint('image cleared');
    mUserImage.value = null;
    mCoverImage.value = null;
  }

  void clear() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    userNameController.clear();
    phoneNoController.clear();
    countryController.clear();
    stateController.clear();
    genderController.clear();
    dobController.clear();
    purposeController.clear();
    gameTypeController.clear();
    otpPin.clear();
    countryCodeController.clear();
  }

  void logout() async {
    try {
      await _dio.post(ApiLink.logout);
      _authStatus(AuthStatus.unAuthenticated);
      clear();
      pref!.saveToken("0");
      mToken("0");
      pref!.logout();
      Get.Get.offAll(() => const FirstScreen());
    } catch (error) {
      debugPrint("logout error: ${error.toString()}");
      // Even if logout API fails, still clear local data
      _authStatus(AuthStatus.unAuthenticated);
      clear();
      pref!.saveToken("0");
      mToken("0");
      pref!.logout();
      Get.Get.offAll(() => const FirstScreen());
    }
  }
}
