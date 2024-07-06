import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/db_helper.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProvider extends ChangeNotifier {
  List<WorkersModel> _serviceWorkers = [];

  List<WorkersModel> get serviceWorkers => _serviceWorkers;

  bool fetchWorkersLoading = false;

  Future<void> fetchWorkers({required String serviceType}) async {
    try {
      final client = Client();
      client.setEndpoint(DbHelper.dbUrl);
      client.setProject(DbHelper.projectId);
      fetchWorkersLoading = true;
      notifyListeners();
      final database = Databases(client);
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
    required BuildContext context,
  }) async {
    try {
      final client = Client();
      client.setEndpoint(DbHelper.dbUrl);
      client.setProject(DbHelper.projectId);
      LoginProvider loginProvider =
          Provider.of<LoginProvider>(context, listen: false);
      if (loginProvider.isGuestLogin) {
        final database = Databases(client);
        final response = await database.createDocument(
          databaseId: DbHelper.serviceMngmtDbId,
          collectionId: DbHelper.serviceActivity,
          documentId: ID.unique(),
          data: {
            "user": 'Guest',
            "service": serviceType,
            "service-provider": serviceProvider,
            "service-provider-ph": serviceProviderPh,
            "activity": activity,
          },
        );
        log('Guest Activity created', name: "activity");
        log(response.toString(), name: "activity");
      } else {
        // account
        final account = Account(client);
        final user = await account.get();
        String userId = user.email;
        final database = Databases(client);
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
      }
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
