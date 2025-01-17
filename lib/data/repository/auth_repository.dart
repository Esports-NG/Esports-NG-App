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
import 'package:e_sport/ui/auth/first_screen.dart';
import 'package:e_sport/ui/auth/login.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:e_sport/ui/home/root.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

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

class AuthRepository extends GetxController {
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

  final Rx<UserModel?> mUser = Rx(null);
  UserModel? get user => mUser.value;

  SharedPref? pref;

  RxList<UserModel> searchedUsers = <UserModel>[].obs;

  Rx<String> mToken = Rx("");
  String get token => mToken.value;

  RxBool mOnSelect = false.obs;
  RxBool mGetCountryCode = false.obs;
  RxBool mNetworkAvailable = false.obs;
  RxBool isLoading = false.obs;
  RxBool searchLoading = false.obs;

  Rx<String> mFcmToken = Rx("");
  String get fcmToken => mFcmToken.value;

  Rx<File?> mUserImage = Rx(null);
  Rx<File?> mCoverImage = Rx(null);
  File? get userImage => mUserImage.value;
  File? get coverImage => mCoverImage.value;

  TextEditingController resetPasswordEmailController = TextEditingController();
  TextEditingController resetPasswordConfirmController =
      TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController resetPasswordOtpController = TextEditingController();
  TextEditingController resetPasswordIdController = TextEditingController();

  RxMap<String, dynamic>? sessionHeaders = RxMap({});

  var dio = Dio();
  IOWebSocketChannel? channel;

  @override
  void onInit() async {
    super.onInit();
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

  Future signUp(UserModel user, BuildContext context) async {
    // try {
    _signUpStatus(SignUpStatus.loading);
    var headers = {
      "Content-Type": "application/json",
    };

    var request = http.MultipartRequest("POST", Uri.parse(ApiLink.register));

    request.headers.addAll(headers);
    request.fields.addAll(user.toRequestJson());
    for (int i = 0; i < user.profile!.igameType!.length; i++) {
      request.fields['profile.igame_type[$i]'] = user.profile!.igameType![i];
    }
    for (int i = 0; i < user.ipurpose!.length; i++) {
      request.fields['ipurpose[$i]'] = user.ipurpose![i];
    }
    if (userImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          "profile.profile_picture", userImage!.path));
    }

    http.StreamedResponse res = await request.send();
    var response = await http.Response.fromStream(res);

