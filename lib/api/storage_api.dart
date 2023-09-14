
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/constants/appwrite_constants.dart';

import '../core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appWriteStorageProvider));
});

class StorageAPI {

  final Storage _storage;
  StorageAPI({
    required Storage storage
  }) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {

    List<String> imageLinks = [];

    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppWriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile(
          path: file.path,
        ),
      );

      imageLinks.add(AppWriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
