
class AppWriteConstants {

  static const String projectID = '64fc84f7edab5c1988b1';
  static const String databaseID = '64fc933625f53318f3a9';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '65003a441a1c31500a49';
  static const String tweetsCollection = '65016d89b0b30a8ce0ee';

  static const String imagesBucket = '65017732418476770f4e';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectID&mode=admin';
}
