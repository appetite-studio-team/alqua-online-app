import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:souq_alqua/helper/db_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProvider extends ChangeNotifier {
  final Client _client;

  ServiceProvider(this._client);

  List<WorkersModel> _serviceWorkers = [];

  List<WorkersModel> get serviceWorkers => _serviceWorkers;

  bool fetchWorkersLoading = false;

  Future<void> fetchWorkers({required String serviceType}) async {
    try {
      fetchWorkersLoading = true;
      notifyListeners();
      final database = Databases(_client);
      final response = await database.listDocuments(
        databaseId: DbHelper.serviceMngmtDbId,
        collectionId: DbHelper.serviceCollectionId,
        queries: [Query.equal('service-type', serviceType)],
      );

      _serviceWorkers = response.documents.map((doc) {
        return WorkersModel(
          id: doc.data['\$id'],
          name: doc.data['name'],
          phoneNumber: doc.data['phoneNumber'] ?? "",
          service: doc.data['service'] ?? "",
          location: doc.data['location'] ?? "",
          serviceType: doc.data['service-type'],
        );
      }).toList();
      fetchWorkersLoading = false;
      notifyListeners();
    } on AppwriteException catch (e) {
      log(e.message.toString(), name: "error");
      log(e.toString(), name: "error");
      fetchWorkersLoading = false;
      notifyListeners();
    }
  }

  // launch phone urls for calling
  void launchPhoneUrls(String tel) async {
    Uri url = Uri(scheme: 'tel', path: tel);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchUrlMap(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  // need to add an activity creation in the appwrite before call the [launchPhoneUrls] method
  Future<void> createActivity({
    required String serviceProvider,
    required String serviceProviderPh,
    required String serviceType,
    required String activity,
  }) async {
    try {
      // account
      final account = Account(_client);
      final user = await account.get();
      String userId = user.email;
      final database = Databases(_client);
      final response = await database.createDocument(
        databaseId: DbHelper.serviceMngmtDbId,
        collectionId: DbHelper.serviceActivity,
        documentId: ID.unique(),
        data: {
          "user": userId,
          "service": serviceType,
          "service-provider": serviceProvider,
          "service-provider-ph": serviceProviderPh,
          "activity": activity,
        },
      );
      log(response.toString(), name: "activity");
    } on AppwriteException catch (e) {
      log(e.message.toString(), name: "error");
      log(e.toString(), name: "error");
    }
  }
}

class WorkersModel {
  String id;
  String name;
  String phoneNumber;
  String service;
  String location;
  String serviceType;

  WorkersModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.service,
    required this.location,
    required this.serviceType,
  });
}
