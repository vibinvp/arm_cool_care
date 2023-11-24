import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/General/AnimatedSplashScreen.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:arm_cool_care/screen/detailpage.dart';
import 'dart:async';

class UserFilterDemo extends StatefulWidget {
  const UserFilterDemo({super.key});

//  final String title = "Requet Users";

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    _timer!.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class UserFilterDemoState extends State<UserFilterDemo> {
  // https://jsonplaceholder.typicode.com/users

  final _debouncer = Debouncer(milliseconds: 500);
  List<Products> users = [];
  List<Products> suggestionList = [];
  final bool _progressBarActive = false;
  final int _current = 0;
  int total = 000;
  int actualprice = 200;
  double? mrp, totalmrp = 000;
  final int _count = 1;

  double? sgst1, cgst1, dicountValue, admindiscountprice;

  @override
  void initState() {
    super.initState();
    setState(() {
      users = SplashScreenState.filteredUsers;
      print(users.toString());
      suggestionList = users;
    });

    // search("").then((usersFromServe) {
    //   setState(() {
    //     users = usersFromServe;
    //     suggestionList = users;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 90,
              padding: const EdgeInsets.symmetric(
//              vertical: 10,
//                  horizontal: 10,
                  ),
              child: Material(
                color: Colors.white,
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: TextField(
                    onChanged: (string) {
                      searchval(string).then((usersFromServe) {
                        setState(() {
                          users = usersFromServe!;
                          suggestionList = users;
                        });
                      });

                      _debouncer.run(() {
                        setState(() {
                          suggestionList = users
                              .where((u) => (u.productName!
                                  .toLowerCase()
                                  .contains(string.toLowerCase())))
                              .toList();
                        });
                      });
                    },
                    style: TextStyle(color: Colors.green[900]),
                    decoration: InputDecoration(
                      hintText: 'Search Services',
                      hintStyle: TextStyle(color: AppColors.black),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: suggestionList != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: suggestionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 6, bottom: 6),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            suggestionList[index])),
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
                                                    Radius.circular(14)),
                                            color: Colors.blue.shade200,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  Constant.Product_Imageurl +
                                                      suggestionList[index]
                                                          .img
                                                          .toString(),
                                                ))),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  suggestionList[index]
                                                          .productName ??
                                                      'name',
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black)
                                                      .copyWith(fontSize: 14),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 1),
                                                    child: Text(
                                                        '\u{20B9} ${calDiscount(suggestionList[index].buyPrice.toString(), suggestionList[index].discount.toString())} ${suggestionList[index].unit_type ?? ""}',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.sellp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '(\u{20B9} ${suggestionList[index].buyPrice})',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: AppColors.mrp,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 0.0, right: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      const SizedBox(
                                                        width: 0.0,
                                                        height: 10.0,
                                                      ),

//                                                       Column(
//                                                         children: <Widget>[
//                                                           Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .end,
//                                                             children: <Widget>[
//                                                               Container(
//                                                                   height: 25,
//                                                                   width: 35,
//                                                                   child:
//                                                                       Material(
//                                                                     color:
//                                                                         AppColors
//                                                                             .tela,
//                                                                     elevation:
//                                                                         0.0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .all(
//                                                                         Radius.circular(
//                                                                             15),
//                                                                       ),
//                                                                     ),
//                                                                     clipBehavior:
//                                                                         Clip.antiAlias,
//                                                                     child:
//                                                                         Padding(
//                                                                       padding: EdgeInsets.only(
//                                                                           bottom:
//                                                                               10),
//                                                                       child: InkWell(
//                                                                           onTap: () {
//                                                                             print(suggestionList[index].count);
//                                                                             if (suggestionList[index].count !=
//                                                                                 "1") {
//                                                                               setState(() {
// //                                                                                _count++;

//                                                                                 String quantity = suggestionList[index].count;
//                                                                                 int totalquantity = int.parse(quantity) - 1;
//                                                                                 suggestionList[index].count = totalquantity.toString();
//                                                                               });
//                                                                             }

// //
//                                                                           },
//                                                                           child: Padding(
//                                                                             padding:
//                                                                                 EdgeInsets.only(
//                                                                               top: 10.0,
//                                                                             ),
//                                                                             child:
//                                                                                 Icon(
//                                                                               Icons.maximize,
//                                                                               size: 20,
//                                                                               color: Colors.white,
//                                                                             ),
//                                                                           )),
//                                                                     ),
//                                                                   )),
//                                                               Padding(
//                                                                 padding: EdgeInsets
//                                                                     .only(
//                                                                         top:
//                                                                             0.0,
//                                                                         left:
//                                                                             15.0,
//                                                                         right:
//                                                                             8.0),
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                       suggestionList[index].count != null
//                                                                           ? '${suggestionList[index].count}'
//                                                                           : '$_count',
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize:
//                                                                               19,
//                                                                           fontFamily:
//                                                                               'Roboto',
//                                                                           fontWeight:
//                                                                               FontWeight.bold)),
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                   margin: EdgeInsets
//                                                                       .only(
//                                                                           left:
//                                                                               3.0),
//                                                                   height: 25,
//                                                                   width: 35,
//                                                                   child:
//                                                                       Material(
//                                                                     color:
//                                                                         AppColors
//                                                                             .tela,
//                                                                     elevation:
//                                                                         0.0,
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius
//                                                                               .all(
//                                                                         Radius.circular(
//                                                                             15),
//                                                                       ),
//                                                                     ),
//                                                                     clipBehavior:
//                                                                         Clip.antiAlias,
//                                                                     child:
//                                                                         InkWell(
//                                                                       onTap:
//                                                                           () {
//                                                                         if (int.parse(suggestionList[index].count) <=
//                                                                             int.parse(suggestionList[index].quantityInStock)) {
//                                                                           setState(
//                                                                               () {
// //                                                                                _count++;

//                                                                             String
//                                                                                 quantity =
//                                                                                 suggestionList[index].count;
//                                                                             int totalquantity =
//                                                                                 int.parse(quantity) + 1;
//                                                                             suggestionList[index].count =
//                                                                                 totalquantity.toString();
//                                                                           });
//                                                                         } else {
//                                                                           showLongToast(
//                                                                               'Only  ${suggestionList[index].count}  products in stock ');
//                                                                         }
//                                                                       },
//                                                                       child:
//                                                                           Icon(
//                                                                         Icons
//                                                                             .add,
//                                                                         size:
//                                                                             20,
//                                                                         color: Colors
//                                                                             .white,
//                                                                       ),
//                                                                     ),
//                                                                   )),
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
                                                      // SizedBox(width: 25,),

                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          3.0),
                                                              height: 30,
                                                              child: Material(
                                                                color: AppColors
                                                                    .tela,
                                                                elevation: 0.0,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            5),
                                                                  ),
                                                                ),
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (Constant
                                                                        .isLogin) {
                                                                      String mrpPrice = calDiscount(
                                                                          suggestionList[index]
                                                                              .buyPrice
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .discount
                                                                              .toString());
                                                                      totalmrp =
                                                                          double.parse(
                                                                              mrpPrice);

                                                                      double
                                                                          dicountValue =
                                                                          double.parse(suggestionList[index].buyPrice.toString()) -
                                                                              totalmrp!;
                                                                      String gstSgst = calGst(
                                                                          mrpPrice,
                                                                          suggestionList[index]
                                                                              .sgst
                                                                              .toString());
                                                                      String gstCgst = calGst(
                                                                          mrpPrice,
                                                                          suggestionList[index]
                                                                              .cgst
                                                                              .toString());

                                                                      String adiscount = calDiscount(
                                                                          suggestionList[index]
                                                                              .buyPrice
                                                                              .toString(),
                                                                          suggestionList[index].msrp ??
                                                                              "0");

                                                                      admindiscountprice = (double.parse(suggestionList[index]
                                                                              .buyPrice
                                                                              .toString()) -
                                                                          double.parse(
                                                                              adiscount));

                                                                      String
                                                                          color =
                                                                          "";
                                                                      String
                                                                          size =
                                                                          "";
                                                                      _addToproducts(
                                                                          suggestionList[index]
                                                                              .productIs
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .productName
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .img
                                                                              .toString(),
                                                                          int.parse(
                                                                              mrpPrice),
                                                                          int.parse(suggestionList[index]
                                                                              .count
                                                                              .toString()),
                                                                          color,
                                                                          size,
                                                                          suggestionList[index]
                                                                              .productDescription
                                                                              .toString(),
                                                                          gstSgst,
                                                                          gstCgst,
                                                                          suggestionList[index]
                                                                              .discount
                                                                              .toString(),
                                                                          dicountValue
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .APMC
                                                                              .toString(),
                                                                          admindiscountprice
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .buyPrice
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .shipping
                                                                              .toString(),
                                                                          suggestionList[index]
                                                                              .quantityInStock
                                                                              .toString());

                                                                      setState(
                                                                          () {
//                                                                              cartvalue++;
                                                                        Constant
                                                                            .carditemCount++;
                                                                        cartItemcount(
                                                                            Constant.carditemCount);
                                                                      });

//                                                                Navigator.push(context,
//                                                                  MaterialPageRoute(builder: (context) => MyApp1()),);
                                                                    } else {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                SignInPage()),
                                                                      );
                                                                    }

//
                                                                  },
                                                                  child:
                                                                      const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 8,
                                                                              top: 5,
                                                                              bottom: 5,
                                                                              right: 8),
                                                                          child: Row(
                                                                            children: [
                                                                              Text("BOOK"),
                                                                              // Center(
                                                                              //   child:
                                                                              //       Icon(
                                                                              //     Icons.add_shopping_cart,
                                                                              //     color: Colors.black,
                                                                              //   ),
                                                                              // ),
                                                                            ],
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
                            double.parse(suggestionList[index]
                                        .discount
                                        .toString()) >
                                    0
                                ? showSticker(index, suggestionList)
                                : const Row()
                          ],
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
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

  final DbProductManager dbmanager = DbProductManager();

  ProductsCart? products1;
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
    if (products1 == null) {
      print(costPrice);
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
