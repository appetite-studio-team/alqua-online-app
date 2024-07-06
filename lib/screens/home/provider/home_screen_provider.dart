import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:souq_alqua/helper/db_helper.dart';
import 'package:souq_alqua/utils/api_support.dart';
import 'package:souq_alqua/screens/home/models/category_model.dart';
import 'package:souq_alqua/screens/home/models/products_model.dart';

String? firebaseUserNumber;

class HomeProvider extends ChangeNotifier {
  bool homeBannerLoading = false;

  List<Document> homeBannerList = [];

  Future<void> getHomeBanner() async {
    try {
      homeBannerLoading = true;
      notifyListeners();
      final client = Client()
          .setEndpoint(DbHelper.dbUrl)
          .setProject(DbHelper.projectId)
          .setSelfSigned(status: true);
      final database = Databases(client);
      final response = await database.listDocuments(
        databaseId: DbHelper.appMngmtDbId,
        collectionId: DbHelper.homeBannerCollectionId,
      );
      homeBannerList = response.documents;
      homeBannerLoading = false;
      log("Home Banner fetched successfully", name: "HomeProvider");
      notifyListeners();
    } on AppwriteException catch (e) {
      log(e.toString(), name: "error in getHomeBanner");
      homeBannerLoading = false;
      notifyListeners();
    }
  }

  // get image url from appwrite
  String getImageUrl({required String image}) =>
      '${DbHelper.dbUrl}/storage/buckets/${DbHelper.homeBannerBucketId}/files/$image/view?project=${DbHelper.projectId}';

  bool getAllCategoriesLoading = false;

  List<GetAllCategories> allCategories = [];

  Future<GetAllCategories?> getAllCategories(context) async {
    getAllCategoriesLoading = true;
    var url = Uri.parse(ApiSupport.baseUrl + ApiSupport.categories);
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${ApiSupport.consumerKey}:${ApiSupport.consumerSecret}'))}',
    };

    http.Response response = await http.get(url, headers: headers);

    log(url.toString());
    log(response.body);
    if (response.statusCode == 200) {
      List<GetAllCategories> categoryList = [];
      categoryList = getAllCategoriesFromJson(response.body);
      // filter categories with count > 0
      allCategories =
          categoryList.where((element) => element.count! > 0).toList();

      getAllCategoriesLoading = false;

      notifyListeners();
    } else {
      getAllCategoriesLoading = false;
      log('Request failed with status: ${response.statusCode}.');
      notifyListeners();
    }

    notifyListeners();

