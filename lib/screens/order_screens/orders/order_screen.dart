import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/home/init_screen.dart';
import 'package:souq_alqua/screens/order_screens/orders/providers/appwrite_order_provider.dart';
import 'package:souq_alqua/screens/order_screens/orders/screens/order_detail_screen.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';
import 'package:souq_alqua/utils/color_class.dart';

import 'package:souq_alqua/utils/constants.dart';
import 'package:souq_alqua/utils/image_class.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  void initState() {
    super.initState();
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    Future.microtask(() {
      Provider.of<AppwriteOrderProvider>(context, listen: false)
          .fetchUserOrders(loginProvider.emailId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Orders',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      body: Consumer<AppwriteOrderProvider>(
        builder: (context, orderService, child) {
          if (orderService.isLoading) {
            return Center(
              child: LoadingAnimationWidget.horizontalRotatingDots(
                color: Colors.redAccent,
                size: 35,
              ),
            );
          } else if (orderService.orders.isEmpty) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageClass.orderIcon,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Still empty on orders?\n Let's start filling up that history!",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      // start shopping button with dropshadow
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ColorClass.kPrimaryColor.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, InitScreen.routeName);
                          },
                          child: const Text(
                            "Start Shopping",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: orderService.orders.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final order = orderService.orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                            order: order,
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: kBlackColor,
                      ),
                    ),
                    title: Row(
                      children: [
                        const Text(
                          'Order ID:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          order.$id
                              .substring(order.$id.length - 6)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: order.data['status'] == 'Order-Placed'
                                ? Colors.grey[500]
                                : order.data['status'] == 'Confirmed'
                                    ? Colors.blue[300]
                                    : order.data['status'] == 'Delivered'
                                        ? Colors.green[300]
                                        : order.data['status'] == 'Cancelled'
                                            ? Colors.red[300]
                                            : Colors.blueGrey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            order.data['status'] == 'Order-Placed'
                                ? 'Order Placed'
                                : order.data['status'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    subtitle:
                        // Delivery Date
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Delivery Date: ${orderService.getFormattedDeliveryDate(order.$createdAt, order.data['status'])}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Order Date: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(order.$createdAt))}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Total items count and price of the order
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Items: ${order.data['items'].length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Text(
                            //   'Total: ${order.data['items'].fold(0, (prev, item) => prev + item['price'] * item['quantity'])}.00 AED',
                            //   style: const TextStyle(
                            //       fontWeight: FontWeight.w600, fontSize: 12),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
