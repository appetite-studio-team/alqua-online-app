import 'package:souq_alqua/helper/language_helper/custom_text.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/screens/product/product_detail_screen/product_details_screen.dart';
import 'package:souq_alqua/utils/animation_class.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/components/product_card.dart';
import 'package:souq_alqua/screens/home/components/search_field.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';
import 'package:souq_alqua/utils/constants.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({
    super.key,
  });

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, snapshot, child) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          autofocus: true,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                snapshot.searchProducts(value);
                              });
                            } else {
                              snapshot.clearSearchList();
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kSecondaryColor.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            border: searchOutlineInputBorder,
                            focusedBorder: searchOutlineInputBorder,
                            enabledBorder: searchOutlineInputBorder,
                            hintText: translate('search_products'),
                            hintStyle: const TextStyle(
                              color: kTextColor,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                snapshot.clearSearchList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                snapshot.searchProductList.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              AnimationClass.noData,
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            CustomText(
                              translate('result_not_found'),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              translate('result_not_found_desc'),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            itemCount: snapshot.searchProductList.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) => ProductCard(
                              product: snapshot.searchProductList[index],
                              onPress: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    product: snapshot.searchProductList[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
