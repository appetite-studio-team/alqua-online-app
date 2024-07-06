import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/components/no_account_text.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';
import 'package:souq_alqua/utils/constants.dart';

import 'package:souq_alqua/utils/image_class.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageClass.appIcon,
                          height: 120,
                        ),
                        const SizedBox(height: 10),
                        // sub title
                        const Text(
                          "🏝 سوق القوعة",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          "تسوق بلمسة محلية \nتجربة تسوق مميزة لأهل القوعة",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 22,
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<LoginProvider>(       
                        builder: (context, provider, child) =>
                            ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          icon: provider.loginScreenAuthLoader
                              ? LoadingAnimationWidget.horizontalRotatingDots(
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Image.asset(ImageClass.googleLogo,
                                  height: 24, width: 24),
                          label: const Text(
                            'Sign in',
                          ),
                          onPressed: () {
                            try {
                              provider.googleLogin(context: context);
                            } catch (e) {
                              log(e.toString());
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const NoAccountText(),
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
