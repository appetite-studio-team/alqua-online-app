// ignore_for_file: use_build_context_synchronously

import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/language_helper/custom_text.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/screens/cart/providers/appwrite_cart_provider.dart';
import 'package:souq_alqua/screens/cart/screen/checkout_screen.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/providers/delivery_location_provider.dart';
import 'package:souq_alqua/screens/home/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';

import 'package:souq_alqua/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/image_class.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:souq_alqua/utils/style_class.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    AppwriteCartProvider appwriteCartProvider =
        Provider.of<AppwriteCartProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    Future.microtask(() {
      if (!loginProvider.isGuestLogin) {
        appwriteCartProvider.getCartItems();
        appwriteCartProvider.getCartLength();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Scaffold(
      appBar: AppBar(
        title: Consumer2<AppwriteCartProvider, LoginProvider>(
          builder: (context, snapshot, loginSnap, child) => Row(
            children: [
              CustomText(
                translate('all_categories'),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 10),
              loginSnap.isGuestLogin || snapshot.cartLength == 0
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: ColorClass.kPrimaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: ColorClass.kPrimaryColor,
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${snapshot.cartLength}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
            ],
          ),
        ),
      ),
      body: Consumer2<AppwriteCartProvider, LoginProvider>(
        builder: (context, cartProvider, loginProvider, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: loginProvider.isGuestLogin
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageClass.loginIcon, height: 110),
                      CustomText(
                        translate('login_profile'),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
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
                      )
                    ],
                  ),
                )
              : cartProvider.isAddtoCartLoading
                  ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        color: ColorClass.kPrimaryColor,
                        size: 35,
                      ),
                    )
                  : cartProvider.productList.isEmpty
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ImageClass.emptyCart,
                                    height: 80,
                                  ),
                                  const SizedBox(height: 10),
                                  //empty cart
                                  Text(
                                    "سلة التسوق فاضية \nأضف بعض الأدوات التقنية الرائعة!",
                                    style: TextStyleClass.text16BlackAr,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // start shopping button with dropshadow
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorClass.kPrimaryColor
                                              .withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 15,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, InitScreen.routeName);
                                      },
                                      child: Text(
                                        translate('start_shopping'),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: cartProvider.productList.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6F9),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                    color: const Color(0xFFD3D3D3)
                                        .withOpacity(0.84),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // product image with corner radius
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      cartProvider.productList[index]
                                          ['productImage'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          cartProvider.productList[index]
                                              ['productName'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 8),
                                        // Text(
                                        //   '${(cartProvider.productList[index]['price']) * cartProvider.productList[index]['quantity']}.00 AED',
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodyMedium!
                                        //       .copyWith(
                                        //         color: kPrimaryColor,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        // ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                  ),
                                                  child: const Icon(Icons.add)),
                                              onPressed: () {
                                                cartProvider
                                                    .increamentProductQuantity(
                                                        index,
                                                        cartProvider
                                                            .productList);
                                              },
                                            ),
                                            Text(
                                              cartProvider.productList[index]
                                                      ['quantity']
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            IconButton(
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                ),
                                                child: const Icon(
                                                  Icons.remove,
                                                ),
                                              ),
                                              onPressed: () {
                                                cartProvider
                                                    .decrementProductQuantity(
                                                        index,
                                                        cartProvider
                                                            .productList,
                                                        context);
                                              },
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.grey[400],
                                              ),
                                              onPressed: () {
                                                // show confirmation dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Remove Item'),
                                                      content: const Text(
                                                          'Are you sure you want to remove this item from cart?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: ColorClass
                                                                  .kPrimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            cartProvider
                                                                .removeProduct(
                                                                    index);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                              color: ColorClass
                                                                  .kPrimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
        ),
      ),
      bottomNavigationBar:
          Consumer3<AppwriteCartProvider, LoginProvider, AddressProvider>(
              builder: (context, cartProvider, loginProvider, addressProvider,
                      child) =>
                  loginProvider.isGuestLogin || cartProvider.cartLength == 0
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          // height: 174,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, -15),
                                blurRadius: 20,
                                color:
                                    const Color(0xFFDADADA).withOpacity(0.15),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const CheckOutScreen();
                              }));
                            },
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
    );
  }
}
