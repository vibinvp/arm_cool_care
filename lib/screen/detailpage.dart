import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/BottomNavigation/wishlist.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/dbhelper/wishlistdart.dart';
import 'package:arm_cool_care/model/Gallerymodel.dart';
import 'package:arm_cool_care/model/GroupProducts.dart';
import 'package:arm_cool_care/model/Varient.dart';
import 'package:arm_cool_care/model/aminities_model.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:arm_cool_care/screen/Zoomimage.dart';
import 'package:arm_cool_care/screen/detailpage1.dart';
import 'package:arm_cool_care/screen/secondtabview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final Products plist;

  const ProductDetails(this.plist, {super.key});

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

class ProductDetailsState extends State<ProductDetails> {
  List<PVariant> pvarlist = [];
  AmenitiesModel amenitiesModel = AmenitiesModel();
  int? _selectedIndex;

  String name = "";
  String sharableProductName = "";
  String sharableProductId = "";

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Select Variant'),
            content: SizedBox(
              width: double.maxFinite,
              height: pvarlist.length * 50.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: pvarlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: pvarlist.isNotEmpty ? 130.0 : 230.0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            total = int.parse(pvarlist[index].price.toString());
                            String mrpPrice = calDiscount(
                                pvarlist[index].price.toString(),
                                pvarlist[index].discount.toString());
                            totalmrp = double.parse(mrpPrice);
                            textval = pvarlist[index].variant.toString();
                            name = pvarlist[index].variant.toString();
                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                pvarlist[index].variant.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            Divider(
                              color: AppColors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  int _current = 0;
  bool flag = true;
  int? wishid;
  bool wishflag = true;
  String url = "";
  String textval = "Select varient";

  // List<Products> products1 = List();
  List<Products> topProducts1 = [];

  final List<String> imgList1 = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final List<String> _currencies = ['ram', 'mohan'];
  final int _count = 1;
  String? _dropDownValue;
  String? _dropDownValue2;
  String? _dropDownValue1, groupname = "";
  int? total;
  int? actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;

  List<Gallery> galiryImage1 = [];
  List<GroupProducts> group = [];
  List<Products> productdetails = [];
  List<String> size = [];
  List<String> color = [];
  List<String> catid = [];
  ProductsCart? products;
  WishlistsCart? nproducts;
  final DbProductManager dbmanager = DbProductManager();
  final DbProductManager1 dbmanager1 = DbProductManager1();

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.isLogin = false;
    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");
    setState(() {
      Constant.isLogin = ligin!;
      Constant.carditemCount = Count!;
      print("${Constant.carditemCount}itemCount");
    });
  }

  static List<WishlistsCart> prodctlist1 = [];

  // final DbProductManager1 dbmanager12 = new DbProductManager1();

  @override
  void initState() {
    super.initState();
    name = widget.plist.productName!;
    gatinfoCount();
    print(' product id ${widget.plist.productIs}');

    getPvarient(widget.plist.productIs.toString()).then((usersFromServe) {
      setState(() {
        pvarlist = usersFromServe!;
      });
    });
    getAmenities();

    dbmanager1.getProductList().then((usersFromServe) {
      setState(() {
        prodctlist1 = usersFromServe;
        for (var i = 0; i < prodctlist1.length; i++) {
          if (prodctlist1[i].pid == widget.plist.productIs) {
            wishid = prodctlist1[i].id;
            wishflag = false;
          }
        }
      });
    });

    catid = widget.plist.productLine!.split(',');
    size = widget.plist.productScale!.split(',');
    color = widget.plist.productColor!.split(',');

    DatabaseHelper.getImage(widget.plist.productIs.toString())
        .then((usersFromServe) {
      setState(() {
        galiryImage1 = usersFromServe!;
        imgList1.clear();
        for (var i = 0; i < galiryImage1.length; i++) {
          imgList1.add(galiryImage1[i].img.toString());
        }
      });
    });

    GroupPro(widget.plist.productIs.toString()).then((usersFromServe) {
      if (mounted) {
        setState(() {
          group = usersFromServe!;
          print(group != null);
          groupname = group[0].name;
          print("${group}group info");
        });
      }
    });
    catby_productData(catid.isNotEmpty ? catid[0] : "0", "0")
        .then((usersFromServe) {
      setState(() {
        topProducts1 = usersFromServe!;
      });
    });

    setState(() {
      actualprice = int.parse(widget.plist.buyPrice.toString());
      total = actualprice;
      url = widget.plist.img!;
      String mrpPrice = calDiscount(
          widget.plist.buyPrice.toString(), widget.plist.discount.toString());
      totalmrp = double.parse(mrpPrice);

      dicountValue = double.parse(widget.plist.buyPrice.toString()) - totalmrp!;
      String gstSgst =
          calGst(totalmrp.toString(), widget.plist.sgst.toString());
      String gstCgst =
          calGst(totalmrp.toString(), widget.plist.cgst.toString());

      sgst1 = double.parse(gstSgst);
      cgst1 = double.parse(gstCgst);
    });
  }

  bool showdis = false;

  Future<void> getAmenities() async {
    await DatabaseHelper.getAmenities(widget.plist.productIs.toString())
        .then((value) {
      amenitiesModel = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gatinfoCount();
    });
    return Scaffold(
      // backgroundColor: AppColors.tela1,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        foregroundColor: Colors.black,
        backgroundColor: AppColors.tela,
        title: Text(
          "Product Details",
          style: TextStyle(color: AppColors.black),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishList()),
              );
            },
            child: Stack(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 40, top: 17),
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
//                showCircle(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 18),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.homeiconcolor,
                      ),
                      child: Text('${Constant.carditemCount}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15.0)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      body: Container(
        child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      imgList1 != null
                          ? imgList1.isNotEmpty
                              ? SizedBox(
                                  height: 280,
                                  // height: MediaQuery.of(context).size.height/2.6,
                                  child: CarouselSlider.builder(
                                      itemCount: imgList1.length,
                                      options: CarouselOptions(
                                          height: 280,
                                          aspectRatio: 0.5,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          }),
                                      itemBuilder: (ctx, index, realIdx) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ZoomImage(imgList1)),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.tela,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Container(
                                                width: 300,
                                                margin:
                                                    const EdgeInsets.all(1.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  child:
                                                      /*Image.network(
                                                Constant.Product_Imageurl+imgUrl,
                                                  fit: BoxFit.fill,
                                              ),*/
                                                      CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: Constant
                                                            .Product_Imageurl2 +
                                                        imgList1[index],
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                )),
                                          ),
                                        );
                                      }))
                              : const Row()
                          : const Row(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: map<Widget>(imgList1, (index, url) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, top: 8),
                              child: Container(
                                width: 25.0,
                                height: 0.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 12.0),
                                child: Divider(
                                  height: 10,
                                  color: _current == index
                                      ? AppColors.tela
                                      : AppColors.darkGray,
                                  thickness: 3.0,
//                                  endIndent: 30.0,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 90,
                            width: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.tela,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: imgList1.isNotEmpty
                                  ? Image.network(
                                      Constant.Product_Imageurl2 +
                                          imgList1.first,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, top: 20),
                            height: 70,
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 11, top: 10, right: 50),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              margin: const EdgeInsets.only(right: 5),
                              height: 30,
                              width: 90,
                              child: Center(
                                child: Text(
                                  '\u{20B9} ${(total! - totalmrp!) * _count} Off',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 1),
                              child: Text('\u{20B9} $total',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0, left: 10, bottom: 1),
                              child: Text(
                                  '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(Constant.val)}',
//                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                      pvarlist.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    "Variant:",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: pvarlist.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                total = int.parse(
                                                    pvarlist[index]
                                                        .price
                                                        .toString());
                                                String mrpPrice = calDiscount(
                                                    pvarlist[index]
                                                        .price
                                                        .toString(),
                                                    pvarlist[index]
                                                        .discount
                                                        .toString());
                                                totalmrp =
                                                    double.parse(mrpPrice);
                                                textval = pvarlist[index]
                                                    .variant
                                                    .toString();
                                                name = pvarlist[index]
                                                    .variant
                                                    .toString();
                                                _selectedIndex = index;
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              decoration: BoxDecoration(
                                                color: _selectedIndex == index
                                                    ? AppColors.tela
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: AppColors.tela),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  pvarlist[index]
                                                      .variant
                                                      .toString(),
                                                  style: TextStyle(
                                                    color:
                                                        _selectedIndex == index
                                                            ? AppColors.white
                                                            : AppColors.black,
                                                  ),
                                                ),
                                              )),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ))
                          : Container(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.only(left: 10, right: 20),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              widget.plist.productColor!.length < 2
                                  ? Container(
                                      height: 5,
                                    )
                                  : Container(),
                              widget.plist.productColor!.length < 2
                                  ? Container()
                                  : SizedBox(
                                      width: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: DropdownButton(
                                          elevation: 0,
                                          hint: _dropDownValue == null
                                              ? const Text('Select color')
                                              : Text(
                                                  _dropDownValue!,
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0,
                                          style: const TextStyle(
                                              color: Colors.blue),
                                          items: color.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Text(val),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                _dropDownValue = val;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: widget.plist.productScale!.length < 2
                                    ? Container()
                                    : SizedBox(
                                        width: 120,
                                        child: DropdownButton(
                                          hint: _dropDownValue1 == null
                                              ? const Text('Select Size')
                                              : Text(
                                                  _dropDownValue1!,
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                ),
                                          isExpanded: true,
                                          iconSize: 30.0,
                                          style: const TextStyle(
                                              color: Colors.blue),
                                          items: size.map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Text(val),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                _dropDownValue1 = val;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                              )
                            ]),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Price :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " \u{20B9} ${(totalmrp! * _count).toStringAsFixed(0)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.sellp),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 3.0),
                                height: 35,
                                child: Material(
                                  color: AppColors.tela,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: AppColors.tela),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      if (Constant.isLogin) {
                                        if (widget.plist.productColor!.length >
                                                2 &&
                                            widget.plist.productScale!.length >
                                                2) {
                                          addTocardval(false);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        } else if (widget
                                                .plist.productColor!.length >
                                            2) {
                                          addTocardval(false);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        } else if (widget
                                                .plist.productScale!.length >
                                            2) {
                                          addTocardval(false);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        } else {
                                          addTocardval(false);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        }

//                                                      if(widget.plist.productColor.length>1 && widget.plist.productScale.length>1 ){
//                                                        if(_dropDownValue!=null&&_dropDownValue1!=null) {
////
//                                                          _addToproducts(context);
//                                                          Scaffold.of(context)
//                                                              .showSnackBar(
//                                                              SnackBar(
//                                                                  content: Text(
//                                                                      " Products  is added to cart "),
//                                                                  duration: Duration(
//                                                                      seconds: 1)));
//                                                          setState(() {
//                                                            Constant.itemcount++;
//
////                                                  print( Constant.totalAmount);
//
//                                                          });
////                                                      }
//                                                        } else{
//                                                          showLongToast("Please Select color & Size");
//                                                        }
//                                                      }
//                                                      else{
//
//                                                        addTocardval();
////                                                        _addToproducts(context);
////                                                        Scaffold.of(context)
////                                                            .showSnackBar(
////                                                            SnackBar(
////                                                                content: Text(
////                                                                    " Products  is added to cart "),
////                                                                duration: Duration(
////                                                                    seconds: 1)));
//                                                      }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }

//                                                    Navigator.push(
//                                                      context,
//                                                      MaterialPageRoute(builder: (context) => DeliveryInfo()),
//                                                    );
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            top: 5,
                                            bottom: 5,
                                            right: 8),
                                        child: Center(
                                          child: Text(
                                            "Add to Cart",
                                            style: TextStyle(
                                                color: AppColors.black),
                                          ),
                                        )),
                                  ),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 3.0),
                                height: 35,
                                child: Material(
                                  color: AppColors.tela1,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: AppColors.tela1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      if (Constant.isLogin) {
                                        if (widget.plist.productColor!.length >
                                                2 &&
                                            widget.plist.productScale!.length >
                                                2) {
                                          addTocardval(true);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        } else if (widget
                                                .plist.productColor!.length >
                                            2) {
                                          addTocardval(true);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        } else if (widget
                                                .plist.productScale!.length >
                                            2) {
                                          addTocardval(true);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        } else {
                                          addTocardval(true);
                                          Constant.carditemCount++;
                                          cartItemcount(Constant.carditemCount);
                                        }

//                                                      if(widget.plist.productColor.length>1 && widget.plist.productScale.length>1 ){
//                                                        if(_dropDownValue!=null&&_dropDownValue1!=null) {
////
//                                                          _addToproducts(context);
//                                                          Scaffold.of(context)
//                                                              .showSnackBar(
//                                                              SnackBar(
//                                                                  content: Text(
//                                                                      " Products  is added to cart "),
//                                                                  duration: Duration(
//                                                                      seconds: 1)));
//                                                          setState(() {
//                                                            Constant.itemcount++;
//
////                                                  print( Constant.totalAmount);
//
//                                                          });
////                                                      }
//                                                        } else{
//                                                          showLongToast("Please Select color & Size");
//                                                        }
//                                                      }
//                                                      else{
//
//                                                        addTocardval();
////                                                        _addToproducts(context);
////                                                        Scaffold.of(context)
////                                                            .showSnackBar(
////                                                            SnackBar(
////                                                                content: Text(
////                                                                    " Products  is added to cart "),
////                                                                duration: Duration(
////                                                                    seconds: 1)));
//                                                      }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()),
                                        );
                                      }

