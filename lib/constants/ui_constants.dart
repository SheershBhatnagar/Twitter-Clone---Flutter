
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:twitter_clone/constants/constants.dart';

import '../theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }
}
