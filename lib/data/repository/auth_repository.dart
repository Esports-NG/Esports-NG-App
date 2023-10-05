// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/shared_pref.dart';
import 'package:e_sport/ui/auth/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

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
  late final genderController = TextEditingController();
  late final dobController = TextEditingController();
  late final referralController = TextEditingController();
  late final passwordController = TextEditingController();
  late final currentPasswordController = TextEditingController();
  late final confirmPasswordController = TextEditingController();
  late final forgotPassword = TextEditingController();
  late final otpPin = TextEditingController();
  late final transactionPinController = TextEditingController();
  late final confirmTransactionPinController = TextEditingController();
  late final userIdController = TextEditingController();
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

  final status = AuthStatus.uninitialized.obs;

  final Rx<UserModel?> mUser = Rx(null);
  UserModel? get user => mUser.value;

  // final Rx<Data?> userAddress = Rx(null);
  // Data? get deliveryAddress => userAddress.value;
  SharedPref? pref;

  Rx<String> mToken = Rx("");
  String get token => mToken.value;

  RxBool mOnSelect = false.obs;
  // bool get onSelect => mOnSelect.value;

  Rx<String> mFcmToken = Rx("");
  String get fcmToken => mFcmToken.value;

  @override
  void onInit() async {
    super.onInit();
    pref = SharedPref();
    await pref!.init();
    if (pref!.getFirstTimeOpen()) {
      _authStatus(AuthStatus.isFirstTime);
      if (kDebugMode) {
        debugPrint(authStatus.name);
        print("My first time using this app");
      }
    } else {
      if (kDebugMode) {
        print("Not my First Time Using this app");
      }

      if (pref!.getUser() != null) {
        mUser(pref!.getUser()!);
        mToken(pref!.read());
        if (kDebugMode) {
          print("result of token is ${mToken.value}");
        }
        _authStatus(AuthStatus.authenticated);

        if (mToken.value == "0") {
          _authStatus(AuthStatus.unAuthenticated);
        }
      } else {
        _authStatus(AuthStatus.unAuthenticated);
      }
    }
  }

  Future signUp(UserModel user) async {
    try {
      _signUpStatus(SignUpStatus.loading);
      debugPrint("request json ${user.toJson()}");
      var response = await http.post(Uri.parse(ApiLink.register),
          body: jsonEncode(user.toJson()),
          headers: {
            "Content-Type": "application/json",
          });
      var json = jsonDecode(response.body);
      if (json['success'] == false) {
        throw (json['message']);
      }

      debugPrint("response $json");
      debugPrint("user id ${json['data']['user_id']}");

      if (json['success'] == true) {
        _signUpStatus(SignUpStatus.success);

        Get.snackbar('Success',
            'Account created successfully, Proceed to validate your account!');
      }

      return response.body;
    } catch (error) {
      _signUpStatus(SignUpStatus.error);
      Get.snackbar(
          'Error',
          (error.toString() ==
                      "Failed host lookup: 'farmersdomain.herokuapp.com'" ||
                  error.toString() ==
                      "Failed host lookup: 'staging-farmers-domain-ae54637d7865.herokuapp.com'")
              ? 'No internet connection!'
              : error.toString());

      debugPrint("Error occurred ${error.toString()}");
    }
  }

  Future login() async {
    _signInStatus(SignInStatus.loading);
    try {
      debugPrint('login here...');

      var response = await http.post(
          Uri.parse(
            ApiLink.login,
          ),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": emailController.text.trim(),
            "password": passwordController.text.trim(),
          }));

      debugPrint(response.body);

      var json = jsonDecode(response.body);
      if (json['errors'] != null) {
        throw (json['message']);
      }

      if (response.statusCode == 200) {
        _signInStatus(SignInStatus.success);
        clear();
        mToken(json['access_token']);
        pref!.saveToken(token);
      } else if (response.statusCode == 403) {
        _signInStatus(SignInStatus.notVerified);
        clear();
        Get.snackbar('Alert', 'Please verify your account in order to proceed');
        // await resendOTP(id: json['data']['user_id']);
        // Get.off(() => OTPVerification(
        //       title: 'Account',
        //       userId: json['data']['user_id'],
        //     ));
      }
      return response.body;
    } catch (error) {
      _signInStatus(SignInStatus.error);
      Get.snackbar(
          'Error',
          (error.toString() ==
                      "Failed host lookup: 'farmersdomain.herokuapp.com'" ||
                  error.toString() ==
                      "Failed host lookup: 'staging-farmers-domain-ae54637d7865.herokuapp.com'")
              ? 'No internet connection!'
              : error.toString());

      debugPrint("error ${error.toString()}");
    }
  }

  void clear() {
    passwordController.clear();
    confirmPasswordController.clear();
    currentPasswordController.clear();
    transactionPinController.clear();
    confirmTransactionPinController.clear();
  }

  void logout() {
    _authStatus(AuthStatus.unAuthenticated);
    clear();
    pref!.saveToken("0");
    mToken("0");
    pref!.logout();
    Get.offAll(() => const LoginScreen());
  }
}
