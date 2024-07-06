class ApiSupport {
  static String appVersion = "1.0.1";
  static String baseUrl = "https://alqua.online/wp-json/wc/v3/";
  static String consumerKey = "ck_4a4e25e4188bc381dddf7894d6bf720c64bd0991";
  static String consumerSecret = "cs_4259456986bc990635b7af798e5170958e7d930e";
  static String wpBaseUrl = "https://alqua.online//wp-json/wp/v2/";
  static const String networkImagePlaceHolder =
      "https://i.imgur.com/4qFGA5y.png";

  /// endpoint: products
  static String products = "products";
  static String categories = "products/categories?per_page=100";
  static String productsByCategory({required int categoryId}) {
    return "products?category=$categoryId";
  }

  static String searchProduct({required String searchTxt}) {
    return "products?search=$searchTxt";
  }

  static String getTagIdBySlug({required String slug}) {
    return 'products/tags?slug=$slug';
  }

  static String getProductsByTagId({required int tagId}) {
    return 'products?tag=$tagId';
  }

  // get all posts
  static String posts = "posts";

  // get specific
  static String tags = "tags";

  // get specific featured image
  static String getFeaturedImage({required int imageId}) {
    return 'media/$imageId';
  }
}
