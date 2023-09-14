
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';

import '../../../core/utils.dart';
import '../../../theme/pallete.dart';
import '../controller/tweet_controller.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const CreateTweetScreen());

  const CreateTweetScreen({super.key});

  @override
  ConsumerState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {

  final tweetTextController = TextEditingController();

  List<File> images = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tweetTextController.dispose();
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
      text: tweetTextController.text,
      images: images,
      context: context,
    );
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: RoundedSmallButton(
              onTap: shareTweet,
              label: "Post",
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          ),
        ],
      ),
      body: isLoading || currentUser == null ? const Loader() : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 15,
                      bottom: 15,
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.profilePic),
                      radius: 22,
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      controller: tweetTextController,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                      decoration: const InputDecoration(
                        hintText: "What's happening?",
                        hintStyle: TextStyle(
                          fontSize: 22,
                          color: Pallete.greyColor,
                        ),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  )
                ],
              ),
              if(images.isNotEmpty)
                CarouselSlider(
                  items: images.map((file) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.file(file),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll: false,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                ),
              ),
              const SizedBox(width: 30,),
              SvgPicture.asset(
                AssetsConstants.gifIcon,
              ),
              const SizedBox(width: 30,),
              SvgPicture.asset(
                AssetsConstants.emojiIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
