
import 'package:flutter/material.dart';

import 'package:twitter_clone/theme/pallete.dart';

class RoundedSmallButton extends StatelessWidget {

  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double verticalPadding;

  const RoundedSmallButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backgroundColor = Pallete.whiteColor,
    this.textColor = Pallete.backgroundColor,
    this.verticalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        backgroundColor: backgroundColor,
        labelPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: verticalPadding
        ),
      ),
    );
  }
}
