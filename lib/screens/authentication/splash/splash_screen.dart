import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:souq_alqua/screens/home/init_screen.dart';
import 'package:souq_alqua/utils/image_class.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const InitScreen();
      }), (route) => false);
      // check if user is logged in or not with shared preference
      //   SharedPreferences.getInstance().then((prefs) {
      //     if (prefs.getString('userId') != null) {
      //       Navigator.pushAndRemoveUntil(context,
      //           MaterialPageRoute(builder: (context) {
      //         return const InitScreen();
      //       }), (route) => false);
      //     } else {
      //       Navigator.pushAndRemoveUntil(context,
      //           MaterialPageRoute(builder: (context) {
      //         return const SignInScreen();
      //       }), (route) => false);
      //     }
      //   });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              ImageClass.appIcon,
              height: 150,
            ),
            LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.black,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
