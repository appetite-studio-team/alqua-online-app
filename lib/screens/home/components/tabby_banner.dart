import 'package:flutter/material.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/utils/color_class.dart';

class TabbyBanner extends StatelessWidget {
  const TabbyBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 15),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            ColorClass.primaryGradientColor2,
            ColorClass.primaryGradientColor1,
          ],
        ),
        color: const Color(0xff3cebbc),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: "${translate("buy_now")} \n ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: translate("pay_later_with"),
                  style: const TextStyle(
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