    return null;
  }

  /// Get all products
  bool getAllProductsLoading = false;

  List<GetAllProducts> allProducts = [];

  Future<GetAllProducts?> getAllProducts(context) async {
    getAllProductsLoading = true;
    var url = Uri.parse(ApiSupport.baseUrl + ApiSupport.products);
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${ApiSupport.consumerKey}:${ApiSupport.consumerSecret}'))}',
    };

    http.Response response = await http.get(url, headers: headers);

    log(url.toString());
    log(response.body);
    if (response.statusCode == 200) {
      allProducts = getAllProductsFromJson(response.body);
      getAllProductsLoading = false;

      notifyListeners();
    } else {
      getAllProductsLoading = false;
      log('Request failed with status: ${response.statusCode}.');
      notifyListeners();
    }

    notifyListeners();

    return null;
  }

  /// Get all products by category
  bool getAllProductsByCategoryLoading = false;

  List<GetAllProducts> allProductsByCategory = [];

  Future<GetAllProducts?> getAllProductsByCategory(int categoryId) async {
    getAllProductsByCategoryLoading = true;
    var url = Uri.parse(ApiSupport.baseUrl +
        ApiSupport.productsByCategory(categoryId: categoryId));
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${ApiSupport.consumerKey}:${ApiSupport.consumerSecret}'))}',
    };

    http.Response response = await http.get(url, headers: headers);

    log(url.toString());
    log(response.body);
    if (response.statusCode == 200) {
      allProductsByCategory = getAllProductsFromJson(response.body);
      getAllProductsByCategoryLoading = false;

      notifyListeners();
    } else {
      getAllProductsByCategoryLoading = false;
      log('Request failed with status: ${response.statusCode}.');
      notifyListeners();
    }

    notifyListeners();

    return null;
  }

  /// Search products
  bool searchProductsLoading = false;

  List<GetAllProducts> searchProductList = [];

  ///clear search list
  void clearSearchList() {
    searchProductList = [];
    notifyListeners();
  }

  Future<GetAllProducts?> searchProducts(String searchTxt) async {
    getAllProductsLoading = true;
    var url = Uri.parse(
        ApiSupport.baseUrl + ApiSupport.searchProduct(searchTxt: searchTxt));
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${ApiSupport.consumerKey}:${ApiSupport.consumerSecret}'))}',
    };

    http.Response response = await http.get(url, headers: headers);

    log(url.toString());
    log(response.body);
    if (response.statusCode == 200) {
      searchProductList = getAllProductsFromJson(response.body);
      getAllProductsLoading = false;

      notifyListeners();
    } else {
      getAllProductsLoading = false;
      log('Request failed with status: ${response.statusCode}.');
      notifyListeners();
    }

    notifyListeners();

    return null;
  }

  Future<int?> getTagIdBySlug(String slug) async {
    var url =
        Uri.parse(ApiSupport.baseUrl + ApiSupport.getTagIdBySlug(slug: slug));
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${ApiSupport.consumerKey}:${ApiSupport.consumerSecret}'))}',
    };
    final response = await http.get(
      url,
      headers: headers,
    );
    // log response
    log(response.body, name: 'getTagIdBySlug');

    if (response.statusCode == 200) {
      final List<dynamic> tags = json.decode(response.body);
      if (tags.isNotEmpty) {
        return tags[0]['id'];
      }
    }
    return null;
  }

  Future<List<GetAllProducts>> getProductsByTagId(int tagId) async {
    var url = Uri.parse(
        ApiSupport.baseUrl + ApiSupport.getProductsByTagId(tagId: tagId));
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${ApiSupport.consumerKey}:${ApiSupport.consumerSecret}'))}',
    };
    final response = await http.get(
      url,
      headers: headers,
    );
    log(response.body, name: 'getProductsByTagId');

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => GetAllProducts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  List<GetAllProducts> _topSellingProducts = [];
  bool _isTopSellingLoading = false;

  List<GetAllProducts> get topSellingProduct => _topSellingProducts;
  bool get isTopSellingLoading => _isTopSellingLoading;

  Future<void> fetchProductsByTagSlug(String slug) async {
    _isTopSellingLoading = true;
    notifyListeners();

    try {
      final int? tagId = await getTagIdBySlug(slug);
      if (tagId != null) {
        _topSellingProducts = await getProductsByTagId(tagId);
        notifyListeners();
      } else {
        _topSellingProducts = [];
      }
      notifyListeners();
    } catch (error) {
      _topSellingProducts = [];
      rethrow;
    } finally {
      _isTopSellingLoading = false;
      notifyListeners();
    }
  }

  Future<io.File> _downloadImage(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getTemporaryDirectory();
    final file = io.File('${documentDirectory.path}/$filename');
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  // share post with image
  Future<void> sharePostWithImage({
    required String title,
    required String description,
    required BuildContext context,
    required String imageUrl,
  }) async {
    final io.File imageFile = await _downloadImage(imageUrl, 'souq alqua.png');

    Share.shareXFiles(
      [XFile(imageFile.path)],
      text:
          "$title\n\n $description\n\nSouq Alqua: Alqua's own online market 📢\n\nDownload the app now\n https://play.google.com/store/apps/details?id=online.alqua.app\n\n",
    );
  }
}
