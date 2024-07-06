import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:souq_alqua/helper/db_helper.dart';

class AddressProvider extends ChangeNotifier {
  final Client _client;

  AddressProvider(this._client);

  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  String? userEmailId;

  Future<void> fetchUserEmail() async {
    final client = Client();
    client.setEndpoint(DbHelper.dbUrl);
    client.setProject(DbHelper.projectId);
    final account = Account(client);
    final user = await account.get();
    final userEmail = user.email;
    userEmailId = userEmail;
    log(userEmailId.toString(), name: "userEmailId");
    if (userEmailId != null) {
      fetchCountries();
      // fetchRewardPoint();
    }
    notifyListeners();
  }

  Future<void> fetchAddresses() async {
    try {
      final account = Account(_client);
      final user = await account.get();
      final userEmail = user.email;
      final database = Databases(_client);
      final response = await database.listDocuments(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.addressCollectionId,
        queries: [Query.equal('userId', userEmail)],
      );

      _addresses = response.documents.map((doc) {
        return Address(
          id: doc.data['\$id'],
          userId: doc.data['userId'] ?? '',
          addressName: doc.data['addressName'] ?? '',
          street: doc.data['street'] ?? '',
          city: doc.data['city'] ?? '',
          phoneNumber: doc.data['phoneNumber'] ?? '',
          doorNo: doc.data['doorNo'] ?? '',
          isDefault: doc.data['isDefault'] ?? false,
        );
      }).toList();
      notifyListeners();
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
    }
  }

  // get the default address of the user if it exists
  Address? get defaultAddress {
    final defaultAddresses =
        _addresses.where((addr) => addr.isDefault).toList();
    if (defaultAddresses.isNotEmpty) {
      return defaultAddresses.first;
    }
    return null;
  }

  Future<void> createAddress(Address address) async {
    final database = Databases(_client);

    // Set isDefault to true for the newly created address
    address.isDefault = true;

    // First, update the existing default address to false
    final defaultAddresses =
        _addresses.where((addr) => addr.isDefault).toList();
    for (final addr in defaultAddresses) {
      addr.isDefault = false;
      await updateAddress(addr);
    }

    // Then, create the new address
    await database.createDocument(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.addressCollectionId,
      documentId: ID.unique(),
      data: {
        'userId': address.userId,
        'addressName': address.addressName,
        'street': address.street,
        'city': address.city,
        'doorNo': address.doorNo, // Added door number field
        'phoneNumber': address.phoneNumber, // Added phone number field
        'isDefault': address.isDefault,
      },
    );

    // Refresh addresses after creating a new one
    await fetchAddresses();
  }

  // update the address
  Future<void> updateAddress(Address address) async {
    final database = Databases(_client);

    await database.updateDocument(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.addressCollectionId,
      documentId: address.id,
      data: {
        'addressName': address.addressName,
        'street': address.street,
        'city': address.city,
        'doorNo': address.doorNo, // Added door number field
        'phoneNumber': address.phoneNumber, // Added phone number field
        'isDefault': address.isDefault,
      },
    );

    // Refresh addresses after updating one
    await fetchAddresses();
  }

  /// Update the default address
  Future<void> updateDefaultAddress(String userId, String addressId) async {
    final database = Databases(_client);

    // Get the current default address
    final response = await database.listDocuments(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.addressCollectionId,
      queries: [
        Query.equal('userId', userId),
        Query.equal('isDefault', true),
      ],
    );

    // Update the current default address
    if (response.documents.isNotEmpty) {
      await database.updateDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.addressCollectionId,
        documentId: response.documents.first.data['\$id'],
        data: {
          'isDefault': false,
        },
      );
    }

    // Update the new default address
    await database.updateDocument(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.addressCollectionId,
      documentId: addressId,
      data: {
        'isDefault': true,
      },
    );

