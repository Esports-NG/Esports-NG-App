// ignore_for_file: unnecessary_null_comparison

import 'package:get/utils.dart';

class Validator {
  static String? isAccountNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isNumericOnly(value!.trim())) {
      return 'Please enter a valid phone number';
    } else if (!GetUtils.isLengthEqualTo(value.trim(), 10)) {
      return 'This must be 10 digit long';
    }
    return null;
  }

  static String? isName(String? value) {
    String pattern = "[A-Za-z]{1,32}";
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!regExp.hasMatch(value!.trim())) {
      return 'Please enter valid name';
    }
    return null;
  }

  static String? isLink(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isURL(value!.trim())) {
      return 'Please enter a valid url';
    }
    return null;
  }

  static String? isEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isEmail(value!.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? isNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isNumericOnly(value!.trim())) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? isPhone(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isNumericOnly(value!.trim()) ||
        !GetUtils.isLengthBetween(value.trim(), 8, 14)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? isAmount(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isNumericOnly(value!.trim())) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  static String? isReferrerCode(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isNumericOnly(value!.trim()) ||
        !GetUtils.isLengthEqualTo(value.trim(), 5)) {
      return '';
    }
    return null;
  }

  static String? isPassword(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String digit = r'\d';
    String char = r'[`~!@#$%\^&*\(\)_+\\\-={}\[\]\/.,<>;]';

    RegExp upperCase = RegExp(pattern, caseSensitive: true);
    RegExp oneDigit = RegExp(digit);
    RegExp specialChar = RegExp(char);

    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isLengthGreaterOrEqual(value.toString().trim(), 8)) {
      return 'Password must be at least 8 characters long';
    } else if (!GetUtils.hasCapitalletter(value!.trim())) {
      return 'Password must be have a capital letter';
    } else if (upperCase.isCaseSensitive) {
      return 'Password must have at least an uppercase letter';
    } else if (!oneDigit.hasMatch(value.trim())) {
      return 'Password must have at least a digit';
    } else if (!specialChar.hasMatch(value.trim())) {
      return 'Password must have at least one special character';
    }
    return null;
  }

  static String? isOldPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isLengthGreaterOrEqual(value, 6)) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? isNewPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isLengthGreaterOrEqual(value, 6)) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? isConfirmPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    } else if (!GetUtils.isLengthGreaterOrEqual(value.toString().trim(), 8)) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? isAddress(String value) {
    if (value.isEmpty) {
      return 'This field is required';
    } else if (!GetUtils.isLengthGreaterThan(value, 4)) {
      return 'Please enter a valid Address';
    }
    return null;
  }

  static String? isNotEmpty(String? value) {
    if (GetUtils.isNullOrBlank(value)!) {
      return 'This field is required';
    }
    return null;
  }

  static String? isOptional(String? value) {
    if (!GetUtils.isBlank(value)! && value!.length != 7) {
      return 'RC Number must be seven digit long';
    }
    return null;
  }

  static String? isInviteCode(String value) {
    if (value != null && value.length != 6) {
      return 'Invite code must be six characters long';
    }
    return null;
  }

  static String? isPromoCode(String value) {
    if (value.isEmpty || value.length != 6) {
      return 'Promo code must be six characters long';
    }
    return null;
  }

  static String? isUsername(String? value) {
    if (value!.isEmpty) {
      return 'username must be empty';
    } else if (!GetUtils.isLengthGreaterOrEqual(value.trim(), 6)) {
      return 'Username must be min. of six characters long';
    }
    return null;
  }

  static String? isPinCode(String value) {
    if (value.isEmpty || value.length != 4) {
      return 'Withdrawal pin must be four characters long';
    }
    return null;
  }
}