//                                                    Navigator.push(
//                                                      context,
//                                                      MaterialPageRoute(builder: (context) => DeliveryInfo()),
//                                                    );
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            top: 5,
                                            bottom: 5,
                                            right: 8),
                                        child: Center(
                                          child: Text(
                                            "Book Now",
                                            style: TextStyle(
                                                color: AppColors.black),
                                          ),
                                        )),
                                  ),
                                )),
//                             wishflag
//                                 ? InkWell(
//                                     onTap: () {
//                                       if (Constant.isLogin) {
//                                         _addToproducts1(context);
//                                         Scaffold.of(context).showSnackBar(SnackBar(
//                                             content: Text(
//                                                 " Product added to the wishlist "),
//                                             duration: Duration(seconds: 1)));
//                                         setState(() {
//                                           Constant.wishlist++;
//                                           _countList(Constant.wishlist);

// //                                                  print( Constant.totalAmount);
//                                           wishflag = false;
//                                         });
//                                       } else {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   SignInPage()),
//                                         );
//                                       }
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(left: 3.0),
//                                       height: 33,
//                                       width: 45,
//                                       // child: Icon(Icons.favorite_border,
//                                       //     size: 30, color: Colors.red),
//                                     ),
//                                   )
//                                 : InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         dbmanager1.deleteProducts(wishid);
//                                         wishflag = true;
//                                       });
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(left: 3.0),
//                                       height: 33,
//                                       width: 45,
//                                       child: Icon(Icons.favorite,
//                                           size: 30, color: AppColors.pink),
//                                     ),
//                                   ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          if (showdis) {
                            setState(() {
                              showdis = false;
                            });
                          } else {
                            setState(() {
                              showdis = true;
                            });
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 14.0,
                                ),
                                child: Text(
                                  'Product Details:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 5.0),
                                  child: Icon(
                                      showdis
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,

//                                        Icons.keyboard_arrow_down,
                                      size: 30,
                                      color: AppColors.black))
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      showdis
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: amenitiesModel
                                          .data!.customFieldsValue!.length,
                                      itemBuilder: (context, index) {
                                        final name = amenitiesModel
                                            .data!
                                            .customFieldsValue![index]
                                            .fieldsName;
                                        final value = amenitiesModel
                                            .data!
                                            .customFieldsValue![index]
                                            .fieldValue;
                                        final key = name!
                                            .substring(0, name.indexOf(','))
                                            .replaceAll("_", " ");

                                        print(
                                            "amenitiesModel.data.customFieldsValue.length--> ${amenitiesModel.data!.customFieldsValue!.length}");
                                        return _amenitiesCard(
                                            key: key, value: value.toString());
                                      }),
                                ),
                                // discription(
                                //     "Warranty: ", widget.plist.warrantys),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.only(
                                //           left: 16.0, top: 8.0),
                                //       child: Text(
                                //         "Return: ",
                                //         overflow: TextOverflow.fade,
                                //         style: new TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 15.0,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.only(
                                //           left: 16.0, top: 8.0),
                                //       child: Text(
                                //         widget.plist.returns == "0"
                                //             ? "No"
                                //             : widget.plist.returns + "day",
                                //         overflow: TextOverflow.fade,
                                //         style: new TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 14.0,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
