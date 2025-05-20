class ApiLink {
  static String domain = "https://api.esportsng.com";
  static String baseurl = "$domain/";
  static String imageUrl = "https://imagedelivery.net/4-uVHHK5QQ1cIDzJPKVNLQ/";

  static String register = "${baseurl}user/v2/";
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
  static String resetPassword(String slug) =>
      "${baseurl}user/v2/password_reset/$slug/";

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
  static String likeComment(String slug) =>
      "${baseurl}post/v2/comment/$slug/like/";
  static String report = "${baseurl}extra/v2/report/";
  static String searchForPostsorUsers(String query, String type) =>
      "${baseurl}$type/v2/search_${type}s/?search=$query";
  static String getEventPosts(String slug) =>
      "${baseurl}post/v2/filter_posts/?tags=$slug";
  static String getAds = "${baseurl}extra/v2/advert/view/";

  //Team
  static String createTeam = "${baseurl}team/v2/";
  static String getAllTeam = "${baseurl}team/v2/";
  static String team = "${baseurl}team/v2/";
  static String getMyTeam = "${baseurl}team/v2/member/";
  static String getTeamFollowers(String slug) =>
      "${baseurl}extra/v2/followers/team/view/?g_s=$slug";
  static String followTeam(String slug) =>
      "${baseurl}extra/v2/followteam/$slug/";
  static String addGameToTeam(String teamSlug, int gameId) =>
      "${baseurl}team/v2/$teamSlug/addgame/$gameId/";
  static String sendTeamApplication = "${baseurl}team/v2/application/";
  static String respondToApplication(
          String playerSlug, String teamSlug, String action) =>
      "${baseurl}team/v2/$teamSlug/$action/$playerSlug/";
  static String getTeamApplications(String slug) =>
      "${baseurl}team/v2/application/?t_s=$slug";
  static String createRosterForGame(String slug) =>
      '${baseurl}team/v2/create/roster/$slug/';
  static String getRosters(String slug) =>
      "${baseurl}team/v2/bygame/$slug/roasters/";
  static String addToRoster(String teamSlug, String playerSlug, int rosterId) =>
      "${baseurl}team/v2/$teamSlug/addplayer/$playerSlug/roster/$rosterId/";
  static String blockTeam(String slug) => "${baseurl}post/v2/block/?t_s=$slug";
  static String editTeam(String slug) => "${baseurl}team/v2/$slug/";
  static String getTeamByOwner(String slug) => "${baseurl}team/v2/owner/$slug/";

  //Player
  static String createPlayer = "${baseurl}player/v2/";
  static String getAllPlayer = "${baseurl}player/v2/";
  static String editPlayer(String slug) => "${baseurl}player/v2/$slug/";
  static String deletePlayer(String slug) => "${baseurl}player/v2/$slug/";

  //Events
  static String createTournament(String slug) =>
      "${baseurl}event/v2/?c_s=$slug";
  static String createSocialEvent(String slug) =>
      "${baseurl}event/v2/$slug/create/socialevent/";
  static String getEventDetails(String slug) => "${baseurl}event/v2/?p=$slug";
  static String getAllEvent = "${baseurl}event/v2/";
  static String getMyEvents = "${baseurl}event/v2/?q=mine";
  static String getAllSocialEvents = "${baseurl}event/v2/view/social";
  static String getAllTournaments = "${baseurl}event/v2/view/tournament";
  static String registerForEvent(
    String eventSlug,
  ) =>
      "${baseurl}event/v2/$eventSlug/join/tournament/";
  static String registerForSocialEvent(String eventSlug) =>
      "${baseurl}event/v2/$eventSlug/join/social/";
  static String unregisterForEvent(String slug, String role, String roleSlug) =>
      "${baseurl}event/v2/leave/$slug/$role/$roleSlug/";
  static String registerForTeamEvent(String slug, String teamSlug) =>
      "${baseurl}event/v2/$slug/join/tournament/?t_s=$teamSlug";
  static String filterEvents = "event/v2/search";
  static String getEventParticipants(String slug) =>
      "${baseurl}event/v2/participants/$slug";
  static String getEventWaitlist(String slug) =>
      "${baseurl}event/v2/view/waitlist/$slug";
  static String createFixture(String slug) =>
      "${baseurl}event/v2/fixture/$slug/";
  static String editFixture(String slug) => "${baseurl}event/v2/fixture/$slug/";
  static String deleteFixture(String slug) =>
      "${baseurl}event/v2/fixture/$slug/";
  static String getFixtures(String slug) =>
      "${baseurl}event/v2/fixture/?e_s=$slug";
  static String getAllFixture() => "${baseurl}event/v2/fixtures/";
  static String getPlatforms = "${baseurl}event/v2/platforms/";
  static String takeActionOnWaitlist(
          String slug, String applicantSlug, String action) =>
      "${baseurl}event/v2/$slug/$action/$applicantSlug/";
  static String editParticipant(
          String slug, String participantSlug, String action) =>
      "${baseurl}event/v2/edit/$slug/participants/$participantSlug/$action/";
  static String getCreatedEvents = "${baseurl}event/v2/created/";
  static String createLivestream = "${baseurl}event/v2/";
  static String getActivities = "${baseurl}event/v2/activities/feed/";

  //Community
  static String createCommunity = "${baseurl}org/v2/";
  static String getAllCommunity = "${baseurl}org/v2/";
  static String followCommunity(String slug) =>
      "${baseurl}extra/v2/followcomm/$slug/";
  static String getCommunityFollowers(String slug) =>
      "${baseurl}extra/v2/followers/comm/view/?g_s=$slug";
  static String getSuggestedUsers = "${baseurl}extra/v2/suggest/users/";
  static String addGameToCommunity(String commSlug, int gameId) =>
      "${baseurl}org/v2/$commSlug/addgame/$gameId/";
  static String blockCommunity(String slug) =>
      "${baseurl}post/v2/block/?c_s=$slug";
  static String editCommunity(String slug) => "${baseurl}org/v2/$slug/";
  static String getCommunityByOwner(String slug) =>
      "${baseurl}org/v2/owner/$slug/";
  static String getUserCommunity = "${baseurl}org/v2/member/";

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
