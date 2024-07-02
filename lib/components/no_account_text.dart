import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';
import 'package:souq_alqua/screens/home/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/utils/style_class.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, snap, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GestureDetector(
            onTap: () {
              snap.updateGuestLogin = true;
              Navigator.pushNamed(context, InitScreen.routeName);
            },
            child: Text(
              "Continue as guest?",
              style: TextStyleClass.text16Primary,
            ),
          ),
        );
      },
    );
  }
}
