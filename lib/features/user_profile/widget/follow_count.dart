
import 'package:flutter/material.dart';

import '../../../theme/pallete.dart';

class FollowCount extends StatelessWidget {

  final int count;
  final String text;

  const FollowCount({
    super.key,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Pallete.whiteColor,
          ),
        ),
        const SizedBox(width: 5,),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Pallete.greyColor,
          ),
        ),
      ],
    );
  }
}

