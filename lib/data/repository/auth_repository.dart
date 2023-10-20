// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/shared_pref.dart';
import 'package:e_sport/ui/auth/login.dart';
import 'package:e_sport/ui/auth/otp_screen.dart';
import 'package:e_sport/ui/home/dashboard.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  late final countryController = TextEditingController();
  late final stateController = TextEditingController();
  late final genderController = TextEditingController();
  late final dobController = TextEditingController();
  late final purposeController = TextEditingController();
  late final gameTypeController = TextEditingController();
  late final pictureController = TextEditingController();
  late final referralController = TextEditingController();
  late final passwordController = TextEditingController();
  late final confirmPasswordController = TextEditingController();
  late final otpPin = TextEditingController();
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

  SharedPref? pref;

  Rx<String> mToken = Rx("");
  String get token => mToken.value;

  RxBool mOnSelect = false.obs;

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

  Future signUp(UserModel user, BuildContext context) async {
    try {
      _signUpStatus(SignUpStatus.loading);
      var response = await http.post(Uri.parse(ApiLink.register),
          body: jsonEncode(user.toJson()),
          headers: {
            "Content-Type": "application/json",
          });
      var json = jsonDecode(response.body);
      debugPrint(response.statusCode.toString() + response.body);

      if (response.statusCode == 500) {
        throw 'Internal server error, contact admin!';
      } else if (response.statusCode != 500 && response.statusCode != 201) {
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
                duration: const Duration(seconds: 3))
            .then((value) async {
          await Future.delayed(const Duration(seconds: 3));
          Get.off(() => const LoginScreen());
          clear();
        });
      }

      return response.body;
    } catch (error) {
      _signUpStatus(SignUpStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      noInternetError(context, error);
    }
  }

  Future login(BuildContext context) async {
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
      var json = jsonDecode(response.body);
      debugPrint(response.statusCode.toString() + response.body);

      if (response.statusCode == 400) {
        throw (json[0]);
      } else if (response.statusCode != 200) {
        throw (json['non_field_errors'] != null
            ? json['non_field_errors'][0]
            : json.toString());
      }

      if (response.statusCode == 200) {
        _signInStatus(SignInStatus.success);
        clear();
        _authStatus(AuthStatus.authenticated);
        EasyLoading.showInfo(json['message'],
                duration: const Duration(seconds: 3))
            .then((value) async {
          await Future.delayed(const Duration(seconds: 3));
          Get.to(() => const OTPScreen());
        });
      }
      return response.body;
    } catch (error) {
      _signInStatus(SignInStatus.error);
      debugPrint("error ${error.toString()}");
      noInternetError(context, error);
    }
  }

  Future verifyOtp(BuildContext context) async {
    _otpValidateStatus(OtpValidateStatus.loading);
    try {
      debugPrint('verifying otp...');
      EasyLoading.show(status: 'Verifying...');
      var response = await http.post(
          Uri.parse(
            ApiLink.verifyOtp,
          ),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "otp": otpPin.text.trim(),
          }));

      var json = jsonDecode(response.body);
      debugPrint(response.statusCode.toString() + response.body);

      if (response.statusCode != 201) {
        throw (json['message']);
      }

      if (response.statusCode == 201) {
        _otpValidateStatus(OtpValidateStatus.success);
        clear();
        mToken(json['access']);
        pref!.saveToken(token);
        // var userModel = UserModel.fromJson(json);
        // mUser(userModel);
        // pref!.setUser(userModel);
        _authStatus(AuthStatus.authenticated);

        EasyLoading.showInfo('Success', duration: const Duration(seconds: 3))
            .then((value) async {
          await Future.delayed(const Duration(seconds: 3));
          Get.off(() => const Dashboard());
        });
      }
      return response.body;
    } catch (error) {
      _otpValidateStatus(OtpValidateStatus.error);
      EasyLoading.dismiss();
      debugPrint("error ${error.toString()}");
      noInternetError(context, error);
    }
  }

  void noInternetError(BuildContext context, var error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          title: (error.toString().contains("esports-ng.vercel.app") ||
                  error.toString().contains("Network is unreachable"))
              ? 'No internet connection!'
              : (error.toString().contains("FormatException"))
                  ? 'An error occurred, try again!'
                  : error.toString(),
          size: Get.height * 0.02,
          color: AppColor().primaryWhite,
          textAlign: TextAlign.start,
        ),
      ),
    );
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
