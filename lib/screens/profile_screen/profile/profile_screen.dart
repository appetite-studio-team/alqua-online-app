import 'package:souq_alqua/helper/language_helper/custom_text.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/helper/language_helper/locale_provider.dart';
import 'package:souq_alqua/screens/cart/screen/checkout_screen.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/delivery_location.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/providers/delivery_location_provider.dart';
import 'package:souq_alqua/screens/order_screens/orders/order_screen.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';

import 'package:souq_alqua/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/utils/api_support.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/image_class.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    AddressProvider addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    Future.microtask(() {
      loginProvider.getPreference();
      loginProvider.checkUserLogin().then((value) {
        if (!loginProvider.isGuestLogin) {
          addressProvider.fetchUserEmail();
        }
      });
    });

    super.initState();
  }

  Future<void> launchWhatsApp(
      {required String phone, required String message}) async {
    String urlString() {
      if (message.isNotEmpty) {
        return "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
      } else {
        return "https://wa.me/$phone/";
      }
    }

    Uri url = Uri.parse(urlString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            translate(
              'profile',
            ),
            style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: Consumer2<LoginProvider, AddressProvider>(
        builder: (context, snap, addressSnap, child) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: snap.isGuestLogin
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageClass.loginIcon, height: 110),
                        Text(
                          translate(
                            'login_profile',
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              }), (route) => false);
                            },
                            child: CustomText(
                              translate('login'),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileMenu(
                          text: translate('contact_us'),
                          icon: "assets/icons/Call.svg",
                          press: () async {
                            // call to "8766786789"
                            Uri url = Uri(scheme: 'tel', path: "0506375562");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                        Consumer<LocaleProvider>(
                          builder: (context, langSnap, child) => ProfileMenu(
                            text: translate('change_language'),
                            icon: "assets/icons/language.svg",
                            press: () async {
                              String newLanguageCode =
                                  Localizations.localeOf(context)
                                              .languageCode ==
                                          'en'
                                      ? 'ar'
                                      : 'en';
                              await langSnap.setLocale(newLanguageCode);
                            },
                          ),
                        ),
                        ProfileMenu(
                          text: translate('whatsapp_support'),
                          icon: ImageClass.whatsappIcon,
                          press: () {
                            launchWhatsApp(
                                phone: "+971506375562",
                                message: "Hello, I need help with my order.");
                          },
                        ),
                        // version info
                        const SizedBox(height: 20),
                        Text(
                          "${translate('version')} ${ApiSupport.appVersion}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const ProfilePic(),
                    const SizedBox(height: 10),
                    Text(
                      snap.userName ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      snap.emailId ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 10),

                    /// My Wallet
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   margin: const EdgeInsets.symmetric(horizontal: 20),
                    //   decoration: BoxDecoration(
                    //     color: Colors.black87,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         spreadRadius: 1,
                    //         blurRadius: 5,
                    //         offset: const Offset(0, 3),
                    //       ),
                    //     ],
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       SvgPicture.asset(
                    //         "assets/icons/Flash Icon.svg",
                    //         // ignore: deprecated_member_use
                    //         color: Colors.white,
                    //         height: 30,
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const Text("Reward Points",
                    //               style: TextStyle(
                    //                 fontFamily: kFontFamily,
                    //                 fontSize: 12,
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold,
                    //               )),
                    //           Text(addressSnap.rewardPoint ?? "0.00",
                    //               style: const TextStyle(
                    //                 fontFamily: kFontFamily,
                    //                 fontSize: 20,
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold,
                    //               )),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    ProfileMenu(
                      text: translate('contact_us'),
                      icon: "assets/icons/Call.svg",
                      press: () async {
                        // call to "8766786789"
                        Uri url = Uri(scheme: 'tel', path: "0506375562");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    Consumer<LocaleProvider>(
                      builder: (context, langSnap, child) => ProfileMenu(
                        text: translate('change_language'),
                        icon: "assets/icons/language.svg",
                        press: () async {
                          String newLanguageCode =
                              Localizations.localeOf(context).languageCode ==
                                      'en'
                                  ? 'ar'
                                  : 'en';
                          await langSnap.setLocale(newLanguageCode);
                        },
                      ),
                    ),
                    ProfileMenu(
                      text: translate('my_cart'),
                      icon: "assets/icons/Cart Icon.svg",
                      press: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CheckOutScreen();
                        }))
                      },
                    ),
                    ProfileMenu(
                      text: translate('my_orders'),
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyOrderScreen();
                        }))
                      },
                    ),
                    ProfileMenu(
                      text: translate('delivery_address'),
                      icon: "assets/icons/Parcel.svg",
                      press: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LocationScreen();
                        }))
                      },
                    ),
                    // ProfileMenu(
                    //   text: translate('faq'),
                    //   icon: "assets/icons/Question mark.svg",
                    //   press: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) {
                    //       return const FaqScreen();
                    //     }));
                    //   },
                    // ),
                    ProfileMenu(
                      text: translate('whatsapp_support'),
                      icon: ImageClass.whatsappIcon,
                      press: () {
                        launchWhatsApp(
                            phone: "+971506375562",
                            message: "Hello, I need help with my order.");
                      },
                    ),
                    ProfileMenu(
                      text: translate('delete_account'),
                      icon: "assets/icons/Trash.svg",
                      press: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: CustomText(translate('delete_account')),
                              content: CustomText(translate('delete_confirm')),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2)),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        false); // Dismiss the dialog and return false
                                  },
                                  child: Text(
                                    translate('Cancel'),
                                    style:
                                        const TextStyle(color: Colors.black45),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorClass.kPrimaryColor),
                                  onPressed: () async {
                                    snap.logoutFn(context: context);
                                  },
                                  child: CustomText(
                                    translate('Delete'),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ProfileMenu(
                      text: translate('logout'),
                      icon: "assets/icons/Log out.svg",
                      press: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const LogoutDialog();
                          },
                        ).then((value) {
                          // This block executes when the dialog is dismissed.
                          if (value != null && value) {
                            // FirebaseAuth.instance.signOut();
                            snap.logoutFn(context: context);
                          }
                        });
                      },
                    ),

                    // version info
                    const SizedBox(height: 20),

                    Text(
                      "${translate('version')} ${ApiSupport.appVersion}",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return AlertDialog(
      title: Text(translate('logout')),
      content: Text(translate('logout_confirm')),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.withOpacity(0.2)),
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Dismiss the dialog and return false
          },
          child: Text(
            translate('Cancel'),
            style: const TextStyle(color: Colors.black45),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.of(context)
                .pop(true); // Dismiss the dialog and return true
          },
          child: Text(
            translate('logout'),
          ),
        ),
      ],
    );
  }
}
