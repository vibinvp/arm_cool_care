import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:arm_cool_care/BottomNavigation/screenpage.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/model/AddressModel.dart';
import 'package:arm_cool_care/model/BlogModel.dart';
import 'package:arm_cool_care/model/CategaryModal.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:arm_cool_care/model/CityName.dart';
import 'package:arm_cool_care/model/CoupanModel.dart';
import 'package:arm_cool_care/model/CustmerModel.dart';
import 'package:arm_cool_care/model/Gallerymodel.dart';
import 'package:arm_cool_care/model/GroupProducts.dart';
import 'package:arm_cool_care/model/InvoiceTrackmodel.dart';
import 'package:arm_cool_care/model/MyReviewModel.dart';
import 'package:arm_cool_care/model/RegisterModel.dart';
import 'package:arm_cool_care/model/TrackInvoiceModel.dart';
import 'package:arm_cool_care/model/Varient.dart';
import 'package:arm_cool_care/model/aminities_model.dart';
import 'package:arm_cool_care/model/banktransation.dart';
import 'package:arm_cool_care/model/cp_models.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:arm_cool_care/model/slidermodal.dart';

// abstract class ArticleRepository {
//   Future<List<Categary>> getArticles();
// }
//
// class ArticleRepositoryImpl implements ArticleRepository {
//   String link = Constant.base_url + "manage/api/p_category/all/?X-Api-Key=" +Constant.API_KEY +"&start=0&limit=20&field=shop_id&ield=shop_id&filter=" + Constant.Shop_id + "&parent=0&loc_id= ";
//   @override
//   Future<List<Categary>> getArticles() async {
//     var response = await http.get(link);
//     if (response.statusCode == 200) {
//       var responseData = json.decode(response.body);
//       List<dynamic> galleryArray = responseData["data"]["p_category"];
//       List<Categary> glist = Categary.getListFromJson(galleryArray);
//       return glist;
//     } else {
//       throw Exception();
//     }
//   }
//
// }

class DatabaseHelper {
  static Future<List<Categary>?> getData(String id) async {
    String link = Constant.base_url +
        "manage/api/p_category/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
        Constant.Shop_id +
        "&parent=" +
        id +
        "&loc_id=" +
        Constant.cityid +
        "&type=1";
    print(link);

    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["p_category"];
      List<Categary> list = Categary.getListFromJson(galleryArray);
      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Slider1>?> getSlider() async {
    String link = Constant.base_url +
        "manage/api/gallery/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=&field=shop_id&filter=" +
        Constant.Shop_id +
        "&place=appslide";
    print(" Slider link$link");
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      print(response.body.toString());
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Slider1> list = Slider1.getListFromJson(galleryArray);

      return list;
    }
  }

  static Future<AmenitiesModel?> getAmenities(String productId) async {
    print('productid--> $productId');
    final url = Constant.base_url +
        'manage/api/custom_fields_value/all/?X-Api-Key=${Constant.API_KEY}&shop_id=${Constant.Shop_id}&product_id=$productId';
    try {
      final response = await http.get(Uri.parse(url));
      print("getAmenities response.statusCode--> ${response.body}");
      print("getAmenities response.statusCode--> ${response.statusCode}");
      if (response.statusCode == 200) {
        AmenitiesModel amenitiesModel = AmenitiesModel();
        final result = json.decode(response.body);
        amenitiesModel = AmenitiesModel.fromJson(result);
        return amenitiesModel;
      }
    } catch (e) {
      log('getAmenities error--> $e');
    }
  }

  static Future<PromotionBanner?> getPromotionBanner(String shopId) async {
    var body = {"shop_id": Constant.Shop_id};

    const url = 'https://www.bigwelt.com/api/app-promo-banner.php';
    try {
      final response = await http.post(Uri.parse(url), body: body);

      print("getSlider response--> ${response.body}");
      print("getSlider response--> ${response.statusCode}");
      print("getSlider response--> ${json.decode(response.body)}");
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return PromotionBanner.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed to create album.');
      }
    } catch (e, s) {
      print('getSlider error --> e:-$e s:-$s');
    }
  }

  static Future<List<Products>?> getTopProduct(String dil, String lim) async {
    String link = Constant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&deals=" +
        dil +
        "&field=shop_id&filter=" +
        Constant.Shop_id +
        "&loc_id=" +
        Constant.cityid;
    log("$dil ....$link");

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      log(response.body.toString());
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getfeature(String dil, String lim) async {
    String link = Constant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&featured=yes&field=shop_id&filter=" +
        Constant.Shop_id +
        "&loc_id=" +
        Constant.cityid;
    print("$dil ....$link");

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Products>?> getTopProduct1(String dil, String lim) async {
    String link = Constant.base_url +
        "manage/api/products/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=" +
        lim +
        "&field=shop_id&filter=" +
        Constant.Shop_id +
        "&sort=DESC&loc_id=" +
        Constant.cityid;
    print("new..........$link");

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["products"];
      List<Products> list = Products.getListFromJson(galleryArray);

      return list;
    }
//    print("List Size: ${list.length}");
  }

  static Future<List<Gallery>?> getImage(String id) async {
    print("Future id$id");
    String link = Constant.base_url +
        "manage/api/gallery/all/?X-Api-Key=" +
        Constant.API_KEY +
        "&start=0&limit=10&place=" +
        id;
//print("Slider"+link);
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List<dynamic> galleryArray = responseData["data"]["gallery"];
      List<Gallery> glist = Gallery.getListFromJson(galleryArray);

      return glist;
    }
//    print("List Size: ${list.length}");
  }

