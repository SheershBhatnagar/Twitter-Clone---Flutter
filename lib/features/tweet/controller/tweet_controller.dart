
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/api/tweet_api.dart';
import 'package:twitter_clone/core/utils.dart';

import '../../../api/storage_api.dart';
import '../../../core/enums/tweet_type_enum.dart';
import '../../../models/tweet_model.dart';
import '../../auth/controller/auth_controller.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getTweetsProvider = FutureProvider((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

class TweetController extends StateNotifier<bool> {

  final Ref _ref;
  final StorageAPI _storageAPI;
  final TweetAPI _tweetAPI;

  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  }) : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void shareTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
  }) {
    if(text.isEmpty) {
      showSnackBar(context, "Please enter some text");
      return;
    }

    if(images.isNotEmpty) {
      _shareImageTweet(
        text: text,
        images: images,
        context: context,
      );
    }
    else {
      _shareTextTweet(
        text: text,
        context: context,
      );
    }
  }

  void _shareImageTweet ({
    required String text,
    required List<File> images,
    required BuildContext context,
  }) async {
    state = true;

    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);

    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: imageLinks,
        uid: user.uid,
        tweetType: TweetType.image,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        reshareCount: 0,
        id: ''
    );

    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => null
    );
  }

  void _shareTextTweet ({
    required String text,
    required BuildContext context
  }) async {
    state = true;

    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      reshareCount: 0,
      id: ''
    );

    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => null
    );
  }

  String _getLinkFromText(String text) {

    String link = '';

    List<String> wordsInSentence = text.split(' ');
    for(String word in wordsInSentence) {
      if(word.startsWith('http://') || word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {

    List<String> hashtags = [];

    List<String> wordsInSentence = text.split(' ');
    for(String word in wordsInSentence) {
      if(word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}