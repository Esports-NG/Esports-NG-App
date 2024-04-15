class TransactionModel {
  final String? title, date, type;
  final double? price;

  TransactionModel({
    this.title,
    this.date,
    this.price,
    this.type,
  });
}

var transactionHistory = [
  TransactionModel(
    title: 'Price Poll Winning',
    date: '30th September, 2023',
    price: 790.05,
    type: 'in',
  ),
  TransactionModel(
    title: 'Tournament X Registration',
    date: '25th September, 2023',
    price: 1000,
    type: 'out',
  ),
  TransactionModel(
    title: 'Withdrawal',
    date: '20th August, 2023',
    price: 3000,
    type: 'out',
  ),
  TransactionModel(
    title: 'Referral Earnings',
    date: '20th August, 2023',
    price: 1500,
    type: 'in',
  ),
  TransactionModel(
    title: 'Price Poll Winning',
    date: '20th August, 2023',
    price: 2500,
    type: 'out',
  ),
  TransactionModel(
    title: 'Price Poll Winning',
    date: '18th August, 2023',
    price: 3000,
    type: 'out',
  ),
];
