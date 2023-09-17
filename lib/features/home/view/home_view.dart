
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../tweet/view/create_tweet_view.dart';

class HomeView extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final appBar = UIConstants.appBar();

  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CreateTweetScreen.route());
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0 ? AssetsConstants.homeFilledIcon : AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AssetsConstants.searchIcon,
                color: Pallete.whiteColor,
              ),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _page == 2 ? AssetsConstants.notifFilledIcon : AssetsConstants.notifOutlinedIcon,
                color: Pallete.whiteColor,
              ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _page == 3 ? Icons.person : Icons.person_outline,
              color: Pallete.whiteColor,
            )
          ),
        ],
      ),
    );
  }
}
