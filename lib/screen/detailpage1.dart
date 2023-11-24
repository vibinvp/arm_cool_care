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
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:arm_cool_care/screen/Zoomimage.dart';
import 'package:arm_cool_care/screen/detailpage.dart';
import 'package:arm_cool_care/screen/secondtabview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails1 extends StatefulWidget {
  final String id;
  const ProductDetails1(this.id, {super.key});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails1> {
  List<PVariant> pvarlist = [];
  String name = "";
  String textval = "Select varient";
  _displayDialog(BuildContext context, int position) async {
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
                  itemCount: pvarlist.isEmpty ? 0 : pvarlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: pvarlist[index] != 0 ? 130.0 : 230.0,
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
                            // imgList1[position].

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

  final int _current = 0;
  bool flag = true;
  bool wishflag = true;
  int? wishid;
  String? url;
  List<Products> products1 = [];
  List<String> catid = [];

  final List<String> imgList1 = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  ];
  List<GroupProducts> group = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _count = 1;
  String? _dropDownValue, groupname = "";
  String? _dropDownValue1;
  int? total;
  int actualprice = 200;
  double? mrp, totalmrp;
  double? sgst1, cgst1, dicountValue, admindiscountprice;
  List<String> size = [];
  List<String> color = [];

  List<Gallery> galiryImage1 = [];
  List<Products> productdetails = [];
  ProductsCart? products;
  Products? prod;
  final DbProductManager dbmanager = DbProductManager();

//  DatabaseHelper helper = DatabaseHelper();
//  Note note ;

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    bool? ligin = pref.getBool("isLogin");

    setState(() {
      Constant.isLogin = ligin!;

      Constant.carditemCount = Count!;
      //      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  String? id;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      gatinfoCount();
      productdetail(widget.id).then((usersFromServe) {
        setState(() {
          productdetails = usersFromServe!;
          if (productdetails.isNotEmpty) {
            setState(() {
              url = productdetails[0].img;
              id = productdetails[0].productIs;
              actualprice = int.parse(productdetails[0].buyPrice.toString());
              total = actualprice;

              String mrpPrice = calDiscount(
                  productdetails[0].buyPrice.toString(),
                  productdetails[0].discount.toString());
              totalmrp = double.parse(mrpPrice);

              String adiscount = calDiscount(
                  productdetails[0].buyPrice.toString(),
                  productdetails[0].msrp.toString());
              admindiscountprice =
                  (double.parse(productdetails[0].buyPrice.toString()) -
                      double.parse(adiscount));
              dicountValue =
                  double.parse(productdetails[0].buyPrice.toString()) -
                      totalmrp!;
              String gstSgst = calGst(
                  totalmrp.toString(), productdetails[0].sgst.toString());
              String gstCgst = calGst(
                  totalmrp.toString(), productdetails[0].cgst.toString());
              color = productdetails[0].productColor!.split(',');
              size = productdetails[0].productScale!.split(',');

              sgst1 = double.parse(gstSgst);
              cgst1 = double.parse(gstCgst);
              print(productdetails[0].productLine.toString() + "product id");
              catid = productdetails[0].productLine!.split(',');
              catby_productData(catid.isNotEmpty ? catid[0] : "0", "0")
                  .then((usersFromServe) {
                setState(() {
                  products1 = usersFromServe!;
                });
              });

              GroupPro(productdetails[0].productIs.toString())
                  .then((usersFromServe) {
                setState(() {
                  group = usersFromServe!;
                  group != null ? groupname = group[0].name : groupname = "";
                });
              });

              dbmanager1.getProductList().then((usersFromServe) {
                setState(() {
                  prodctlist1 = usersFromServe;
                  for (var i = 0; i < prodctlist1.length; i++) {
                    if (prodctlist1[i].pid == id) {
                      wishflag = false;
                      wishid = prodctlist1[i].id;
                      break;
                    }
                  }
                });
              });
            });
          }
        });
      });
      DatabaseHelper.getImage(widget.id).then((usersFromServe) {
        setState(() {
          galiryImage1 = usersFromServe!;
          imgList1.clear();
          for (var i = 0; i < galiryImage1.length; i++) {
            imgList1.add(galiryImage1[i].img.toString());
          }
        });
      });

      getPvarient(widget.id).then((usersFromServe) {
        setState(() {
          pvarlist = usersFromServe!;
        });
      });
    });
  }

  bool showdis = false;

  static List<WishlistsCart> prodctlist1 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
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
                ),
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
                                  height: 200,
                                  // height: MediaQuery.of(context).size.height/2.6,
                                  child: CarouselSlider.builder(
                                      itemCount: imgList1.length,
                                      options: CarouselOptions(
                                        height: 200,
                                        aspectRatio: 1.5,
                                        enlargeCenterPage: true,
                                        autoPlay: true,
                                      ),
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
                                                height: 270,
                                                width: 400,
                                                margin:
                                                    const EdgeInsets.all(4.0),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: map<Widget>(imgList1, (index, url) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 120, top: 5),
                            child: Container(
                              width: 25.0,
                              height: 0.0,

                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 7.0),

                              child: Divider(
                                height: 20,
                                color: _current == index
                                    ? AppColors.tela
                                    : AppColors.darkGray,

                                thickness: 2.0,
//                                  endIndent: 30.0,
                              ),
//                                decoration: BoxDecoration(
//                                  shape: BoxShape.rectangle,
//                                  color: _current == index ? Colors.orange : Colors.grey,
//                                ),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 5, left: 15),
                        child: Text(name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 18, top: 10, right: 50),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 1),
                              child: Text('\u{20B9} $total',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
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
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: productdetail(widget.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data?.length,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  Products item = snapshot.data![index];
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: map<Widget>(imgList1,
                                              (index, url) {
                                            return Container(
                                              width: 25.0,
                                              height: 0.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 7.0),
                                              child: Container(),
//                                decoration: BoxDecoration(
//                                  shape: BoxShape.rectangle,
//                                  color: _current == index ? Colors.orange : Colors.grey,
//                                ),
                                            );
                                          }),
                                        ),

