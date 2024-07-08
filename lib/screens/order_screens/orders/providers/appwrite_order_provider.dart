// import 'package:appwrite/appwrite.dart';
// // ignore: library_prefixes
// import 'package:appwrite/models.dart' as Models;
// import 'package:flutter/material.dart';
// import 'package:souq_alqua/helper/db_helper.dart';

// class AppwriteOrderProvider with ChangeNotifier {
//   late final Databases databases;

//   AppwriteOrderProvider() {
//     final client = Client().setEndpoint(DbHelper.dbUrl);
//     client.setProject(DbHelper.projectId);
//     databases = Databases(client);
//   }

// Stream<List<Models.Document>> getOrderStream(String email) {
//     return databases.listDocuments(
//       databaseId: DbHelper.orderMngmtDbId,
//       collectionId: DbHelper.ordersCollectionId,
//       queries: [
//         Query.equal('userId', email),
//       ],
//     ).asStream().map((response) => response.documents);
//   }
//   Future<void> removeProductFromOrder(
//       int index, List products, String documentId) async {
//     products.removeAt(index);
//     await databases.updateDocument(
//       databaseId: DbHelper.orderMngmtDbId,
//       collectionId: DbHelper.ordersCollectionId,
//       documentId: documentId,
//       data: {'items': products},
//     );
//     notifyListeners();
//   }

// ignore_for_file: avoid_print

//   double calculateTotalPrice(Models.Document document) {
//     List products = document.data['items'];
//     return products.fold(0,
//         (total, product) => total + (product['price'] * product['quantity']));
//   }
// }
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/db_helper.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/screens/cart/providers/appwrite_cart_provider.dart';

class AppwriteOrderProvider extends ChangeNotifier {
  final Client client;
  final Databases databases;

  List<Document> _orders = [];
  bool _isLoading = false;

  AppwriteOrderProvider(this.client) : databases = Databases(client);

  List<Document> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchUserOrders(String emailAddress) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await databases.listDocuments(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.ordersCollectionId,
        queries: [Query.equal('userId', emailAddress)],
      );
      log(response.toString());
      _orders = response.documents;
      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Document?> fetchOrderItems(String orderId) async {
    try {
      return await databases.getDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.ordersCollectionId,
        documentId: orderId,
      );
    } catch (e) {
      print('Error fetching order items: $e');
      return null;
    }
  }

  // cancel order - only change the status to 'Cancelled'
  bool isCancelOrderLoading = false;
  Future<void> cancelOrder(String orderId, BuildContext context) async {
    try {
      isCancelOrderLoading = true;
      notifyListeners();
      await databases.updateDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.ordersCollectionId,
        documentId: orderId,
        data: {'status': 'Cancelled'},
      ).then((value) async {
        AppwriteCartProvider cartProvider =
            Provider.of<AppwriteCartProvider>(context, listen: false);
        await cartProvider.reduceRewardPointOnOrder(context);
        String translate(String key) {
          return AppLocalizations.of(context)?.translate(key) ?? key;
        }

        floatingSnackBar(
            message: translate('order_cancelled'), context: context);
      });

      isCancelOrderLoading = false;
      notifyListeners();
    } catch (e) {
      isCancelOrderLoading = false;
      notifyListeners();
      print('Error cancelling order: $e');
    }
  }

  // Function to get the formatted delivery date
  String getFormattedDeliveryDate(String createdAt, String status) {
    DateTime createdDate = DateTime.parse(createdAt);
    DateTime deliveryDate;

    if (status != 'Order-Placed') {
      deliveryDate = createdDate.add(const Duration(days: 4));
    } else {
      deliveryDate = createdDate.add(const Duration(days: -4));
    }

    return DateFormat('MMMM d, yyyy').format(deliveryDate);
  }
}
