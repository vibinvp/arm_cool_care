import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/Web/WebviewTermandCondition.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/CategaryModal.dart';
import 'package:arm_cool_care/model/Gallerymodel.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:arm_cool_care/model/slidermodal.dart';
import 'package:arm_cool_care/screen/SearchScreen.dart';
import 'package:arm_cool_care/screen/SubCategry.dart';
import 'package:arm_cool_care/screen/detailpage.dart';
import 'package:arm_cool_care/screen/detailpage1.dart';
import 'package:arm_cool_care/screen/productlist.dart';
import 'package:arm_cool_care/screen/secondtabview.dart';
import 'package:url_launcher/url_launcher.dart';

Future<PromotionBanner> createAlbum(String shopId) async {
  var body = {"shop_id": Constant.Shop_id};
  final response = await http.post(
      Uri.parse('https://www.bigwelt.com/api/app-promo-banner.php'),
      body: body);
  log("response------>${response.body}");

  print("jsonDecode(response.body)---> ${jsonDecode(response.body)}");
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    log(response.body.toString());
    return PromotionBanner.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class PromotionBanner {
  String? shopId;
  String? images;
  bool? status;
  String? msg;
  String? path;

  PromotionBanner(
      {required this.shopId,
      required this.images,
      required this.status,
      required this.msg,
      required this.path});

  PromotionBanner.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    images = json['images'];
    status = json['status'];
    msg = json['msg'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shop_id'] = shopId;
    data['images'] = images;
    data['status'] = status;
    data['msg'] = msg;
    data['path'] = path;
    return data;
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  static int cartvalue = 0;

  bool progressbar = true;

  static List<String> imgList5 = [
    'https://www.liveabout.com/thmb/y4jjlx2A6PVw_QYG4un_xJSFGBQ=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/asos-plus-size-maxi-dress-56e73ba73df78c5ba05773ab.jpg',
    'https://www.thebalanceeveryday.com/thmb/lMeVfLyCZWVPdU5eyjFLyK4AYQs=/400x250/filters:no_upscale():max_bytes(150000):strip_icc()/metrostyle-catalog-df95d1ece06c4197b1da85e316a05f90.jpg',
    'https://rukminim1.flixcart.com/image/400/450/k3xcdjk0pkrrdj/sari/h/d/x/free-multicolor-combosr-28001-ishin-combosr-28001-original-imafa5257bxdzm5j.jpeg?q=90',
    'https://i.pinimg.com/474x/62/4e/ce/624ece8daf9650f1a382995b340dc1e9.jpg'
  ];

  final int _current = 0;
  final _start = 0;
  static List<Categary> list = <Categary>[];
  static List<Categary> list1 = <Categary>[];
  static List<Categary> list2 = <Categary>[];
  static List<Slider1> sliderlist = [];

  static List<Products> topProducts = [];
  static List<Products> topProducts1 = [];
  static List<Products> bestProducts = [];
  static List<Products> dilofdayProducts = [];
  static List<Slider1> bannerSlider = [];
  List<Gallery> galiryImage = [];
  final List<String> imgL = [];
  List<Products> products1 = [];
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  PromotionBanner promotionBanner =
      PromotionBanner(shopId: '', images: '', status: null, msg: '', path: '');
  String imageUrl = '';
  List reverseList = [];

  double? mrp, totalmrp = 000;
  final int _count = 1;

  // PackageInfo packageInfo ;
  // AppUpdateInfo _updateInfo;
  String lastversion = "0";
  int? valcgeck;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  /* Future<void> checkForUpdate(BuildContext contex) async {
    packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    lastversion=version.substring(version.lastIndexOf(".")+1);

    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        valcgeck=int.parse(lastversion);
        _updateInfo = info;
        if(_updateInfo?.updateAvailable){
          Showpop();
        }
        _updateInfo?.updateAvailable == true;
        print(_updateInfo);
        print(version);
        print(_updateInfo.availableVersionCode-valcgeck);
        print(lastversion);
        print("_updateInfo.......");

//        showDilogue(contex);
        print(_updateInfo);
      });
    }).catchError((e) => _showError(e));
  }*/

  getPackageInfo() async {
    // NewVersion newVersion = NewVersion(context: context);
    // final status = await newVersion.getVersionStatus();
    // // status.canUpdate; // (true)
    // // status.localVersion ;// (1.2.1)
    // // status.storeVersion; // (1.2.3)
    // // status.appStoreLink;
    // newVersion.showAlertIfNecessary();
    // // print(status.canUpdate);
    // // print(status.localVersion);
    // // print(status.storeVersion);
    // // print(status.appStoreLink);
  }

  final addController = TextEditingController();

  Position? position;

  getAddress(double lat, double long) async {
    // final coordinates = Coordinates(lat, long);
    var addresses = await placemarkFromCoordinates(lat, long);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.locality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
      // print('Rahul ${address}');
      // pref.setString("lat", lat.toString());
      // pref.setString("lat", lat.toString());
      // pref.setString("add", address.toString().replaceAll("null", ""));
    });
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position!.latitude;
      Constant.longitude = position!.longitude;
      print(' lat ${Constant.latitude},${Constant.longitude}');
      getAddress(Constant.latitude, Constant.longitude);
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();

    if (Constant.Checkupdate) {
      getPackageInfo();
      Constant.Checkupdate = false;
    }
    // checkForUpdate(context);

    DatabaseHelper.getData("0").then((usersFromServe) {
      if (mounted) {
        setState(() {
          list = usersFromServe!;
        });
      }
    });

    DatabaseHelper.getSlider().then((usersFromServe1) {
      if (mounted) {
        setState(() {
          sliderlist = usersFromServe1!;
        });
      }
    });

    DatabaseHelper.getPromotionBanner(Constant.Shop_id).then((value) {
      if (mounted) {
        print("valueee--> ${value!.path}");
        promotionBanner = value;
        imageUrl = value.path!;
        setState(() {});
      }
      print("my url--------->");
      // print(Constant.mainurl + promotionBanner.path + promotionBanner.images);
      var url = Constant.mainurl +
          promotionBanner.path.toString() +
          promotionBanner.images.toString();
    });
    DatabaseHelper.getTopProduct("top", "0").then((usersFromServe) {
      if (mounted) {
        setState(() {
          ScreenState.topProducts = usersFromServe!;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    DatabaseHelper.getTopProduct("day", "0").then((usersFromServe) {
      if (mounted) {
        setState(() {
          ScreenState.topProducts1 = usersFromServe!;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });

    DatabaseHelper.getTopProduct("best", "0").then((usersFromServe) {
      if (mounted) {
        setState(() {
          ScreenState.bestProducts = usersFromServe!;
        });
      }
    });

    DatabaseHelper.getfeature("yes", "10").then((usersFromServe) {
      if (mounted) {
        setState(() {
          products1 = usersFromServe!;
//          ScreenState.topProducts.add(topProducts[0]);
        });
      }
    });
    getBanner().then((usersFromServe) {
      if (mounted) {
        setState(() {
          bannerSlider = usersFromServe!;
          print("banner------>${bannerSlider.length}");
        });
      }
    });

//    search
    DatabaseHelper.getTopProduct1("new", "0").then((usersFromServe) {
      if (mounted) {
        setState(() {
          ScreenState.dilofdayProducts = usersFromServe!;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    reverseList = dilofdayProducts.reversed.toList();

//    showDilogue(context);
    return Container(
        color: AppColors.white,
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: AppColors.tela,
                    child: GestureDetector(
                      onTap: () {
                        _getCurrentLocation();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => UserFilterDemo()),
                        // );
                      },
                      child: Card(
                        color: AppColors.tela,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0.0,
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 0, bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Material(
                              color: Colors.white,
                              elevation: 0.0,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserFilterDemo()),
                                    );
                                  },
                                  child: TextField(
                                    enabled: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(4),
                                        hintText: "Search Services",
                                        hintStyle: const TextStyle(
                                            fontSize: 12.0, color: Colors.grey),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.black,
                                          size: 20,
                                        )),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  sliderlist != null
                      ? sliderlist.isNotEmpty
                          ? Container(
                              color: AppColors.white,
                              height: 190.0,
                              width: MediaQuery.of(context).size.width,
                              child: sliderlist != null
                                  ? sliderlist.isNotEmpty
                                      ? CarouselSlider.builder(
                                          itemCount: sliderlist.length,
                                          options: CarouselOptions(
                                            aspectRatio: 2.4,
                                            viewportFraction: 0.96,
                                            enlargeCenterPage: true,
                                            autoPlay: true,
                                          ),
                                          itemBuilder: (ctx, index, realIdx) {
                                            return Container(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!sliderlist[index]
                                                      .title!
                                                      .isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Screen2(
                                                                  sliderlist[
                                                                          index]
                                                                      .title
                                                                      .toString(),
                                                                  "")),
                                                    );
                                                  } else if (!sliderlist[index]
                                                      .description!
                                                      .isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails1(
                                                                  sliderlist[
                                                                          index]
                                                                      .description
                                                                      .toString())),
                                                    );
//
                                                  }
                                                },
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 2.0,
                                                            right: 2),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        child:
                                                            CachedNetworkImage(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.fill,
                                                          imageUrl: Constant
                                                                  .Base_Imageurl +
                                                              sliderlist[index]
                                                                  .img
                                                                  .toString(),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ))),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColors.tela,
                                          ),
                                        )
                                  : const Row())
                          : Container()
                      : Container(),

                  /*   Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all( 10) ,


                            decoration: new BoxDecoration(
//                              color: AppColors.white,
                       border:Border.all(
                           color: Colors.green
                       ),

                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:  AssetImage("assets/images/banner2.jpeg"),
                            ),
                           borderRadius: BorderRadius.circular(10),


                              color: Colors.white,
                            ),

                          ),*/

                  /*list!=null?list.length>0? Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Text("Shop By Categories",
                                    style: TextStyle(
                                        color: AppColors.product_title_name,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                              ],
                            ),
                          ):Container():Container(),*/
                  /* list!=null? Container(
                            color: Color(0xFFf2f2f2),
//                    margin: EdgeInsets.symmetric(vertical: 8.0),
                            height: 170.0,

                            child: list!=null?list.length != null ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length == null ? 0 : list
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(


                                    margin: EdgeInsets.symmetric(horizontal: 5),

                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          // color: AppColors.black,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),),
                                          child: Material(
                                            color: AppColors.white,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Sbcategory(list[index].pCats, list[index].pcatId)),);

                                              },
                                              child: Container(
                                                height: 150.0,
                                                width: 150.0,
                                                decoration: new BoxDecoration(

                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        image:list[index].img.isEmpty? AssetImage("assets/images/logo.png",):NetworkImage(
                                                            Constant.base_url +
                                                                "manage/uploads/p_category/" +
                                                                list[index].img),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                                child: Container(
//
                                                  decoration: BoxDecoration(
                                                    // color: AppColors.tela1,
                                                    borderRadius: BorderRadius
                                                        .circular(10),


                                                  ),
                                                  child: Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Container(
                                                        alignment:Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: AppColors.tela,
                                                          borderRadius: BorderRadius.only(
                                                              bottomRight: Radius.circular(10.0),
                                                              bottomLeft: Radius.circular(10.0)),
                                                        ),
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 28,
                                                        child: Text(
                                                          list[index].pCats,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 12),
                                                        ),
                                                      )


                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),



                                      ],
                                    )

                                );
                              },) : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: AppColors.tela,
                              ),
                            ):Container(),



                          ):Row(),*/

                  list != null
                      ? list.isNotEmpty
                          ? Container(
                              color: AppColors.white,
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0,
                                        left: 8.0,
                                        right: 8.0,
                                        bottom: 8.0),
                                    child: Text(
                                      " Find Service",
                                      style: TextStyle(
                                          color: AppColors.product_title_name,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                      : Container(),

                  list != null
                      ? list.isNotEmpty
                          ? SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                // gridDelegate:
                                //     SliverGridDelegateWithFixedCrossAxisCount(
                                //         mainAxisExtent: 170, crossAxisCount: 4),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      index == 0
                                          ? Row(
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebViewClass(
                                                                  "AMC",
                                                                  "http://www.armcoolcare.w4u.in/amc")),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .tela,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        // width: 80,
                                                        height: 90,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            child: Image.asset(
                                                                "assets/images/amc.png",
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          // SizedBox(height: 10.0),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "AMC",
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                color: AppColors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Sbcategory(
                                                        list[index]
                                                            .pCats
                                                            .toString(),
                                                        list[index]
                                                            .pcatId
                                                            .toString())),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 5.0, 5.0, 0.0),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors.tela,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                // width: 80,
                                                height: 90,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  child: list[index]
                                                          .img!
                                                          .isEmpty
                                                      ? Image.asset(
                                                          "assets/images/logo.png",
                                                          fit: BoxFit.fill)
                                                      : Image.network(
                                                          Constant.base_url +
                                                              "manage/uploads/p_category/" +
                                                              list[index]
                                                                  .img
                                                                  .toString(),
                                                          fit: BoxFit.fill),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  // SizedBox(height: 10.0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      list[index]
                                                          .pCats
                                                          .toString(),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          // ? Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 10.0),
                          //     child: Container(
                          //         decoration: BoxDecoration(
                          //             // border: Border.all(
                          //             //     color: AppColors.tela,
                          //             //     width: 2),
                          //             borderRadius: BorderRadius.circular(12)),
                          //         height: 180,
                          //         child: GridView.builder(
                          //           itemCount: list.length,
                          //           shrinkWrap: true,
                          //           physics: NeverScrollableScrollPhysics(),
                          //           gridDelegate:
                          //               SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 2,
                          //             mainAxisSpacing: 10,
                          //             crossAxisSpacing: 10,
                          //             mainAxisExtent: 175,

                          //             // childAspectRatio:
                          //             //     (itemWidth / itemHeight),
                          //             //childAspectRatio: 1 / 1
                          //           ),
                          //           itemBuilder: (context, index) {
                          //             return
                          //                 // InkWell(
                          //                 //   onTap: () {
                          //                 //     // var i = list[index].pcatId;
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           Sbcategory(
                          //               list[index].pCats,
                          //               list[index].pcatId)),
                          // );
                          //                 //   },
                          //                 //   child: Column(
                          //                 //     children: <Widget>[
                          //                 //       Stack(
                          //                 //         children: [
                          //                 //           Container(
                          //                 //             decoration: BoxDecoration(
                          //                 //               // border: Border.all(
                          //                 //               //     color: AppColors.tela,
                          //                 //               //     width: 2),
                          //                 //               borderRadius:
                          //                 //                   BorderRadius.circular(
                          //                 //                       12),
                          //                 //             ),
                          //                 //             width: MediaQuery.of(context)
                          //                 //                 .size
                          //                 //                 .width,
                          //                 //             height: 175,
                          //                 //             child: ClipRRect(
                          //                 //               borderRadius:
                          //                 //                   BorderRadius.circular(
                          //                 //                       12),
                          //                 //               child: list[index]
                          //                 //                       .img
                          //                 //                       .isEmpty
                          //                 //                   ? Image.asset(
                          //                 //                       "assets/images/logo.png",
                          //                 //                       fit: BoxFit.fill)
                          //                 //                   : Image.network(
                          //                 //                       Constant.base_url +
                          //                 //                           "manage/uploads/p_category/" +
                          //                 //                           list[index].img,
                          //                 //                       height: 90,
                          //                 //                       fit: BoxFit.fill),
                          //                 //             ),
                          //                 //           ),
                          //                 //           Container(
                          //                 //             decoration: BoxDecoration(
                          //                 //               color: Colors.black
                          //                 //                   .withOpacity(0.5),
                          //                 //               borderRadius:
                          //                 //                   BorderRadius.circular(
                          //                 //                       12),
                          //                 //             ),
                          //                 //             width: MediaQuery.of(context)
                          //                 //                 .size
                          //                 //                 .width,
                          //                 //             height: 175,
                          //                 //             child: Center(
                          //                 //               child: Text(
                          //                 //                 list[index]
                          //                 //                     .pCats
                          //                 //                     .toUpperCase(),
                          //                 //                 maxLines: 2,
                          //                 //                 textAlign:
                          //                 //                     TextAlign.center,
                          //                 //                 overflow:
                          //                 //                     TextOverflow.ellipsis,
                          //                 //                 style: TextStyle(
                          //                 //                     fontWeight:
                          //                 //                         FontWeight.bold,
                          //                 //                     fontSize: 14,
                          //                 //                     color:
                          //                 //                         AppColors.white),
                          //                 //               ),
                          //                 //             ),
                          //                 //           ),
                          //                 //         ],
                          //                 //       ),
                          //                 //       // SizedBox(
                          //                 //       //   height: 7,
                          //                 //       // ),
                          //                 //       // Text(
                          //                 //       //   list[index].pCats,
                          //                 //       //   maxLines: 2,
                          //                 //       //   textAlign: TextAlign.center,
                          //                 //       //   overflow:
                          //                 //       //       TextOverflow.ellipsis,
                          //                 //       //   style: TextStyle(
                          //                 //       //     fontWeight: FontWeight.bold,
                          //                 //       //     fontSize: 14,
                          //                 //       //     color: AppColors.black,
                          //                 //       //   ),
                          //                 //       // ),
                          //                 //     ],
                          //                 //   ),
                          //                 // );

                          //                 InkWell(
                          //               onTap: () {
                          //                 // var i = list[index].pcatId;
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           Sbcategory(
                          //                               list[index].pCats,
                          //                               list[index].pcatId)),
                          //                 );
                          //               },
                          //               child: Card(
                          //                 color: Colors.grey[200],
                          //                 shape: RoundedRectangleBorder(
                          //                     side: BorderSide(
                          //                       color: AppColors.tela,
                          //                     ),
                          //                     borderRadius:
                          //                         BorderRadius.circular(10)),
                          //                 margin: EdgeInsets.zero,
                          //                 child: Column(
                          //                   children: <Widget>[
                          //                     Container(
                          //                       decoration: BoxDecoration(
                          //                         // border: Border.all(
                          //                         //     color: AppColors.tela,
                          //                         //     width: 2),
                          //                         borderRadius:
                          //                             BorderRadius.only(
                          //                                 topLeft:
                          //                                     Radius.circular(
                          //                                         10),
                          //                                 topRight:
                          //                                     Radius.circular(
                          //                                         10)),
                          //                       ),
                          //                       width: MediaQuery.of(context)
                          //                           .size
                          //                           .width,
                          //                       height: 130,
                          //                       child: ClipRRect(
                          //                           borderRadius:
                          //                               BorderRadius.only(
                          //                                   topLeft: Radius
                          //                                       .circular(10),
                          //                                   topRight:
                          //                                       Radius.circular(
                          //                                           10)),
                          //                           child: list[index]
                          //                                   .img
                          //                                   .isEmpty
                          //                               ? Image.asset(
                          //                                   "assets/images/logo.png",
                          //                                   fit: BoxFit.fill)
                          //                               : Image.network(
                          //                                   Constant.base_url +
                          //                                       "manage/uploads/p_category/" +
                          //                                       list[index].img,
                          //                                   height: 90,
                          //                                   fit: BoxFit.fill)),
                          //                     ),
                          //                     SizedBox(
                          //                       height: 7,
                          //                     ),
                          //                     Text(
                          //                       list[index].pCats,
                          //                       maxLines: 2,
                          //                       textAlign: TextAlign.center,
                          //                       overflow: TextOverflow.ellipsis,
                          //                       style: TextStyle(
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: 14,
                          //                         color: AppColors.black,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         )
                          //         // physics: ClampingScrollPhysics(),
                          //         // controller: new ScrollController(
                          //         //     keepScrollOffset: false),
                          //         // shrinkWrap: true,
                          //         // crossAxisCount: 4,
                          //         // childAspectRatio: 0.65,
                          //         //children: List.generate(list.length, (index) {

                          //         ),
                          //   )
                          : const Row()
                      : const Row(),

                  topProducts.isNotEmpty
                      ? Container(
                          color: AppColors.white,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  Constant.AProduct_type_Name1,
                                  style: const TextStyle(
                                      color: AppColors.product_title_name,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 8.0, left: 8.0),
                                child: ElevatedButton(
                                    //color: AppColors.tela,
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.tela)),
                                    child: const Text('View All',
                                        style:
                                            TextStyle(color: AppColors.white)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductList(
                                                "Top",
                                                Constant.AProduct_type_Name1)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  topProducts.isNotEmpty
                      ? SizedBox(
                          height: 230.0,
                          child: topProducts != null
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 8.0, bottom: 20),
                                  height: 220.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts.length ?? 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: topProducts[index] != 0
                                              ? 140.0
                                              : 230.0,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 10,
                                            child: Column(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails(
                                                                  topProducts[
                                                                      index])),
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 130,
                                                        width: 130,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.contain,
                                                            imageUrl: Constant
                                                                    .Product_Imageurl +
                                                                topProducts[
                                                                        index]
                                                                    .img
                                                                    .toString(),
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 2,
                                                            top: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3, right: 5),
                                                    decoration: BoxDecoration(
                                                        color: AppColors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        )),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          topProducts[index]
                                                              .productName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '\u{20B9} ${topProducts[index].buyPrice}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: AppColors
                                                                          .black,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              1),
                                                                  child: Text(
                                                                      '\u{20B9} ${calDiscount(topProducts[index].buyPrice.toString(), topProducts[index].discount.toString())}',
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .green,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              13)),
                                                                ),
                                                              ],
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (Constant
                                                                    .isLogin) {
                                                                  String mrpPrice = calDiscount(
                                                                      topProducts[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .discount
                                                                          .toString());
                                                                  totalmrp =
                                                                      double.parse(
                                                                          mrpPrice);

                                                                  double
                                                                      dicountValue =
                                                                      double.parse(topProducts[index]
                                                                              .buyPrice
                                                                              .toString()) -
                                                                          totalmrp!;
                                                                  String gstSgst = calGst(
                                                                      mrpPrice,
                                                                      topProducts[
                                                                              index]
                                                                          .sgst
                                                                          .toString());
                                                                  String gstCgst = calGst(
                                                                      mrpPrice,
                                                                      topProducts[
                                                                              index]
                                                                          .cgst
                                                                          .toString());

                                                                  String adiscount = calDiscount(
                                                                      topProducts[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      topProducts[index]
                                                                              .msrp ??
                                                                          "0");

                                                                  admindiscountprice = (double.parse(topProducts[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString()) -
                                                                      double.parse(
                                                                          adiscount));

                                                                  String color =
                                                                      "";
                                                                  String size =
                                                                      "";
                                                                  _addToproducts(
                                                                      topProducts[
                                                                              index]
                                                                          .productIs
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .productName
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .img
                                                                          .toString(),
                                                                      int.parse(
                                                                          mrpPrice),
                                                                      int.parse(topProducts[
                                                                              index]
                                                                          .count
                                                                          .toString()),
                                                                      color,
                                                                      size,
                                                                      topProducts[
                                                                              index]
                                                                          .productDescription
                                                                          .toString(),
                                                                      gstSgst,
                                                                      gstCgst,
                                                                      topProducts[
                                                                              index]
                                                                          .discount
                                                                          .toString(),
                                                                      dicountValue
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .APMC
                                                                          .toString(),
                                                                      admindiscountprice
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .shipping
                                                                          .toString(),
                                                                      topProducts[
                                                                              index]
                                                                          .quantityInStock
                                                                          .toString());

                                                                  setState(() {
                                                                    Constant
                                                                        .carditemCount++;
                                                                    cartItemcount(
                                                                        Constant
                                                                            .carditemCount);
                                                                  });
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SignInPage()),
                                                                  );
                                                                }
                                                              },
                                                              child: SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child: Card(
                                                                  elevation: 5,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color:
                                                                        AppColors
                                                                            .tela,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: AppColors.tela,
                                  ),
                                ),
                        )
                      : Container(),
                  //appBanner

                  bannerSlider != null
                      ? bannerSlider.isNotEmpty
                          ? SizedBox(
                              height: 170.0,
                              width: MediaQuery.of(context).size.width,
                              child: bannerSlider != null
                                  ? bannerSlider.isNotEmpty
                                      ? CarouselSlider.builder(
                                          itemCount: bannerSlider.length,
                                          options: CarouselOptions(
                                            aspectRatio: 2.8,
                                            viewportFraction: 1.5,
                                            // enlargeCenterPage: true,
                                            autoPlay: false,
                                          ),
                                          itemBuilder: (ctx, index, realIdx) {
                                            return Container(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!bannerSlider[index]
                                                      .title!
                                                      .isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Screen2(
                                                                  sliderlist[
                                                                          index]
                                                                      .title
                                                                      .toString(),
                                                                  "")),
                                                    );
                                                  } else if (!bannerSlider[
                                                          index]
                                                      .description!
                                                      .isEmpty) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails1(
                                                                  bannerSlider[
                                                                          index]
                                                                      .description
                                                                      .toString())),
                                                    );
//
                                                  }
                                                },
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5.0,
                                                            right: 5),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        child:
                                                            CachedNetworkImage(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              30,
                                                          fit: BoxFit.fill,
                                                          imageUrl: Constant
                                                                  .Base_Imageurl +
                                                              bannerSlider[
                                                                      index]
                                                                  .img
                                                                  .toString(),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ))),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColors.tela,
                                          ),
                                        )
                                  : const Row())
                          : Container()
                      : Container(),

                  bestProducts != null
                      ? bestProducts.isNotEmpty
                          ? Container(
                              color: Colors.white,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 18.0, right: 8.0),
                                    child: Text(
                                      "BEST DEALS",
                                      style: TextStyle(
                                          color: AppColors.product_title_name,
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0, left: 8.0),
                                    child: ElevatedButton(
                                        // color: AppColors.tela,
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppColors.tela)),
                                        child: Text('View All',
                                            style: TextStyle(
                                                color: AppColors.white)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductList(
                                                  "best", "Best Deals"),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),

                  bestProducts != null
                      ? bestProducts.isNotEmpty
                          ? Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: bestProducts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 6,
                                            bottom: 6),
                                        child: Card(
                                          elevation: 1,
                                          color: Colors.grey.shade100,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetails(
                                                            bestProducts[
                                                                index])),
                                              );
                                            },
                                            child: Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              bestProducts[
                                                                          index]
                                                                      .productName ??
                                                                  'name',
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: const TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black)
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            2.0,
                                                                        bottom:
                                                                            1),
                                                                child: Text(
                                                                    '\u{20B9} ${calDiscount(bestProducts[index].buyPrice.toString(), bestProducts[index].discount.toString())}  ${bestProducts[index].unit_type ?? ""}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .sellp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    )),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '\u{20B9} ${bestProducts[index].buyPrice}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: AppColors
                                                                          .mrp,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                              )
                                                            ],
                                                          ),

                                                          /* Container(
                                                          margin: EdgeInsets.only(left: 0.0,right: 10),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: <Widget>[
                                                                SizedBox(width: 0.0,height: 10.0,),

                                                                Column(
                                                                  children: <Widget>[
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: <Widget>[
                                                                        Container(
                                                                            height: 25,
                                                                            width: 35,
                                                                            child:
                                                                            Material(

                                                                              color: AppColors.teladep,
                                                                              elevation: 0.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child:Padding (
                                                                                padding: EdgeInsets.only(bottom: 10),
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      print(products1[index].count);
                                                                                      if(products1[index].count!="1"){
                                                                                        setState(() {
//                                                                                _count++;

                                                                                          String  quantity=products1[index].count;
                                                                                          int totalquantity=int.parse(quantity)-1;
                                                                                          products1[index].count=totalquantity.toString();

                                                                                        });
                                                                                      }



//



                                                                                    },
                                                                                    child:Padding(padding: EdgeInsets.only(top:10.0,),

                                                                                      child:Icon(
                                                                                        Icons.maximize,size: 20,
                                                                                        color: Colors.white,
                                                                                      ),


                                                                                    )
                                                                                ),
                                                                              ),
                                                                            )),

                                                                        Padding(
                                                                          padding:
                                                                          EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
                                                                          child:Center(
                                                                            child:
                                                                            Text(products1[index].count!=null?'${products1[index].count}':'$_count',

                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 19,
                                                                                    fontFamily: 'Roboto',
                                                                                    fontWeight: FontWeight.bold)),

                                                                          ),),

                                                                        Container(
                                                                            margin: EdgeInsets.only(left: 3.0),
                                                                            height: 25,
                                                                            width: 35,
                                                                            child:
                                                                            Material(

                                                                              color: AppColors.teladep,
                                                                              elevation: 0.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  if(int.parse(products1[index].count) <= int.parse(products1[index].quantityInStock)){
                                                                                    setState(() {
//                                                                                _count++;

                                                                                      String  quantity=products1[index].count;
                                                                                      int totalquantity=int.parse(quantity)+1;
                                                                                      products1[index].count=totalquantity.toString();

                                                                                    });
                                                                                  }
                                                                                  else{
                                                                                    showLongToast('Only  ${products1[index].count}  products in stock ');
                                                                                  }


                                                                                },


                                                                                child:Icon(
                                                                                  Icons.add,size: 20,
                                                                                  color: Colors.white,
                                                                                ),


                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                // SizedBox(width: 10,),

                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: <Widget>[

                                                                    Container(
                                                                        margin: EdgeInsets.only(left: 3.0),
                                                                        height: 40,

                                                                        child:
                                                                        Material(

                                                                          color: AppColors.sellp,
                                                                          elevation: 0.0,
                                                                          shape: RoundedRectangleBorder(
                                                                            side: BorderSide(
                                                                              color: Colors.white,
                                                                            ),
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(20),
                                                                            ),
                                                                          ),
                                                                          clipBehavior: Clip.antiAlias,
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              if(Constant.isLogin){


                                                                                String  mrp_price=calDiscount(products1[index].buyPrice,products1[index].discount);
                                                                                totalmrp= double.parse(mrp_price);


                                                                                double dicountValue=double.parse(products1[index].buyPrice)-totalmrp;
                                                                                String gst_sgst=calGst(mrp_price,products1[index].sgst);
                                                                                String gst_cgst=calGst(mrp_price,products1[index].cgst);

                                                                                String  adiscount=calDiscount(products1[index].buyPrice,products1[index].msrp!=null?products1[index].msrp:"0");

                                                                                admindiscountprice=(double.parse(products1[index].buyPrice)-double.parse(adiscount));



                                                                                String color="";
                                                                                String size="";
                                                                                _addToproducts(products1[index].productIs,products1[index].productName,products1[index].img,int.parse(mrp_price),int.parse(products1[index].count),color,size,products1[index].productDescription,gst_sgst,gst_cgst,
                                                                                    products1[index].discount,dicountValue.toString(), products1[index].APMC, admindiscountprice.toString(),products1[index].buyPrice,products1[index].shipping,products1[index].quantityInStock);


                                                                                setState(() {
//                                                                              cartvalue++;
                                                                                  Constant.carditemCount++;
                                                                                  cartItemcount(Constant.carditemCount);

                                                                                });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

                                                                              }
                                                                              else{


                                                                                Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (context) => SignInPage()),);
                                                                              }

//

                                                                            },
                                                                            child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
                                                                                child:Center(

                                                                                  child:Icon(Icons.add_shopping_cart,color: Colors.white,),

                                                                                )),),
                                                                        )),









                                                                  ],
                                                                ),






                                                              ]
                                                          ) ,
                                                        ),*/
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8,
                                                            left: 8,
                                                            top: 8,
                                                            bottom: 8),
                                                    width: 110,
                                                    height: 110,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                AppColors.tela,
                                                            width: 0.2),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(55),
                                                        ),
                                                        color: Colors
                                                            .blue.shade200,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              bestProducts[index]
                                                                          .img !=
                                                                      null
                                                                  ? Constant
                                                                          .Product_Imageurl +
                                                                      bestProducts[
                                                                              index]
                                                                          .img
                                                                          .toString()
                                                                  : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                            ))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //double.parse(products1[index].discount)>0?  showSticker(index,products1):Row(),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const Row()
                      : const Row(),

                  topProducts1 != null
                      ? topProducts1.isNotEmpty
                          ? Container(
                              color: AppColors.white,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      'DEALS OF THE DAY',
                                      style: TextStyle(
                                          color: AppColors.product_title_name,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0, left: 8.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppColors.tela)),
                                        // color: AppColors.tela,
                                        child: Text('View All',
                                            style: TextStyle(
                                                color: AppColors.white)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductList("day",
                                                        "Deals of the day")),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),

                  topProducts1.isNotEmpty
                      ? SizedBox(
                          height: 230.0,
                          child: topProducts1 != null
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 8.0, bottom: 20),
                                  height: 220.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts1.length ?? 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          width: topProducts1[index] != 0
                                              ? 140.0
                                              : 230.0,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 3,
                                            child: Column(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails(
                                                                  topProducts1[
                                                                      index])),
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 110,
                                                        width: 110,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.contain,
                                                            imageUrl: Constant
                                                                    .Product_Imageurl +
                                                                topProducts1[
                                                                        index]
                                                                    .img
                                                                    .toString(),
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 2,
                                                            top: 5),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3, right: 5),
                                                    decoration: BoxDecoration(
                                                        color: AppColors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        )),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          topProducts1[index]
                                                              .productName
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '\u{20B9} ${topProducts1[index].buyPrice}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: AppColors
                                                                          .black,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4.0,
                                                                          bottom:
                                                                              1),
                                                                  child: Text(
                                                                      '\u{20B9} ${calDiscount(topProducts1[index].buyPrice.toString(), topProducts1[index].discount.toString())}',
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .green,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              13)),
                                                                ),
                                                              ],
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (Constant
                                                                    .isLogin) {
                                                                  String mrpPrice = calDiscount(
                                                                      topProducts1[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .discount
                                                                          .toString());
                                                                  totalmrp =
                                                                      double.parse(
                                                                          mrpPrice);

                                                                  double
                                                                      dicountValue =
                                                                      double.parse(topProducts1[index]
                                                                              .buyPrice
                                                                              .toString()) -
                                                                          totalmrp!;
                                                                  String gstSgst = calGst(
                                                                      mrpPrice,
                                                                      topProducts1[
                                                                              index]
                                                                          .sgst
                                                                          .toString());
                                                                  String gstCgst = calGst(
                                                                      mrpPrice,
                                                                      topProducts1[
                                                                              index]
                                                                          .cgst
                                                                          .toString());

                                                                  String adiscount = calDiscount(
                                                                      topProducts1[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      topProducts1[index]
                                                                              .msrp ??
                                                                          "0");

                                                                  admindiscountprice = (double.parse(topProducts1[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString()) -
                                                                      double.parse(
                                                                          adiscount));

                                                                  String color =
                                                                      "";
                                                                  String size =
                                                                      "";
                                                                  _addToproducts(
                                                                      topProducts1[
                                                                              index]
                                                                          .productIs
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .productName
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .img
                                                                          .toString(),
                                                                      int.parse(
                                                                          mrpPrice),
                                                                      int.parse(topProducts1[
                                                                              index]
                                                                          .count
                                                                          .toString()),
                                                                      color,
                                                                      size,
                                                                      topProducts1[
                                                                              index]
                                                                          .productDescription
                                                                          .toString(),
                                                                      gstSgst,
                                                                      gstCgst,
                                                                      topProducts1[
                                                                              index]
                                                                          .discount
                                                                          .toString(),
                                                                      dicountValue
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .APMC
                                                                          .toString(),
                                                                      admindiscountprice
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .buyPrice
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .shipping
                                                                          .toString(),
                                                                      topProducts1[
                                                                              index]
                                                                          .quantityInStock
                                                                          .toString());

                                                                  setState(() {
                                                                    Constant
                                                                        .carditemCount++;
                                                                    cartItemcount(
                                                                        Constant
                                                                            .carditemCount);
                                                                  });
                                                                } else {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SignInPage()),
                                                                  );
                                                                }
                                                              },
                                                              child: SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child: Card(
                                                                  elevation: 5,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color:
                                                                        AppColors
                                                                            .tela,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: AppColors.tela,
                                  ),
                                ),
                        )
                      : Container(),

                  /*Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 5,left: 8,right: 8,top: 5),
                            padding: EdgeInsets.all( 8) ,


                            decoration: new BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),


//                              color: AppColors.white,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image:  AssetImage("assets/images/banner3.jpeg"),
                              ),


                              // color: Colors.white,
                            ),

                          ),*/

                  /* FutureBuilder(
                              future: getBanner(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length == null
                                        ? 0
                                        : snapshot.data.length,

                                    shrinkWrap: true,
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      Slider1 item = snapshot.data[index];
                                      return InkWell(
                                          onTap: () {
                                            // print(item.title + "TITLE");
                                            // print(item.description + "DESCR");
                                            if (!item.title.isEmpty) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Screen2(
                                                            item.title, "")),
                                              );
                                            }
                                            else
                                            if (!item.description.isEmpty) {
                                              Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetails1(item
                                                            .description)),);
//

                                            }
                                          },

                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 6.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 5),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: Constant
                                                  .Product_Imageurl5 + item.img,
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                              new Icon(Icons.error),

                                            ),
                                          )
                                      );
                                    },

                                  );
                                }
                                else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }
                          ),*/
                  //yetan

                  /* bannerSlider!=null? bannerSlider.length>0? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom:10, right: 0),
                              width: 412,
                              height: 200,
                              child: GridView.count(
                                scrollDirection: Axis.horizontal,

                                  crossAxisCount: 1,
                                  childAspectRatio: 0.4,
                                  padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 0),
                                  children: List.generate(bannerSlider.length, (index){

                                    return InkWell(
                                        onTap: () {
                                          // print(item.title + "TITLE");
                                          // print(item.description + "DESCR");
                                          if (!bannerSlider[index].title.isEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Screen2(
                                                          bannerSlider[index].title, "")),
                                            );
                                          }
                                          else
                                          if (!bannerSlider[index].description.isEmpty) {
                                            Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetails1(bannerSlider[index]
                                                          .description)),);
//

                                          }
                                        },

                                        child: Container(

                                            child:ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(Constant.Product_Imageurl5 + bannerSlider[index].img,fit: BoxFit.fitWidth,
                                               ),
                                            )

                                          /*CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: Constant
                                                .Product_Imageurl5 + bannerSlider[index].img,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                            new Icon(Icons.error),

                                          ),*/
                                        )
                                    );

                                  })),
                            ),
                          ):Container():Container(),*/

                  dilofdayProducts.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Text(
                                  " " + Constant.AProduct_type_Name2,
                                  style: TextStyle(
                                      color: AppColors.product_title_name,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 8.0, left: 8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.tela),
                                    ),
                                    // color: AppColors.tela,
                                    child: Text('View All',
                                        style:
                                            TextStyle(color: AppColors.black)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductList(
                                                "new",
                                                Constant.AProduct_type_Name2)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        )
                      : Container(),

                  dilofdayProducts.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisExtent: 130,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5),
                              physics: const ClampingScrollPhysics(),
                              controller:
                                  ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              // crossAxisCount: 2,

                              // childAspectRatio: 0.68,
                              padding: const EdgeInsets.only(
                                  top: 0, left: 6, right: 6, bottom: 0),
                              itemCount: (dilofdayProducts.length >= 6
                                  ? 6
                                  : dilofdayProducts.length),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    dilofdayProducts[index])),
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 0,
                                                left: 0,
                                                top: 0,
                                                bottom: 0),
                                            width: 110,
                                            height: 110,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.tela),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(14)),
                                                color: Colors.blue.shade200,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      dilofdayProducts[index]
                                                                  .img !=
                                                              null
                                                          ? Constant
                                                                  .Product_Imageurl +
                                                              dilofdayProducts[
                                                                      index]
                                                                  .img
                                                                  .toString()
                                                          : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                    ))),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      dilofdayProducts[index]
                                                              .productName ??
                                                          'name',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black)
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 2.0,
                                                                bottom: 1),
                                                        child: Text(
                                                            '\u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice.toString(), dilofdayProducts[index].discount.toString())} ${dilofdayProducts[index].unit_type != null ? "/" + dilofdayProducts[index].unit_type.toString() : ""}',
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .sellp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '(\u{20B9} ${dilofdayProducts[index].buyPrice})',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color:
                                                                  AppColors.mrp,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 0.0,
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
//
                              }),
