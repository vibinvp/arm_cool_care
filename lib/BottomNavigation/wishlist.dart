import 'package:flutter/material.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/StyleDecoration/styleDecoration.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/screen/ShowAddress.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  WishlistState createState() => WishlistState();
}

class WishlistState extends State<WishList> {
  final DbProductManager dbmanager = DbProductManager();
  static List<ProductsCart> prodctlist = [];
  static List<ProductsCart> prodctlist1 = [];
  double totalamount = 0;

  final int _count = 1;
  bool islogin = false;

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    islogin != pref.get("isLogin");
    setState(() {
      Constant.isLogin = islogin;
    });
  }

  @override
  void initState() {
//    openDBBB();
    super.initState();
    gatinfo();
    dbmanager.getProductList().then((usersFromServe) {
      if (mounted) {
        setState(() {
          prodctlist1 = usersFromServe;
          for (var i = 0; i < prodctlist1.length; i++) {
            print(prodctlist1[i].pprice);
            totalamount = totalamount + double.parse(prodctlist1[i].pprice);
          }

          Constant.totalAmount = totalamount;
          Constant.itemcount = prodctlist1.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      body: Container(
        child: Column(
          children: <Widget>[
            createHeader(),
            createSubTitle(),
            Expanded(
                child: ListView.builder(
              itemCount: prodctlist1 == null ? 0 : prodctlist1.length,
              itemBuilder: (BuildContext context, int index) {
                ProductsCart item = prodctlist1[index];
                var i = item.pQuantity;

                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      dbmanager.deleteProducts(item.id!);

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(" Product is remove"),
                          duration: Duration(seconds: 1)));
                    } else {
                      dbmanager.deleteProducts(item.id!);
                      setState(() {
//                        Constant.itemcount--;
////                              Constant.totalAmount= Constant.totalAmount-double.parse(item.pprice);
//                        Constant.carditemCount--;
//                        cartItemcount(Constant.carditemCount);
                      });

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(" Product is remove "),
                          duration: Duration(seconds: 1)));
                    }
                    // Remove the item from the data source.
                    setState(() {
                      prodctlist1.removeAt(index);
                      Constant.totalAmount =
                          Constant.totalAmount - double.parse(item.pprice);
                      Constant.itemcount--;

                      Constant.carditemCount--;
                      cartItemcount(Constant.carditemCount);
                    });
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    padding: const EdgeInsets.all(5.0),
                    child: const Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    height: 100.0,
                    decoration: const BoxDecoration(color: Colors.red),
                    padding: const EdgeInsets.all(5.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: InkWell(
                      onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ProductDetails()),
//                );
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 16),
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 0, left: 4, top: 8, bottom: 8),
                                    width: 110,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.tela),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(14)),
                                        color: Colors.blue.shade200,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              Constant.Product_Imageurl +
                                                  item.pimage.toString(),
                                            ))),
                                  ),
                                  Expanded(
                                    flex: 100,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 8, top: 4),
                                            child: Text(
                                              item.pname ?? 'name',
                                              maxLines: 2,
                                              softWrap: true,
                                              style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)
                                                  .copyWith(fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          item.pcolor != null
                                              ? item.pcolor!.length > 0
                                                  ? Text(
                                                      'COLOR ${item.pcolor}',
                                                      style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black)
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14),
                                                    )
                                                  : const Row()
                                              : const Row(),
                                          const SizedBox(height: 6),
                                          item.psize != null
                                              ? item.psize!.length > 0
                                                  ? Text(
                                                      'Size ${item.psize}',
                                                      style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black)
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14),
                                                    )
                                                  : const Row()
                                              : const Row(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  item.pprice == null
                                                      ? '100'
                                                      : '\u{20B9} ${double.parse(item.pprice).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontWeight: FontWeight.w700,
                                                  ).copyWith(
                                                      color: Colors.green),
                                                ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.all(8.0),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment
                                                //             .center,
                                                //     crossAxisAlignment:
                                                //         CrossAxisAlignment.end,
                                                //     children: <Widget>[
                                                //       InkWell(
                                                //         onTap: () {
                                                //           if (prodctlist1[index]
                                                //                   .quantity !=
                                                //               1) {
                                                //             setState(() {
                                                //               String pvalue =
                                                //                   calDiscount1(
                                                //                       item.costPrice,
                                                //                       item.discount);
                                                //               double price =
                                                //                   double.parse(
                                                //                       pvalue);
                                                //               Constant.totalAmount =
                                                //                   Constant.totalAmount -
                                                //                       price;
                                                //               int quantity =
                                                //                   item.pQuantity;
                                                //               int totalquantity =
                                                //                   quantity - 1;
                                                //               double
                                                //                   incrementprice =
                                                //                   (price *
                                                //                       totalquantity);
                                                //               prodctlist1[index]
                                                //                       .price =
                                                //                   incrementprice
                                                //                       .toString();
                                                //               prodctlist1[index]
                                                //                       .quantity =
                                                //                   totalquantity;
                                                //               dbmanager
                                                //                   .updateStudent(
                                                //                       item);
                                                //             });
                                                //           }
                                                //         },
                                                //         child: Icon(
                                                //           Icons.remove,
                                                //           size: 24,
                                                //           color: Colors
                                                //               .grey.shade700,
                                                //         ),
                                                //       ),
                                                //       Container(
                                                //         color: Colors
                                                //             .grey.shade200,
                                                //         padding:
                                                //             const EdgeInsets
                                                //                     .only(
                                                //                 bottom: 2,
                                                //                 right: 12,
                                                //                 left: 12),
                                                //         child: Text(item
                                                //                     .pQuantity ==
                                                //                 null
                                                //             ? '1'
                                                //             : '${prodctlist1[index].quantity}'),
                                                //       ),
                                                //       InkWell(
                                                //         onTap: () {
                                                //           setState(() {
                                                //             String pvalue =
                                                //                 calDiscount1(
                                                //                     item.costPrice,
                                                //                     item.discount);
                                                //             double price =
                                                //                 double.parse(
                                                //                     pvalue);
                                                //             Constant.totalAmount =
                                                //                 Constant.totalAmount +
                                                //                     price;

                                                //             int quantity =
                                                //                 item.pQuantity;
                                                //             int totalquantity =
                                                //                 quantity + 1;
                                                //             double
                                                //                 incrementprice =
                                                //                 (price *
                                                //                     totalquantity);
                                                //             prodctlist1[index]
                                                //                     .price =
                                                //                 incrementprice
                                                //                     .toString();
                                                //             prodctlist1[index]
                                                //                     .quantity =
                                                //                 totalquantity;
                                                //             dbmanager
                                                //                 .updateStudent(
                                                //                     item);
                                                //           });
                                                //         },
                                                //         child: Icon(
                                                //           Icons.add,
                                                //           size: 24,
                                                //           color: Colors
                                                //               .grey.shade700,
                                                //         ),
                                                //       )
                                                //     ],
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 10, top: 8),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Colors.red),
                              child: InkWell(
                                onTap: () {
                                  dbmanager.deleteProducts(item.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(" Product is remove"),
                                          duration: Duration(seconds: 1)));
                                  setState(() {
                                    prodctlist1.removeAt(index);
                                    Constant.itemcount--;
                                    Constant.totalAmount =
                                        Constant.totalAmount -
                                            double.parse(item.pprice);
                                    Constant.carditemCount--;
                                    cartItemcount(Constant.carditemCount);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              },
            )),
            footer(context),
          ],
        ),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: const TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black)
                      .copyWith(color: Colors.black, fontSize: 12),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 30),
                child: Text(
                  '\u{20B9} ${Constant.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.greenAccent.shade700,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (Constant.isLogin) {
                if (Constant.itemcount > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAddress("0")),
                  );
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }
            },
            // color: AppColors.tela,
            // padding:
            //     const EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            // shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(24))),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.tela),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)))),
            child: const Text(
              "Book Now",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 12, top: 35),
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        'Total (${Constant.itemcount}) Items',
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  String calDiscount1(String byprice, String discount2) {
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

  String calDiscount(String totalamount) {
    setState(() {
      Constant.totalAmount = double.parse(totalamount);
    });
    return Constant.totalAmount.toStringAsFixed(2).toString();
  }
}