//  Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=5000&cats=" + pcategoryid + "&field=shop_id&filter=" + Const.Shop_id+"&loc_id="
}

Future<List<Categary>?> getData(String id) async {
  String link = Constant.base_url +
      "manage/api/p_category/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=20&field=shop_id&ield=shop_id&filter=" +
      Constant.Shop_id +
      "&parent=" +
      id +
      "&loc_id=" +
      Constant.cityid +
      "&type=1";
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_category"];

    return Categary.getListFromJson(galleryArray);
  }
}

Future<List<Products>> catby_productData(String id, String lim) async {
  String link = Constant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=1000&cats=" +
      id +
      "&field=shop_id&filter=" +
      Constant.Shop_id +
      "&loc_only=" +
      "&type=1";

  print('linkcatpro   $link');
  final response = await http.get(Uri.parse(link));

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    // Ensure that Products.getListFromJson handles the case where galleryArray is null
    return Products.getListFromJson(galleryArray) ?? [];
  }

  // Handle other error cases if needed
  return []; // Return an empty list if there's an error
}

// Future<List<Products>?> catby_productData(String id, String lim) async {
//   String link = Constant.base_url +
//       "manage/api/products/all/?X-Api-Key=" +
//       Constant.API_KEY +
//       "&start=0&limit=1000&cats=" +
//       id +
//       "&field=shop_id&filter=" +
//       Constant.Shop_id +
//       "&loc_only=" +
//       "&type=1";

//   print('linkcatpro   $link');
//   final response = await http.get(Uri.parse(link));
//   if (response.statusCode == 200) {
//     var responseData = json.decode(response.body);
//     List<dynamic> galleryArray = responseData["data"]["products"];

//     return Products.getListFromJson(galleryArray);
//   }
//   return null;
// }

Future<List<TrackInvoice>?> trackInvoice(String mobile) async {
  String link = Constant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&field=client_id&is_service=1&filter=" +
      mobile;
  print("invoicelink---->$link");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    log(response.body.toString());
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];

    return TrackInvoice.getListFromJson(galleryArray);
  }
}

Future<List<TrackInvoice>?> trackOrder(String mobile) async {
  String link = Constant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&field=client_id&is_service=0&filter=" +
      mobile;
  print("invoicelink---->$link");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    log(response.body.toString());
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];

    return TrackInvoice.getListFromJson(galleryArray);
  }
}

Future<List<InvoiceInvoice>?> trackInvoiceOrder(String invoice) async {
  String link = Constant.base_url +
      "manage/api/invoice_details/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&field=invoice_id&filter=" +
      invoice;
  print("invOrderLink----->$link");
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    log(response.body.toString());
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoice_details"];

    return InvoiceInvoice.getListFromJson(galleryArray);
  }
}

Future<CpDetails?> getCpDetails() async {
  String link = Constant.base_url + "api/cp.php?shop_id=${Constant.Shop_id}";
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    log(response.body.toString());
    var responseData = json.decode(response.body);
    return CpDetails.fromJson(responseData);
  }
}

Future updateAny(String table, String field, String value) async {
  print(field);
  print(value);
  var map = <String, dynamic>{};
  map['Api_key'] = Constant.API_KEY;
  map['shop_id'] = Constant.Shop_id;
  map['table'] = table;
  map['id_name'] = "user_id";
  map['id_no'] = Constant.user_id;
  map['field'] = field;
  map['value'] = value;
  String link = Constant.base_url + "api/upany";
  // print(link);
  // print(map.toString());
  final response = await http.post(Uri.parse(link), body: map);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));
    if (user.success == "true") showLongToast(user.message);
  }
}

