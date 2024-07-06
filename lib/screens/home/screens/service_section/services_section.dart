import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:souq_alqua/helper/language_helper/custom_text.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/screens/home/screens/service_section/screens/worker_screen.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/image_class.dart';

class Services extends StatelessWidget {
  const Services({super.key});
// services
  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    List<ServiceModel> services = [
      ServiceModel(
        icon: ImageClass.dress,
        text: translate('dress'),
        key: 'dress',
      ),
      ServiceModel(
        icon: ImageClass.restaurants,
        text: translate('restaurant'),
        key: 'restaurant',
      ),
      ServiceModel(
        icon: ImageClass.supermarket,
        text: translate('supermarket'),
        key: 'supermarket',
      ),
      ServiceModel(
        icon: ImageClass.workerIcon,
        text: translate('Workers'),
        key: 'worker',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          services.length,
          (index) => ServicesCard(
            icon: services[index].icon,
            text: services[index].text,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllWorkersScreen(
                    title: services[index].text,
                    serviceKey: services[index].key,
                    serviceIcon: services[index].icon,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ServicesCard extends StatelessWidget {
  const ServicesCard({
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
          CustomText(
            text,
            color: ColorClass.grayColor,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }
}

class ServiceModel {
  final String icon;
  final String key;
  final String text;

  ServiceModel({
    required this.icon,
    required this.key,
    required this.text,
  });
}
