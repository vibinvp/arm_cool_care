import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';

import 'package:arm_cool_care/dbhelper/database_helper.dart';

import 'package:arm_cool_care/model/TrackInvoiceModel.dart';

import 'package:arm_cool_care/screen/order_details.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String? mobile;
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? mob = pre.getString("mobile");
    setState(() {
      mobile = mob;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tela,
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          // " ${getTranslated(context, 'mo')}",
          'My Orders',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: trackOrder(mobile!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.length);
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      TrackInvoice item = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                  item.id.toString(),
                                  item.deliveryDate.toString(),
                                  item.states.toString(),
                                  item.mobile.toString(),
                                  double.parse(item.invoiceTotal.toString()) +
                                      double.parse(item.shipping.toString()),
                                  item.notes.toString()),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Invoice Id : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.black,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          item.id.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          item.states.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.orange[800]),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Amount : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                        item.shipping!.isEmpty
                                            ? Text(
                                                "\u{20B9} ${double.parse(item.invoiceTotal.toString())}")
                                            : Text(
                                                "\u{20B9} ${double.parse(item.invoiceTotal.toString()) + double.parse(item.shipping.toString())}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.green),
                                              ),
                                        // Text(
                                        //   "Payment Method: ${item.payType}",
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 14),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          item.created.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     border:
                                    //         Border.all(color: AppColors.tela),
                                    //     borderRadius: BorderRadius.circular(5),
                                    //   ),
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.start,
                                    //         children: [
                                    //           Container(
                                    //             height: 70,
                                    //             width: 60,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Pending"
                                    //                     ? Icons.pending
                                    //                     : Icons
                                    //                         .pending_outlined,
                                    //                 color: item.states ==
                                    //                         "Pending"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Pending",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Pending"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Pending"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Accepted"
                                    //                     ? Icons.done
                                    //                     : Icons.done_outlined,
                                    //                 color: item.states ==
                                    //                         "Accepted"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Accepted",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Accepted"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Accepted"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Packed"
                                    //                     ? Icons.backpack
                                    //                     : Icons
                                    //                         .backpack_outlined,
                                    //                 color: item.states ==
                                    //                         "Packed"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Packed",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Packed"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Packed"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 60,
                                    //             margin:
                                    //                 EdgeInsets.only(right: 5),
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Shipped"
                                    //                     ? Icons.delivery_dining
                                    //                     : Icons
                                    //                         .delivery_dining_outlined,
                                    //                 color: item.states ==
                                    //                         "Shipped"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Shipped",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Shipped"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Shipped"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.start,
                                    //         children: [
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Delivered"
                                    //                     ? Icons.delivery_dining
                                    //                     : Icons
                                    //                         .delivery_dining_outlined,
                                    //                 color: item.states ==
                                    //                         "Delivered"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Delivered",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Delivered"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Delivered"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             margin:
                                    //                 EdgeInsets.only(right: 5),
                                    //             height: 70,
                                    //             width: 68,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Complete"
                                    //                     ? Icons.done_all
                                    //                     : Icons
                                    //                         .done_all_outlined,
                                    //                 color: item.states ==
                                    //                         "Complete"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Completed",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Complete"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Complete"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             margin:
                                    //                 EdgeInsets.only(right: 5),
                                    //             height: 70,
                                    //             width: 65,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Replace"
                                    //                     ? Icons.find_replace
                                    //                     : Icons
                                    //                         .find_replace_outlined,
                                    //                 color: item.states ==
                                    //                         "Replace"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Replaced",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Replace"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Replace"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //             margin:
                                    //                 EdgeInsets.only(right: 5),
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Cancelled"
                                    //                     ? Icons.cancel
                                    //                     : Icons.cancel_outlined,
                                    //                 color: item.states ==
                                    //                         "Cancelled"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Cancelled",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Cancelled"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Cancelled"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.start,
                                    //         children: [
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Rejected"
                                    //                     ? Icons
                                    //                         .cancel_presentation
                                    //                     : Icons
                                    //                         .cancel_presentation_outlined,
                                    //                 color: item.states ==
                                    //                         "Rejected"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Rejected",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Rejected"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Rejected"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //             child: ListTile(
                                    //               contentPadding:
                                    //                   EdgeInsets.only(left: 5),
                                    //               title: Icon(
                                    //                 item.states == "Refundded"
                                    //                     ? Icons.money
                                    //                     : Icons.money_outlined,
                                    //                 color: item.states ==
                                    //                         "Refundded"
                                    //                     ? AppColors.tela
                                    //                     : AppColors.lightGray,
                                    //               ),
                                    //               subtitle: Text(
                                    //                 "Refunded",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                     fontSize: 11,
                                    //                     fontWeight: item
                                    //                                 .states ==
                                    //                             "Refundded"
                                    //                         ? FontWeight.bold
                                    //                         : FontWeight.normal,
                                    //                     color: item.states ==
                                    //                             "Refundded"
                                    //                         ? AppColors.tela
                                    //                         : AppColors
                                    //                             .lightGray),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //           ),
                                    //           Container(
                                    //             height: 70,
                                    //             width: 65,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Text(
                                    //   "Delivery Address:",
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 14),
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Text(
                                    //   "${item.address}",
                                    //   style:
                                    //       TextStyle(color: AppColors.lightGray),
                                    // ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
