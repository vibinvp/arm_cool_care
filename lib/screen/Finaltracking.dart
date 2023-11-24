import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/CancleandRefundmodel.dart';
import 'package:arm_cool_care/model/InvoiceTrackmodel.dart';
import 'package:arm_cool_care/model/TrackInvoiceModel.dart';
import 'package:arm_cool_care/model/cp_models.dart';
import 'package:arm_cool_care/screen/custom_order.dart';
import 'package:arm_cool_care/screen/detailpage1.dart';
import 'package:http/http.dart' as http;
import 'package:arm_cool_care/screen/my_bookings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalOrderTracker extends StatefulWidget {
  final String invoiceno;
  final String dateval;
  final String status;
  final String mobile;

  const FinalOrderTracker(
      this.invoiceno, this.dateval, this.status, this.mobile,
      {super.key});

  @override
  _FinalOrderTrackerState createState() => _FinalOrderTrackerState();
}

class _FinalOrderTrackerState extends State<FinalOrderTracker> {
  int? difference;
  int? daliverydate;
  List<String>? list;
  TrackInvoice? invoiceDetrails;
  bool isLoading = true;
  CpDetails _cpDetails = CpDetails();

  getSuvstring() {
    String date = widget.dateval.substring(0, 10);
    list = date.split("-");
    int a = int.parse(list![0]);
    int b = int.parse(list![1]);
    int c = int.parse(list![2]);
    daliverydate = int.parse(list![2]);
    final birthday = DateTime(a, b, c);
    final date2 = DateTime.now();

    difference = date2.difference(birthday).inDays;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCpDetails().then((value) {
      _cpDetails = value!;
    });
    trackInvoice(widget.mobile).then((value) {
      setState(() {
        invoiceDetrails = value!.first;
        isLoading = false;
      });
    });
  }

  void openPdf() async {
    final filePath = '${Constant.base_url}/pdf?inv=2&id=${widget.invoiceno}';
    //if (await canLaunch(filePath)) {
    log(filePath.toString());
    await launch(filePath);
    // }
  }

