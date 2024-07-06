// ignore_for_file: avoid_print

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/cart/providers/appwrite_cart_provider.dart';
// ignore: unused_import
import 'package:souq_alqua/screens/cart/providers/cart_provider.dart';
import 'package:souq_alqua/screens/home/models/products_model.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';
import 'package:souq_alqua/utils/color_class.dart';

import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class ProductDetailsScreen extends StatelessWidget {
  static String routeName = "/details";
  final GetAllProducts product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Visibility(
                visible: product.attributes.isNotEmpty &&
                    product.attributes.last.name == 'Rating',
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Text(
                        product.attributes.isEmpty
                            ? '0.0'
                            : product.attributes.last.options.first,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset("assets/icons/Star Icon.svg"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Consumer2<LoginProvider, AppwriteCartProvider>(
            builder: (context, loginProvider, awSnap, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // price of the product
                  // RichText(
                  //     text: TextSpan(
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 11,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  //   children: [
                  //     const TextSpan(text: "AED  "),
                  //     TextSpan(
                  //       text: "${product.price.toString()}.00",
                  //       style: const TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 22,
                  //         fontWeight: FontWeight.w900,
                  //       ),
                  //     ),
                  //   ],
                  // )),
                  const Spacer(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorClass.kPrimaryColor,
                        boxShadow: const [
                          BoxShadow(
                            color: ColorClass.kPrimaryColor,
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (loginProvider.isGuestLogin) {
                              floatingSnackBar(
                                  message: 'Please login to add to cart',
                                  context: context);
                            } else {
                              // Call the addToCart function
                              await awSnap.addToCart(product);
                              floatingSnackBar(
                                  message: 'Added to cart', context: context);
                            }
                          } catch (error) {
                            // Handle any errors here
                            print("Error adding to cart: $error");
                          } finally {
                            // Ensure the loading indicator is dismissed if an error occurs
                            // can pop the screen here
                            Navigator.canPop(context)
                                ? Navigator.pop(context)
                                : null;
                          }
                        },
                        child: awSnap.isAddtoCartLoading
                            ? LoadingAnimationWidget.horizontalRotatingDots(
                                color: Colors.white,
                                size: 30,
                              )
                            : const Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
