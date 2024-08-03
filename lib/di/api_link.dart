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
  static String likeComment(int commentId) =>
      "${baseurl}post/comment/$commentId/like/";
  static String report = "${baseurl}extra/report/";

  //Team
  static String createTeam = "${baseurl}team/create/";
  static String getAllTeam = "${baseurl}team/view/";
  static String team = "${baseurl}team/";
  static String getMyTeam = "${baseurl}team/myteam/";
  static String getTeamFollowers(int id) =>
      "${baseurl}extra/followers/team/view/?group_id=$id";
  static String followTeam(int id) => "${baseurl}extra/followteam/$id/";
  static String addGameToTeam(int teamId, int gameId) =>
      "${baseurl}team/$teamId/addgame/$gameId/";
  static String sendTeamApplication = "${baseurl}team/application/create/";
  static String respondToApplication(int playerId, int teamId, String action) =>
      "${baseurl}team/application/edit/$playerId/$teamId/$action/";
  static String getTeamApplications(int id) =>
      "${baseurl}team/application/view/";
  static String createRosterForGame(int teamId) =>
      '${baseurl}team/create/roster/$teamId/';
  static String getRosters(int teamId) =>
      "${baseurl}team/bygame/$teamId/roasters/";
  static String addToRoster(int teamId, int playerId, int rosterId) =>
      "${baseurl}team/$teamId/addplayer/$playerId/roster/$rosterId/";
  static String blockTeam(id) => "${baseurl}post/block/?team_pk=$id";

  //Player
  static String createPlayer = "${baseurl}player/register/";
  static String getAllPlayer = "${baseurl}player/view/";

  //Events
  static String createTournament(int communityId) =>
      "${baseurl}event/$communityId/create/event/";
  static String createSocialEvent(int communityId) =>
      "${baseurl}event/$communityId/create/socialevent/";
  static String getAllEvent = "${baseurl}event/view/";
  static String getAllSocialEvents = "${baseurl}event/view/social";
  static String getAllTournaments = "${baseurl}event/view/tournament";
  static String registerForEvent(int id) => "${baseurl}event/$id/join/";
  static String registerForSocialEvent(int id) =>
      "${baseurl}event/social/$id/join/";
  static String unregisterForEvent(int eventId, String role, int roleId) =>
      "${baseurl}event/leave/$eventId/$role/$roleId/";
  static String registerForTeamEvent(int id, int teamId) =>
      "${baseurl}event/$id/join/?teampk=$teamId";
  static String filterEvents = "event/search";
  static String getEventParticipants(int id) =>
      "${baseurl}event/participants/$id";

  //Community
  static String createCommunity = "${baseurl}org/register/";
  static String getAllCommunity = "${baseurl}org/list/";
  static String followCommunity(int id) => "${baseurl}extra/followcomm/$id/";
  static String getCommunityFollowers(int id) =>
      "${baseurl}extra/followers/comm/view/?group_id=$id";
  static String getSuggestedUsers = "${baseurl}extra/suggest/users/";
  static String addGameToCommunity(int commId, int gameId) =>
      "${baseurl}org/$commId/addgame/$gameId/";
  static String blockCommunity(id) => "${baseurl}post/block/?comm_pk=$id";

  //Profile
  static String getDataWithFollowers({required int id, required String type}) =>
      "${baseurl}extra/$type/$id/data/?commpk=$id";
  static String getProfileFollowersList({required int id}) =>
      "${baseurl}extra/followers/user/view/?group_id=$id";
  //Author Profile
  static String getUserDataWithFollowers({required int id}) =>
      "${baseurl}extra/user/$id/data/";

  // Games
  static String getAllGames = "${baseurl}games/view/";
  static String getGame(int id) => "${baseurl}games/view/?pk=$id";
  static String getUserGames = "${baseurl}player/games";
  static String followGame(int gameId) => "${baseurl}games/follow/$gameId/";
  static String getGameFollowers(int gameId) =>
      "${baseurl}games/followers/$gameId/users/";

  // News
  static String getNews =
      "https://nexalgamingcommunity.com/wp-json/wp/v2/posts?_fields=author,id,content,title,link,featured_media,date&nocache=1";
  // static String withdraw = "${baseurl}initiate-withdrawal";
  // static String dashboard = "${baseurl}users/dashboard";
  // static String setTransactionPin = "${baseurl}wallet/set-transaction-pin";
  // static String changeTransactionPin =
  //     "${baseurl}wallet/change-transaction-pin";
}
