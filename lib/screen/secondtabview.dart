import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/BottomNavigation/wishlist.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'package:arm_cool_care/screen/SearchScreen.dart';
import 'package:arm_cool_care/screen/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen2 extends StatefulWidget {
  final String title;
  final String id;
  const Screen2(this.id, this.title, {super.key});
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen2> {
  // List<Categary> mvCategary = List();
  List<Products> products1 = [];

  @override
  void initState() {
    checkmvid();

    setState(() {
      val = Constant.carditemCount;
    });
    super.initState();
  }

  static const int PAGE_SIZE = 15;
  final int _current = 0;

  static int? val;
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
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 18),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.telamoredeep,
                        // color: Colors.blue,
                      ),
                      child: Text('${Constant.carditemCount}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        title: Text(widget.title.isEmpty ? " " : widget.title,
            style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 110,
                      child: PagewiseListView(
                          pageSize: PAGE_SIZE,
                          itemBuilder: _itemBuilder,
                          pageFuture: (pageIndex) => catby_productData(
                              widget.id, (pageIndex! * PAGE_SIZE).toString())),
                    ),
                  ]),
              childCount: 1,
            ),
          )
        ]),
      ),
    );
  }

  SharedPreferences? pref;

  Widget _itemBuilder(context, Products entry, _) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 6),
      decoration: const BoxDecoration(
          // color: AppColors.tela1,

          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetails(entry)),
            );
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      right: 8, left: 8, top: 8, bottom: 8),
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.tela),
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      color: Colors.blue.shade200,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: entry.img != null
                              ? NetworkImage(
                                  Constant.Product_Imageurl +
                                      entry.img.toString(),
                                )
                              : const AssetImage("assets/images/plogo.png")
                                  as ImageProvider)),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            entry.productName ?? 'name',
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)
                                .copyWith(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 1),
                              child: Text(
                                  '\u{20B9} ${calDiscount(entry.buyPrice.toString(), entry.discount.toString())}',
                                  style: TextStyle(
                                    color: AppColors.sellp,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                '(\u{20B9} ${entry.buyPrice})',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.mrp,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Text(
                            ' ${entry.productVendor ?? ""}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontStyle: FontStyle.italic,
                              color: AppColors.black,
                              // decoration: TextDecoration.lineThrough
                            ),
                          ),
                        ),
                        entry.p_id == null
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 6.0, top: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    _displayDialog(context,
                                        entry.productIs.toString(), entry);
                                    // _showSelectionDialog(context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      top: 0.0,
                                      right: 5.0,
                                    ),
                                    margin: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 0),
                                          child: Text(
                                            entry.youtube != null &&
                                                    entry.youtube!.length > 15
                                                ? "${entry.youtube!.substring(0, 15)}.."
                                                : entry.youtube ??
                                                    "", // Use entry.youtube if not null, otherwise use an empty string
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Icon(
                                              Icons.expand_more,
                                              color: Colors.black,
                                              size: 30,
                                            ))
                                      ],
                                    )),
                                  ),
                                )),
                        Container(
                          margin: const EdgeInsets.only(left: 0.0, right: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const SizedBox(
                                  width: 0.0,
                                  height: 10.0,
                                ),

                                const Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 25,
                                          width: 35,
                                          // child:
//                                             Material(

//                                               color: AppColors.tela,
//                                               elevation: 0.0,
//                                               shape: RoundedRectangleBorder(

//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(15),
//                                                 ),
//                                               ),
//                                               clipBehavior: Clip.antiAlias,
//                                               child:Padding (
//                                                 padding: EdgeInsets.only(bottom: 12),
//                                                 child: InkWell(
//                                                     onTap: () {
//                                                       print(entry.count);
//                                                       if(entry.count!="1"){
//                                                         setState(() {
// //                                                                                _count++;

//                                                           String  quantity=entry.count;
//                                                           int totalquantity=int.parse(quantity)-1;
//                                                           entry.count=totalquantity.toString();

//                                                         });
//                                                       }

// //

//                                                     },
//                                                     child:Padding(padding: EdgeInsets.only(top:10.0,),

//                                                       child:Icon(
//                                                         Icons.maximize,size: 20,
//                                                         color: Colors.white,
//                                                       ),

//                                                     )
//                                                 ),
//                                               ),
//                                             )
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //       top: 0.0, left: 10.0, right: 8.0),
                                        //   child: Center(
                                        //     child: Text(
                                        //         entry.count != null
                                        //             ? '${entry.count}'
                                        //             : '$_count',
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 15,
                                        //             fontFamily: 'Roboto',
                                        //             fontWeight:
                                        //                 FontWeight.bold)),
                                        //   ),
                                        // ),
//                                         Container(
//                                             margin: EdgeInsets.only(left: 3.0),
//                                             height: 25,
//                                             width: 35,
//                                             child: Material(
//                                               color: AppColors.tela,
//                                               elevation: 0.0,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(15),
//                                                 ),
//                                               ),
//                                               clipBehavior: Clip.antiAlias,
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   if (int.parse(entry.count) <=
//                                                       int.parse(entry
//                                                           .quantityInStock)) {
//                                                     setState(() {
// //                                                                                _count++;

//                                                       String quantity =
//                                                           entry.count;
//                                                       int totalquantity =
//                                                           int.parse(quantity) +
//                                                               1;
//                                                       entry.count =
//                                                           totalquantity
//                                                               .toString();
//                                                     });
//                                                   } else {
//                                                     showLongToast(
//                                                         'Only  ${entry.count}  products in stock ');
//                                                   }
//                                                 },
//                                                 child: Icon(
//                                                   Icons.add,
//                                                   size: 20,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             )),
                                      ],
                                    )
                                  ],
                                ),
                                // SizedBox(width: 25,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                        margin:
                                            const EdgeInsets.only(left: 2.0),
                                        height: 30,
                                        width: 85,
                                        child: Material(
                                          color: AppColors.tela,
                                          elevation: 0.0,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: InkWell(
                                            onTap: () {
                                              if (Constant.isLogin.toString ==
                                                      "null" ||
                                                  Constant.isLogin) {
                                                String mrpPrice = calDiscount(
                                                    entry.buyPrice.toString(),
                                                    entry.discount.toString());
                                                totalmrp =
                                                    double.parse(mrpPrice);

                                                double dicountValue =
                                                    double.parse(entry.buyPrice
                                                            .toString()) -
                                                        totalmrp!;
                                                String gstSgst = calGst(
                                                    mrpPrice,
                                                    entry.sgst.toString());
                                                String gstCgst = calGst(
                                                    mrpPrice,
                                                    entry.cgst.toString());

                                                String adiscount = calDiscount(
                                                    entry.buyPrice.toString(),
                                                    entry.msrp ?? "0");

                                                admindiscountprice = (double
                                                        .parse(entry.buyPrice
                                                            .toString()) -
                                                    double.parse(adiscount));

                                                String color = "";
                                                String size = "";
                                                String? mv = pref!.getString(
                                                  "mvid",
                                                );
                                                //
                                                // if(mv==null||mv.isEmpty){
                                                // pref.setString("mvid",entry.mv);
                                                _addToproducts(
                                                    entry.productIs.toString(),
                                                    entry.productName
                                                        .toString(),
                                                    entry.img.toString(),
                                                    int.parse(mrpPrice),
                                                    int.parse(
                                                        entry.count.toString()),
                                                    color,
                                                    size,
                                                    entry.productDescription
                                                        .toString(),
                                                    gstSgst,
                                                    gstCgst,
                                                    entry.discount.toString(),
                                                    dicountValue.toString(),
                                                    entry.APMC.toString(),
                                                    admindiscountprice
                                                        .toString(),
                                                    entry.buyPrice.toString(),
                                                    entry.shipping.toString(),
                                                    entry.quantityInStock
                                                        .toString(),
                                                    entry.youtube.toString(),
                                                    entry.mv.toString());

                                                setState(() {
//                                                                              cartvalue++;
                                                  Constant.carditemCount++;
                                                  cartItemcount(
                                                      Constant.carditemCount);
                                                  // _ProductList1Stateq.val=Constant.carditemCount++;
                                                });

                                                // Navigator.pushReplacement(context,
                                                //   MaterialPageRoute(builder: (context) => ProductShow(widget.cat,widget.title)),);

                                                // }
                                                /* else{
                                                  if(mv==entry.mv){
                                                    _addToproducts(entry.productIs,entry.productName,entry.img,int.parse(mrp_price),int.parse(entry.count),color,size,entry.productDescription,gst_sgst,gst_cgst,
                                                        entry.discount,dicountValue.toString(), entry.APMC, admindiscountprice.toString(),entry.buyPrice,entry.shipping,entry.quantityInStock,entry.youtube,entry.mv);

                                                    setState(() {
//                                                                              cartvalue++;
                                                      Constant.carditemCount++;
                                                      cartItemcount(Constant.carditemCount);
                                                      // _ProductList1Stateq.val=Constant.carditemCount++;

                                                    });

                                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductList1(widget.mv_id,widget.title)),);

                                                  }
                                                  else{

                                                    showAlertDialog(context,entry);


                                                    // showLongToast("not added product");
                                                  }


                                                }*/
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignInPage()),
                                                );
                                              }

//
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    top: 5,
                                                    bottom: 5,
                                                    right: 3),
                                                child: Center(
                                                  child: Text(
                                                    "Book Now",
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
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
    );
  }

  checkmvid() async {
    pref = await SharedPreferences.getInstance();
  }

  bool showFab = true;
  int total = 000;
  int actualprice = 200;
  double? mrp, totalmrp = 000;
  final int _count = 1;
  String textval = "Select Variant";

  double? sgst1, cgst1, dicountValue, admindiscountprice;
  final DbProductManager dbmanager = DbProductManager();

  showAlertDialog(BuildContext context, Products pro) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        dbmanager.deleteallProducts();

        Constant.itemcount = 0;
        Constant.carditemCount = 0;
        cartItemcount(Constant.carditemCount);

        String mrpPrice =
            calDiscount(pro.buyPrice.toString(), pro.discount.toString());
        totalmrp = double.parse(mrpPrice);
        String color = "";
        String size = "";
        double dicountValue = double.parse(pro.buyPrice.toString()) - totalmrp!;
        String gstSgst = calGst(mrpPrice, pro.sgst.toString());
        String gstCgst = calGst(mrpPrice, pro.cgst.toString());
        String adiscount =
            calDiscount(pro.buyPrice.toString(), pro.msrp ?? "0");
        admindiscountprice =
            (double.parse(pro.buyPrice.toString()) - double.parse(adiscount));

        pref!.setString("mvid", pro.mv.toString());
        _addToproducts(
            pro.productIs.toString(),
            pro.productName.toString(),
            pro.img.toString(),
            int.parse(mrpPrice),
            int.parse(pro.count.toString()),
            color,
            size,
            pro.productDescription.toString(),
            gstSgst,
            gstCgst,
            pro.discount.toString(),
            dicountValue.toString(),
            pro.APMC.toString(),
            admindiscountprice.toString(),
            pro.buyPrice.toString(),
            pro.shipping.toString(),
            pro.quantityInStock.toString(),
            pro.youtube.toString(),
            pro.mv.toString());

        setState(() {
//                                                                              cartvalue++;
          Constant.carditemCount++;
          cartItemcount(Constant.carditemCount);
          // _ProductList1Stateq.val=Constant.carditemCount++;
        });

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductShow(widget.cat,widget.title)),);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Replace cart item?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
          "Your cart contains dishes from different Restaurent. Do you want to discard the selection and add this" +
              pro.productName.toString()),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getSelection(String name) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.tela, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(fontSize: 18, color: AppColors.white),
      )),
    );
  }

  _displayDialog(BuildContext context, String id, Products entry) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Select Variant'),
            content: SizedBox(
              width: double.maxFinite,
              height: 200,
              child: FutureBuilder(
                  future: getPvarient(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: snapshot.data![index] != 0 ? 130.0 : 230.0,
                              color: Colors.white,
                              margin: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    entry.buyPrice =
                                        snapshot.data![index].price;
                                    entry.discount =
                                        snapshot.data![index].discount;

                                    // total= int.parse(snapshot.data[index].price);
                                    // String  mrp_price=calDiscount(snapshot.data[index].price,snapshot.data[index].discount);
                                    // totalmrp= double.parse(mrp_price);
                                    entry.youtube =
                                        snapshot.data![index].variant;

                                    Navigator.pop(context);
                                  });
                                },
                                child: getSelection(
                                    snapshot.data![index].variant.toString()),

                                /* Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        child: Text(
                                          snapshot.data[index].variant,
                                          overflow:TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 15,color:AppColors.black,

                                          ),
                                        ),
                                      ),
                                      Divider(

                                        color: AppColors.black,
                                      ),





                                    ],
                                  ),*/
                              ),
                            );
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
  // final DbProductManager dbmanager = new DbProductManager();

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
      String totalQun,
      String varient,
      String mv) {
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
          pimage: image ?? "",
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
          totalQuantity: totalQun,
          varient: varient,
          mv: int.parse(mv));
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

  void gatinfoCount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int? Count = pref.getInt("itemCount");
    setState(() {
      Constant.carditemCount = Count!;
      print("${Constant.carditemCount}itemCount");
    });
  }
}
