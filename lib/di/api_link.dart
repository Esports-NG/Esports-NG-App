class ApiLink {
  static String domain = "https://esports-ng.vercel.app";
  static String baseurl = "$domain/";

  static String register = "${baseurl}user/register/";
  static String login = "${baseurl}user/login/";
  static String logout = "${baseurl}user/logout";
  static String validateOtp = "${baseurl}user/otp";
  static String resendOtp = "${baseurl}user/resend-otp";
  static String forgotPassword = "${baseurl}user/forgot-password";
  static String resetPassword = "${baseurl}user/reset-password";
  static String validateResetOtp = "${baseurl}user/otp/verify";
  static String getUser = "${baseurl}users/info";
  static String updateUser = "${baseurl}users/profile";
  static String deleteAcct = "${baseurl}users";
  static String changePassword = "${baseurl}users/profile";

  //Products
  // static String product = "${baseurl}products";
  // static String recommendedProduct = "${baseurl}products/recommendations";
  // static String sellerProduct = "${baseurl}products/catalog";
  // static String uploadImage = "${baseurl}uploads/products";
  // static String favorite = "${baseurl}favorites";
  // static String myCart = "${baseurl}my-cart";
  // static String checkOut = "${baseurl}checkout-session";

  //Transactions
  // static String transaction = "${baseurl}transactions";
  // static String myTransaction = "${baseurl}users/my-transactions";
  // static String withdraw = "${baseurl}initiate-withdrawal";
  // static String dashboard = "${baseurl}users/dashboard";
  // static String setTransactionPin = "${baseurl}wallet/set-transaction-pin";
  // static String changeTransactionPin =
  //     "${baseurl}wallet/change-transaction-pin";

  //Order
  // static String orders = "${baseurl}my-orders";

  //Notification
  // static String notification = "${baseurl}users/notifications";

  //Bank
  // static String allBank = "${baseurl}nuban/banks";
  // static String resolveBank = "${baseurl}nuban/resolve";
  // static String myBank = "${baseurl}nuban/my-banks";
  // static String withdrawFund = "${baseurl}initiate-withdrawal";
}
