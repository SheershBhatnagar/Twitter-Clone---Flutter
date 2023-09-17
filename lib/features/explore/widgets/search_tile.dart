
import 'package:flutter/material.dart';

import 'package:twitter_clone/models/user_model.dart';

class SearchTile extends StatelessWidget {

  final UserModel userModel;

  const SearchTile({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(userModel.profilePic),
      ),
      title: Text(userModel.name),
    );
  }
}

