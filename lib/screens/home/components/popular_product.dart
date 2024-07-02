import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';
import 'package:souq_alqua/screens/product/product_detail_screen/product_details_screen.dart';

import '../../../components/product_card.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, snapshot, child) => Column(
        children: [
          const Padding(
            //"Popular Products",
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle(
              title: "🔥 الأكثر مبيعاً",
              press: null,
              reverseAlign: true,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: snapshot.topSellingProduct.length > 40
                ? 40
                : snapshot.topSellingProduct.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(10),
              child: DynamicProductCard(
                product: snapshot.topSellingProduct[index],
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: snapshot.topSellingProduct[index],
                        ),
                      ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
