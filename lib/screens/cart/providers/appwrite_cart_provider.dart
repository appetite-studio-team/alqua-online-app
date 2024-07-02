import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/db_helper.dart';
import 'package:souq_alqua/screens/home/models/products_model.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/providers/delivery_location_provider.dart';

class AppwriteCartProvider extends ChangeNotifier {
  bool isAddtoCartLoading = false;
  Future<void> addToCart(GetAllProducts product) async {
    try {
      isAddtoCartLoading = true;
      notifyListeners();
      final client = Client()
          .setEndpoint(DbHelper.dbUrl)
          .setProject(DbHelper.projectId)
          .setSelfSigned(status: true); //
      final account = Account(client);
      final user = await account.get();
      // userId
      final userId = user.$id;
      final userEmail = user.email;
      final database = Databases(client);

      // Check if a cart for the user already exists
      final carts = await database.listDocuments(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.cartCollectionId,
        queries: [Query.equal('userId', userEmail)],
      );

      bool cartExists =
          carts.documents.where((cart) => cart.$id == userId).isNotEmpty;

      if (!cartExists) {
        log('cart not exits');

        // Create a new item in the 'items' collection
        final itemsResponse = await database.createDocument(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.itemsCollectionId,
          documentId: ID.unique(),
          data: {
            'productId': product.id.toString(),
            'productName': product.name,
            // 'price': double.parse(product.price ?? '0'),
            'price': 0.0, // '0.0' is a placeholder for 'product.price
            'quantity': 1,
            'productImage': product.images.isEmpty
                ? "https://via.placeholder.com/150"
                : product.images[0].src,
          },
        );
        log(itemsResponse.$id, name: "items response Id");
        // Create a new cart in the 'carts' collection
        final cartResponse = await database.createDocument(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.cartCollectionId,
          documentId: userId,
          data: {
            'userId': userEmail,
            'items': [itemsResponse.$id],
          },
        );
        log(cartResponse.$id, name: "cart response Id");
      } else {
        log('cart alredy exits');

        // Get the existing cart
        final cart = carts.documents.firstWhere((cart) => cart.$id == userId);

        // Check if the item already exists in the cart
        bool itemExists = false;
        for (var item in cart.data['items']) {
          if (item['productId'] == product.id.toString()) {
            itemExists = true;
            break;
          }
        }

        if (itemExists) {
          log('item alredy exits: incrementing quantity');

          // Increment the quantity of the item by 1
          final item = cart.data['items']
              .firstWhere((item) => item['productId'] == product.id.toString());
          final newQuantity = item['quantity'] + 1;
          await database.updateDocument(
            databaseId: DbHelper.orderMngmtDbId,
            collectionId: DbHelper.itemsCollectionId,
            documentId: item['\$id'],
            data: {
              'quantity': newQuantity,
            },
          );
        } else {
          log('item not alredy exits: adding new');

          // Create a new item in the 'items' collection
          final itemsResponse = await database.createDocument(
            databaseId: DbHelper.orderMngmtDbId,
            collectionId: DbHelper.itemsCollectionId,
            documentId: ID.unique(),
            data: {
              'productId': product.id.toString(),
              'productName': product.name,
              // 'price': double.parse(product.price ?? '0'),
              'price': 0.0, // '0.0' is a placeholder for 'product.price

              'quantity': 1,
              'productImage': product.images.isEmpty
                  ? "https://via.placeholder.com/150"
                  : product.images[0].src,
            },
          );

          log(itemsResponse.$id, name: "created item response Id");

          List exitingItems = [];
          for (var item in cart.data['items']) {
            exitingItems.add(item["\$id"]);
            log(item["\$id"].toString(), name: "already exiting cart ids");
          }
          exitingItems.add(itemsResponse.$id);

          // Update the existing cart by adding the new item to the 'items' array
          final updatedCartResponse = await database.updateDocument(
            databaseId: DbHelper.orderMngmtDbId,
            collectionId: DbHelper.cartCollectionId,
            documentId: userId,
            data: {
              'items': exitingItems,
            },
          );

          log(updatedCartResponse.$id, name: "updated cart response Id");
        }
      }

      await getCartLength();

      isAddtoCartLoading = false;
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
    }

    isAddtoCartLoading = false;
    notifyListeners();
  }

  int cartLength = 0;