//                          productName1(),

                                        Container(
//                        height: 90,

                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),

                                          margin: const EdgeInsets.only(
                                              left: 10, right: 20),
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                // item.productColor.length<2?Container():  Container(
                                                //   width: 60,
                                                //   height: 25,
                                                //   decoration:BoxDecoration(
                                                //
                                                //     borderRadius: BorderRadius.circular(15),
                                                //     color: Colors.red,
                                                //   ),
                                                //   child: Text(""),
                                                // ) ,

                                                item.productColor!.length < 2
                                                    ? Container()
                                                    : SizedBox(
                                                        width: 120,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: DropdownButton(
                                                            elevation: 0,
                                                            hint: _dropDownValue ==
                                                                    null
                                                                ? const Text(
                                                                    'Select color')
                                                                : Text(
                                                                    _dropDownValue!,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                            isExpanded: true,
                                                            iconSize: 30.0,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                            items: color.map(
                                                              (val) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: val,
                                                                  child:
                                                                      Text(val),
                                                                );
                                                              },
                                                            ).toList(),
                                                            onChanged: (val) {
                                                              setState(
                                                                () {
                                                                  _dropDownValue =
                                                                      val;
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: item.productScale!
                                                              .length <
                                                          2
                                                      ? Container()
                                                      : SizedBox(
                                                          width: 120,
                                                          child: DropdownButton(
                                                            hint: _dropDownValue1 ==
                                                                    null
                                                                ? const Text(
                                                                    'Select Size')
                                                                : Text(
                                                                    _dropDownValue1!,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                            isExpanded: true,
                                                            iconSize: 30.0,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                            items: size.map(
                                                              (val) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: val,
                                                                  child:
                                                                      Text(val),
                                                                );
                                                              },
                                                            ).toList(),
                                                            onChanged: (val) {
                                                              setState(
                                                                () {
                                                                  _dropDownValue1 =
                                                                      val;
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                )
                                              ]),
                                        ),

                                        // SizedBox(height: 15,),

                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 0.0, right: 30),
                                          child: Row(children: <Widget>[
                                            const SizedBox(
                                              width: 0.0,
                                              height: 10.0,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 15),
                                                        height: 33,
                                                        width: 40,
                                                        child: Material(
                                                          color: AppColors.tela,
                                                          elevation: 0.0,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  2),
                                                            ),
                                                          ),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: InkWell(
                                                              onTap: () {
                                                                if (_count !=
                                                                    1) {
                                                                  setState(() {
                                                                    _count--;
//                                                        totalmrp=mrp * _count;
                                                                  });
                                                                }
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 10.0,
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .maximize,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )),
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0,
                                                              left: 10.0,
                                                              right: 8.0),
                                                      child: Center(
                                                        child: Text('$_count',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 19,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 3.0),
                                                        height: 33,
                                                        width: 40,
                                                        child: Material(
                                                          color: AppColors.tela,
                                                          elevation: 0.0,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  2),
                                                            ),
                                                          ),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (_count <=
                                                                  int.parse(item
                                                                      .quantityInStock
                                                                      .toString())) {
                                                                print(item
                                                                    .quantityInStock);
                                                                setState(() {
                                                                  print(_count);
                                                                  _count++;
//                                                     totalmrp=mrp * _count;
                                                                });
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                " Products  is not avaliable "),
                                                                        duration:
                                                                            Duration(seconds: 1)));
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 30,
                                                              color: AppColors
                                                                  .black,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    const SizedBox(width: 10),
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 3.0),
                                                        height: 35,
                                                        child: Material(
                                                          color: AppColors.tela,
                                                          elevation: 0.0,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (Constant
                                                                  .isLogin) {
//
                                                                if (item.productColor!
                                                                            .length >
                                                                        0 &&
                                                                    item.productScale!
                                                                            .length >
                                                                        0) {
                                                                  if (int.parse(item
                                                                          .quantityInStock
                                                                          .toString()) >
                                                                      0) {
                                                                    _addToproducts(
                                                                        context);
                                                                    Constant
                                                                        .carditemCount++;
                                                                    cartItemcount(
                                                                        Constant
                                                                            .carditemCount);
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                " Products  is added to cart "),
                                                                        duration:
                                                                            Duration(seconds: 1)));
                                                                    setState(
                                                                        () {
                                                                      Constant
                                                                          .itemcount++;

//                                                  print( Constant.totalAmount);
                                                                    });
                                                                  } else {
                                                                    showLongToast(
                                                                        "Product is out of stock");
                                                                  }
                                                                } else if (item
                                                                        .productColor!
                                                                        .length >
                                                                    2) {
                                                                  if (int.parse(item
                                                                          .quantityInStock
                                                                          .toString()) >
                                                                      0) {
                                                                    _addToproducts(
                                                                        context);
                                                                    Constant
                                                                        .carditemCount++;
                                                                    cartItemcount(
                                                                        Constant
                                                                            .carditemCount);
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                " Products  is added to cart "),
                                                                        duration:
                                                                            Duration(seconds: 1)));
                                                                    setState(
                                                                        () {
                                                                      Constant
                                                                          .itemcount++;

//                                                  print( Constant.totalAmount);
                                                                    });
                                                                  } else {
                                                                    showLongToast(
                                                                        "Product is out of stock");
                                                                  }
                                                                } else if (item
                                                                        .productScale!
                                                                        .length >
                                                                    2) {
                                                                  if (int.parse(item
                                                                          .quantityInStock
                                                                          .toString()) >
                                                                      0) {
                                                                    _addToproducts(
                                                                        context);
                                                                    Constant
                                                                        .carditemCount++;
                                                                    cartItemcount(
                                                                        Constant
                                                                            .carditemCount);
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                " Products  is added to cart "),
                                                                        duration:
                                                                            Duration(seconds: 1)));
                                                                    setState(
                                                                        () {
                                                                      Constant
                                                                          .itemcount++;

//                                                  print( Constant.totalAmount);
                                                                    });
                                                                  } else {
                                                                    showLongToast(
                                                                        "Product is out of stock");
                                                                  }
                                                                } else {
                                                                  if (int.parse(item
                                                                          .quantityInStock
                                                                          .toString()) >
                                                                      0) {
                                                                    _addToproducts(
                                                                        context);
                                                                    Constant
                                                                        .carditemCount++;
                                                                    cartItemcount(
                                                                        Constant
                                                                            .carditemCount);
                                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                " Products  is added to cart "),
                                                                        duration:
                                                                            Duration(seconds: 1)));
                                                                    setState(
                                                                        () {
                                                                      Constant
                                                                          .itemcount++;

//                                                  print( Constant.totalAmount);
                                                                    });
                                                                  } else {
                                                                    showLongToast(
                                                                        "Product is out of stock");
                                                                  }
                                                                }
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SignInPage()),
                                                                );
                                                              }
                                                            },
                                                            child:
                                                                const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 8,
                                                                        top: 5,
                                                                        bottom:
                                                                            5,
                                                                        right:
                                                                            8),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Add to Bag",
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppColors.black),
                                                                      ),
                                                                    )),
                                                          ),
                                                        )),
                                                    wishflag
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (Constant
                                                                  .isLogin) {
                                                                _addToproducts1(
                                                                    context);

                                                                showLongToast(
                                                                    " Products  is added to wishlist ");

                                                                setState(() {
                                                                  wishflag =
                                                                      false;
                                                                  Constant
                                                                      .wishlist++;
                                                                  _countList(
                                                                      Constant
                                                                          .wishlist);

//                                                  print( Constant.totalAmount);
                                                                });
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const SignInPage()),
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          3.0),
                                                              height: 33,
                                                              width: 45,
                                                              child: const Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  size: 30,
                                                                  color:
                                                                      AppColors
                                                                          .pink),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                dbmanager1
                                                                    .deleteProducts(
                                                                        wishid!);
                                                                wishflag = true;
                                                              });
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          3.0),
                                                              height: 33,
                                                              width: 45,
                                                              child: const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  size: 30,
                                                                  color:
                                                                      AppColors
                                                                          .pink),
                                                            ),
                                                          ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ]),
                                        ),

                                        pvarlist.isNotEmpty
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0, top: 18.0),
                                                    child: Text(
                                                      ' Variant:',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              top: 8.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _displayDialog(
                                                              context, index);
                                                          // _showSelectionDialog(context);
                                                        },
                                                        child: Container(
                                                          // width: MediaQuery.of(context).size.width/1.5,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10.0,
                                                            top: 0.0,
                                                            right: 10.0,
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 5.0,
                                                          ),

                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),

                                                          child: Center(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Text(
                                                                  textval.length >
                                                                          20
                                                                      ? "${textval.substring(0, 20)}.."
                                                                      : textval,

                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  // maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: AppColors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .expand_more,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 30,
                                                                  ))
                                                            ],
                                                          )),
                                                        ),
                                                      )),

                                                  /*Container(
                                 color: AppColors.black,
                                   margin:EdgeInsets.only(left: 10,top: 10,right: 10) ,
                                   height: 45,
                                   child: Padding(
                                     padding: EdgeInsets.only(left: 0,top: 0,right: 0),
                                     child: TextField(
                                         minLines: 1,
                                         maxLines: 3,
                                         decoration: InputDecoration(
                                           prefixIcon: Icon(Icons.expand_more),
                                             hintText: "Select varient",
                                             border: OutlineInputBorder()
                                         )),))*/
                                                ],
                                              )
                                            : const Row(),

                                        const SizedBox(
                                          height: 20,
                                        ),

                                        Row(
                                          children: <Widget>[
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0, top: 8.0),
                                              child: Text(
                                                'Product Details:',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
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
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0, top: 8.0),
                                                  child: Icon(
                                                      showdis
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,

//                                        Icons.keyboard_arrow_down,
                                                      size: 30,
                                                      color: AppColors.black)),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        showdis
                                            ? Column(
                                                children: <Widget>[
                                                  // discription("Warranty: ",item.warrantys),

                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.start,
                                                  //   children: <Widget>[
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //                   .only(
                                                  //               left: 16.0,
                                                  //               top: 8.0),
                                                  //       child: Text(
                                                  //         "Return: ",
                                                  //         overflow:
                                                  //             TextOverflow.fade,
                                                  //         style: new TextStyle(
                                                  //           color: Colors.black,
                                                  //           fontSize: 15.0,
                                                  //           fontWeight:
                                                  //               FontWeight.bold,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //                   .only(
                                                  //               left: 16.0,
                                                  //               top: 8.0),
                                                  //       child: Text(
                                                  //         item.returns == "0"
                                                  //             ? "No"
                                                  //             : item.returns +
                                                  //                 "day",
                                                  //         overflow:
                                                  //             TextOverflow.fade,
                                                  //         style: new TextStyle(
                                                  //           color: Colors.black,
                                                  //           fontSize: 14.0,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
//                             discription("Return: ",widget.plist.returns),
//                                                 discription("Brand: ",item.productVendor),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.start,
                                                  //   children: <Widget>[
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //                   .only(
                                                  //               left: 16.0,
                                                  //               top: 8.0),
                                                  //       child: Text(
                                                  //         "Cancel: ",
                                                  //         overflow:
                                                  //             TextOverflow.fade,
                                                  //         style: new TextStyle(
                                                  //           color: Colors.black,
                                                  //           fontSize: 15.0,
                                                  //           fontWeight:
                                                  //               FontWeight.bold,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //                   .only(
                                                  //               left: 16.0,
                                                  //               top: 8.0),
                                                  //       child: Text(
                                                  //         item.cancels == "0"
                                                  //             ? "No"
                                                  //             : item.cancels +
                                                  //                 "day",
                                                  //         overflow:
                                                  //             TextOverflow.fade,
                                                  //         style: new TextStyle(
                                                  //           color: Colors.black,
                                                  //           fontSize: 14.0,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  discription1(item
                                                      .productDescription
                                                      .toString()),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                      group != null
                          ? Column(
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
                                                            SizedBox(
                                                                height: 70,
                                                                child: Image.network(
                                                                    Constant.Product_Imageurl1 +
                                                                        group[index]
                                                                            .img
                                                                            .toString(),
                                                                    fit: BoxFit
                                                                        .cover)
                                                                /*CachedNetworkImage(
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
                                                                ),
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
                            )
                          : const Row(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 11.0, right: 8.0),
                            child: Text(
                              'RELATED PRODUCTS',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 8.0, left: 8.0),
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        AppColors.tela)),
                                // color: AppColors.tela,
                                child: const Text('View All',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  print(catid.length);
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        height: 235.0,
                        child: products1 != null
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 150.0,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        products1[index])),
                                          );
//
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 165,
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    Constant.Product_Imageurl +
                                                        products1[index]
                                                            .img
                                                            .toString(),
//                                                  =="no-cover.png"? getImage(topProducts[index].productIs):topProducts[index].image,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 0, top: 5),
                                                padding: const EdgeInsets.only(
                                                    left: 3, right: 5),
                                                color: AppColors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      products1[index]
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
                                                          '(\u{20B9} ${products1[index].buyPrice})',
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
                                                              '\u{20B9} ${calDiscount(products1[index].buyPrice.toString(), products1[index].discount.toString())}',
                                                              style: TextStyle(
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
                                    ),
                                  );
                                })
                            : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              )
            ])),
      ),
    );
  }

  productName1() {
    actualprice = int.parse(productdetails[0].buyPrice.toString());
    total = actualprice;

    String mrpPrice = calDiscount(productdetails[0].buyPrice.toString(),
        productdetails[0].discount.toString());
    totalmrp = double.parse(mrpPrice);

    Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 10),
      child: Text(
          productdetails[0].productName.toString() == null
              ? productdetails[0].productName!.length.toString()
              : "sanjar",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  priceold() {
    Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
      child: Text('\u{20B9} $total',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AppColors.mrp,
              decoration: TextDecoration.lineThrough)),
    );
  }

  priceNew() {
    Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 1),
      child: Text(
          totalmrp != null
              ? '\u{20B9} ${(totalmrp! * _count).toStringAsFixed(2)}'
              : '1000',
//                              total.toString()==null?'\u{20B9} $total':actualprice.toString(),
          style: const TextStyle(
            color: AppColors.sellp,
            fontWeight: FontWeight.w700,
          )),
    );
  }

  productDetails() {
    Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Text(
        productdetails[0].productDescription.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
    );
  }

//  discountValue;
//  String adminper;
//  String adminpricevalue;
//  String costPrice;

  void _addToproducts(BuildContext context) {
    if (products == null) {
      ProductsCart st = ProductsCart(
          pid: productdetails[0].productIs,
          pname: productdetails[0].productName,
          pimage: url,
          pprice: (totalmrp! * _count).toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: productdetails[0].productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: productdetails[0].discount,
          discountValue: dicountValue.toString(),
          adminper: productdetails[0].msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: total.toString(),
          shipping: productdetails[0].shipping,
          totalQuantity: productdetails[0].quantityInStock,
          varient: textval,
          mv: int.parse(productdetails[0].mv.toString()),
          date1: '',
          id: null,
          moq: '',
          time1: '');
      dbmanager
          .insertStudent(st)
          .then((id) => {print('Student Added to Db $id')});
    }
  }

  WishlistsCart? nproducts;
  final DbProductManager1 dbmanager1 = DbProductManager1();

  void _addToproducts1(BuildContext context) {
    if (nproducts == null) {
      WishlistsCart st1 = WishlistsCart(
          pid: productdetails[0].productIs,
          pname: productdetails[0].productName,
          pimage: url,
          pprice: totalmrp.toString(),
          pQuantity: _count,
          pcolor: _dropDownValue,
          psize: _dropDownValue1,
          pdiscription: productdetails[0].productDescription,
          sgst: sgst1.toString(),
          cgst: cgst1.toString(),
          discount: productdetails[0].discount,
          discountValue: dicountValue.toString(),
          adminper: productdetails[0].msrp,
          adminpricevalue: admindiscountprice.toString(),
          costPrice: productdetails[0].buyPrice,
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

  String calDiscount(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = (byprice1 - (byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  String calGst(String byprice, String sgst) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(sgst);

    discount = ((byprice1 * discount1) / (100.0 + discount1));

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget discription1(String Discription) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                _parseHtmlString(Discription ?? ""),
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

  Future _countList(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("wcount", val);
  }
}
