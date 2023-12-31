
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
import 'package:twitter_clone/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {

  final searchController = TextEditingController();

  bool isShowUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          height: 50,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
                print('searching for users $isShowUsers');
              });
            },
            decoration: InputDecoration(
              hintText: 'Search Twitter',
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
            ),
          )
        ),
      ),
      body: ref.watch(searchUserProvider(searchController.text.trim())).when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return SearchTile(userModel: user);
            },
          );
        },
        error: (error, st) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
