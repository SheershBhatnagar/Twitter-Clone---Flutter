
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/api/tweet_api.dart';

import '../../../models/tweet_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(tweetAPI: ref.watch(tweetAPIProvider));
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  return ref.watch(userProfileControllerProvider.notifier).getUserTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {

  final TweetAPI _tweetAPI;

   UserProfileController({
    required TweetAPI tweetAPI,
  }) :  _tweetAPI = tweetAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {

    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
