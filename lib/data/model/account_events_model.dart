class AccountEventsModel {
  final String? image;
  final String? game, tName, tType;
  final int? entry, prizePool;
  final List? genre;

  AccountEventsModel({
    this.image,
    this.game,
    this.tName,
    this.tType,
    this.genre,
    this.entry,
    this.prizePool,
  });
}

var accountEventItem = [
  AccountEventsModel(
    image: 'assets/images/png/postImage5.png',
    game: 'Mortal Kombat',
    tName: 'World Champions Cup',
    tType: 'Teams',
    genre: ['Ranked', 'Ongoing Registration'],
    entry: 2000,
    prizePool: 200000,
  ),
  AccountEventsModel(
    image: 'assets/images/png/postImage5.png',
    game: 'Mortal Kombat',
    tName: 'World Champions Cup',
    tType: 'Teams',
    genre: ['Ranked', 'Ongoing Registration'],
    entry: 2000,
    prizePool: 200000,
  ),
];
