class ApiLink {
  static String domain = "https://esports-ng.vercel.app";
  static String baseurl = "$domain/";

  static String register = "${baseurl}user/register/";
  static String login = "${baseurl}user/login/";
  static String user = "${baseurl}user/";
  static String tokenRefresh = "${baseurl}user/token/refresh/";
  static String getCountryCode = "https://restcountries.com/v3/name/";
  static String logout = "${baseurl}user/logout";
  static String verifyOtp = "${baseurl}user/otp";
  static String resendOtp = "${baseurl}user/resend-otp";
  static String forgotPassword = "${baseurl}user/forgot-password";
  static String resetPassword = "${baseurl}user/reset-password";
  static String validateResetOtp = "${baseurl}user/otp/verify";
  static String getUser = "${baseurl}user/info/";
  static String updateUser = "${baseurl}users/profile";
  static String deleteAcct = "${baseurl}users";
  static String changePassword = "${baseurl}users/profile";

  //Post
  static String createPost = "${baseurl}post/create/";
  static String editPost = "${baseurl}post/edit/";
  static String deletePost = "${baseurl}post/delete/";
  static String getAllPost = "${baseurl}post/view/";
  static String getMyPost = "${baseurl}post/myposts/";
  static String likePost = "${baseurl}post/like/";
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

}