//                             discription("Return: ",widget.plist.returns),
                                // discription(
                                //     "Brand: ", widget.plist.productVendor),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: <Widget>[
                                //     Padding(
                                //       padding: const EdgeInsets.only(
                                //           left: 16.0, top: 8.0),
                                //       child: Text(
                                //         "Cancel: ",
                                //         overflow: TextOverflow.fade,
                                //         style: new TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 15.0,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.only(
                                //           left: 16.0, top: 8.0),
                                //       child: Text(
                                //         widget.plist.cancels == "0"
                                //             ? "No"
                                //             : widget.plist.cancels + "day",
                                //         overflow: TextOverflow.fade,
                                //         style: new TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 14.0,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
//                             discription("Cancel: ",widget.plist.cancels),
//                             discription("Delivery: ",widget.plist.cancels),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    _parseHtmlString(widget
                                        .plist.productDescription
                                        .toString()),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
//                             Padding(
//                                padding: const EdgeInsets.only(left:16.0,top: 8.0),
//                                child:  Text(widget.plist.productDescription,
//                                  overflow: TextOverflow.fade,
//                                  style: new TextStyle(
//                                    color: Colors.black,
//                                    fontSize: 14.0,
//                                  ),
//                                ),
//                              ),
                              ],
                            )
                          : Container(),
                      group == null
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                group != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 8.0),
                                        child: Text(
                                          groupname.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const Row(),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  height: 78.0,
                                  child: group != null
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: group.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return group[index].img!.length > 2
                                                ? SizedBox(
                                                    width: 70.0,
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: InkWell(
                                                        onTap: () {
//                                              setState(() {
//
//                                                url=imgList1[index];
//                                                showLongToast("Product is selected ");
//                                              });
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductDetails1(group[
                                                                            index]
                                                                        .productIs
                                                                        .toString())),
                                                          );
//
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            group[index]
                                                                        .img!
                                                                        .length >
                                                                    2
                                                                ? SizedBox(
                                                                    height: 70,
                                                                    child: Image
                                                                        .network(
                                                                      Constant.Product_Imageurl1 +
                                                                          group[index]
                                                                              .img
                                                                              .toString(),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                    /*  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:Constant.Product_Imageurl1+group[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                    placeholder: (context, url) =>
                                                        Center(
                                                            child:
                                                            CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                    new Icon(Icons.error),

                                                  ),*/
                                                                    )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const Row();
                                          })
                                      : const CircularProgressIndicator(),
                                ),
                              ],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 14.0, right: 8.0),
                            child: Text(
                              '  RELATED SERVICES',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 8.0, left: 5.0),
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                  AppColors.tela,
                                )),
                                // color: AppColors.tela,
                                child: const Text('View All',
                                    style: TextStyle(color: AppColors.black)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Screen2(
                                            catid.isNotEmpty ? catid[0] : "0",
                                            "RELATED PRODUCTS")),
                                  );
                                }),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          height: 210.0,
                          child: topProducts1 != null
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topProducts1.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: topProducts1[index] != 0
                                          ? 155.0
                                          : 230.0,
                                      // decoration: BoxDecoration(
                                      //   color: AppColors.tela,
                                      //   borderRadius: BorderRadius.circular(8),
                                      // ),
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                            color: AppColors.tela,
                                          ),
                                        ),
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
//
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 150,
//                                            width: 162,

                                                    child: topProducts1[index]
                                                                .img !=
                                                            null
                                                        ? ClipRRect(
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                            child:
                                                                Image.network(
                                                              Constant.Product_Imageurl +
                                                                  topProducts1[
                                                                          index]
                                                                      .img
                                                                      .toString(),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          )
                                                        /*  CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: Constant
                                                            .Product_Imageurl +
                                                            topProducts1[index].img,
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                        placeholder: (context, url) =>
                                                            Center(
                                                                child:
                                                                CircularProgressIndicator()),
                                                        errorWidget:
                                                            (context, url, error) =>
                                                        new Icon(Icons.error),

                                                      )*/
                                                        : Image.asset(
                                                            "assets/images/logo.png"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5, top: 5),
                                                padding: const EdgeInsets.only(
                                                    left: 3, right: 5),
                                                color: AppColors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      topProducts1[index]
                                                          .productName
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '(\u{20B9} ${topProducts1[index].buyPrice})',
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
                                                              fontSize: 12,
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
                                                                  left: 10),
                                                          child: Text(
                                                              '\u{20B9} ${calDiscount(topProducts1[index].buyPrice.toString(), topProducts1[index].discount.toString())}',
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      12)),
                                                        ),
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
                                  })
                              : const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              ),
            ])),
      ),
    );
  }

