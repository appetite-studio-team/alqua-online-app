import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/home/provider/home_screen_provider.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, snap, child) => snap.homeBannerLoading
          ? const SizedBox()
          : SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.2,
                  autoPlayInterval: const Duration(seconds: 6),
                  enlargeCenterPage: true,
                ),
                items: snap.homeBannerList
                    .map((item) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                                offset: Offset(2, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              snap.getImageUrl(image: item.data['image']),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
