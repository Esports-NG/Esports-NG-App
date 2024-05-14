class ApiLink {
  static String domain = "https://esports-ng.vercel.app";
  static String baseurl = "$domain/";
  static String imageUrl = "http://res.cloudinary.com/dkykwpryb/";

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
  static String followUser = "${baseurl}extra/followuser/";
  // static String followCommunity = "${baseurl}extra/followcomm/";
  static String followTeam = "${baseurl}extra/followteam/";
  static String viewUserTeam = "${baseurl}team/myteam/";

  //Post
  static String createPost = "${baseurl}post/create/";
  static String editPost = "${baseurl}post/edit/";
  static String deletePost = "${baseurl}post/delete/";
  static String getAllPost = "${baseurl}post/view/";
  static String getPostsForYou = "${baseurl}post/for_you";
  static String getBookmarkedPost = "${baseurl}post/viewbooked/";
  static String getFollowingPost = "${baseurl}post/viewbooked/";
  static String getMyPost = "${baseurl}post/myposts/";
  static String likePost = "${baseurl}post/like/";
  static String post = "${baseurl}post/";
  static String comment = "${baseurl}post/comment/";
  static String turnNotification = "${baseurl}post/on_notifs/team/";
  static String getPostDetails(int id) => "${baseurl}post/view/$id";

  //Team
  static String createTeam = "${baseurl}team/create/";
  static String getAllTeam = "${baseurl}team/view/";
  static String team = "${baseurl}team/";

  //Player
  static String createPlayer = "${baseurl}player/register/";
  static String getAllPlayer = "${baseurl}player/view/";

  //Events
  static String createTournament = "${baseurl}event/1/create/";
  static String createSocialEvent = "${baseurl}event/1/create/";
  static String getAllEvent = "${baseurl}event/view/";
  static String getAllSocialEvents = "${baseurl}event/view/social";
  static String getAllTournaments = "${baseurl}event/view/tournament";
  static String registerForTournament(int id) => "${baseurl}event/$id/join/";
  static String filterEvents = "event/search";

  //Community
  static String createCommunity = "${baseurl}org/register/";
  static String getAllCommunity = "${baseurl}org/list/";
  static String followCommunity(int id) => "${baseurl}extra/followcomm/$id/";
  static String getCommunityFollowers(int id) =>
      "${baseurl}extra/followers/comm/view/?group_id=$id";

  //Profile
  static String getDataWithFollowers({required int id, required String type}) =>
      "${baseurl}extra/$type/$id/data/?commpk=$id";
  static String getProfileFollowersList({required int id}) =>
      "${baseurl}extra/followers/user/view/?group_id=$id";
  //Author Profile
  static String getUserDataWithFollowers({required int id}) =>
      "${baseurl}extra/user/$id/data/";

  // Games
  static String getAllGames = "${baseurl}/games/view/";
  static String getGame(int id) => "${baseurl}/games/view/?pk=$id";

  // static String withdraw = "${baseurl}initiate-withdrawal";
  // static String dashboard = "${baseurl}users/dashboard";
  // static String setTransactionPin = "${baseurl}wallet/set-transaction-pin";
  // static String changeTransactionPin =
  //     "${baseurl}wallet/change-transaction-pin";
}