// GridView.builder(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     mainAxisExtent: 175,
//                                     crossAxisSpacing: 5),
//                             itemCount: dilofdayProducts.length >= 4
//                                 ? 4
//                                 : dilofdayProducts.length,
//                             physics: ClampingScrollPhysics(),
//                             controller:
//                                 new ScrollController(keepScrollOffset: false),
//                             shrinkWrap: true,
//                             // crossAxisCount: 2,
//                             // childAspectRatio: 0.68,
//                             itemBuilder: (context, index) {
//                               // padding: EdgeInsets.only(
//                               //     top: 8, left: 6, right: 6, bottom: 0),

//                               return Container(
//                                 child: Card(
//                                   elevation: 0.0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Column(
//                                     children: <Widget>[
//                                       InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ProductDetails(
//                                                         dilofdayProducts[
//                                                             index])),
//                                           );
// //
//                                         },
//                                         child: SizedBox(
//                                           height: 120,
//                                           width: double.infinity,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                             child: CachedNetworkImage(
//                                               fit: BoxFit.cover,
//                                               imageUrl: Constant
//                                                       .Product_Imageurl +
//                                                   dilofdayProducts[index].img,
//                                               //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                               placeholder: (context, url) => Center(
//                                                   child:
//                                                       CircularProgressIndicator()),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                       new Icon(Icons.error),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           margin: EdgeInsets.only(
//                                               left: 5,
//                                               right: 5,
//                                               top: 10,
//                                               bottom: 5),
//                                           padding: EdgeInsets.only(
//                                               left: 3, right: 5),
//                                           color: AppColors.white,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: <Widget>[
//                                               Text(
//                                                 dilofdayProducts[index]
//                                                     .productName,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 1,
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12,
//                                                   color: AppColors.black,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 4,
//                                               ),
//                                               // Row(
//                                               //   mainAxisAlignment:
//                                               //       MainAxisAlignment.center,
//                                               //   children: [
//                                               //     Text(
//                                               //       '  \u{20B9} ${dilofdayProducts[index].buyPrice}',
//                                               //       overflow:
//                                               //           TextOverflow.ellipsis,
//                                               //       maxLines: 2,
//                                               //       style: TextStyle(
//                                               //           fontWeight:
//                                               //               FontWeight.w700,
//                                               //           fontStyle:
//                                               //               FontStyle.italic,
//                                               //           fontSize: 12,
//                                               //           color: AppColors.black,
//                                               //           decoration:
//                                               //               TextDecoration
//                                               //                   .lineThrough),
//                                               //     ),
//                                               //     Padding(
//                                               //       padding:
//                                               //           const EdgeInsets.only(
//                                               //               top: 2.0,
//                                               //               bottom: 1,
//                                               //               right: 10),
//                                               //       child: Text(
//                                               //           '  \u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice, dilofdayProducts[index].discount)}',
//                                               //           style: TextStyle(
//                                               //               color:
//                                               //                   AppColors.green,
//                                               //               fontWeight:
//                                               //                   FontWeight.w700,
//                                               //               fontSize: 12)),
//                                               //     ),
//                                               //   ],
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
                        )
                      : Container(),
                  Container(
                    height: 6,
                  ),
                  // slider
                  imageUrl.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(
                              color: AppColors.white,
                              height: 190.0,
                              width: MediaQuery.of(context).size.width,
                              child: sliderlist != null
                                  ? sliderlist.isNotEmpty
                                      ? CarouselSlider.builder(
                                          itemCount: sliderlist.length,
                                          options: CarouselOptions(
                                            aspectRatio: 2.4,
                                            viewportFraction: 0.96,
                                            enlargeCenterPage: true,
                                            autoPlay: true,
                                          ),
                                          itemBuilder: (ctx, index, realIdx) {
                                            return Container(
                                              child: GestureDetector(
                                                onTap: () {
//                                                   if (!sliderlist[index]
//                                                       .title
//                                                       .isEmpty) {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               Screen2(
//                                                                   sliderlist[
//                                                                           index]
//                                                                       .title,
//                                                                   "")),
//                                                     );
//                                                   } else if (!sliderlist[index]
//                                                       .description
//                                                       .isEmpty) {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               ProductDetails1(
//                                                                   sliderlist[
//                                                                           index]
//                                                                       .description)),
//                                                     );
// //

//                                                   }
                                                },
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 2.0,
                                                            right: 2),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        child:
                                                            CachedNetworkImage(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.fill,
                                                          imageUrl: Constant
                                                                  .mainurl +
                                                              promotionBanner
                                                                  .path
                                                                  .toString() +
                                                              promotionBanner
                                                                  .images
                                                                  .toString(),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ))),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColors.tela,
                                          ),
                                        )
                                  : const Row()),
                        ),

                  // 2nd part dilofdayproducts
                  reverseList.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0, bottom: 0),
                                child: Text(
                                  "  Repair Service",
                                  style: TextStyle(
                                      color: AppColors.product_title_name,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 8.0, left: 8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.tela)),
                                    child: const Text('View All',
                                        style:
                                            TextStyle(color: AppColors.black)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductList(
                                                "new",
                                                Constant.AProduct_type_Name2)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  reverseList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisExtent: 130,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5),
                              physics: const ClampingScrollPhysics(),
                              controller:
                                  ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              // crossAxisCount: 2,

                              // childAspectRatio: 0.68,
                              padding: const EdgeInsets.only(
                                  top: 0, left: 6, right: 6, bottom: 0),
                              itemCount: (reverseList.length >= 6
                                  ? 6
                                  : reverseList.length),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    reverseList[index])),
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 0,
                                                left: 0,
                                                top: 0,
                                                bottom: 0),
                                            width: 110,
                                            height: 110,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.tela),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(14)),
                                                color: Colors.blue.shade200,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      reverseList[index].img !=
                                                              null
                                                          ? Constant
                                                                  .Product_Imageurl +
                                                              reverseList[index]
                                                                  .img
                                                          : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                    ))),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      reverseList[index]
                                                              .productName ??
                                                          'name',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black)
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 2.0,
                                                                bottom: 1),
                                                        child: Text(
                                                            '\u{20B9} ${calDiscount(reverseList[index].buyPrice, reverseList[index].discount)} ${reverseList[index].unit_type != null ? "/" + reverseList[index].unit_type : ""}',
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .sellp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '(\u{20B9} ${reverseList[index].buyPrice})',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color:
                                                                  AppColors.mrp,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 0.0,
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
//
                              }),
