class NotificationModel {
  final String? profileImage, likeDetails, details, time, type;
  final List? likeImages;

  NotificationModel({
    this.profileImage,
    this.likeDetails,
    this.details,
    this.likeImages,
    this.time,
    this.type,
  });
}

var personal = [
  NotificationModel(
    profileImage: 'assets/images/png/heart.png',
    type: 'post',
    likeDetails: 'Mhiz Zee and 4 others liked your post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
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
    likeDetails: 'Ghost reposted your post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
    likeImages: [
      'assets/images/png/photo4.png',
    ],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/photo3.png',
    type: 'comment',
    likeDetails: 'Ghost reposted your post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
    likeImages: [
      'assets/images/png/photo4.png',
    ],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/icon_library.png',
    type: 'follow',
    likeDetails: 'Dustin and 3 others followed you',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
    likeImages: [
      'assets/images/png/photo1.png',
      'assets/images/png/photo2.png',
      'assets/images/png/photo3.png',
      'assets/images/png/photo4.png',
    ],
  ),
  NotificationModel(
    profileImage: 'assets/images/png/photo3.png',
    type: 'comment',
    likeDetails: 'Ghost reposted your post',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... jpeg/mortalkombat/tuyhxueye....',
    likeImages: [
      'assets/images/png/photo4.png',
    ],
  ),
];