Future<List<Products>?> productdetail(String id) async {
  String link = Constant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=10&field=shop_id&filter=" +
      Constant.Shop_id +
      "&id=" +
      id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
  }
}

Future<List<TrackInvoice>?> trackInvoice1(String mobile) async {
  String link = Constant.base_url +
      "manage/api/invoices/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=1&field=client_id&filter=" +
      mobile;
  print(link);

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["invoices"];
    List<TrackInvoice> list = TrackInvoice.getListFromJson(galleryArray);
    print(list.length);

    return list;
  }
}

Future<List<WalletUser>> get_walletrecord(String val, int lim) async {
  String link = Constant.base_url +
      "manage/api/wallet_user/all?X-Api-Key=" +
      Constant.API_KEY +
      "&start=" +
      lim.toString() +
      "&limit=10&w_user=" +
      val;
  print("This is sub link $link");
  final response = await http.get(Uri.parse(link));

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(response);
    List<dynamic>? galleryArray = responseData["data"]["wallet_user"];

    if (galleryArray != null) {
      List<WalletUser> list = WalletUser.getListFromJson(galleryArray);
      return list;
    } else {
      // Handle the case where galleryArray is null
      return []; // or throw an exception, depending on your use case
    }
  } else {
    // Handle the case where the response status code is not 200
    return []; // or throw an exception, depending on your use case
  }
}

// Future<List<WalletUser>?> get_walletrecord(String val, int lim) async {
//   String link = Constant.base_url +
//       "manage/api/wallet_user/all?X-Api-Key=" +
//       Constant.API_KEY +
//       "&start=" +
//       lim.toString() +
//       "&limit=10&w_user=" +
//       val;
//   print("This is  sub link$link");
//   final response = await http.get(Uri.parse(link));
//   if (response.statusCode == 200) {
//     var responseData = json.decode(response.body);
//     print(response);
//     List<dynamic> galleryArray = responseData["data"]["wallet_user"];
//     List<WalletUser> list = WalletUser.getListFromJson(galleryArray);

//     return list;
//   }
// }

Future<List<CustmerModel>?> mywallet(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = Constant.base_url +
      "manage/api/customers/all?X-Api-Key=" +
      Constant.API_KEY +
      "&user_id=" +
      userid +
      "&shop_id=" +
      Constant.Shop_id;
  print("wallet link---->$link");
  final response = await http.get(Uri.parse(link));
  print("response----->${response.body}");
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["customers"];

    return CustmerModel.getListFromJson(galleryArray);
  }
}

Future<List<Products>?> search(String query) async {
  String link = Constant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=10&field=shop_id&filter=" +
      Constant.Shop_id +
      "&id=";
  print("Serch  $link");

  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
  }
}

Future<List<Review>?> myReview(String userid) async {
  print(userid);
//  String link = "http://www.sanjarcreation.com/manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=2345&field=shop_id&filter=49" ;
  String link = Constant.base_url +
      "manage/api/reviews/all?X-Api-Key=9C03CAEC0A143D345578448E263AF8A6&user_id=" +
      userid +
      "&field=shop_id&filter=" +
      Constant.Shop_id;
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
//    print(responseData.toString());
    List<dynamic> galleryArray = responseData["data"]["reviews"];

    return Review.getListFromJson(galleryArray);
  }
}

Future<List<GroupProducts>?> GroupPro(String userid) async {
  String link = "https://www.bigwelt.com/api/pg.php?id=$userid&shop_id=" +
      Constant.Shop_id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData;
//    GroupProducts  groupProducts= GroupProducts.fromMap(json.decode(response.body));
////    List<dynamic> galleryArray = responseData["data"]["reviews"];
//    print(galleryArray.toString()+"Gallery");
    return GroupProducts.getListFromJson(galleryArray);
  }
}

Future<List<Products>?> searchval(String query) async {
  String link = Constant.base_url +
      "manage/api/products/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=50&field=shop_id&filter=" +
      Constant.Shop_id +
      "&q=" +
      query +
      "&user_id=" +
      Constant.User_ID +
      "&id=";
  print(link);
  List<dynamic> galleryArray;
  final date2 = DateTime.now();
//  String md5=Constant.Shop_id+date2.day.toString()+date2.month.toString()+date2.year.toString();
  String md5 = Constant.Shop_id + DateFormat("dd-MM-yyyy").format(date2);

  print(md5);
//  searchdatasave(query);
  generateMd5(md5, query);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    galleryArray = responseData["data"]["products"];

    return Products.getListFromJson(galleryArray);
  }
}

