import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/components/product_card.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';
import 'package:souq_alqua/utils/color_class.dart';

import '../product_detail_screen/product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  final int categoryId;

  const ProductsScreen({super.key, required this.categoryId});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);
    Future.microtask(() {
      homeProvider.getAllProductsByCategory(widget.categoryId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, snapshot, child) => snapshot
                  .getAllProductsByCategoryLoading
              ? Center(
                  child: LoadingAnimationWidget.horizontalRotatingDots(
                    color: ColorClass.kPrimaryColor,
                    size: 35,
                  ),
                )
              :
              // set no data found
              snapshot.allProductsByCategory.isEmpty
                  ? const Center(
                      child: Text("No products found"),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        itemCount: snapshot.allProductsByCategory.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) => DynamicProductCard(
                          product: snapshot.allProductsByCategory[index],
                          onPress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: snapshot.allProductsByCategory[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