  Future<int> getCartLength() async {
    final client = Client();
    client.setEndpoint(DbHelper.dbUrl);
    client.setProject(DbHelper.projectId);

    final account = Account(client);
    final user = await account.get();

    final database = Databases(client);
    final cartDocs = await database.listDocuments(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.cartCollectionId,
      queries: [
        Query.equal('userId', user.email),
      ],
    );

    if (cartDocs.documents.isNotEmpty) {
      final cartDoc = cartDocs.documents[0];
      final products = cartDoc.data['items'] as List<dynamic>? ?? [];
      cartLength = products.length;
      notifyListeners();
      log(products.length.toString(), name: "cart length");
      return products.length;
    } else {
      return 0;
    }
  }

  List productList = [];
  bool isGetCartItemsLoading = false;
  getCartItems() async {
    try {
      isGetCartItemsLoading = true;
      notifyListeners();
      final client = Client();
      client.setEndpoint(DbHelper.dbUrl);
      client.setProject(DbHelper.projectId);

      final account = Account(client);
      final user = await account.get();

      final database = Databases(client);
      final cartDocs = await database.listDocuments(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.cartCollectionId,
        queries: [
          Query.equal('userId', user.email),
        ],
      );

      if (cartDocs.documents.isNotEmpty) {
        final cartDoc = cartDocs.documents[0];
        productList = cartDoc.data['items'] as List<dynamic>? ?? [];
        log(productList.toString(), name: "cart items");
        isGetCartItemsLoading = false;
        notifyListeners();
        return productList;
      } else {
        productList.clear;
        isGetCartItemsLoading = false;
        notifyListeners();
        notifyListeners();
        return [];
      }
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
      isGetCartItemsLoading = false;
      notifyListeners();
    }
  }

// clear cart
  bool isClearCartLoading = false;
  void clearCart() {
    productList.clear();
    cartLength = 0;
    notifyListeners();
  }