// GridView.builder(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     mainAxisExtent: 175,
//                                     crossAxisSpacing: 5),
//                             itemCount: reverseList.length - 4,
//                             // ? 4
//                             // : dilofdayProducts.length,
//                             physics: ClampingScrollPhysics(),
//                             controller:
//                                 new ScrollController(keepScrollOffset: false),
//                             shrinkWrap: true,
//                             // crossAxisCount: 2,
//                             // childAspectRatio: 0.68,
//                             itemBuilder: (context, index) {
//                               // padding: EdgeInsets.only(
//                               //     top: 8, left: 6, right: 6, bottom: 0),

//                               return Container(
//                                 child: Card(
//                                   elevation: 0.0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Column(
//                                     children: <Widget>[
//                                       InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ProductDetails(
//                                                         reverseList[index])),
//                                           );
// //
//                                         },
//                                         child: SizedBox(
//                                           height: 120,
//                                           width: double.infinity,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                             child: CachedNetworkImage(
//                                               fit: BoxFit.cover,
//                                               imageUrl:
//                                                   Constant.Product_Imageurl +
//                                                       reverseList[index].img,
//                                               //                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
//                                               placeholder: (context, url) => Center(
//                                                   child:
//                                                       CircularProgressIndicator()),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                       new Icon(Icons.error),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           margin: EdgeInsets.only(
//                                               left: 5,
//                                               right: 5,
//                                               top: 10,
//                                               bottom: 5),
//                                           padding: EdgeInsets.only(
//                                               left: 3, right: 5),
//                                           color: AppColors.white,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: <Widget>[
//                                               Text(
//                                                 reverseList[index].productName,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 1,
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12,
//                                                   color: AppColors.black,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 4,
//                                               ),
//                                               // Row(
//                                               //   mainAxisAlignment:
//                                               //       MainAxisAlignment.center,
//                                               //   children: [
//                                               //     Text(
//                                               //       '  \u{20B9} ${dilofdayProducts[index].buyPrice}',
//                                               //       overflow:
//                                               //           TextOverflow.ellipsis,
//                                               //       maxLines: 2,
//                                               //       style: TextStyle(
//                                               //           fontWeight:
//                                               //               FontWeight.w700,
//                                               //           fontStyle:
//                                               //               FontStyle.italic,
//                                               //           fontSize: 12,
//                                               //           color: AppColors.black,
//                                               //           decoration:
//                                               //               TextDecoration
//                                               //                   .lineThrough),
//                                               //     ),
//                                               //     Padding(
//                                               //       padding:
//                                               //           const EdgeInsets.only(
//                                               //               top: 2.0,
//                                               //               bottom: 1,
//                                               //               right: 10),
//                                               //       child: Text(
//                                               //           '  \u{20B9} ${calDiscount(dilofdayProducts[index].buyPrice, dilofdayProducts[index].discount)}',
//                                               //           style: TextStyle(
//                                               //               color:
//                                               //                   AppColors.green,
//                                               //               fontWeight:
//                                               //                   FontWeight.w700,
//                                               //               fontSize: 12)),
//                                               //     ),
//                                               //   ],
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
                        )
                      : Container(),
                  Container(
                    height: 6,
                  ),

                  products1 != null
                      ? products1.isNotEmpty
                          ? Container(
                              color: Colors.white,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      "Featured Products",
                                      style: TextStyle(
                                          color: AppColors.product_title_name,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 8.0, left: 8.0),
                                    child: ElevatedButton(
                                        // color: AppColors.tela,

                                        child: Text('View All',
                                            style: TextStyle(
                                                color: AppColors.white)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductList("yes",
                                                        "Featured Products")),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                  Container(
                    height: 10,
                    color: AppColors.white,
                  ),

                  products1 != null
                      ? products1.isNotEmpty
                          ? Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: products1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 6,
                                            bottom: 6),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.green),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16))),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetails(
                                                          products1[index])),
                                            );
                                          },
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            products1[index]
                                                                    .productName ??
                                                                'name',
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)
                                                                .copyWith(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 2.0,
                                                                      bottom:
                                                                          1),
                                                              child: Text(
                                                                  '\u{20B9} ${calDiscount(products1[index].buyPrice.toString(), products1[index].discount.toString())}  ${products1[index].unit_type ?? ""}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppColors
                                                                        .sellp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '\u{20B9} ${products1[index].buyPrice}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color:
                                                                        AppColors
                                                                            .mrp,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                        /* Container(
                                                        margin: EdgeInsets.only(left: 0.0,right: 10),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: <Widget>[
                                                              SizedBox(width: 0.0,height: 10.0,),

                                                              Column(
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: <Widget>[
                                                                      Container(
                                                                          height: 25,
                                                                          width: 35,
                                                                          child:
                                                                          Material(

                                                                            color: AppColors.teladep,
                                                                            elevation: 0.0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                color: Colors.white,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            clipBehavior: Clip.antiAlias,
                                                                            child:Padding (
                                                                              padding: EdgeInsets.only(bottom: 10),
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    print(products1[index].count);
                                                                                    if(products1[index].count!="1"){
                                                                                      setState(() {
//                                                                                _count++;

                                                                                        String  quantity=products1[index].count;
                                                                                        int totalquantity=int.parse(quantity)-1;
                                                                                        products1[index].count=totalquantity.toString();

                                                                                      });
                                                                                    }



//



                                                                                  },
                                                                                  child:Padding(padding: EdgeInsets.only(top:10.0,),

                                                                                    child:Icon(
                                                                                      Icons.maximize,size: 20,
                                                                                      color: Colors.white,
                                                                                    ),


                                                                                  )
                                                                              ),
                                                                            ),
                                                                          )),

                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets.only(top: 0.0, left: 15.0, right: 8.0),
                                                                        child:Center(
                                                                          child:
                                                                          Text(products1[index].count!=null?'${products1[index].count}':'$_count',

                                                                              style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 19,
                                                                                  fontFamily: 'Roboto',
                                                                                  fontWeight: FontWeight.bold)),

                                                                        ),),

                                                                      Container(
                                                                          margin: EdgeInsets.only(left: 3.0),
                                                                          height: 25,
                                                                          width: 35,
                                                                          child:
                                                                          Material(

                                                                            color: AppColors.teladep,
                                                                            elevation: 0.0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(
                                                                                color: Colors.white,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            clipBehavior: Clip.antiAlias,
                                                                            child: InkWell(
                                                                              onTap: () {
                                                                                if(int.parse(products1[index].count) <= int.parse(products1[index].quantityInStock)){
                                                                                  setState(() {
//                                                                                _count++;

                                                                                    String  quantity=products1[index].count;
                                                                                    int totalquantity=int.parse(quantity)+1;
                                                                                    products1[index].count=totalquantity.toString();

                                                                                  });
                                                                                }
                                                                                else{
                                                                                  showLongToast('Only  ${products1[index].count}  products in stock ');
                                                                                }


                                                                              },


                                                                              child:Icon(
                                                                                Icons.add,size: 20,
                                                                                color: Colors.white,
                                                                              ),


                                                                            ),
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              // SizedBox(width: 10,),

                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: <Widget>[

                                                                  Container(
                                                                      margin: EdgeInsets.only(left: 3.0),
                                                                      height: 40,

                                                                      child:
                                                                      Material(

                                                                        color: AppColors.sellp,
                                                                        elevation: 0.0,
                                                                        shape: RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                            color: Colors.white,
                                                                          ),
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        clipBehavior: Clip.antiAlias,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            if(Constant.isLogin){


                                                                              String  mrp_price=calDiscount(products1[index].buyPrice,products1[index].discount);
                                                                              totalmrp= double.parse(mrp_price);


                                                                              double dicountValue=double.parse(products1[index].buyPrice)-totalmrp;
                                                                              String gst_sgst=calGst(mrp_price,products1[index].sgst);
                                                                              String gst_cgst=calGst(mrp_price,products1[index].cgst);

                                                                              String  adiscount=calDiscount(products1[index].buyPrice,products1[index].msrp!=null?products1[index].msrp:"0");

                                                                              admindiscountprice=(double.parse(products1[index].buyPrice)-double.parse(adiscount));



                                                                              String color="";
                                                                              String size="";
                                                                              _addToproducts(products1[index].productIs,products1[index].productName,products1[index].img,int.parse(mrp_price),int.parse(products1[index].count),color,size,products1[index].productDescription,gst_sgst,gst_cgst,
                                                                                  products1[index].discount,dicountValue.toString(), products1[index].APMC, admindiscountprice.toString(),products1[index].buyPrice,products1[index].shipping,products1[index].quantityInStock);


                                                                              setState(() {
//                                                                              cartvalue++;
                                                                                Constant.carditemCount++;
                                                                                cartItemcount(Constant.carditemCount);

                                                                              });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);

                                                                            }
                                                                            else{


                                                                              Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => SignInPage()),);
                                                                            }

//

                                                                          },
                                                                          child:Padding(padding: EdgeInsets.only(left: 8,top: 5,bottom: 5,right: 8),
                                                                              child:Center(

                                                                                child:Icon(Icons.add_shopping_cart,color: Colors.white,),

                                                                              )),),
                                                                      )),









                                                                ],
                                                              ),






                                                            ]
                                                        ) ,
                                                      ),*/
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 8,
                                                      left: 8,
                                                      top: 8,
                                                      bottom: 8),
                                                  width: 110,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors.tela,
                                                          width: 0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(55),
                                                      ),
                                                      color:
                                                          Colors.blue.shade200,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                            products1[index]
                                                                        .img !=
                                                                    null
                                                                ? Constant
                                                                        .Product_Imageurl +
                                                                    products1[
                                                                            index]
                                                                        .img
                                                                        .toString()
                                                                : "ttps://www.drawplanet.cz/wp-content/uploads/2019/10/dsc-0009-150x100.jpg",
                                                          ))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      //double.parse(products1[index].discount)>0?  showSticker(index,products1):Row(),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const Row()
                      : const Row(),

