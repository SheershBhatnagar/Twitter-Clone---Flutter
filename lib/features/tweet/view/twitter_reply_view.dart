
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../common/common.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';
import '../../../theme/pallete.dart';
import '../controller/tweet_controller.dart';

class TwitterReplyScreen extends ConsumerWidget {

  static route(Tweet tweet) => MaterialPageRoute(builder: (context) => TwitterReplyScreen(tweet: tweet));

  final Tweet tweet;

  const TwitterReplyScreen({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onTap: () {},
              label: "Reply",
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
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

                  if(latestTweet.repliedTo == tweet.id && !isTweetAlreadyPresent) {

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
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
            text: value,
            context: context,
            images: [],
            repliedTo: tweet.id,
          );
        },
        decoration: const InputDecoration(
          hintText: "Tweet your reply",
          hintStyle: TextStyle(
            color: Pallete.blueColor,
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        )
      ),
    );
  }
}

