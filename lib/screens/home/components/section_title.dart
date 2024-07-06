import 'package:flutter/material.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Offstage(
          offstage: press == null,
          child: TextButton(
              onPressed: press,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                backgroundColor: Colors.grey.shade100,
              ),
              child: Text(
                translate(
                  'see_more',
                ),
              )),
        ),
      ],
    );
  }
}