    debugPrint(response.body);
    var json = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw (json['profile'] != null
          ? json['profile'][0]
          : json['phone_number'] != null
              ? json['phone_number'][0]
              : json['user_name'] != null
                  ? json['user_name'][0]
                  : json['full_name'] != null
                      ? json['full_name'][0]
                      : json['email'] != null
                          ? json['email'][0]
                          : json['password'] != null
                              ? json['password'][0]
                              : json
                                  .toString()
                                  .replaceAll('{', '')
                                  .replaceAll('}', ''));
    }

    if (response.statusCode == 201) {
      _signUpStatus(SignUpStatus.success);
      EasyLoading.showInfo(
              'Account created successfully!\nConfirmation email sent, Please check your email for further instructions!',
              duration: const Duration(seconds: 2))
          .then((value) async {
        await Future.delayed(const Duration(seconds: 2));
        Get.offAll(() => const LoginScreen());
        clear();
        clearPhoto();
      });
    }

    return response.body;
    // } catch (error) {
    //   _signUpStatus(SignUpStatus.error);
    //   debugPrint("Error occurred ${error.toString()}");
    //   throw(error);
    //   getError(error);
    // }
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

      var response = await http.post(Uri.parse(ApiLink.login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": emailController.text.trim().toLowerCase(),
            "password": passwordController.text.trim(),
            "token": fcmToken,
            "device_name":
                androidInfo != null ? androidInfo.device : iosInfo?.name,
            "device_type": Platform.isAndroid ? "android" : "ios"
          }));

      var json = jsonDecode(response.body);
      if (json.toString().contains('non_field_errors')) {
        throw (json["error"]['non_field_errors'][0]);
      }
      if (json['error'] != null) {
        print(json['error']);
        Helpers()
            .showCustomSnackbar(message: json['error'].toString().capitalize!);
        _signInStatus(SignInStatus.error);
      }

      if (json.toString().contains('Quota Exceeded')) {
        throw ('${json[0]}. Contact admin!');
      }

      if (response.statusCode == 200) {
        if (json['tokens'] != null) {
          var userModel = UserModel.fromJson(json);
          mToken(json['tokens']['access']);
          pref!.saveToken(token);
          mUser(userModel);
          pref!.setUser(userModel);
          _signInStatus(SignInStatus.success);
          _authStatus(AuthStatus.authenticated);
          Helpers().showCustomSnackbar(message: "Login Successful");
          await Future.delayed(const Duration(seconds: 1));
          Get.offAll(() => const RootDashboard());
        } else {
          if (json['message'] != null) {
            Helpers().showCustomSnackbar(message: json["message"]);
          }
          _signInStatus(SignInStatus.error);
        }
      }

      return response.body;
    } catch (error) {
      _signInStatus(SignInStatus.error);
      debugPrint("error $error");
      getError(error);
    }
  }

  Future getUserInfo() async {
    try {
      debugPrint('getting user info...');
      var response = await http.get(Uri.parse(ApiLink.getUser), headers: {
        "Content-Type": "application/json",
        'Authorization': 'JWT $token',
      });
      log(response.body);
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      debugPrint(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        var userModel = UserModel.fromJson(json);
        mUser(userModel);
        pref!.setUser(userModel);
      }
      return response.body;
    } catch (error) {
      debugPrint("getting user info: ${error.toString()}");
    }
  }

  Future updateUser() async {
    try {
      EasyLoading.show(status: 'Updating user info');
      _updateProfileStatus(UpdateProfileStatus.loading);
      var response = await http.put(
          Uri.parse('${ApiLink.user}${user!.id}/update/'),
          body: jsonEncode({
            "full_name": fullNameController.text.trim(),
            "user_name": userNameController.text.trim(),
            "phone_number": phoneNoController.text.trim(),
            "email": emailController.text.trim(),
            "bio": bioController.text.trim()
          }),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'JWT $token'
          });
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }
      debugPrint(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        _updateProfileStatus(UpdateProfileStatus.success);
        Get.to(() => const CreateSuccessPage(title: 'Profile Updated'));
        EasyLoading.dismiss();
        getUserInfo();
        clearPhoto();
      } else if (response.statusCode == 401) {
        refreshToken().then((value) => EasyLoading.showInfo('try again!'));
      }
      return response.body;
    } catch (error) {
      _updateProfileStatus(UpdateProfileStatus.error);
      EasyLoading.dismiss();
      debugPrint("Error occurred ${error.toString()}");
      getError(error);
    }
  }

  void updateProfileImage() async {
    try {
      EasyLoading.show(status: 'Updating user info');
      _updateProfileStatus(UpdateProfileStatus.loading);
      var headers = {'Authorization': 'JWT $token'};
      var request = http.MultipartRequest(
          "PUT", Uri.parse('${ApiLink.user}${user!.id}/update/'));
      request.files.add(await http.MultipartFile.fromPath(
          'profile.profile_picture', userImage!.path));
      request.headers.addAll(headers);

      await request.send().then((response) {
        response.stream.transform(utf8.decoder).listen((response) {
          EasyLoading.dismiss();
          updateUser();
        });
      });
    } catch (error) {
      EasyLoading.dismiss();
      _updateProfileStatus(UpdateProfileStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      getError(error);
    }
  }

  void updateCoverImage() async {
    try {
      EasyLoading.show(status: 'Updating user info');
      _updateProfileStatus(UpdateProfileStatus.loading);
      var headers = {'Authorization': 'JWT $token'};
      var request = http.MultipartRequest(
          "PUT", Uri.parse('${ApiLink.user}${user!.id}/update/'));
      request.files.add(
          await http.MultipartFile.fromPath('profile.cover', coverImage!.path));
      request.headers.addAll(headers);

      await request.send().then((response) {
        response.stream.transform(utf8.decoder).listen((response) {
          EasyLoading.dismiss();
          updateUser();
        });
      });
    } catch (error) {
      EasyLoading.dismiss();
      _updateProfileStatus(UpdateProfileStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      getError(error);
    }
  }

  void updateBothImages() async {
    try {
      EasyLoading.show(status: 'Updating user info');
      _updateProfileStatus(UpdateProfileStatus.loading);
      var headers = {'Authorization': 'JWT $token'};
      var request = http.MultipartRequest(
          "PUT", Uri.parse('${ApiLink.user}${user!.id}/update/'));
      request.files.add(await http.MultipartFile.fromPath(
          'profile.profile_picture', userImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('profile.cover', coverImage!.path));
      request.headers.addAll(headers);

      await request.send().then((response) {
        response.stream.transform(utf8.decoder).listen((response) {
          EasyLoading.dismiss();
          updateUser();
        });
      });
    } catch (error) {
      EasyLoading.dismiss();
      _updateProfileStatus(UpdateProfileStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      getError(error);
    }
  }

  Future followUser(int userId) async {
    _followStatus(FollowStatus.loading);
    debugPrint('following user...');
    var response = await http.post(
      Uri.parse('${ApiLink.followUser}$userId/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT $token'
      },
    );
    debugPrint(response.body);
    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw (json['detail']);
    }
    debugPrint(response.body);
    if (response.statusCode == 200) {
      _followStatus(FollowStatus.success);
      if (json["message"].toString().contains("unfollowed")) {
        return "unfollowed";
      } else {
        return "followed";
      }
    } else {
      return "error";
    }
  }

  Future followOthers(String userId) async {
    try {
      EasyLoading.show(status: 'please wait...');
      _followStatus(FollowStatus.loading);
      debugPrint('following user...');
      var response = await http.post(
        Uri.parse('${ApiLink.followUser}$userId/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT $token'
        },
      );
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }
      debugPrint(response.body);
      if (response.statusCode == 200) {
        EasyLoading.showInfo(json['message']).then((value) async {});
        _followStatus(FollowStatus.success);
      } else {
        _followStatus(FollowStatus.error);
        EasyLoading.dismiss();
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      EasyLoading.dismiss();
      debugPrint("follow user error: $error");
      getError(error);
    }
  }

  Future turnNotification(String postId) async {
    try {
      EasyLoading.show(status: 'please wait...');
      _followStatus(FollowStatus.loading);
      debugPrint('turning notification');
      var response = await http.post(
        Uri.parse('${ApiLink.turnNotification}?group_id=$postId/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT $token'
        },
      );
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }
      debugPrint(response.body);
      if (response.statusCode == 200) {
        EasyLoading.showInfo(json['message']).then((value) async {});
        _followStatus(FollowStatus.success);
      } else {
        _followStatus(FollowStatus.error);
        EasyLoading.dismiss();
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      EasyLoading.dismiss();
      debugPrint("turning notification error: $error");
      getError(error);
    }
  }

  Future followTeam(int id) async {
    _followStatus(FollowStatus.loading);
    try {
      debugPrint('following team...');
      var response = await http.post(
        Uri.parse(ApiLink.followTeam(id)),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT $token'
        },
      );
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }
      debugPrint(response.body);
      if (response.statusCode == 200) {
        _followStatus(FollowStatus.success);
        if (json["message"].toString().contains("unfollowed")) {
          return "unfollowed";
        } else {
          return "followed";
        }
      } else {
        return "error";
      }
    } catch (error) {
      _followStatus(FollowStatus.error);
      debugPrint("follow team error: $error");
      getError(error);
    }
  }

  Future followCommunity(int communityId) async {
    _followStatus(FollowStatus.loading);

    debugPrint('following community...');
    var response = await http.post(
      Uri.parse(ApiLink.followCommunity(communityId)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT $token'
      },
    );
    print(response.body);
    print(response.statusCode);
    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw (json['detail']);
    }
    debugPrint(response.body);
    if (response.statusCode == 200) {
      _followStatus(FollowStatus.success);
      if (json["message"].toString().contains("unfollowed")) {
        return "unfollowed";
      } else {
        return "followed";
      }
    } else {
      return "error";
    }
  }

  Future getProfileFollowerList(int id) async {
    var response = await http
        .get(Uri.parse(ApiLink.getProfileFollowersList(id: id)), headers: {
      "Content-Type": "application/json",
      "Authorization": 'JWT $token'
    });
    List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => e as Map<String, dynamic>).toList();
  }

  Future refreshToken() async {
    try {
      var response = await http.post(Uri.parse(ApiLink.tokenRefresh),
          body: jsonEncode({"refresh": user!.tokens!.refresh}),
          headers: {
            "Content-Type": "application/json",
          });
      var json = jsonDecode(response.body);

      debugPrint(response.body);
      if (response.statusCode == 200) {
        var tokens = Tokens.fromJson(json);
        UserModel userModel = UserModel();
        userModel.tokens = tokens;
        mToken(userModel.tokens!.access);
        pref!.saveToken(userModel.tokens!.access!);
        mUser(userModel);
        pref!.setUser(userModel);
      }
      return response.body;
    } catch (error) {
      debugPrint("refresh token error: ${error.toString()}");
    }
  }

  Future getCountryCode() async {
    try {
      EasyLoading.show(status: 'Fetching country info');
      debugPrint('getting country data');
      var response = await http.get(
          Uri.parse(
              '${ApiLink.getCountryCode}${countryController.text.trim()}'),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        // debugPrint(response.body);
        mGetCountryCode.value = true;
        List<dynamic> json = jsonDecode(response.body);
        countryCodeController.text =
            '${json[0]['idd']['root']}${json[0]['idd']['suffixes'][0]}';
        debugPrint(
            "code: ${json[0]['idd']['root']}${json[0]['idd']['suffixes'][0]}");
        EasyLoading.showSuccess('Success');
      }
      return response.body;
    } catch (error) {
      if (error.toString().contains('restcountries.com')) {
        EasyLoading.showInfo('Network error, try again');
      } else {
        EasyLoading.dismiss();
      }
      debugPrint("getting country code error: ${error.toString()}");
    }
  }

  Future searchForUsers(String query) async {
    try {
      var response = await http.get(
          Uri.parse(ApiLink.searchForPostsorUsers(query, "user")),
          headers: {
            "Authorization": "JWT $token",
            "Content-type": "application/json"
          });

      var json = jsonDecode(response.body);
      var list = List.from(json);
      var users = list.map((e) => UserModel.fromJson(e)).toList();

      searchedUsers.assignAll(users);
    } catch (err) {}
  }

  Future searchAll(String query) async {
    try {
      var response = await http.get(Uri.parse(ApiLink.searchAll(query)),
          headers: {
            "Authorization": "JWT $token",
            "Content-type": "application/json"
          });

      var json = jsonDecode(response.body);

      return json;
    } catch (err) {}
  }

  Future sendActivationLink(String email) async {
    try {
      var response = await http
          .post(Uri.parse(ApiLink.sendActivationEmail(email)), headers: {
        // "Authorization": "JWT $token",
        "Content-type": "application/json"
      });

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Account activation email sent.");
      }
    } catch (err) {}
  }

  Future requestPasswordOtp() async {
    var body = {"email": resetPasswordEmailController.text};
    var response = await dio.post(ApiLink.requestPasswordOtp, data: body);

    var cookies = response.headers.map['set-cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      dio.options.headers['cookie'] = cookies;
    }

    print(response.data);
    var json = response.data;

    if (response.statusCode == 200) {
      Helpers().showCustomSnackbar(message: json['message']);
      return true;
    }
    return false;
  }

  Future verifyPasswordOtp() async {
    var body = {"otp": int.parse(resetPasswordOtpController.text)};
    var response = await dio.post(ApiLink.verifyOtp, data: body);

    var cookies = response.headers.map['set-cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      dio.options.headers['cookie'] = cookies;
    }

    print(response.data);
    var json = response.data;

    resetPasswordIdController.text = json['message']!.toString();

    if (response.statusCode == 200) {
      Helpers().showCustomSnackbar(message: "Verified OTP");
      return true;
    }
    return false;
  }

  Future resetPassword() async {
    var body = {
      "password": resetPasswordController.text,
      "password2": resetPasswordConfirmController.text
    };
    var response = await dio
        .put(ApiLink.resetPassword(resetPasswordIdController.text), data: body);

    print(response.data);

    var json = response.data;

    if (response.statusCode == 200) {
      Helpers().showCustomSnackbar(message: "Your password has been reset");
      Get.off(() => const LoginScreen());
    }
  }

  void getError(var error) {
    Helpers().showCustomSnackbar(
        message: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Internal server error, contact admin!'
                : error.toString().replaceAll('(', '').replaceAll(')', ''));
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
    var response = await http.post(Uri.parse(ApiLink.logout),
        headers: {"Authorization": "JWT $token"});
    log(response.body);
    _authStatus(AuthStatus.unAuthenticated);
    clear();
    pref!.saveToken("0");
    mToken("0");
    pref!.logout();
    Get.offAll(() => const FirstScreen());
  }
}
