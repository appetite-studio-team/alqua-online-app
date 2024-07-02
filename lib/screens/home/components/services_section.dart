import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/image_class.dart';
import 'package:souq_alqua/utils/style_class.dart';

class Services extends StatelessWidget {
  const Services({super.key});
// services
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": ImageClass.taxi, "text": "تاكسي"},
      {"icon": ImageClass.restaurants, "text": "مطعم"},
      {"icon": ImageClass.supermarket, "text": "سوبرماركت"},
      {"icon": ImageClass.workerIcon, "text": "عامل"},
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {},
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: ColorClass.primaryGradientColor2.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon.contains('.svg')
                ? SvgPicture.asset(
                    icon,
                    // ignore: deprecated_member_use
                    color: ColorClass.kPrimaryColor,
                  )
                : Image.asset(icon),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyleClass.text14GreyAr,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
