
import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../api/auth_api.dart';
import '../../../api/user_api.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authAPI: ref.watch(authAPIProvider),
      userAPI: ref.watch(userAPIProvider)
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {

  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  }): _authAPI = authAPI,
      _userAPI = userAPI,
      super(false);

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
            (l) => showSnackBar(context, l.message),
            (r) async {
              UserModel userModel = UserModel(
                email: email,
                name: getNameFromEmail(email),
                followers: const [],
                following: const [],
                profilePic: '',
                bannerPic: '',
                uid: '',
                bio: '',
                isTwitterBlue: false,
              );
              final res2 = await _userAPI.saveUserData(userModel);
              res2.fold(
                      (l) => showSnackBar(context, l.message),
                      (r) {
                            showSnackBar(context, 'Account created successfully! Please login.');
                            Navigator.push(context, LoginView.route());
                          }
              );
            }
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Welcome back!');
          Navigator.push(context, HomeView.route());
        },
    );
  }
}
