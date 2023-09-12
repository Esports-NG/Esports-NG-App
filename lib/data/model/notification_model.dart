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
    likeDetails: 'Commented on your post @Paula Bakare',
    details: 'This Update is so sick! I love it!',
    likeImages: [],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/user.png',
    type: 'follow',
    likeDetails: 'Dustin and 3 others followed you',
    details: '',
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
    link: 'jpeg/mortalkombat/tuyhxueye....',
    likeDetails: 'Tagged you to a post made by @Evade @Paula Bakare',
    details:
        'Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
    likeImages: [],
  ),
];
