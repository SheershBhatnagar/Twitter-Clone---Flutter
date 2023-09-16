
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:twitter_clone/constants/constants.dart';

import '../features/explore/view/explore_view.dart';
import '../features/tweet/widgets/tweet_list.dart';
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

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const ExploreView(),
    const Text('Notifications'),
  ];
}