    // Refresh addresses after updating the default address
    await fetchAddresses();
  }

  Future<void> deleteAddress(String addressId) async {
    final database = Databases(_client);

    // Check if the address being deleted is the default address
    final addressIndex = _addresses.indexWhere((addr) => addr.id == addressId);
    final isDefault = addressIndex != -1 && _addresses[addressIndex].isDefault;

    await database.deleteDocument(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.addressCollectionId,
      documentId: addressId,
    );

    // Refresh addresses after deleting one
    await fetchAddresses();

    // If the deleted address was the default one and there are other addresses available
    if (isDefault && _addresses.isNotEmpty) {
      // Set the first available address as the new default
      _addresses[0].isDefault = true;
      await updateAddress(_addresses[0]);
    }
  }

  String? userSelectedCountry;

  /// COuntry fns
  Future<List<CountryModel>> fetchCountries() async {
    final client = Client();
    client.setEndpoint(DbHelper.dbUrl);
    client.setProject(DbHelper.projectId);
    final database = Databases(client);

    final response = await database.listDocuments(
      databaseId: DbHelper.orderMngmtDbId,
      collectionId: DbHelper.userCollectionId,
      queries: [Query.equal('userId', userEmailId)],
    );
    //log the response
    log(response.toString(), name: "response");

    // If no country exists for the user, create a default country entry (UAE)
    if (response.documents.isEmpty) {
      await database.createDocument(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.userCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userEmailId,
          'countryName': 'UAE 🇦🇪',
        },
      );

      // Return UAE as the default country
      return [
        CountryModel(
          countryName: 'UAE 🇦🇪',
          userId: userEmailId!,
          id: ID.unique(),
        )
      ];
    }

    // If country entries exist, return them
    return response.documents.map((doc) {
      userSelectedCountry = doc.data['countryName'];
      notifyListeners();
      return CountryModel(
        countryName: doc.data['countryName'],
        userId: doc.data['userId'],
        id: doc.data['\$id'],
      );
    }).toList();
  }

  // String? rewardPoint;
  // set setRewardPoint(String? value) {
  //   rewardPoint = value;
  //   notifyListeners();
  // }

  // Future<void> fetchRewardPoint() async {
  //   final client = Client();
  //   client.setEndpoint(DbHelper.dbUrl);
  //   client.setProject(DbHelper.projectId);
  //   final database = Databases(client);

  //   final response = await database.listDocuments(
  //     databaseId: DbHelper.orderMngmtDbId,
  //     collectionId: DbHelper.userCollectionId,
  //     queries: [Query.equal('userId', userEmailId)],
  //   );

  //   if (response.documents.isNotEmpty) {
  //     rewardPoint = response.documents.first.data['rewardPoint'];
  //     if (rewardPoint != null) {
  //       rewardPoint = rewardPoint.toString();
  //       log(rewardPoint.toString(), name: "rewardPoint found");
  //       notifyListeners();
  //     } else {
  //       rewardPoint = '0';
  //       // Update the reward point to 0
  //       await database.updateDocument(
  //         databaseId: DbHelper.orderMngmtDbId,
  //         collectionId: DbHelper.userCollectionId,
  //         documentId: response.documents.first.data['\$id'],
  //         data: {
  //           'rewardPoint': "0.00",
  //         },
  //       );
  //       log("No reward point found", name: "rewardPoint");
  //       notifyListeners();
  //     }
  //   } else {
  //     rewardPoint = '0.00';
  //   }

  //   notifyListeners();
  // }

  Future<void> selectOrUpdateCountry(String countryName) async {
    try {
      final client = Client();
      client.setEndpoint(DbHelper.dbUrl);
      client.setProject(DbHelper.projectId);
      final database = Databases(client);

      // Check if the country already exists for the provided userId
      final response = await database.listDocuments(
        databaseId: DbHelper.orderMngmtDbId,
        collectionId: DbHelper.userCollectionId,
        queries: [
          Query.equal('userId', userEmailId),
        ],
      );

      if (response.documents.isNotEmpty) {
        // Update the existing country
        await database.updateDocument(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.userCollectionId,
          documentId: response.documents.first.data['\$id'],
          data: {
            'countryName': countryName,
          },
        );
      } else {
        // Create a new country
        await database.createDocument(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.userCollectionId,
          documentId: ID.unique(),
          data: {
            'userId': userEmailId,
            'countryName': countryName,
          },
        );
      }
      fetchCountries();
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error");
    }
  }
}

class Address {
  String id;
  String userId; // User email
  String addressName;
  String street;
  String city;
  String phoneNumber;
  String doorNo;
  bool isDefault;

  Address({
    required this.id,
    required this.userId,
    required this.addressName,
    required this.street,
    required this.city,
    required this.phoneNumber,
    required this.doorNo,
    required this.isDefault,
  });
}

class CountryModel {
  String id;
  String userId; // User email
  String countryName;

  CountryModel({
    required this.id,
    required this.userId,
    required this.countryName,
  });
}
