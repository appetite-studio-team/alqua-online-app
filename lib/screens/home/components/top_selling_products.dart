import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';
import 'package:souq_alqua/screens/product/product_detail_screen/product_details_screen.dart';
import 'package:souq_alqua/components/product_card.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'section_title.dart';

class TopSellingProducts extends StatelessWidget {
  const TopSellingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, productsProvider, child) {
        return Visibility(
          visible: productsProvider.topSellingProduct.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  //"Top Selling 🔥",

                  child: SectionTitle(
                    title: "🔥 الأكثر مبيعاً",
                    reverseAlign: true,
                    press: null,
                  ),
                ),
                const SizedBox(height: 10),
                productsProvider.isTopSellingLoading
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                        color: ColorClass.kPrimaryColor,
                        size: 30,
                      ))
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.29,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount:
                              productsProvider.topSellingProduct.length > 20
                                  ? 20
                                  : productsProvider.topSellingProduct.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: DynamicProductCard(
                              product:
                                  productsProvider.topSellingProduct[index],
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                        product: productsProvider
                                            .topSellingProduct[index],
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
