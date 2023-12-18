import 'package:flutter/material.dart';

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

class RepostModel {
  final String? title;
  final IconData? icon;

  RepostModel({this.title, this.icon});
}

var repostItem = [
  RepostModel(title: 'Repost', icon: Icons.autorenew_outlined),
  RepostModel(title: 'Repost with Comment', icon: Icons.edit),
];
