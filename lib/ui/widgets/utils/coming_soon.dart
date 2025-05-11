import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          IconsaxPlusLinear.clock_1,
          size: 35,
          color: Colors.white.withOpacity(0.75),
        ),
        const Gap(5),
        CustomText(
          title: "Coming soon",
          fontFamily: 'InterMedium',
          size: 16,
          color: Colors.white.withOpacity(0.75),
        )
      ],
    );
  }
}
