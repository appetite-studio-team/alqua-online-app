import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/cart/providers/appwrite_cart_provider.dart';
import 'package:souq_alqua/screens/home/screens/home_banner/home_banner.dart';
import 'package:souq_alqua/screens/home/screens/service_section/services_section.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';

import 'package:souq_alqua/utils/image_class.dart';

import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/category_view.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Access providers once at the beginning
    final HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);
    final LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    final AppwriteCartProvider appwriteCartProvider =
        Provider.of<AppwriteCartProvider>(context, listen: false);

    // Use Future.microtask to handle asynchronous operations
    Future.microtask(() async {
      final futures = <Future>[];

      if (homeProvider.allCategories.isEmpty) {
        futures.add(homeProvider.getAllCategories(context));
      }
      if (homeProvider.allProducts.isEmpty) {
        futures.add(homeProvider.getAllProducts(context));
      }
      if (homeProvider.topSellingProduct.isEmpty) {
        futures.add(homeProvider.fetchProductsByTagSlug('top-selling'));
      }
      if (homeProvider.homeBannerList.isEmpty) {
        futures.add(homeProvider.getHomeBanner());
      }
      if (loginProvider.userId == null) {
        futures.add(loginProvider.getPreference());
      }
      loginProvider.checkUserLogin().then((value) {
        if (!loginProvider.isGuestLogin) {
          futures.add(appwriteCartProvider.getCartLength());
        }
      });

      // if user is logged in, get the cart length

      // Wait for all futures to complete
      await Future.wait(futures);
    });
  }

  Future<void> onRefresh() async {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);
    homeProvider.getAllCategories(context);
    homeProvider.getAllProducts(context);
    homeProvider.fetchProductsByTagSlug('top-selling');
    homeProvider.getHomeBanner();
  }

  @override
  Widget build(BuildContext context) {
       
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          ImageClass.appIcon,
          height: 55,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Column(
              children: [
                HomeHeader(),
                HomeBanner(),
                Services(),
                CategoryView(),
                SizedBox(height: 20),
                PopularProducts(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