//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;
  void _addToproducts(BuildContext context) {
    if (products == null) {
      print("${totalmrp! * _count}............");
      ProductsCart st = ProductsCart(
          pid: widget.plist.productIs,
          pname: widget.plist.productName,
          pimage: url,
          pprice: (totalmrp! * _count).toString(),
          pQuantity: _count,
          pcolor: _dropDownValue ?? "",
          psize: _dropDownValue1 ?? "",
          pdiscription: widget.plist.productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: widget.plist.discount,
          discountValue: dicountValue.toString(),
          adminper: widget.plist.msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: widget.plist.shipping,
          totalQuantity: widget.plist.quantityInStock,
          varient: textval,
          mv: int.parse(widget.plist.mv.toString()),
          date1: '',
          time1: '',
          moq: '',
          id: null);
      dbmanager
          .insertStudent(st)
          .then((id) => {print('Student Added to Db $id')});
    }
  }

  void _buyNow(BuildContext context) {
    if (products == null) {
      print("${totalmrp! * _count}............");
      ProductsCart st = ProductsCart(
          pid: widget.plist.productIs,
          pname: widget.plist.productName,
          pimage: url,
          pprice: (totalmrp! * _count).toString(),
          pQuantity: _count,
          pcolor: _dropDownValue ?? "",
          psize: _dropDownValue1 ?? "",
          pdiscription: widget.plist.productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: widget.plist.discount,
          discountValue: dicountValue.toString(),
          adminper: widget.plist.msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: widget.plist.shipping,
          totalQuantity: widget.plist.quantityInStock,
          varient: textval,
          mv: int.parse(widget.plist.mv.toString()),
          date1: '',
          id: null,
          moq: '',
          time1: '');

      dbmanager
          .insertStudent(st)
          .then((id) => {print('Student Added to Db $id')});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishList(),
        ),
      );
    }
  }

  void _addToproducts1(BuildContext context) {
    if (nproducts == null) {
      WishlistsCart st1 = WishlistsCart(
          pid: widget.plist.productIs,
          pname: widget.plist.productName,
          pimage: url,
          pprice: totalmrp.toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: widget.plist.productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: widget.plist.discount,
          discountValue: dicountValue.toString(),
          adminper: widget.plist.msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: widget.plist.buyPrice,
          id: null);

      dbmanager1.insertStudent(st1).then((id) => {
            setState(() {
              wishid = id;

              print('Student Added to Db $wishid');
              print(Constant.totalAmount);
            })
          });
    }
  }

  // shareProduct(String url, String title, String price) async {
  //   // /* var request = await HttpClient().getUrl(Uri.parse(url??'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
  //   // var response = await request.close();
  //   // Uint8List bytes = await consolidateHttpClientResponseBytes(response);*/
  //   await Share.text("my text title", price, "text/plain");
  // }

  _amenitiesCard({String? key, String? value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$key:",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            value.toString(),
            softWrap: true,
            style: _discriptionText(),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  TextStyle _discriptionText() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    );
  }

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

  void addTocardval(bool buyNow) {
    if (int.parse(widget.plist.quantityInStock.toString()) > 0) {
      buyNow ? _buyNow(context) : _addToproducts(context);
      showLongToast(" Product added to the cart ");

      setState(() {
        Constant.itemcount++;

//                                                  print( Constant.totalAmount);
      });
    } else {
      showLongToast("Product is out of stock");
    }
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _countList(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("wcount", val);
  }

  Widget discription(String name, String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              name,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                Discription ?? "",
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
