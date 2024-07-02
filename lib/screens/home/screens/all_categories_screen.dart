import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:souq_alqua/screens/home/components/category_view.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/product/products/products_screen.dart';
import 'package:souq_alqua/utils/color_class.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Categories",
            style: Theme.of(context).textTheme.bodyLarge),
        leading: null,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, snapshot, child) => snapshot.getAllCategoriesLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: ColorClass.kPrimaryColor,
                  size: 35,
                ),
              )
            : Column(children: [
                Expanded(
                    child: GridView.builder(
                  itemCount: snapshot.allCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1.8,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemBuilder: (context, index) => VerticalCategoryCard(
                    image: snapshot.allCategories[index].image == null
                        ? ""
                        : snapshot.allCategories[index].image!.src!,
                    category: snapshot.allCategories[index].name ?? "",
                    numOfBrands: 18,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsScreen(
                            categoryId: snapshot.allCategories[index].id!,
                          ),
                        ),
                      );
                    },
                  ),
                )),
              ]),
      ),
    );
  }
}
