import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/cart/cart_screen.dart';
import 'package:souq_alqua/screens/cart/providers/appwrite_cart_provider.dart';

import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
          Consumer<AppwriteCartProvider>(
            builder: (context, value, _) => IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem: value.cartLength,
                press: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                }),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
