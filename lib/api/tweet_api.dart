
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:twitter_clone/core/core.dart';

import '../constants/appwrite_constants.dart';
import '../models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(appWriteDatabaseProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(Tweet tweet);
  Future<List<model.Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<model.Document> likeTweet(Tweet tweet);
  FutureEither<model.Document> updateReshareCount(Tweet tweet);
  Future<List<model.Document>> getRepliesToTweet(Tweet tweet);
  Future<model.Document> getTweetById(String id);
  Future<List<model.Document>> getUserTweets(String uid);
}

class TweetAPI implements ITweetAPI {

  final Databases _db;
  final Realtime _realtime;

  TweetAPI({
    required Databases db,
    required Realtime realtime,
  }) : _db = db,
       _realtime = realtime;

  @override
  FutureEither<model.Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );

      return right(document);
    }
    on AppwriteException catch (e, st) {
      return left(Failure(e.message??'Some error occurred', st));
    }
    catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<model.Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.orderDesc('tweetedAt'),
      ],
    );

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
        'databases.${AppWriteConstants.databaseID}.collections.${AppWriteConstants.tweetsCollection}.documents',
      ],
    ).stream;
  }

  @override
  FutureEither<model.Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );

      return right(document);
    }
    on AppwriteException catch (e, st) {
      return left(Failure(e.message??'Some error occurred', st));
    }
    catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<model.Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseID,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );

      return right(document);
    }
    on AppwriteException catch (e, st) {
      return left(Failure(e.message??'Some error occurred', st));
    }
    catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<model.Document>> getRepliesToTweet(Tweet tweet) async {

    final document = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
        Query.orderDesc('tweetedAt'),
      ],
    );

    return document.documents;
  }

  @override
  Future<model.Document> getTweetById(String id) async {
    
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<model.Document>> getUserTweets(String uid) async {

    final documents = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseID,
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
        Query.orderDesc('tweetedAt'),
      ],
    );

    return documents.documents;
  }
}
