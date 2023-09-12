class NotificationModel {
  final String? profileImage,
      likeDetails,
      details,
      time,
      type,
      infoName,
      infoTag,
      link;
  final List? likeImages;

  NotificationModel({
    this.profileImage,
    this.likeDetails,
    this.details,
    this.likeImages,
    this.time,
    this.type,
    this.infoName,
    this.infoTag,
    this.link,
  });
}

var personal = [
  NotificationModel(
    profileImage: 'assets/images/png/heart.png',
    type: 'post',
    link: 'jpeg/mortalkombat/tuyhxueye....',
    likeDetails: 'Mhiz Zee and 4 others liked your post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
    likeImages: [
      'assets/images/png/photo1.png',
      'assets/images/png/photo2.png',
      'assets/images/png/photo3.png',
      'assets/images/png/photo4.png',
      'assets/images/png/photo5.png',
    ],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/icon_library.png',
    type: 'post',
    link: 'jpeg/mortalkombat/tuyhxueye....',
    likeDetails: 'Ghost reposted your post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
    likeImages: [
      'assets/images/png/photo4.png',
    ],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/photo3.png',
    infoName: 'Ashley Stone',
    infoTag: '@toxicgyal234',
    type: 'comment',
    time: '21 hours ago',
    likeDetails: 'Commented on your post @Paula Bakare',
    details: 'This Update is so sick! I love it!',
  ),
  NotificationModel(
    profileImage: 'assets/images/png/user.png',
    type: 'follow',
    likeDetails: 'Dustin and 3 others followed you',
    likeImages: [
      'assets/images/png/photo1.png',
      'assets/images/png/photo2.png',
      'assets/images/png/photo3.png',
      'assets/images/png/photo4.png',
    ],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/photo4.png',
    infoName: 'Stephanie',
    infoTag: '@stephinreallife',
    type: 'tagged',
    time: '2 days ago',
    link: 'jpeg/mortalkombat/tuyhxueye....',
    likeDetails: 'Tagged you to a post made by @Evade @Paula Bakare',
    details:
        'Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
  ),
];

var post = [
  NotificationModel(
    link: 'jpeg/mortalkombat/tuyhxueye....',
    time: '2 minutes ago',
    likeDetails: 'XBox.NG Made a post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
  ),
  NotificationModel(
    link: 'jpeg/mortalkombat/tuyhxueye....',
    time: '4 hours ago',
    likeDetails: 'XBox.NG Made a post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
  ),
  NotificationModel(
    link: 'jpeg/mortalkombat/tuyhxueye....',
    time: '1 day ago',
    likeDetails: 'XBox.NG Made a post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
  ),
  NotificationModel(
    link: 'jpeg/mortalkombat/tuyhxueye....',
    time: '3 weeks ago',
    likeDetails: 'XBox.NG Made a post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
  ),
  NotificationModel(
    link: 'jpeg/mortalkombat/tuyhxueye....',
    time: '2 months ago',
    likeDetails: 'XBox.NG Made a post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
  ),
  NotificationModel(
    link: 'jpeg/mortalkombat/tuyhxueye....',
    time: '1 year ago',
    likeDetails: 'XBox.NG Made a post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain...',
  ),
];

var events = [
  NotificationModel(
    profileImage: 'assets/images/png/sparkles.png',
    type: 'event',
    link: 'http://jointournament@nexal.com',
    infoTag: 'PLAYSTATION.NG',
    likeDetails: 'Click the link to join the tournament',
    details: 'FIFA 23 Tournament is about to start! Don’t miss out',
  ),
  NotificationModel(
    profileImage: 'assets/images/png/clipboard-list.png',
    type: 'tournament',
    link: 'See all',
    infoTag: 'See Fixtures for Tournament Z',
    likeDetails:
        'Avengers FC    vs    Indomitables                5pm WAT\nControllers       vs    Evolution                       7pm WAT',
    details: '',
  ),
  NotificationModel(
    profileImage: 'assets/images/png/photo5.png',
    type: 'announcement',
    link: 'See Details',
    infoTag: 'ARE YOU A GAME DEVELOPER? APPLY FOR GAMATHON’S ARK PITCH TODAY!',
    likeDetails: '',
    details: '',
  ),
  NotificationModel(
    profileImage: 'assets/images/png/sparkles.png',
    type: 'announcement',
    link: 'jpeg/mortalkombat/tuyhxueye....',
    infoTag: 'Nexal Gaming’s Event Registration Closes Soon!!!',
    likeDetails: 'Haven’t registered? Click the link to do so.',
    details: '',
  ),
  NotificationModel(
    profileImage: 'assets/images/png/sparkles.png',
    type: 'event',
    link: 'http://jointournament@nexal.com',
    infoTag: 'PLAYSTATION.NG',
    likeDetails: 'Click the link to join the tournament',
    details: 'FIFA 23 Tournament is about to start! Don’t miss out',
  ),
  NotificationModel(
    profileImage: 'assets/images/png/clipboard-list.png',
    type: 'tournament',
    link: 'See all',
    infoTag: 'See Fixtures for Tournament Z',
    likeDetails:
        'Avengers FC    vs    Indomitables                5pm WAT\nControllers       vs    Evolution                       7pm WAT',
    details: '',
  ),
];