//                   bannerSlider.length == 0
//                       // ? Container()
//                       ? Container(
//                           height: 170,
//                           width: MediaQuery.of(context).size.width,
//                           margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
//                           // padding: EdgeInsets.all(10),
//                           decoration: new BoxDecoration(
// //                              color: AppColors.white,

//                             image: DecorationImage(
//                               fit: BoxFit.fill,
//                               image: imageUrl.isEmpty
//                                   ? AssetImage("assets/images/logo.png")
//                                   : NetworkImage(Constant.Base_Imageurl +
//                                       bannerSlider[1].img),
//                             ),
//                             borderRadius: BorderRadius.circular(10),

//                             color: Colors.white,
//                           ),
//                         )
//                       : Container(),

                  /* Container(
                            height: 500,
                            width: 200,
                            color:Color(0xFFf2f2f2),
                          ),*/
                ],
              ),
              // Builds 1000 ListTiles
              childCount: 1,
            ),
          ),
        ]));
  }

  /*Showpop(){
    showDialog(
      barrierDismissible: false, // JUST MENTION THIS LINE
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(5.0),
                child:  Container(
                  height: 110.0,
                  width: 320.0,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding:  EdgeInsets.all(5.0),
                          child: Text("New Version is avaliable on Playstore",style: TextStyle(fontSize: 18,color: Colors.black),)
                      ),
//          Padding(
//              padding:  EdgeInsets.all(10.0),
//              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
//          ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          (_updateInfo.availableVersionCode-valcgeck)<3? FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel !', style: TextStyle(color: AppColors.black, fontSize: 18.0),)):Row(),

                          FlatButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                // _launchURL();
                              },
                              child: Text('Update ', style: TextStyle(color: AppColors.green, fontSize: 18.0),)),

                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }*/

