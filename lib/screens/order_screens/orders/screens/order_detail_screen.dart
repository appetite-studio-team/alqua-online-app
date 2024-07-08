import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/language_helper/custom_text.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/screens/order_screens/orders/providers/appwrite_order_provider.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/constants.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  final Document order;

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          translate('order_details'),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<AppwriteOrderProvider>(
        builder: (context, orderService, _) => FutureBuilder<Document?>(
          future: orderService.fetchOrderItems(order.$id),
          builder: (context, itemSnapshot) {
            if (itemSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: ColorClass.kPrimaryColor,
                  size: 35,
                ),
              );
            } else if (itemSnapshot.hasError) {
              return const Center(child: Text('Error loading items'));
            } else if (!itemSnapshot.hasData) {
              return const Center(child: Text('No items found'));
            } else {
              final item = itemSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    for (var i = 0; i < item.data['items'].length; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading:
                              // display the image of the product with corner radius and black border
                              ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              item.data['items'][i]['productImage'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.data['items'][i]['productName'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: ColorClass.redAccentColor
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${translate('qty')} : ${item.data['items'][i]['quantity']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          // trailing: Text(
                          //   '${item.data['items'][i]['price']}.00 AED',
                          //   style: const TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 12),
                          // ),
                        ),
                      ),
                    const Divider(),
                    // shiping address
                    ListTile(
                      title: CustomText(translate('delivery_address'),
                          fontWeight: FontWeight.bold, fontSize: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_city,
                          color: kPrimaryColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.data['userId'] ?? '--'}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${item.data['shippingAddress'] ?? '--'}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${translate('phone')} :${item.data['phoneNumber'] ?? '--'}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // payment method
                    // ListTile(
                    //   title: const Text(
                    //     'Payment Method',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold, fontSize: 12),
                    //   ),
                    //   leading: Container(
                    //     padding: const EdgeInsets.all(10),
                    //     height: 40,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xFFF5F6F9),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: const Icon(
                    //       Icons.payment,
                    //       color: kPrimaryColor,
                    //     ),
                    //   ),
                    //   subtitle: Text(
                    //     item.data['paymentMethod'] ?? '--',
                    //     style: const TextStyle(fontSize: 12),
                    //   ),
                    // ),
                    // order status
                    ListTile(
                      title: CustomText(
                        translate(
                          'order_status',
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.info,
                          color: kPrimaryColor,
                        ),
                      ),
                      subtitle: CustomText(
                        item.data['status'] == 'Order-Placed'
                            ? translate('order_placed')
                            : item.data['status'] == 'Confirmed'
                                ? translate('confirmed')
                                : item.data['status'] == 'Delivered'
                                    ? translate('delivered')
                                    : item.data['status'] == 'Cancelled'
                                        ? translate('cancelled')
                                        : '--',
                        fontSize: 12,
                      ),
                    ),
                    const Divider(),
                    // Delivery fee
                    ListTile(
                      title: Row(
                        children: [
                          CustomText(translate('delivery_fee'),
                              fontWeight: FontWeight.bold, fontSize: 12),
                          const Spacer(),
                          Text(
                            '${translate('aed')} 0.00',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: const Row(
                        children: [
                          // Text(
                          //   'Total Amount',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 12),
                          // ),
                          // Spacer(),
                          // Text(
                          //   '${item.data['items'].fold(0, (prev, item) => prev + item['price'] * item['quantity'])}.00 AED',
                          //   style: const TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 12),
                          // ),
                        ],
                      ),
                    ),
                    // if order is placed then enable the cancel button
                    if (item.data['status'] == 'Order-Placed')
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // show dialog to confirm the cancel order
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: CustomText(
                                    translate(
                                      'cancel_order',
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  content: CustomText(
                                    translate(
                                      'confirm_order_cancel',
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CustomText(
                                        translate(
                                          'no',
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        orderService
                                            .cancelOrder(order.$id, context)
                                            .then((value) =>
                                                Navigator.of(context).pop());
                                      },
                                      child: CustomText(
                                        translate(
                                          'yes',
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorClass.redAccentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: orderService.isCancelOrderLoading
                                ? LoadingAnimationWidget.horizontalRotatingDots(
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : CustomText(
                                    translate(
                                      'cancel_order',
                                    ),
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
