import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:souq_alqua/utils/color_class.dart';

class TabbyBanner extends StatelessWidget {
  const TabbyBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 27,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            ColorClass.primaryGradientColor2,
            ColorClass.primaryGradientColor1,
          ],
        ),
        color: const Color(0xff3cebbc),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: "Buy now.\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Pay later with",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            "https://i0.wp.com/ifnfintech.com/wp-content/uploads/2021/04/tabby.png?fit=322%2C150&ssl=1",
            width: 60,
          )
        ],
      ),
    );
  }
}

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      "https://tse2.mm.bing.net/th/id/OIG3.QUHk97ZF8s1mVV0XfMuO?pid=ImgGn",
      "https://tse4.mm.bing.net/th/id/OIG3.P5Hy4263qB_MysPssvRQ?pid=ImgGn",
      "https://tse2.mm.bing.net/th/id/OIG4.Cih35dTlmZeD1w0RoLaB?pid=ImgGn",
      "https://tse2.mm.bing.net/th/id/OIG4.pp50fRwhFv2bN2hKbQvZ?pid=ImgGn",
      // Add more image URLs here
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 1.8,
          enlargeCenterPage: true,
        ),
        items: imgList
            .map((item) => Container(
                  margin: const EdgeInsets.all(5.0),
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
                      item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