//  showDilogue(BuildContext context) {
//    Dialog errorDialog = Dialog(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//      //this right here
//      child: Container(
//        height: 160.0,
//        width: 300.0,
//
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Padding(
//                padding: EdgeInsets.all(10.0),
//                child: Text("New Version is avaliable on Playstore",
//                  style: TextStyle(fontSize: 18, color: Colors.black),)
//            ),
////          Padding(
////              padding:  EdgeInsets.all(10.0),
////              child: Text('${_updateInfo.availableVersionCode}',style: TextStyle(fontSize: 18,color: Colors.black),)
////          ),
//
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('Cancel !', style: TextStyle(
//                        color: AppColors.black, fontSize: 18.0),)),
//
//                FlatButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                      _launchURL();
//                    },
//                    child: Text('Update Now ', style: TextStyle(
//                        color: AppColors.green, fontSize: 18.0),)),
//
//              ],
//            )
//          ],
//        ),
//      ),
//    );
//    showDialog(
//        context: context, builder: (BuildContext context) => errorDialog);
//  }

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(Constant.val);
    print(returnStr);
    return returnStr;
  }

  final DbProductManager dbmanager = DbProductManager();

  ProductsCart? products2;

//cost_price=buyprice
  void _addToproducts(
      String pID,
      String pName,
      String image,
      int price,
      int quantity,
      String cVal,
      String pSize,
      String pDisc,
      String sgst,
      String cgst,
      String discount,
      String disVal,
      String adminper,
      String adminperVal,
      String costPrice,
      String shippingcharge,
      String totalQun) {
    if (products2 == null) {
//      print(pID+"......");
//      print(p_name);
//      print(image);
//      print(price);
//      print(quantity);
//      print(c_val);
//      print(p_size);
//      print(p_disc);
//      print(sgst);
//      print(cgst);
//      print(discount);
//      print(dis_val);
//      print(adminper);
//      print(adminper_val);
//      print(cost_price);
      ProductsCart st = ProductsCart(
          pid: pID,
          pname: pName,
          pimage: image,
          pprice: (price * quantity).toString(),
          pQuantity: quantity,
          pcolor: cVal,
          psize: pSize,
          pdiscription: pDisc,
          sgst: sgst,
          cgst: cgst,
          discount: discount,
          discountValue: disVal,
          adminper: adminper,
          adminpricevalue: adminperVal,
          costPrice: costPrice,
          shipping: shippingcharge,
          totalQuantity: totalQun);
      dbmanager.insertStudent(st).then((id) => {
            showLongToast(" Products  is added to cart "),
            print(' Added to Db $id')
          });
    }
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    if (sgst.length > 1) {
      returnStr = discount.toString();
      double byprice1 = double.parse(byprice);
      print(sgst);

      double discount1 = double.parse(sgst);

      discount = ((byprice1 * discount1) / (100.0 + discount1));

      returnStr = discount.toStringAsFixed(2);
      print(returnStr);
      return returnStr;
    } else {
      return '0';
    }
  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.gharbazar';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
