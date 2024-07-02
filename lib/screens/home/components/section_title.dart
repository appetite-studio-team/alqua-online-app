import 'package:flutter/material.dart';
import 'package:souq_alqua/utils/style_class.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {Key? key,
      required this.title,
      required this.press,
      this.reverseAlign = false})
      : super(key: key);

  final String title;
  final GestureTapCallback? press;
  final bool reverseAlign;

  @override
  Widget build(BuildContext context) {
    return reverseAlign
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Offstage(
                offstage: press == null,
                child: TextButton(
                  onPressed: press,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  // mort
                  child: Text("المزيد", style: TextStyleClass.text14GreyAr),
                ),
              ),
              Text(
                title,
                style: TextStyleClass.text16BlackAr,
              ),
            ],
          )
        : Row(
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
                  child: const Text("See More"),
                ),
              ),
            ],
          );
  }
}
