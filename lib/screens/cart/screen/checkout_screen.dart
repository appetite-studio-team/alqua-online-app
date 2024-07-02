// ignore_for_file: use_build_context_synchronously

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/cart/providers/appwrite_cart_provider.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/delivery_location.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/providers/delivery_location_provider.dart';
import 'package:souq_alqua/screens/home/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';

import 'package:souq_alqua/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/constants.dart';
import 'package:souq_alqua/utils/image_class.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:souq_alqua/utils/style_class.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  void initState() {
    AppwriteCartProvider appwriteCartProvider =
        Provider.of<AppwriteCartProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    Future.microtask(() {
      if (!loginProvider.isGuestLogin) {
        appwriteCartProvider.getCartItems();
        appwriteCartProvider.getCartLength();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer2<AppwriteCartProvider, LoginProvider>(
          builder: (context, snapshot, loginSnap, child) => Row(
            children: [
              Text(
                "Checkout",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              loginSnap.isGuestLogin || snapshot.cartLength == 0
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: ColorClass.kPrimaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: ColorClass.kPrimaryColor,
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${snapshot.cartLength}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
            ],
          ),
        ),
      ),
      body: Consumer2<AppwriteCartProvider, LoginProvider>(
        builder: (context, cartProvider, loginProvider, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: loginProvider.isGuestLogin
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageClass.loginIcon, height: 110),
                      Text(
                        "Ready to roll?\n Log in to make these cars yours",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              }), (route) => false);
                            },
                            child: const Text('Login')),
                      )
                    ],
                  ),
                )
              : cartProvider.isAddtoCartLoading
                  ? Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        color: ColorClass.kPrimaryColor,
                        size: 35,
                      ),
                    )
                  : cartProvider.productList.isEmpty
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ImageClass.toyCart,
                                    height: 70,
                                  ),
                                  const SizedBox(height: 10),
                                  // order placed - shop will contact you
                                  Text(
                                    "تم تقديم الطلب، سيتصل بك المتجر",
                                    style: TextStyleClass.text16BlackAr,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 15),
                                  // start shopping button with dropshadow
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorClass.kPrimaryColor
                                              .withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 15,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, InitScreen.routeName);
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
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: List.generate(
                                  cartProvider.productList.length,
                                  (index) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F6F9),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 5,
                                            color: const Color(0xFFD3D3D3)
                                                .withOpacity(0.84),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // product image with corner radius
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              cartProvider.productList[index]
                                                  ['productImage'],
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  cartProvider
                                                          .productList[index]
                                                      ['productName'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                  maxLines: 2,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${cartProvider.productList[index]['quantity']} x AED ${(cartProvider.productList[index]['price']) * cartProvider.productList[index]['quantity']}.00',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Delivery Date
                              const SizedBox(height: 20),
                              ListTile(
                                title: const Text(
                                  'Delivery Date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                    Icons.calendar_today,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('MMMM dd yyyy').format(
                                    DateTime.now().add(
                                      const Duration(days: 3),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),

                              /// Shipping Address
                              Consumer<AddressProvider>(
                                builder: (context, addressProvider, child) =>
                                    ListTile(
                                  title: const Text(
                                    'Shipping Address',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
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
                                      Icons.location_city,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  subtitle: addressProvider.defaultAddress !=
                                          null
                                      ? Text(
                                          "${addressProvider.defaultAddress!.addressName}, ${addressProvider.defaultAddress!.doorNo}, ${addressProvider.defaultAddress!.street}, ${addressProvider.defaultAddress!.city}\n${addressProvider.defaultAddress!.phoneNumber}",
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      : const Text(
                                          "Please select a delivery address",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: ColorClass.kPrimaryColor),
                                        ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const LocationScreen();
                                      }));
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),

                              // Coupon Code / Gift Card
                              ListTile(
                                title: const Text(
                                  'Coupon Code / Gift Card',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                    Icons.card_giftcard,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                subtitle: const Text(
                                  'Add a coupon code or gift card',
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing:
                                    // icon button with bottom sheet dialog for coupon code
                                    IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          final textController =
                                              TextEditingController();
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom, // Adjusts for the keyboard
                                            ),
                                            child: SingleChildScrollView(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      'Add Coupon Code',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          AddressCustomTextField(
                                                        textController:
                                                            textController,
                                                        hintText:
                                                            'Enter Coupon Code',
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        //  show snackbar as feature not implemented
                                                        floatingSnackBar(
                                                            message:
                                                                'Feature not available yet!',
                                                            context: context);

                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Apply'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                ),
                              ),

                              // Payment Method
                              ListTile(
                                title: const Text(
                                  'Payment Method',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                    Icons.payment,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                subtitle: const Text(
                                  'Cash on Delivery',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              // Shiping fee
                              ListTile(
                                title: const Text(
                                  'Shipping Fee',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                    Icons.local_shipping,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                subtitle: const Text(
                                  'AED 0.00',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Total Amount
                              ListTile(
                                title: const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                    Icons.monetization_on,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'AED ${(cartProvider.productList.fold(0, (prev, item) => prev + (item['price'] * item['quantity'] as int))).toString()}.00',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
        ),
      ),
      bottomNavigationBar: Consumer3<AppwriteCartProvider, LoginProvider,
              AddressProvider>(
          builder: (context, cartProvider, loginProvider, addressProvider,
                  child) =>
              loginProvider.isGuestLogin || cartProvider.cartLength == 0
                  ? const SizedBox()
                  : AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeIn,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        // height: 174,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -15),
                              blurRadius: 20,
                              color: const Color(0xFFDADADA).withOpacity(0.15),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            // check if the user is guest and default address is available
                            if (loginProvider.isGuestLogin) {
                              floatingSnackBar(
                                  message: 'Please login to checkout!',
                                  context: context);
                              return;
                            } else if (addressProvider.defaultAddress == null) {
                              floatingSnackBar(
                                  message: 'Please select a delivery address',
                                  context: context);

                              return;
                            } else {
                              await cartProvider.checkout(
                                phoneNumber:
                                    addressProvider.defaultAddress!.phoneNumber,
                                deliveryAddrss:
                                    "${addressProvider.defaultAddress!.addressName}, ${addressProvider.defaultAddress!.doorNo}, ${addressProvider.defaultAddress!.street}, ${addressProvider.defaultAddress!.city}",
                                context: context,
                              );
                              floatingSnackBar(
                                  message: 'Order placed successfully!',
                                  context: context);
                            }
                          },
                          child: cartProvider.isCartLoading
                              ? LoadingAnimationWidget.horizontalRotatingDots(
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Text("Check Out"),
                        ),
                      ),
                    )),
    );
  }
}
