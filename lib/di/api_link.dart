class ApiLink {
  static String domain = "https://api.esportsng.com";
  static String baseurl = "$domain/";
  static String imageUrl = "https://imagedelivery.net/4-uVHHK5QQ1cIDzJPKVNLQ/";

  static String register = "${baseurl}user/v2/register/";
  static String login = "${baseurl}user/v2/login/";
  static String user = "${baseurl}user/v2/";
  static String tokenRefresh = "${baseurl}user/v2/token/refresh/";
  static String getCountryCode = "https://restcountries.com/v3/name/";
  static String logout = "${baseurl}user/v2/logout";
  static String validateResetOtp = "${baseurl}user/v2/otp/verify";
  static String getUser = "${baseurl}user/v2/info/";
  static String updateUser = "${baseurl}users/v2/profile";
  static String deleteAcct = "${baseurl}users/v2";
  static String sendActivationEmail(String email) =>
      "${baseurl}user/v2/resendlink/$email/";
  static String requestPasswordOtp = "${baseurl}user/v2/otp_request/";
  static String verifyOtp = "${baseurl}user/v2/reset/otp/verify/";
  static String resetPassword(String id) =>
      "${baseurl}user/v2/password_reset/$id/";

  static String followUser = "${baseurl}extra/v2/followuser/";
  // static String followCommunity = "${baseurl}extra/v2/followcomm/";
  static String viewUserTeam = "${baseurl}team/v2/myteam/";
  static String searchAll(String query) =>
      "${baseurl}extra/v2/search/?param=$query";
  static String postFromGroup(String slug, String group) =>
      "${baseurl}post/v2/authored/?p=$slug&group=$group";
  static String getNotifications(int id) => "${baseurl}notification/v2/all/";
  static String logOut = "${baseurl}auth/v2/logout/";

  //Post
  static String createPost = "${baseurl}post/v2/";
  static String editPost = "${baseurl}post/v2/";
  static String deletePost = "${baseurl}post/v2/";
  static String getAllPost = "${baseurl}post/v2/";
  static String getPostsForYou = "${baseurl}extra/v2/my/feed/";
  static String getBookmarkedPost = "${baseurl}post/v2/viewbooked/";
  static String getFollowingPost = "${baseurl}post/v2/following/";
  static String getMyPost = "${baseurl}post/v2/myposts/";
  static String likePost = "${baseurl}post/v2/like/";
  static String post = "${baseurl}post/v2/";
  static String comment = "${baseurl}post/v2/comment/";
  static String turnNotification = "${baseurl}post/v2/on_notifs/team/";
  static String getPostDetails(String slug) => "${baseurl}post/v2/?p=$slug";
  static String likeComment(int commentId) =>
      "${baseurl}post/v2/comment/$commentId/like/";
  static String report = "${baseurl}extra/v2/report/";
  static String searchForPostsorUsers(String query, String type) =>
      "${baseurl}$type/v2/search_${type}s/?search=$query";
  static String getEventPosts(int id) =>
      "${baseurl}post/v2/filter_posts/?tags__event_id=$id";
  static String getAds = "${baseurl}extra/v2/advert/view/";

  //Team
  static String createTeam = "${baseurl}team/v2/create/";
  static String getAllTeam = "${baseurl}team/v2/";
  static String team = "${baseurl}team/v2/";
  static String getMyTeam = "${baseurl}team/v2/myteam/";
  static String getTeamFollowers(String slug) =>
      "${baseurl}extra/v2/followers/team/view/?g_s=$slug";
  static String followTeam(String slug) =>
      "${baseurl}extra/v2/followteam/$slug/";
  static String addGameToTeam(int teamId, int gameId) =>
      "${baseurl}team/v2/$teamId/addgame/$gameId/";
  static String sendTeamApplication = "${baseurl}team/v2/application/create/";
  static String respondToApplication(int playerId, int teamId, String action) =>
      "${baseurl}team/v2/application/edit/$playerId/$teamId/$action/";
  static String getTeamApplications(int id) =>
      "${baseurl}team/v2/application/view/";
  static String createRosterForGame(int teamId) =>
      '${baseurl}team/v2/create/roster/$teamId/';
  static String getRosters(int teamId) =>
      "${baseurl}team/v2/bygame/$teamId/roasters/";
  static String addToRoster(int teamId, int playerId, int rosterId) =>
      "${baseurl}team/v2/$teamId/addplayer/$playerId/roster/$rosterId/";
  static String blockTeam(id) => "${baseurl}post/v2/block/?team_pk=$id";
  static String editTeam(id) => "${baseurl}team/v2/edit/$id/";
  static String getTeamByOwner(String slug) => "${baseurl}team/v2/owner/$slug/";

  //Player
  static String createPlayer = "${baseurl}player/v2/register/";
  static String getAllPlayer = "${baseurl}player/v2/";
  static String editPlayer(int id) => "${baseurl}player/v2/edit/$id/";
  static String deletePlayer(int id) => "${baseurl}player/v2/delete/$id/";

  //Events
  static String createTournament(String slug) =>
      "${baseurl}event/v2/?c_s=$slug";
  static String createSocialEvent(int communityId) =>
      "${baseurl}event/v2/$communityId/create/socialevent/";
  static String getEventDetails(String slug) => "${baseurl}event/v2/?p=$slug";
  static String getAllEvent = "${baseurl}event/v2/";
  static String getMyEvents = "${baseurl}event/v2/myevents/";
  static String getAllSocialEvents = "${baseurl}event/v2/view/social";
  static String getAllTournaments = "${baseurl}event/v2/view/tournament";
  static String registerForEvent(int id) => "${baseurl}event/v2/$id/join/";
  static String registerForSocialEvent(int id) =>
      "${baseurl}event/v2/social/$id/join/";
  static String unregisterForEvent(int eventId, String role, int roleId) =>
      "${baseurl}event/v2/leave/$eventId/$role/$roleId/";
  static String registerForTeamEvent(int id, int teamId) =>
      "${baseurl}event/v2/$id/join/?teampk=$teamId";
  static String filterEvents = "event/v2/search";
  static String getEventParticipants(int id) =>
      "${baseurl}event/v2/participants/$id";
  static String getEventWaitlist(int id) =>
      "${baseurl}event/v2/view/waitlist/$id";
  static String createFixture(String slug) =>
      "${baseurl}event/v2/fixture/$slug/";
  static String editFixture(String slug) => "${baseurl}event/v2/fixture/$slug/";
  static String deleteFixture(int id) =>
      "${baseurl}event/v2/fixture/$id/delete/";
  static String getFixtures(int id) =>
      "${baseurl}event/v2/fixture/view/?eventpk=$id";
  static String getAllFixture() => "${baseurl}event/v2/fixtures/all/";
  static String getPlatforms = "${baseurl}event/v2/platforms/";
  static String takeActionOnWaitlist(
          int eventId, int applicantId, String action) =>
      "${baseurl}event/v2/$eventId/$action/$applicantId/";
  static String editParticipant(
          int eventId, int participantId, String action) =>
      "${baseurl}event/v2/edit/$eventId/participants/$participantId/$action/";
  static String getCreatedEvents = "${baseurl}event/v2/created/";
  static String createLivestream = "${baseurl}event/v2/stream/create/";
  static String getActivities = "${baseurl}event/v2/activities/feed/";

  //Community
  static String createCommunity = "${baseurl}org/v2/register/";
  static String getAllCommunity = "${baseurl}org/v2/";
  static String followCommunity(String slug) =>
      "${baseurl}extra/v2/followcomm/$slug/";
  static String getCommunityFollowers(String slug) =>
      "${baseurl}extra/v2/followers/comm/view/?g_s=$slug";
  static String getSuggestedUsers = "${baseurl}extra/v2/suggest/users/";
  static String addGameToCommunity(int commId, int gameId) =>
      "${baseurl}org/v2/$commId/addgame/$gameId/";
  static String blockCommunity(id) => "${baseurl}post/v2/block/?comm_pk=$id";
  static String editCommunity(id) => "${baseurl}org/v2/edit/$id/";
  static String getCommunityByOwner(String slug) =>
      "${baseurl}org/v2/owner/$slug/";

  //Profile
  static String getDataWithFollowers(
          {required String slug, required String type}) =>
      "${baseurl}extra/v2/$type/$slug/data/";
  static String getProfileFollowersList({required String slug}) =>
      "${baseurl}extra/v2/followers/user/view/?g_s=$slug";
  //Author Profile
  static String getUserDataWithFollowers({required String slug}) =>
      "${baseurl}extra/v2/user/$slug/data/";

  // Games
  static String getAllGames = "${baseurl}games/v2/";
  static String getGame(int id) => "${baseurl}games/v2/?p=$id";
  static String getUserGames = "${baseurl}player/v2/games";
  static String followGame(int gameId) => "${baseurl}games/v2/follow/$gameId/";
  static String getGameFollowers(int gameId) =>
      "${baseurl}games/v2/followers/$gameId/users/";
  static String searchForGames(String query) =>
      "${baseurl}games/v2/find_game/?search=$query";
  static String getGamesToPlay = "${baseurl}games/v2/feed/";

  // News
  static String getNews =
      "https://nexalgamingcommunity.com/wp-json/wp/v2/posts?_fields=author,id,content,title,link,featured_media,date&nocache=1";
  // static String withdraw = "${baseurl}initiate-withdrawal";
  // static String dashboard = "${baseurl}users/dashboard";
  // static String setTransactionPin = "${baseurl}wallet/set-transaction-pin";
  // static String changeTransactionPin =
  //     "${baseurl}wallet/change-transaction-pin";
}
