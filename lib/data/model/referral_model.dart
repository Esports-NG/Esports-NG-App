class ReferralModel {
  final String? title;
  final double? price;

  ReferralModel({
    this.title,
    this.price,
  });
}

var referralEarningsItem = [
  ReferralModel(title: 'Subscribed', price: 3),
  ReferralModel(title: 'Referrals', price: 11),
  ReferralModel(title: 'Total Cash Earned', price: 1500),
];
