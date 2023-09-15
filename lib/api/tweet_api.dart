
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
}
