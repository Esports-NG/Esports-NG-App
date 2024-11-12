class ApiLink {
  static String domain = "https://esportsng-production.up.railway.app";
  static String baseurl = "$domain/";
  static String imageUrl = "http://res.cloudinary.com/dkykwpryb/";

  static String register = "${baseurl}user/register/";
  static String login = "${baseurl}user/login/";
  static String user = "${baseurl}user/";
  static String tokenRefresh = "${baseurl}user/token/refresh/";
  static String getCountryCode = "https://restcountries.com/v3/name/";
  static String logout = "${baseurl}user/logout";
  static String validateResetOtp = "${baseurl}user/otp/verify";
  static String getUser = "${baseurl}user/info/";
  static String updateUser = "${baseurl}users/profile";
  static String deleteAcct = "${baseurl}users";
  static String sendActivationEmail(String email) =>
      "${baseurl}user/resendlink/$email/";
  static String requestPasswordOtp = "${baseurl}user/otp_request/";
  static String verifyOtp = "${baseurl}user/reset/otp/verify/";
  static String resetPassword(String id) =>
      "${baseurl}user/password_reset/$id/";

  static String followUser = "${baseurl}extra/followuser/";
  // static String followCommunity = "${baseurl}extra/followcomm/";
  static String viewUserTeam = "${baseurl}team/myteam/";
  static String searchAll(String query) =>
      "${baseurl}extra/search/?param=$query";
  static String postFromGroup(int id, String group) =>
      "${baseurl}post/authored/?pk=$id&group=$group";

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
  static String searchForPostsorUsers(String query, String type) =>
      "${baseurl}$type/search_${type}s/?search=$query";
  static String getEventPosts(int id) =>
      "${baseurl}post/filter_posts/?tags__event_id=$id";
  static String getAds = "${baseurl}extra/advert/view/";

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
  static String editTeam(id) => "${baseurl}team/edit/$id/";

  //Player
  static String createPlayer = "${baseurl}player/register/";
  static String getAllPlayer = "${baseurl}player/view/";
  static String editPlayer(int id) => "${baseurl}player/edit/$id/";
  static String deletePlayer(int id) => "${baseurl}player/delete/$id/";

  //Events
  static String createTournament(int communityId) =>
      "${baseurl}event/$communityId/create/event/";
  static String createSocialEvent(int communityId) =>
      "${baseurl}event/$communityId/create/socialevent/";
  static String getEventDetails(int id) => "${baseurl}event/view/$id/";
  static String getAllEvent = "${baseurl}event/view/";
  static String getMyEvents = "${baseurl}event/myevents/";
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
  static String getEventWaitlist(int id) => "${baseurl}event/view/waitlist/$id";
  static String createFixture(int id) => "${baseurl}event/fixture/create/$id/";
  static String editFixture(int id) => "${baseurl}event/fixture/$id/edit/";
  static String deleteFixture(int id) => "${baseurl}event/fixture/$id/delete/";
  static String getFixtures(int id) =>
      "${baseurl}event/fixture/view/?eventpk=$id";
  static String getPlatforms = "${baseurl}event/platforms/";
  static String takeActionOnWaitlist(
          int eventId, int applicantId, String action) =>
      "${baseurl}event/$eventId/$action/$applicantId/";
  static String editParticipant(
          int eventId, int participantId, String action) =>
      "${baseurl}event/edit/$eventId/participants/$participantId/$action/";
  static String getCreatedEvents = "${baseurl}event/created/";

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
  static String editCommunity(id) => "${baseurl}org/edit/$id/";

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
  static String searchForGames(String query) =>
      "${baseurl}games/find_game/?search=$query";

  // News
  static String getNews =
      "https://nexalgamingcommunity.com/wp-json/wp/v2/posts?_fields=author,id,content,title,link,featured_media,date&nocache=1";
  // static String withdraw = "${baseurl}initiate-withdrawal";
  // static String dashboard = "${baseurl}users/dashboard";
  // static String setTransactionPin = "${baseurl}wallet/set-transaction-pin";
  // static String changeTransactionPin =
  //     "${baseurl}wallet/change-transaction-pin";
}