  @override
  Widget build(BuildContext context) {
    getSuvstring();
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   clipBehavior: Clip.antiAlias,
      //   onPressed: () {
      //     openPdf();
      //   },
      //   child: Center(
      //     child: Icon(Icons.download),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: AppColors.tela,
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          // "${getTranslated(context, 'mo')}",
          'My Bookings',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //   height: 40,
                    //   color: Colors.grey.shade200,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 10, right: 10),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         // Text(
                    //         //   "Invoice Id: ${invoiceDetrails?.id ?? ""}",
                    //         //   style: TextStyle(
                    //         //       fontWeight: FontWeight.bold, fontSize: 14),
                    //         // ),
                    //         // Text(
                    //         //   invoiceDetrails.created,
                    //         //   style: TextStyle(color: Colors.grey, fontSize: 14),
                    //         // )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10),
                    // width: double.infinity,
                    // child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     SizedBox(
                    //       height: 10,
                    //     ),
                    //     Row(
                    //       children: [
                    //         Container(
                    //           height: 40,
                    //           child: Text(
                    //             "Shipping To:  ",
                    //             style: TextStyle(
                    //                 fontSize: 14, fontWeight: FontWeight.bold),
                    //           ),
                    //         ),
                    //         Container(
                    //           height: 40,
                    //           width: MediaQuery.of(context).size.width / 1.39,
                    //           child: Text(
                    //             "${invoiceDetrails.address}",
                    //             maxLines: 2,
                    //             style: TextStyle(fontSize: 14),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     Divider(
                    //       color: Colors.grey.shade200,
                    //       thickness: 1,
                    //       endIndent: 10,
                    //     )
                    //   ],
                    // ),
                    // ),
                    // Container(
                    //   height: 50,
                    //   color: Colors.grey.shade200,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 10),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           "Ordered Product(s)",
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold, fontSize: 14),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    FutureBuilder(
                        future: trackInvoiceOrder(widget.invoiceno),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              height: 500,
                              child: ListView.builder(
                                itemCount: snapshot.data!.length ?? 0,
                                shrinkWrap: true,
                                // primary: false,
                                // physics: NeverScrollableScrollPhysics(),
                                // scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  InvoiceInvoice item = snapshot.data![index];
                                  return Stack(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails1(item
                                                        .productId
                                                        .toString())),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 16, top: 16),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16))),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8,
                                                    left: 0,
                                                    top: 8,
                                                    bottom: 8),
                                                width: 90,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors.tela),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
                                                    color: Colors.blue.shade200,
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                          Constant.Product_Imageurl1 +
                                                              item.image
                                                                  .toString(),
                                                        ))),
                                              ),
                                              Expanded(
                                                flex: 100,
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
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Expanded(
                                                              child: Text(
                                                                item.productName ??
                                                                    'name',
                                                                maxLines: 2,
                                                                softWrap: true,
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            18,
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
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Row(
                                                        children: <Widget>[
                                                          item.color != null
                                                              ? item.color!
                                                                          .length >
                                                                      0
                                                                  ? Text(
                                                                      'COLOR: ${item.color}',
                                                                      style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black).copyWith(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  : const Row()
                                                              : const Row(),
                                                          const SizedBox(
                                                              width: 20),
                                                        ],
                                                      ),
                                                      item.quantity != null
                                                          ? Text(
                                                              'Quantity: ${item.quantity}',
                                                              style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black)
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          : const Row(),
                                                      item.size != null
                                                          ? item.size!.length >
                                                                  0
                                                              ? Text(
                                                                  'Size: ${item.size}',
                                                                  style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color: Colors
                                                                              .black)
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              14),
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
                                                              item.price == null
                                                                  ? '100'
                                                                  : '\u{20B9} ${calDiscount(item.price.toString(), item.userPer.toString())}',
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ).copyWith(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            // Container(
                                                            //   height: 20,
                                                            //   width: 50,
                                                            //   decoration:
                                                            //       BoxDecoration(
                                                            //     border: Border.all(
                                                            //       color: AppColors
                                                            //           .tela,
                                                            //     ),
                                                            //     borderRadius:
                                                            //         BorderRadius
                                                            //             .circular(
                                                            //                 5),
                                                            //   ),
                                                            //   child: Center(
                                                            //       // child: Text(
                                                            //       //   item?.userDis ==
                                                            //       //           null
                                                            //       //       ? ''
                                                            //       //       : '\u{20B9} ${(double.parse(item?.userDis)).toStringAsFixed(0)}',
                                                            //       //   style: TextStyle(
                                                            //       //     color: AppColors
                                                            //       //         .tela,
                                                            //       //     fontWeight:
                                                            //       //         FontWeight
                                                            //       //             .w700,
                                                            //       //   ),
                                                            //       // ),
                                                            //       ),
                                                            // ),

                                                            widget.status ==
                                                                    "Delivered"
                                                                ? ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDilogueReviw(
                                                                          context,
                                                                          item.productId
                                                                              .toString());
                                                                    },
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(AppColors.red),
                                                                        shape: MaterialStateProperty.all(
                                                                          const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(24))),
                                                                        )),
                                                                    // color:
                                                                    //     AppColors
                                                                    //         .red,
                                                                    // padding: const EdgeInsets
                                                                    //     .only(
                                                                    //     left:
                                                                    //         10,
                                                                    //     right:
                                                                    //         10),
                                                                    // shape: const RoundedRectangleBorder(
                                                                    //     borderRadius:
                                                                    //         BorderRadius.all(Radius.circular(24))),
                                                                    child:
                                                                        const Text(
                                                                      "Review",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  )
                                                                : const Row(),

                                                            //Add review Button
                                                          ],
                                                        ),
                                                      ),
                                                      const Row(
                                                        children: [
                                                          // Text("Variations: "),
                                                          // Text(
                                                          //   "${item?.variant == "Select varient" ? "" : item?.variant}",
                                                          //   style: TextStyle(
                                                          //       color: AppColors
                                                          //           .lightGray),
                                                          // ),
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
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                    // Container(
                    //   height: 10,
                    //   color: Colors.grey.shade300,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Total",
                    //         style: TextStyle(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.black),
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             "Order ",
                    //             style: TextStyle(fontSize: 15),
                    //           ),
                    //           Text(
                    //             "\u{20B9}${invoiceDetrails.invoiceSubtotal}",
                    //             style: TextStyle(fontSize: 15),
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             "Shipping Fee:",
                    //             style: TextStyle(fontSize: 15),
                    //           ),
                    //           Text(
                    //             "\u{20B9}${invoiceDetrails.shipping}",
                    //             style: TextStyle(fontSize: 15),
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Divider(
                    //         color: Colors.grey.shade200,
                    //         thickness: 1,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             "Total Payable :",
                    //             style: TextStyle(fontSize: 15),
                    //           ),
                    //           Text(
                    //             "\u{20B9}${double.parse(invoiceDetrails.invoiceSubtotal) + double.parse(invoiceDetrails.shipping)}",
                    //             style: TextStyle(fontSize: 15),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   height: 30,
                    //   color: Colors.grey.shade200,
                    // ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InkWell(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 40,
                        //     width: MediaQuery.of(context).size.width / 2.2,
                        //     margin: EdgeInsets.only(left: 10, right: 5, top: 20),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8),
                        //       color: AppColors.tela,
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         "Track Order",
                        //         style: TextStyle(
                        //             fontSize: 17,
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        footer(context),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              log(_cpDetails.mobileNo.toString());
                              launchDialer(_cpDetails.mobileNo.toString());
                            },
                            child: Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width / 2.2,
                              margin: const EdgeInsets.only(
                                  left: 5, right: 10, top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.sellp,
                              ),
                              child: const Center(
                                child: Text(
                                  "Support Center",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  //: 0,
                  //left: 15,
                  bottom: 70,
                  //top: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green,
                    ),
                    height: 40,
                    width: 120,
                    child: Center(
                        child: TextButton.icon(
                            onPressed: () {
                              openPdf();
                            },
                            icon:
                                const Icon(Icons.download, color: Colors.white),
                            label: const Text(
                              "Invoice",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                  ),
                ),
              ],
            ),
    );
  }

  footer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                daliverydate == 00
                    ? ((widget.status != 'Cancelled')
                        ? ElevatedButton(
                            onPressed: () {
                              showDilogue(context);
                              val = "can";
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.amberAccent),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.only(
                                  left: 60,
                                  right: 60,
                                )),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                )),
                            // color: Colors.amberAccent,
                            // padding: const EdgeInsets.only(
                            //   left: 60,
                            //   right: 60,
                            // ),
                            // shape: const RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(15))),
                            child: Text(
                              " ${getTranslated(context, 'can')}",
                            ),
                          )
                        : const Row())
                    : const Row(),
                const SizedBox(
                  width: 15.0,
                ),
                daliverydate != 00
                    ? ElevatedButton(
                        onPressed: () {
                          showDilogue(context);
                          val = "rep";
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.only(
                              left: 60,
                              right: 60,
                            )),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            )),
                        // color: Colors.black,
                        // padding: const EdgeInsets.only(
                        //   left: 60,
                        //   right: 60,
                        // ),
                        // shape: const RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(10))),
                        child: const Text(
                          "Return",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const Row(),
              ],
            ),
          ),
          //SizedBox(height: 8),