  Future<void> increamentProductQuantity(
      int index, List<dynamic> products) async {
    try {
      products[index]['quantity']++;
      final client = Client(endPoint: DbHelper.dbUrl)
        ..setProject(DbHelper.projectId)
        ..setSelfSigned(status: true);
      final database = Databases(client);
      await database.updateDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.itemsCollectionId,
        documentId: products[index]["\$id"],
        data: {
          'quantity': products[index]['quantity'],
        },
      );
      notifyListeners();
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
    }
  }

  Future<void> decrementProductQuantity(
      int index, List<dynamic> products, context) async {
    if (products[index]['quantity'] > 1) {
      // Decrement the quantity if it's greater than 1
      products[index]['quantity']--;

      // Update the product in Appwrite
      try {
        final client = Client(endPoint: DbHelper.dbUrl)
          ..setProject(DbHelper.projectId)
          ..setSelfSigned(status: true);
        final database = Databases(client);
        await database.updateDocument(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.itemsCollectionId,
          documentId: products[index]["\$id"],
          data: {
            'quantity': products[index]['quantity'],
          },
        );
        notifyListeners();
      } on AppwriteException catch (e) {
        log(e.toString(), name: "error");
      }
    } else {
      // Prompt the user for deletion if the quantity is 1
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove item from cart?'),
            content: const Text(
                'Are you sure you want to remove this item from your cart?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Remove'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        // Delete the product from Appwrite
        try {
          final client = Client(endPoint: DbHelper.dbUrl)
            ..setProject(DbHelper.projectId)
            ..setSelfSigned(status: true);
          final database = Databases(client);
          await database.deleteDocument(
            databaseId: DbHelper.orderMngmtDbId,
            collectionId: DbHelper.itemsCollectionId,
            documentId: products[index]["\$id"],
          );
          products.removeAt(index);
          getCartLength();
          notifyListeners();
        } on AppwriteException catch (e) {
          log(e.toString(), name: "error");
        }
      }
    }
  }

  // removeProduct from cart
  Future<void> removeProduct(
    int index,
  ) async {
    try {
      final client = Client(endPoint: DbHelper.dbUrl)
        ..setProject(DbHelper.projectId)
        ..setSelfSigned(status: true);
      final database = Databases(client);
      await database.deleteDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.itemsCollectionId,
        documentId: productList[index]["\$id"],
      );
      productList.removeAt(index);
      getCartLength();
      notifyListeners();
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
    }
  }

  bool isCartLoading = false;
  Future<void> checkout(
      {required String deliveryAddrss,
      required String phoneNumber,
      required BuildContext context}) async {
    try {
      isCartLoading = true;
      notifyListeners();
      final client = Client();
      client.setEndpoint(DbHelper.dbUrl);
      client.setProject(DbHelper.projectId);

      final account = Account(client);
      final user = await account.get();
      final userId = user.$id;
      final userEmail = user.email;

      final database = Databases(client);

      // Get the cart document for the user
      final carts = await database.listDocuments(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.cartCollectionId,
        queries: [Query.equal('userId', userEmail)],
      );

      bool cartExists =
          carts.documents.where((cart) => cart.$id == userId).isNotEmpty;

      if (!cartExists) {
        log('cart not exits');
        isCartLoading = false;
        notifyListeners();
        return;
      } else {
        log('cart exits');
        final cart = carts.documents.firstWhere((cart) => cart.$id == userId);
        List allItemsId = [];
        for (var item in cart.data['items']) {
          allItemsId.add(item["\$id"]);
          log(item["\$id"].toString(), name: "All exiting cart ids");
        }

        // Create a new order in the 'orders' collection
        final orderResponse = await database.createDocument(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.ordersCollectionId,
          documentId: ID.unique(),
          data: {
            'userId': userEmail,
            'items': allItemsId,
            'status': 'Order-Placed',
            'shippingAddress': deliveryAddrss,
            'phoneNumber': phoneNumber,
            'paymentMethod': 'Cash on Delivery'
          },
        );

        log(orderResponse.$id, name: "order response Id");

        // Delete the cart
        await database.updateDocument(
            databaseId: DbHelper.orderMngmtDbId,
            collectionId: DbHelper.cartCollectionId,
            documentId: userId,
            data: {"items": []});

        // Clear the cart length
        clearCart();
        notifyListeners();

        // Update reward points
        await updateRewardPointOnOrder(context, allItemsId.length);
      }

      isCartLoading = false;
      notifyListeners();
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
      isCartLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRewardPointOnOrder(
      BuildContext context, int rewardPoint) async {
    final client = Client();
    client.setEndpoint(DbHelper.dbUrl);
    client.setProject(DbHelper.projectId);
    final database = Databases(client);

    final account = Account(client);
    final user = await account.get();

    // Fetch current reward points
    final response = await database.listDocuments(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.userCollectionId,
      queries: [Query.equal('userId', user.email)],
    );

    if (response.documents.isNotEmpty) {
      var currentRewardPoint =
          response.documents.first.data['rewardPoint'] ?? '0';
      currentRewardPoint = currentRewardPoint.toString();
      double currentPoints = double.tryParse(currentRewardPoint) ?? 0;

      // Add 2 points
      double updatedPoints = currentPoints + rewardPoint;

      // Update in the database
      await database.updateDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.userCollectionId,
        documentId: response.documents.first.data['\$id'],
        data: {
          'rewardPoint': updatedPoints.toStringAsFixed(2),
        },
      );
      AddressProvider addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.setRewardPoint = updatedPoints.toStringAsFixed(2);
      notifyListeners();
    }
  }

  // reduce 2 points on cancel order

  Future<void> reduceRewardPointOnOrder(BuildContext context) async {
    final client = Client();
    client.setEndpoint(DbHelper.dbUrl);
    client.setProject(DbHelper.projectId);
    final database = Databases(client);

    final account = Account(client);
    final user = await account.get();

    // Fetch current reward points
    final response = await database.listDocuments(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.userCollectionId,
      queries: [Query.equal('userId', user.email)],
    );

    if (response.documents.isNotEmpty) {
      var currentRewardPoint =
          response.documents.first.data['rewardPoint'] ?? '0';
      currentRewardPoint = currentRewardPoint.toString();
      double currentPoints = double.tryParse(currentRewardPoint) ?? 0;

      // Add 2 points
      double updatedPoints = currentPoints - 2;

      // Update in the database
      await database.updateDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.userCollectionId,
        documentId: response.documents.first.data['\$id'],
        data: {
          'rewardPoint': updatedPoints.toStringAsFixed(2),
        },
      );
      AddressProvider addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.setRewardPoint = updatedPoints.toStringAsFixed(2);
      notifyListeners();
    }
  }

  // get delviery date
  String getAproxDelvieryDat(String todaysDate) {
    DateTime createdDate = DateTime.parse(todaysDate);
    DateTime deliveryDate;

    deliveryDate = createdDate.add(const Duration(days: -4));

    return DateFormat('MMMM d, yyyy').format(deliveryDate);
  }
}
