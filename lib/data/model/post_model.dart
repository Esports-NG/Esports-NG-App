class Posts {
  final String? image, pImage;
  final String? name, uName;
  final String? time;
  final List? genre;
  final String? details;
  final String? likes;
  final String? comment;
  final String? views;
  final String? repost;

  Posts(
      {this.image,
      this.pImage,
      this.name,
      this.uName,
      this.time,
      this.genre,
      this.details,
      this.likes,
      this.comment,
      this.views,
      this.repost});
}

var postItem = [
  Posts(
    image: 'assets/images/png/postImage1.png',
    pImage: 'assets/images/png/postDImage.png',
    name: 'CODM',
    uName: 'Empire#2245',
    time: '2hours ago',
    genre: ['Arcade', 'Strategy'],
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... ',
    likes: '5',
    comment: '32',
    views: '126',
    repost: '17',
  ),
  Posts(
    image: 'assets/images/png/postImage2.png',
    pImage: 'assets/images/png/postDImage.png',
    name: 'CODM',
    uName: 'Empire#2245',
    time: '2hours ago',
    genre: ['Arcade', 'Action', 'Strategy'],
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... ',
    likes: '5',
    comment: '32',
    views: '126',
    repost: '17',
  ),
  Posts(
    image: 'assets/images/png/postImage3.png',
    pImage: 'assets/images/png/postDImage.png',
    name: 'CODM',
    uName: 'Empire#2245',
    time: '2hours ago',
    genre: ['Arcade', 'Action', 'Strategy'],
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... ',
    likes: '5',
    comment: '32',
    views: '126',
    repost: '17',
  ),
];
