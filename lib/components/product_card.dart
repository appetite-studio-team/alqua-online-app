import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:souq_alqua/screens/home/models/products_model.dart';
import 'package:souq_alqua/utils/api_support.dart';
import 'package:souq_alqua/utils/constants.dart';
import 'package:souq_alqua/utils/image_class.dart';

class ProductByCategoryCard extends StatelessWidget {
  const ProductByCategoryCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final GetAllProducts product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: kSecondaryColor.withOpacity(0.1)),
                  // color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.images.isEmpty
                    ? Image.asset(
                        ImageClass.emptyProductImage,
                        fit: BoxFit.cover,
                      )
                    : Image.network(product.images[0].src!),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.end,
              maxLines: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "AED ${product.price}",
                //   style: const TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //     color: kPrimaryColor,
                //   ),
                // ),
                // InkWell(
                //   borderRadius: BorderRadius.circular(50),
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     height: 20,
                //     width: 20,
                //     decoration: BoxDecoration(
                //       color: kSecondaryColor.withOpacity(0.1),
                //       shape: BoxShape.circle,
                //     ),
                //     child: SvgPicture.asset(
                //       "assets/icons/Heart Icon_2.svg",
                //       colorFilter: const ColorFilter.mode(
                //           Color(0xFFDBDEE4), BlendMode.srcIn),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final GetAllProducts product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.03,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: kSecondaryColor.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.images.isEmpty
                    ? Image.asset(
                        ImageClass.emptyProductImage,
                        fit: BoxFit.cover,
                      )
                    : Image.network(product.images[0].src!),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "AED ${product.price}",
                //   style: const TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //     color: kPrimaryColor,
                //   ),
                // ),
                // InkWell(
                //   borderRadius: BorderRadius.circular(50),
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     height: 20,
                //     width: 20,
                //     decoration: BoxDecoration(
                //       color: kSecondaryColor.withOpacity(0.1),
                //       shape: BoxShape.circle,
                //     ),
                //     child: SvgPicture.asset(
                //       "assets/icons/Heart Icon_2.svg",
                //       colorFilter: const ColorFilter.mode(
                //           Color(0xFFDBDEE4), BlendMode.srcIn),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DynamicProductCard extends StatelessWidget {
  const DynamicProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final GetAllProducts product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: kSecondaryColor.withOpacity(0.1)),
                  // color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const Center(
                    child: Icon(Icons.image),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 242,
                  imageUrl: product.images.isEmpty
                      ? ApiSupport.networkImagePlaceHolder
                      : product.images.first.src ??
                          ApiSupport.networkImagePlaceHolder,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "${product.price}.00 AED",
            //       style: const TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w600,
            //         color: kPrimaryColor,
            //       ),
            //     ),

            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
