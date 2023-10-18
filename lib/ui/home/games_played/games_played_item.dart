import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class GamesPlayedItem extends StatelessWidget {
  const GamesPlayedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: AssetImage('assetName'))
            ) ,
          )
        ],
      ),
    );
  }
}
