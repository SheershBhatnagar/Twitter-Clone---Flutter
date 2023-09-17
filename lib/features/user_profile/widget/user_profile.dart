
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widget/follow_count.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../tweet/controller/tweet_controller.dart';
import '../../tweet/widgets/tweet_card.dart';

class UserProfile extends ConsumerWidget {

  final UserModel user;

  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null ? const Loader() : NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 150,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: user.bannerPic.isEmpty ? Container(
                    color: Pallete.blueColor,
                  ) : Image.network(
                    user.bannerPic,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                    radius: 40,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {

                    },
                    child: Text(
                      currentUser.uid == user.uid ? 'Edit Profile' : 'Follow',
                      style: const TextStyle(
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    '@${user.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Pallete.greyColor,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    user.bio,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      FollowCount(
                        count: user.following.length,
                        text: "Following",
                      ),
                      const SizedBox(width: 15,),
                      FollowCount(
                        count: user.followers.length,
                        text: "Followers",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Divider(
                    color: Pallete.greyColor,
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: ref.watch(getUserTweetsProvider(user.uid)).when(
        data: (tweets) {
          return ref.watch(getLatestTweetsProvider).when(
            data: (data) {

              final latestTweet = Tweet.fromMap(data.payload);

              bool isTweetAlreadyPresent = false;

              for(final tweetModel in tweets) {
                if(tweetModel.id == latestTweet.id) {
                  isTweetAlreadyPresent = true;
                  break;
                }
              }

              if(!isTweetAlreadyPresent) {

                if(data.events.contains('databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create')) {
                  tweets.insert(0, Tweet.fromMap(data.payload));
                }
                else if(data.events.contains('databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update')) {

                  final startingPoint = data.events[0].lastIndexOf('documents.');
                  final endPoint = data.events[0].lastIndexOf('.update');

                  final tweetId = data.events[0].substring(startingPoint + 10, endPoint);

                  var tweet = tweets.where((element) => element.id == tweetId).first;

                  final tweetIndex = tweets.indexOf(tweet);
                  tweets.removeWhere((element) => element.id == tweetId);

                  tweet = Tweet.fromMap(data.payload);
                  tweets.insert(tweetIndex, tweet);
                }
              }

              return Expanded(
                child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet,);
                    }
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () {
              return Expanded(
                child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet,);
                    }
                ),
              );
            },
          );
        },
        error: (error, st) => ErrorText(error: error.toString(),),
        loading: () => const Loader(),
      ),
    );
  }
}