//          RaisedButton(
//            onPressed: () {
//
//
//            },
//            color: Colors.amberAccent,
//            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(24))),
//            child: Text(
//              "Buy Now",
//
//            ),
//          ),
          // SizedBox(height: 8),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 12, top: 12),
      child: const Text(
        "SHOPPING CART",
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

    returnStr = discount.toStringAsFixed(2);
    print(returnStr);
    return returnStr;
  }

  final _formKey12 = GlobalKey<FormState>();

  String val = "";

  final resignofcause = TextEditingController();

  final resignofcause1 = TextEditingController();

  double? _ratingController;
  launchWhatsapp(String whatsappNumber) async {
    print("whatsapp----->$whatsappNumber");
    var url = Uri.encodeFull("http://wa.me/$whatsappNumber/");
    print("url----->$url");
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e, s) {
      print("e------>$e");
      print("e------>$s");
    }
  }

  launchDialer(String phoneNumber) async {
    var url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showDilogue(BuildContext context) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 250.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey12,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLines: 4,
//                    keyboardType: TextInputType.number, // Use mobile input type for emails.
                      controller: resignofcause,
                      validator: (String? value) {
                        print("Length${value!.length}");
                        if (value.isEmpty) {
                          return " Please enter the  reason....";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Resion',
                        labelText: 'Please mention reason',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),

//                                      icon: new Icon(Icons.queue_play_next),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),
                      ))),
            ),
            TextButton(
                onPressed: () {
                  if (_formKey12.currentState!.validate()) {
                    cancleandRefund(val, context);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Submit !',
                  style: TextStyle(color: AppColors.pink, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  cancleandRefund(String val, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mobile = pref.getString("mobile");

    String link = Constant.base_url + "api/order_status.php";
    var map = <String, dynamic>{};
    map['user_id'] = mobile;
    map['order_id'] = widget.invoiceno;
    map['status'] = val;
    map['note'] = resignofcause.text;
    map['api_id'] = Constant.Shop_id;
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
      CancleandRefund user =
          CancleandRefund.fromJson(jsonDecode(response.body));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrackOrder()),
      );

      showLongToast(user.message);
    }
  }

  senReview(BuildContext context, String id) async {
    String link = Constant.base_url + "manage/api/reviews/add";

    print(Constant.user_id);
    print(Constant.API_KEY);
    print(_ratingController.toString());
    print(resignofcause1.text);
    print(id);
    var map = <String, dynamic>{};
    map['user_id'] = Constant.user_id;
    map['X-Api-Key'] = Constant.API_KEY;
    map['stars'] =
        (_ratingController!.toStringAsFixed(Constant.val)).toString();
    map['review'] = resignofcause1.text;
    map['shop_id'] = Constant.Shop_id;
    map['product'] = id;
    map['dates'] = " ";
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData.toString());
      CancleandRefund1 user =
          CancleandRefund1.fromJson(jsonDecode(response.body));
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => TrackOrder()),);

//        showLongToast("Rivew submitted successfully");
      showLongToast(user.message);
    } else {
      throw Exception("Nothing is generated");
    }
  }

  showDilogueReviw(BuildContext context, String id) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 250.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey12,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                      maxLines: 4,
//                      keyboardType: TextInputType.number, // Use mobile input type for emails.
                      controller: resignofcause1,
                      validator: (String? value) {
                        print("Length${value!.length}");
                        if (value.isEmpty && value.length > 10) {
                          return " Please enter the  review";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Review',
                        labelText: 'Please mention review',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),

//                                      icon: new Icon(Icons.queue_play_next),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 3.0),
                        ),
                      ))),
            ),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _ratingController = rating;
                print(_ratingController);
              },
            ),
            TextButton(
                onPressed: () {
                  senReview(context, id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Submit !',
                  style: TextStyle(color: AppColors.pink, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }
}

//  createSubTitle() {
//    return Container(
//      alignment: Alignment.topLeft,
//      child: Text(
//        'Total (${Constant.itemcount}) Items',
//        style: CustomTextStyle.textFormFieldBold
//            .copyWith(fontSize: 12, color: Colors.grey),
//      ),
//      margin: EdgeInsets.only(left: 12, top: 4),
//    );
//  }
