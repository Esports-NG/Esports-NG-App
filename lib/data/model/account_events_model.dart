class AccountEventsModel {
  final String? image;
  final String? title,
      game,
      tName,
      tType,
      time,
      registrationDate,
      tournamentDate;
  final int? entry, prizePool;
  final List? genre;

  AccountEventsModel({
    this.image,
    this.game,
    this.title,
    this.tName,
    this.tType,
    this.time,
    this.registrationDate,
    this.tournamentDate,
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

var tournamentItem = [
  AccountEventsModel(
    image: 'assets/images/png/tournament.png',
    game: 'Mortal Kombat',
    tName: 'World Champions Cup',
    tType: 'Teams',
    registrationDate: 'Aug26 2023 - Aug31 2023',
    tournamentDate: 'Aug26 2023 - Aug31 2023',
    genre: ['Ranked', 'Ongoing Registration'],
    entry: 2000,
    prizePool: 200000,
  ),
  AccountEventsModel(
    image: 'assets/images/png/tournament.png',
    game: 'Mortal Kombat',
    tName: 'World Champions Cup',
    tType: 'Teams',
    registrationDate: 'Aug26 2023 - Aug31 2023',
    tournamentDate: 'Aug26 2023 - Aug31 2023',
    genre: ['Ranked', 'Ongoing Registration'],
    entry: 2000,
    prizePool: 200000,
  ),
  AccountEventsModel(
    image: 'assets/images/png/tournament.png',
    game: 'Mortal Kombat',
    tName: 'World Champions Cup',
    tType: 'Teams',
    registrationDate: 'Aug26 2023 - Aug31 2023',
    tournamentDate: 'Aug26 2023 - Aug31 2023',
    genre: ['Ranked', 'Ongoing Registration'],
    entry: 2000,
    prizePool: 200000,
  ),
];

var socialEventItem = [
  AccountEventsModel(
      image: 'assets/images/png/social-event.png',
      title: 'Clatter of Clans Twitter Space ⚔️',
      game: 'General, CODM',
      tName: 'World Champions Cup',
      tType: 'Teams',
      registrationDate: 'Aug26 2023 - Aug31 2023',
      tournamentDate: 'September 1st',
      time: '9:00pm - Twitter (X)'),
  AccountEventsModel(
      image: 'assets/images/png/social-event.png',
      title: 'Clatter of Clans Twitter Space ⚔️',
      game: 'General, CODM',
      tName: 'World Champions Cup',
      tType: 'Teams',
      registrationDate: 'Aug26 2023 - Aug31 2023',
      tournamentDate: 'September 1st',
      time: '9:00pm - Twitter (X)'),
  AccountEventsModel(
      image: 'assets/images/png/social-event.png',
      title: 'Clatter of Clans Twitter Space ⚔️',
      game: 'General, CODM',
      tName: 'World Champions Cup',
      tType: 'Teams',
      registrationDate: 'Aug26 2023 - Aug31 2023',
      tournamentDate: 'September 1st',
      time: '9:00pm - Twitter (X)'),
];
