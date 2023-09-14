
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/common.dart';
import '../controller/auth_controller.dart';

class LoginView extends ConsumerStatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const LoginView());

  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {

  final appBar = UIConstants.appBar();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref.read(authControllerProvider.notifier)
        .login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context
    );
  }

  @override
  Widget build(BuildContext context) {

    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: isLoading ? const LoadingPage() : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const Text(
                  "Log in to Twitter.",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 100),
                AuthField(
                  controller: emailController,
                  hintText: "Email Address",
                ),
                const SizedBox(height: 25),
                AuthField(
                  controller: passwordController,
                  hintText: "Password",
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    onTap: onLogin,
                    label: "Done",
                    verticalPadding: 5,
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                      fontSize: 16
                    ),
                    children: [
                      TextSpan(
                        text: " SignUp",
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(context, SignUpView.route());
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
