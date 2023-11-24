import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/BottomNavigation/wishlist.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:arm_cool_care/screen/SearchScreen.dart';
import 'package:arm_cool_care/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  final String cat, title;
  const ProductList(this.cat, this.title, {super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showFab = true;
  final int _current = 0;
  int total = 000;
  int actualprice = 200;
  double? mrp, totalmrp = 000;
  final int _count = 1;

  double? sgst1, cgst1, dicountValue, admindiscountprice;

  List<Products> products1 = [];
  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    setState(() {
      Constant.carditemCount = Count!;
      print("${Constant.carditemCount}itemCount");
    });
  }

  @override
  void initState() {
    super.initState();
    gatinfoCount();
    print(widget.title);

    if (widget.cat == "new") {
      DatabaseHelper.getTopProduct1(widget.cat, "1000").then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
        });
      });
    } else if (widget.title == 'Featured Products') {
      DatabaseHelper.getfeature('yes', "100").then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
        });
      });
    } else {
      DatabaseHelper.getTopProduct(widget.cat, "100").then((usersFromServe) {
        setState(() {
          products1 = usersFromServe!;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    gatinfoCount();
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.tela,
            leading: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,
                  ),
                )),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserFilterDemo()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 0, right: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              ),
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
                      padding: EdgeInsets.only(top: 13, right: 30),
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.black,
                      ),
                    ),
                    showCircle(),
                  ],
                ),
              )
            ],
            title: Text(widget.title.isEmpty ? Constant.appname : widget.title,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold)),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 10.0, right: 8.0,bottom: 10.0),
                child: Center(
                  child: Text(widget.title,
                    style: TextStyle(
                        color: AppColors.product_title_name,
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),*/

                Expanded(
                  child: products1 != null
                      ? products1.isNotEmpty
                          ? ListView.builder(
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
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
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
                                                        color: AppColors.tela),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
                                                    color: Colors.blue.shade200,
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
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                              TextOverflow.fade,
                                                          style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black)
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
                                                                '\u{20B9} ${calDiscount(products1[index].buyPrice.toString(), products1[index].discount.toString())} ${products1[index].unit_type != null ? "/${products1[index].unit_type}" : ""}',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      AppColors
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
                                                              '(\u{20B9} ${products1[index].buyPrice})',
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
                                                      const SizedBox(
                                                        width: 0.0,
                                                        height: 10.0,
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 0.0,
                                                            right: 10),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
//                                                               Column(
//                                                                 children: <
//                                                                     Widget>[
//                                                                   Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .end,
//                                                                     children: <
//                                                                         Widget>[
//                                                                       Container(
//                                                                           height:
//                                                                               25,
//                                                                           width:
//                                                                               35,
//                                                                           child:
//                                                                               Material(
//                                                                             color:
//                                                                                 AppColors.tela,
//                                                                             elevation:
//                                                                                 0.0,
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(
//                                                                               borderRadius: BorderRadius.all(
//                                                                                 Radius.circular(15),
//                                                                               ),
//                                                                             ),
//                                                                             clipBehavior:
//                                                                                 Clip.antiAlias,
//                                                                             child:
//                                                                                 Padding(
//                                                                               padding: EdgeInsets.only(bottom: 10),
//                                                                               child: InkWell(
//                                                                                   onTap: () {
//                                                                                     print(products1[index].count);
//                                                                                     if (products1[index].count != "1") {
//                                                                                       setState(() {
// //                                                                                _count++;

//                                                                                         String quantity = products1[index].count;
//                                                                                         int totalquantity = int.parse(quantity) - 1;
//                                                                                         products1[index].count = totalquantity.toString();
//                                                                                       });
//                                                                                     }

// //
//                                                                                   },
//                                                                                   child: Padding(
//                                                                                     padding: EdgeInsets.only(
//                                                                                       top: 10.0,
//                                                                                     ),
//                                                                                     child: Icon(
//                                                                                       Icons.maximize,
//                                                                                       size: 20,
//                                                                                       color: Colors.black,
//                                                                                     ),
//                                                                                   )),
//                                                                             ),
//                                                                           )),
//                                                                       Padding(
//                                                                         padding: EdgeInsets.only(
//                                                                             top:
//                                                                                 0.0,
//                                                                             left:
//                                                                                 5.0,
//                                                                             right:
//                                                                                 5.0),
//                                                                         child:
//                                                                             Center(
//                                                                           child: Text(
//                                                                               products1[index].count != null ? '${products1[index].count}' : '$_count',
//                                                                               style: TextStyle(color: Colors.black, fontSize: 19, fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
//                                                                         ),
//                                                                       ),
//                                                                       Container(
//                                                                           margin: EdgeInsets.only(
//                                                                               left:
//                                                                                   3.0),
//                                                                           height:
//                                                                               25,
//                                                                           width:
//                                                                               35,
//                                                                           child:
//                                                                               Material(
//                                                                             color:
//                                                                                 AppColors.tela,
//                                                                             elevation:
//                                                                                 0.0,
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(
//                                                                               borderRadius: BorderRadius.all(
//                                                                                 Radius.circular(15),
//                                                                               ),
//                                                                             ),
//                                                                             clipBehavior:
//                                                                                 Clip.antiAlias,
//                                                                             child:
//                                                                                 InkWell(
//                                                                               onTap: () {
//                                                                                 if (int.parse(products1[index].count) <= int.parse(products1[index].quantityInStock)) {
//                                                                                   setState(() {
// //                                                                                _count++;

//                                                                                     String quantity = products1[index].count;
//                                                                                     int totalquantity = int.parse(quantity) + 1;
//                                                                                     products1[index].count = totalquantity.toString();
//                                                                                   });
//                                                                                 } else {
//                                                                                   showLongToast('Only  ${products1[index].count}  products in stock ');
//                                                                                 }
//                                                                               },
//                                                                               child: Icon(
//                                                                                 Icons.add,
//                                                                                 size: 20,
//                                                                                 color: Colors.black,
//                                                                               ),
//                                                                             ),
//                                                                           )),
//                                                                     ],
//                                                                   )
//                                                                 ],
//                                                               ),
                                                              // SizedBox(width: 10,),

                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: <Widget>[
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              3.0),
                                                                      height:
                                                                          30,
                                                                      width: 70,
                                                                      child:
                                                                          Material(
                                                                        color: AppColors
                                                                            .tela,
                                                                        elevation:
                                                                            0.0,
                                                                        shape:
                                                                            const RoundedRectangleBorder(
                                                                          side:
                                                                              BorderSide(
                                                                            color:
                                                                                AppColors.tela,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(2),
                                                                          ),
                                                                        ),
                                                                        clipBehavior:
                                                                            Clip.antiAlias,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (Constant.isLogin) {
                                                                              String mrpPrice = calDiscount(products1[index].buyPrice.toString(), products1[index].discount.toString());
                                                                              totalmrp = double.parse(mrpPrice);

                                                                              double dicountValue = double.parse(products1[index].buyPrice.toString()) - totalmrp!;
                                                                              String gstSgst = calGst(mrpPrice, products1[index].sgst.toString());
                                                                              String gstCgst = calGst(mrpPrice, products1[index].cgst.toString());

                                                                              String adiscount = calDiscount(products1[index].buyPrice.toString(), products1[index].msrp ?? "0");

                                                                              admindiscountprice = (double.parse(products1[index].buyPrice.toString()) - double.parse(adiscount));

                                                                              String color = "";
                                                                              String size = "";
                                                                              _addToproducts(products1[index].productIs.toString(), products1[index].productName.toString(), products1[index].img.toString(), int.parse(mrpPrice), int.parse(products1[index].count.toString()), color, size, products1[index].productDescription.toString(), gstSgst, gstCgst, products1[index].discount.toString(), dicountValue.toString(), products1[index].APMC.toString(), admindiscountprice.toString(), products1[index].buyPrice.toString(), products1[index].shipping.toString(), products1[index].quantityInStock.toString());

                                                                              setState(() {
//                                                                              cartvalue++;
                                                                                Constant.carditemCount++;
                                                                                cartItemcount(Constant.carditemCount);
                                                                              });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                            } else {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => SignInPage()),
                                                                              );
                                                                            }

//
                                                                          },
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.only(left: 0, top: 5, bottom: 5, right: 0),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "BOOK",
                                                                                  style: TextStyle(color: AppColors.black, fontSize: 12, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                // Icon(Icons.add_shopping_cart,color: Colors.white,),
                                                                              )),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    double.parse(products1[index]
                                                .discount
                                                .toString()) >
                                            0
                                        ? showSticker(index, products1)
                                        : const Row(),
                                  ],
                                );
                              },
                            )
                          : const Center(child: CircularProgressIndicator())
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),

          /*
        }
      )*/
        ));
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
}