searchdatasave(String query, String md5) async {
  String link = Constant.base_url +
      "api/search.php?shop_id=" +
      Constant.Shop_id +
      "&user_id=" +
      Constant.User_ID +
      "&q=" +
      query +
      "&key=" +
      md5;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
//      var responseData = json.decode(response.body);
  }
}

void generateMd5(String input, String q) {
  String key = md5.convert(utf8.encode(input)).toString();
  searchdatasave(q, key);
  print(key);
}

Future<List<Slider1>?> getBanner() async {
  String link = Constant.base_url +
      "manage/api/gallery/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=&field=shop_id&filter=" +
      Constant.Shop_id +
      "&place=appbanner";
  print('banner link---->$link');
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["gallery"];
    List<Slider1> list = Slider1.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<UserAddress>?> getAddress() async {
  String link = Constant.base_url +
      "manage/api/user_address/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=&shop_id=" +
      Constant.Shop_id +
      "&user_id=" +
      Constant.user_id;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["user_address"];
//    List<UserAddress> list =

    return UserAddress.getListFromJson(galleryArray);
  }
//    print("List Size: ${list.length}");
}

Future<Coupan?> getCoupan(String code) async {
  String link = Constant.base_url +
      "manage/api/coupon_codes/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&shop_id=" +
      Constant.Shop_id +
      "&code=" +
      code;
//      Constant.base_url + "manage/api/coupon_codes/all/?X-Api-Key=" +
//      Constant.API_KEY + "shop_id=" + Constant.Shop_id +"code="+code;
  print(link);
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    print(responseData);
    Coupan coupan = Coupan.fromMap(json.decode(response.body));
    return coupan;
  }
//    print("List Size: ${list.length}");
}

Future<List<PVariant>?> getPvarient(String id) async {
  String link = Constant.base_url +
      "manage/api/p_variant/all/?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=100&pid=" +
      id;
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["p_variant"];
    List<PVariant> list = PVariant.getListFromJson(galleryArray);

    return list;
  }
}

Future<List<CityName>?> getPcity() async {
  log("called getpCity");
  String link = Constant.base_url +
      'manage/api/mv_delivery_locations/all/?X-Api-Key=' +
      Constant.API_KEY +
      '&field=shop_id&filter=' +
      Constant.Shop_id;
  log("locton link-------------${link.toString()}");
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    log("response citys------>${response.body.toString()}");
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["mv_delivery_locations"];
    List<CityName> list = CityName.getListFromJson(galleryArray);

    return list;
  }
}

Future deleteAccount(String table, String field, String value) async {
  print(field);
  print(value);
  var map = <String, dynamic>{};
  map['Api_key'] = Constant.API_KEY;
  map['shop_id'] = Constant.Shop_id;
  map['table'] = table;
  map['id_name'] = "user_id";
  map['id_no'] = Constant.user_id;
  map['field'] = field;
  map['value'] = value;
  print("map--------->$map");
  String link = Constant.base_url + "api/upany";
  print(link);
  print(map.toString());
  final response = await http.post(Uri.parse(link), body: map);
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));
    if (user.success == "true") {
      showLongToast("Account Deleted Successfully...");
    }
  }
}

//    print("List Size: ${list.length}");

Future<List<BlogModel>?> getfeature(String dil, String lim) async {
  String link = Constant.base_url +
      "manage/api/manage_pages/all?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=" +
      lim +
      "&wht=blog&shop_id=" +
      Constant.Shop_id +
      "&place=publish&type=";
  print("$dil ....$link");

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["manage_pages"];
    List<BlogModel> list = BlogModel.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}

Future<List<BlogModel>?> searchBlogs(String q, String lim) async {
  String link = Constant.base_url +
      "manage/api/manage_pages/all?X-Api-Key=" +
      Constant.API_KEY +
      "&start=0&limit=" +
      lim +
      "&wht=blog&shop_id=" +
      Constant.Shop_id +
      "&place=publish&type=&q=" +
      q;
  print("$q ....$link");

//    Const.Base_Url + "manage/api/products/all/?X-Api-Key=" + Const.API_KEY + "&start=0&limit=4&field=shop_id&filter=" + Const.Shop_id + "&sort=DESC&loc_id=" + HomePage.loc_id,
  final response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<dynamic> galleryArray = responseData["data"]["manage_pages"];
    List<BlogModel> list = BlogModel.getListFromJson(galleryArray);

    return list;
  }
//    print("List Size: ${list.length}");
}
