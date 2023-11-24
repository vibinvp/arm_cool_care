import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:arm_cool_care/BottomNavigation/wishlist.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/StyleDecoration/styleDecoration.dart';
import 'package:arm_cool_care/dbhelper/CarrtDbhelper.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/AddressModel.dart';
import 'package:arm_cool_care/model/CityName.dart';
import 'package:arm_cool_care/model/CoupanModel.dart';
import 'package:arm_cool_care/model/InvoiceModel.dart';
import 'package:arm_cool_care/model/OrderDliverycharge.dart';
import 'package:arm_cool_care/model/TrackInvoiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShowINVoiceIc1.dart';
import 'ShowInvoiceid2.dart';
import 'finalScreen.dart';

class CheckOutPage extends StatefulWidget {
  final UserAddress address;
  const CheckOutPage(this.address, {super.key});
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final DbProductManager dbmanager = DbProductManager();
  final coupanController = TextEditingController();
  List<CityName> citys = [];

  String? name1;
  String? email1;
  String? mobile1;
  String? gateway;
  String? codp;
  String? pin1;
  String? city1;
  String? address1;
  String? address2;
  String? user_name;
  double? finalamount, calcutateAmount, checkamount, difference = 0.0;
  bool discountval_flag = false;
  bool hideScheduleOrderButton = false;

  String? sex1;
  String? coupancode;
  String? user_id1;
  String? state1;
  String? invoiceid;
  String? razorpay_key;
  String? deliveryfee = '00.00';
  bool flag = true;
  bool flagCity = false;
  bool isOrderScheduled = true;
  List<TrackInvoice> list = [];
  bool applyButtonLoader = false;
  bool hideApplyButton = false;
  String? couponType;

  Future<void> _gefreedelivery() async {
    final response = await http.get(Uri.parse(
        Constant.base_url + 'api/shipping.php?shop_id=' + Constant.Shop_id));

    if (response.statusCode == 200) {
      print("response------>${response.body}");
      final jsonBody = json.decode(response.body);
      DeliveryCharge user1 = DeliveryCharge.fromJson(jsonDecode(response.body));
      if (user1.success.toString() == "true") {
        setState(() {
          gateway = user1.Gateway;
          print("gateway--------->$gateway");
          codp = user1.COD;

          Onedayprice = double.parse(user1.fast_price);
          fast_text = user1.fast_text;
          razorpay_key = user1.razorpay_key;
          print("razorpay----->$razorpay_key");
        });
        print(user1.COD);
        // print("user1.Min_Order");
        if (Constant.totalAmount < double.parse(user1.Min_Order)) {
          setState(() {
            deliveryfee =
                (double.parse(user1.Fee) + Constant.shipingAmount).toString();
            print("deliveryfee----->$deliveryfee");
            // print("deliveryfee");

            finalamount =
                Constant.totalAmount + double.parse(user1.Fee) + Onedayprice;
            // print(finalamount);
            // print("finalamount");
          });
        } else {
          if (Constant.shipingAmount > 0) {
            deliveryfee =
                (double.parse("0.0") + Constant.shipingAmount).toString();
            finalamount =
                Constant.totalAmount + double.parse(user1.Fee) + Onedayprice;
          } else {
            deliveryfee = '0.0';
          }
        }

//        setState(() {
//          invoiceid=user.Invoice;
//
//        });
      } else {}
    } else {
      throw Exception("Unable to generate Employee Invoice");
    }
//    print("123  Unable to generate Employee Invoice");
  }

/*
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String name= pre.getString("name");
    String email= pre.getString("email");
    String mobile= pre.getString("mobile");
    String pin= pre.getString("pin");
    String city= pre.getString("city");
    String address= pre.getString("address");
    String sex= pre.getString("sex");
    String state=pre.getString("state");
    String userid=pre.getString("user_id");
    print(name);
    print(email);
    print(pin);

    this.setState(() {

      name1=name;
      email1= email;
      mobile1=mobile;
      pin1=pin;
      city1=city;
      address1=address;
      sex1=sex;
      state1=state;
      user_id1=userid;


    });
  }
*/
  SharedPreferences? pre;
  Future<void> getUserInfo() async {
    pre = await SharedPreferences.getInstance();
    user_name = pre!.getString("mobile");
    print("${user_name}userNAme");

    String? email = pre!.getString("email");
    String? name = pre!.getString("name");
//    String pin= pre.getString("pin");
//    String city= pre.getString("city");
//    String address= pre.getString("address");
    String? sex = pre!.getString("sex");
//    String state=pre.getString("state");
    String? userid = pre!.getString("user_id");

    setState(() {
      name1 = widget.address.fullName;
      email1 = widget.address.email;
      mobile1 = widget.address.mobile;
      pin1 = widget.address.pincode;
      city1 = widget.address.city;
      address1 = widget.address.address1;
      address2 = widget.address.address2;
      sex1 = sex;
      state1 = widget.address.state;
      user_id1 = userid;
      Constant.name = name!;
      Constant.email = email!;
      Constant.username = user_name!;
      Constant.latitude = double.parse(widget.address.lat.toString());
      Constant.longitude = double.parse(widget.address.lng.toString());
    });
  }

  Razorpay? razorpay;
  List<ProductsCart> prodctlist1 = [];

  @override
  void initState() {
    getUserInfo();

    super.initState();

    finalamount = Constant.totalAmount;
    calcutateAmount = Constant.totalAmount;
    _gefreedelivery();

    dbmanager.getProductList().then((usersFromServe) {
      if (mounted) {
        setState(() {
          prodctlist1 = usersFromServe;
          print(" Shipping ${prodctlist1[0].shipping}");
          print(" Shipping ${prodctlist1[0].shipping!.length}");

          for (var i = 0; i < prodctlist1.length; i++) {
            Constant.shipingAmount = Constant.shipingAmount +
                        prodctlist1[i].shipping!.trim().length >
                    1
                ? double.parse(prodctlist1[i].shipping!.trim())
                : 0.0;
            print(" Shipping ${Constant.shipingAmount}");
          }
        });
      }
    });

    getPcity().then((value) {
      citys = value!;
    });

    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  String? orderid;
  String? signature;
  String? paymentId;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay!.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    // print(response.signature);
    setState(() {
      orderid = response.orderId;
      signature = response.signature;
      paymentId = response.paymentId;
    });
    _getInvoice1("ONLINE");
  }

  void handlerErrorFailure(PaymentSuccessResponse response) {
    print("Pament error");
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    showLongToast(' Payment Error');
  }

  void handlerExternalWallet(PaymentSuccessResponse response) {
    print("External Wallet");
    showLongToast("External Wallet");
  }

  void openCheckout() {
//    var options1 = {
//      'key': 'rzp_live_y9LCkyj468leuC',
//      'amount': finalamount*100, //in the smallest currency sub-unit.
//      'name':Constant.name,
//      'order_id': invoiceid, // Generate order_id using Orders API
//      'description': 'Fine T-Shirt',
//      'prefill': {
//        'contact': mobile1,
//        'email': email1
//      }
//    };

//    rzp_live_vkeFphEQQ90LK1
    var options = {
      'key': razorpay_key,
      'amount': finalamount! * 100.0,
      "currency": "INR",
      'name': Constant.name,
      'description': prodctlist1[0].pname,
      'prefill': {'contact': mobile1, 'email': email1},
      'external': {
        'wallets': ['paytm']
      }
    };
/*     var options = {
      "key" : "[YOUR_API_KEY]",
      "amount" : "10000",
      "name" : "Sample App",
      "description" : "Payment for the some random product",
      "prefill" : {
        "contact" : "2323232323",
        "email" : "shdjsdh@gmail.com"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };*/

    try {
      razorpay!.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.tela,
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text(
            "Checkout",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        body: Container(
          child: Builder(builder: (context) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 28,
                  child: Container(
//                  Color:Colors.teal[50],

                    child: ListView(
                      children: <Widget>[
                        selectedAddressSection(),
                        //standardDelivery(),
                        checkoutItem(),
                        priceSection(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Column(
                    children: <Widget>[
                      /*   gateway == 'no'*/
                      isOrderScheduled
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 20.0, right: 0),
                                    child: InkWell(
                                      onTap: () {
                                        showCalander();
                                        // _showSelectionDialog(context);
                                      },
                                      child: Container(
                                        // width: MediaQuery.of(context).size.width/1.5,
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 0.0, right: 10),
                                        margin: const EdgeInsets.only(
                                            left: 0.0, top: 0.0, right: 0),

                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),

                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                textval.length > 20
                                                    ? "${textval.substring(0, 20)}.."
                                                    : textval,

                                                overflow: TextOverflow.fade,
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: Colors.black,
                                                  size: 30,
                                                ))
                                          ],
                                        )),
                                      ),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 20.0, right: 10),
                                    child: InkWell(
                                      onTap: () {
                                        if (textval == "Select Date") {
                                          showLongToast("Please select date");
                                        } else {
                                          _displayDialog(context);
                                        }

                                        // _showSelectionDialog(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 0.0, right: 10),
                                        margin: const EdgeInsets.only(
                                            left: 0.0, top: 0.0, right: 0),

                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        // width: MediaQuery.of(context).size.width/1.5,

                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                textval1.length > 20
                                                    ? "${textval1.substring(0, 20)}.."
                                                    : textval1,

                                                overflow: TextOverflow.fade,
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: Colors.black,
                                                  size: 30,
                                                ))
                                          ],
                                        )),
                                      ),
                                    )),
                              ],
                            )
                          : const Row(),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        child: Card(
                          elevation: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "Total : "
                                  "\u{20B9}${finalamount!.toStringAsFixed(2)}",
                                  style: CustomTextStyle.textFormFieldMedium
                                      .copyWith(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              codp == 'yes'
                                  ? Container(
                                      width: hideScheduleOrderButton
                                          ? MediaQuery.of(context).size.width -
                                              107
                                          : 100,
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "scheduled----------->$isOrderScheduled");
                                          /*    if (isOrderScheduled && textval == "Select Date" || textval1 == "Select Time") {
                                          showLongToast("Please select date & time...");
                                        } else {
                                          _getInvoice1("COD");
                                          setState(() {
                                            flag = false;
                                          });
                                        }*/
                                          if (isOrderScheduled) {
                                            if (textval == "Select Date" ||
                                                textval1 == "Select Time") {
                                              showLongToast(
                                                  "Please select date & time...");
                                            } else {
                                              for (var i = 0;
                                                  i < citys.length;
                                                  i++) {
                                                if (pin1 == citys[i].places) {
                                                  setState(() {
                                                    flagCity = true;
                                                  });
                                                }
                                              }

                                              if (flagCity == true) {
                                                orderConfirmation(() {
                                                  _getInvoice1("COD");
                                                  setState(() {
                                                    flag = false;
                                                    // Navigator.pop(context);
                                                  });
                                                  showLongToast(
                                                      "Please wait for comfirmation...........");
                                                });
                                              } else {
                                                checkPincodePOPUP();
                                                // Navigator.pop(context);
                                              }
                                            }
                                          } else if (isOrderScheduled ==
                                              false) {
                                            for (var i = 0;
                                                i < citys.length;
                                                i++) {
                                              if (pin1 == citys[i].places) {
                                                setState(() {
                                                  flagCity = true;
                                                });
                                              }
                                            }

                                            if (flagCity == true) {
                                              orderConfirmation(() {
                                                _getInvoice1("COD");
                                                setState(() {
                                                  flag = false;
                                                });
                                                showLongToast(
                                                    "Please wait for comfirmation...........");
                                                //  Navigator.pop(context);
                                              });
                                            } else {
                                              checkPincodePOPUP();
                                              // Navigator.pop(context);
                                            }
                                          }

                                          // Navigator.push(context,
                                          //new MaterialPageRoute(builder: (context) => CheckOutPage()));
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                              const EdgeInsets.only(
                                                  top: 12,
                                                  left: 12,
                                                  right: 12,
                                                  bottom: 12),
                                            ),
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    AppColors
                                                        .checkoup_paybuttoncolor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24)))),
                                        // color:
                                        //     AppColors.checkoup_paybuttoncolor,
                                        // padding: const EdgeInsets.only(
                                        //     top: 12,
                                        //     left: 12,
                                        //     right: 12,
                                        //     bottom: 12),
                                        // shape: const RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.all(
                                        //         Radius.circular(24))),
                                        child: flag
                                            ? Text(
                                                "Cash",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                      ),
                                    )
                                  : const Row(),
                              razorpay_key == ""
                                  ? const SizedBox(
                                      height: 35,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: hideScheduleOrderButton
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80
                                                : 100,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      const MaterialStatePropertyAll(
                                                          AppColors
                                                              .checkoup_paybuttoncolor),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24)))),
                                              // color:
                                              onPressed: () {
                                                // _getInvoice1("UPI/QRCODE");
                                                print(
                                                    "scheduled----------->$isOrderScheduled");

                                                if (isOrderScheduled) {
                                                  if (textval ==
                                                          "Select Date" ||
                                                      textval1 ==
                                                          "Select Time") {
                                                    showLongToast(
                                                        "Please select date & time...");
                                                  } else {
                                                    for (var i = 0;
                                                        i < citys.length;
                                                        i++) {
                                                      if (pin1 ==
                                                          citys[i].places) {
                                                        setState(() {
                                                          flagCity = true;
                                                        });
                                                      }
                                                    }

                                                    if (flagCity == true) {
                                                      openCheckout();
                                                    } else {
                                                      checkPincodePOPUP();
                                                    }
                                                  }
                                                } else if (isOrderScheduled ==
                                                    false) {
                                                  for (var i = 0;
                                                      i < citys.length;
                                                      i++) {
                                                    if (pin1 ==
                                                        citys[i].places) {
                                                      setState(() {
                                                        flagCity = true;
                                                      });
                                                    }
                                                  }
                                                  if (flagCity == true) {
                                                    openCheckout();
                                                  } else {
                                                    checkPincodePOPUP();
                                                    // Navigator.pop(context);
                                                  }
                                                }

                                                // color:

//                      Navigator.push(context,
//                          new MaterialPageRoute(builder: (context) => CheckOutPage()));
                                              },
//                                               color: AppColors
//                                                   .checkoup_paybuttoncolor,
// //                          padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
//                                               shape:
//                                                   const RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.all(
//                                                               Radius.circular(
//                                                                   24))),
                                              child: Text(
                                                "Pay Online",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          /*Container(
                          child: RaisedButton(
                            onPressed: () {
                              _getInvoice1("THROUGH ACCOUNTS");
//                      Navigator.push(context,
//                          new MaterialPageRoute(builder: (context) => CheckOutPage()));
                            },
                            color: AppColors.checkoup_paybuttoncolor,
//                          padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(24))),
                            child: Text(
                              "THROUGH ACCOUNTS", style: CustomTextStyle.textFormFieldMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),

                            ),
                          ),
                            ),*/
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  selectedAddressSection() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(

//              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 6,
              ),

              const Text(
                "Service Adress:",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[],
              ),
              createAddressText("Name: $name1", 16),
              createAddressText(
                  address1 != null ? "$address1 $address2" : "address", 6),
              // createAddressText(address1!=null?address1:"address", 6),
              createAddressText(
                  city1 == null ? 'Banglore' : '$city1 , $pin1 ', 6),
              createAddressText(state1 ?? 'Karnatka', 6),
              const SizedBox(
                height: 6,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Mobile : ",
                      style: CustomTextStyle.textFormFieldMedium
                          .copyWith(fontSize: 12, color: Colors.grey.shade800)),
                  TextSpan(
                      text: mobile1 ?? '9989898989',
                      style: CustomTextStyle.textFormFieldBold
                          .copyWith(color: Colors.black, fontSize: 12)),
                ]),
              ),

              const SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.grey.shade300,
                height: 1,
                width: double.infinity,
              ),
//              addressAction()
            ],
          ),
        ),
      ),
    );
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: CustomTextStyle.textFormFieldMedium
            .copyWith(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }

  addressAction() {
    return Container(
      child: Row(
        children: <Widget>[
          const Spacer(
            flex: 2,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit / Change",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(fontSize: 12, color: Colors.indigo.shade700),
            ),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
          ),
          const Spacer(
            flex: 3,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          const Spacer(
            flex: 3,
          ),
          TextButton(
            onPressed: () {},
            child: Text("Add New Address",
                style: CustomTextStyle.textFormFieldSemiBold
                    .copyWith(fontSize: 12, color: Colors.indigo.shade700)),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  /* standardDelivery() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border:
          Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: 1,
            groupValue: 1,
            onChanged: (isChecked) {},
            activeColor: Colors.tealAccent.shade400,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Standard Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "  Free Delivery",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }*/

  checkoutItem() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding:
              const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: ListView.builder(
            itemBuilder: (context, position) {
              return checkoutListItem(position);
            },
            itemCount: WishlistState.prodctlist1.length > 0
                ? WishlistState.prodctlist1.length
                : 0,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
          ),
        ),
      ),
    );
  }

  checkoutListItem(int position) {
    return Stack(
      children: <Widget>[
        Container(
//              padding: EdgeInsets.only(right: 8, top: 4),
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              WishlistState.prodctlist1[position].pname ?? 'name',
              maxLines: 2,
              softWrap: true,
              style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)
                  .copyWith(fontSize: 14),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 16, top: 16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(right: 8, left: 0, top: 8, bottom: 8),
                width: 50,
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.tela),
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          Constant.Product_Imageurl +
                              WishlistState.prodctlist1[position].pimage
                                  .toString(),
                        ))),
              ),
              Expanded(
                flex: 100,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          // WishlistState.prodctlist1[position].pcolor!=null?  Text(
                          //   'COLOR: ${WishlistState.prodctlist1[position].pcolor}',
                          //   style:TextStyle( fontWeight: FontWeight.w400, color: Colors.black)
                          //       .copyWith(color: Colors.grey, fontSize: 14),
                          // ):Row(),Quantity:
                          // WishlistState.prodctlist1[position].pcolor.length>0?   SizedBox(width: 20):Row(),

                          WishlistState.prodctlist1[position].pQuantity != null
                              ? Text(
                                  ' ${WishlistState.prodctlist1[position].pQuantity}',
                                  style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)
                                      .copyWith(
                                          color: Colors.grey, fontSize: 14),
                                )
                              : const Row(),
                        ],
                      ),

//                      SizedBox(height: 3),
//                      WishlistState.prodctlist1[position].psize!=null? Text(
//                        'Size: ${WishlistState.prodctlist1[position].psize}',
//                        style:TextStyle( fontWeight: FontWeight.w400, color: Colors.black)
//                            .copyWith(color: Colors.grey, fontSize: 14),
//                      ):Row(),

                      WishlistState.prodctlist1[position].shipping!.length > 0
                          ? Text(
                              'Shipping:  \u{20B9} ${WishlistState.prodctlist1[position].shipping}',
                              style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)
                                  .copyWith(color: Colors.grey, fontSize: 14),
                            )
                          : const Row(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              WishlistState.prodctlist1[position].pprice == null
                                  ? '00.0'
                                  : '\u{20B9} ${double.parse(WishlistState.prodctlist1[position].pprice).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ).copyWith(color: Colors.green),
                            ),
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
      ],
    );
  }

  priceSection() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.all(Radius.circular(4)),
//              border: Border.all(color: Colors.grey.shade200)),
          padding:
              const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Flexible(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 10.0),
//                      child:  TextFormField(
//                        controller:coupanController,
//                        keyboardType: TextInputType.number,
//                        validator: (String value){
//                          if(value.isEmpty){
//                            return " Apply Coupon Code";
//                          }
//                        },
//                        decoration: const InputDecoration(
//                            hintText: "Apply Coupon Code"),
////                        enabled: !_status,
//                      ),
//                    ),
////                    flex: 2,
//                  ),
//
//
//                  Expanded(
//                    child: Padding(
//                      padding: EdgeInsets.only(right: 0.0),
//                      child: Container(
//                          child:  Center(
//                            child: RaisedButton(
//                              child: new Text("Apply  Coupon"),
//                              textColor: Colors.white,
//                              color: AppColors.telamoredeep,
//                              onPressed: () {
//
////
//                              },
//                              shape: new RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(20.0)),
//                            ),
//                          )),
//                    ),
////                    flex: 2,
//                  ),
//                ],
//              ),

              hideApplyButton
                  ? Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.sellp,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "Congratulations! you saved \u{20B9}${difference!.toStringAsFixed(1)} on this order.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextFormField(
                              controller: coupanController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return " Apply Coupon Code";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Apply Coupon Code"),
//                        enabled: !_status,
                            ),
                          ),
//                    flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Container(
                                child: Center(
                              child: applyButtonLoader
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              const MaterialStatePropertyAll(
                                            AppColors.checkoup_paybuttoncolor,
                                          ),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)))),
                                      child: const Text("Apply "),
                                      // textColor: Colors.white,
                                      // color: AppColors.checkoup_paybuttoncolor,
                                      onPressed: () {
                                        setState(() {
                                          applyButtonLoader = true;
                                        });
                                        _applycoupancode("1");
                                      },
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(20.0)),
                                    ),
                            )),
                          ),
//                    flex: 2,
                        ),
                      ],
                    ),

              const SizedBox(
                height: 25,
              ),
              Text(
                "PRICE DETAILS",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Total price",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "\u{20B9} ${calcutateAmount!.toStringAsFixed(2)}",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Service Total",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${Constant.itemcount}",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Padding(
              //       padding: EdgeInsets.only(top: 10),
              //       child: Text(
              //         fast_text,
              //         style: CustomTextStyle.textFormFieldSemiBold
              //             .copyWith(fontSize: 15, color: Colors.black54),
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(top: 10),
              //       child: Text(
              //         Onedayprice != null ? Onedayprice.toString() : "00.00",
              //         style: CustomTextStyle.textFormFieldSemiBold
              //             .copyWith(fontSize: 15, color: Colors.black54),
              //       ),
              //     ),
              //   ],
              // ),
              //Text(deliveryfee),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Service Charge",
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      deliveryfee != null
                          ? deliveryfee == "0.0"
                              ? "FREE"
                              : deliveryfee.toString()
                          : "00.00",
                      style: CustomTextStyle.textFormFieldSemiBold.copyWith(
                          fontSize: 15,
                          color: deliveryfee == "0.0"
                              ? Colors.green
                              : Colors.black54),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    finalamount!.toStringAsFixed(2),
                    style: CustomTextStyle.textFormFieldMedium
                        .copyWith(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.grey.shade700, fontSize: 12),
          ),
          Text(
            value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: color, fontSize: 12),
          )
        ],
      ),
    );
  }

// String invoicemenual;
  Future _getInvoice1(String paymode) async {
    var map = <String, dynamic>{};
    map['name'] = name1;
    map['mobile'] = user_name;
    map['email'] = email1;
    map['address'] = address1;
    map['pincode'] = pin1;
    map['city'] = city1;
    map['invoice_total'] = calcutateAmount.toString();
    map['notes'] = '';
    map['shop_id'] = Constant.Shop_id.toString();
    map['PayMode'] = paymode;
    map['user_id'] = "user_id";
    map['is_service'] = "1";
    map['shipping'] = deliveryfee;
    map['mv'] = prodctlist1[0].mv.toString();
    map['lat'] = Constant.latitude.toString();
    map['lng'] = Constant.longitude.toString();
    map['coupon'] = coupancode ?? "";
    map['couponAmount'] = difference.toString();
    map['adate'] = textval == "Select Date" || textval.isEmpty
        ? ''
        : (Jiffy.parse(textval, pattern: "dd/MM/yyyy")
                .format(pattern: "yyyy-MM-dd"))
            .toString();
    map['atime'] =
        textval1 == "Select Time" || textval1.isEmpty ? '' : textval1;
    map['fast_price'] = Onedayprice != null ? Onedayprice.toString() : "0.0";
    final response = await http
        .post(Uri.parse(Constant.base_url + 'api/order.php'), body: map);

    if (response.statusCode == 200) {
//      final jsonBody = json.decode(response.body);
      Invoice1 user = Invoice1.fromJson(jsonDecode(response.body));
      // print("123"+user.Invoice);
      if (user.success.toString() == "true") {
        print("12345" + user.Invoice);

        _uploadProducts(user.Invoice, paymode);
        setState(() {
          invoiceid = user.Invoice;
        });
      } else {
        showLongToast('Invoice is not generated');
      }
    } else {
      throw Exception("Unable to generate Employee Invoice");
    }
//    print("123  Unable to generate Employee Invoice");
  }

  Future _uploadProducts(String invoice, String paytype) async {
    // int pmv= prodctlist1[0].mv;
    //
    // print("Pmv12   "+pmv.toString()+ "   "+prodctlist1.length.toString());
    for (int i = 0; i < prodctlist1.length; i++) {
      /*     if(pmv==prodctlist1[i].mv) {
        setState(() {
          pmv=prodctlist1[i].mv;

          print("Pmv"+pmv.toString());
        });*/

      // print("WishlistState.prodctlist1[i].pimage");
      // print(WishlistState.prodctlist1[i].pimage);

      var map = <String, dynamic>{};
      // print(invoice);
      // print(WishlistState.prodctlist1[i].pid);
      // print(WishlistState.prodctlist1[i].pname);
      // print(WishlistState.prodctlist1[i].pQuantity);
      // print(WishlistState.prodctlist1[i].costPrice);
      // print(WishlistState.prodctlist1[i].discount);
      // print(WishlistState.prodctlist1[i].discountValue);
      // print(WishlistState.prodctlist1[i].adminper);
      // print(WishlistState.prodctlist1[i].adminpricevalue);
      // print(WishlistState.prodctlist1[i].cgst);
      // print(WishlistState.prodctlist1[i].sgst);
      // print(WishlistState.prodctlist1[i].pcolor);
      // print(WishlistState.prodctlist1[i].pimage);

      map['invoice_id'] = invoice;
      map['product_id'] = prodctlist1[i].pid;
      map['product_name'] = prodctlist1[i].pname;
      map['quantity'] = prodctlist1[i].pQuantity.toString();
      map['price'] = (int.parse(prodctlist1[i].costPrice.toString()) *
              prodctlist1[i].pQuantity)
          .toString();
      map['user_per'] = prodctlist1[i].discount;
      map['user_dis'] = (double.parse(prodctlist1[i].discountValue.toString()) *
              prodctlist1[i].pQuantity)
          .toStringAsFixed(2)
          .toString();
      map['admin_per'] = prodctlist1[i].adminper;
      map['admin_dis'] = prodctlist1[i].adminpricevalue;
      map['shop_id'] = Constant.Shop_id;
      map['cgst'] = (double.parse(prodctlist1[i].cgst.toString()) *
              WishlistState.prodctlist1[i].quantity)
          .toStringAsFixed(2);
      map['sgst'] = (double.parse(prodctlist1[i].sgst.toString()) *
              WishlistState.prodctlist1[i].quantity)
          .toStringAsFixed(2);
      map['variant'] = prodctlist1[i].varient == null
          ? " "
          : WishlistState.prodctlist1[i].varient;
      map['color'] =
          prodctlist1[i].pcolor == null || prodctlist1[i].pcolor!.isEmpty
              ? ""
              : prodctlist1[i].pcolor;
      map['size'] =
          prodctlist1[i].psize == null || prodctlist1[i].psize!.isEmpty
              ? ""
              : prodctlist1[i].psize;
      map['refid'] = "0";
      map['image'] = prodctlist1[i].pimage;
      map['prime'] = "0";
      map['mv'] = prodctlist1[i].mv.toString();
      print(WishlistState.prodctlist1[i].id);
      print(prodctlist1[i].id);
      final response = await http
          .post(Uri.parse(Constant.base_url + 'api/order.php'), body: map);

      try {
        // print(response);
        if (response.statusCode == 200) {
//        final jsonBody = json.decode(response.body);
          ProductAdded1 user =
              ProductAdded1.fromJson(jsonDecode(response.body));

          setState(() {
            if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'ONLINE') {
              showLongToast('Your Booking is Sucessfull');
              dbmanager.deleteallProducts();
              Constant.itemcount = 0;
              Constant.carditemCount = 0;
              cartItemcount(Constant.carditemCount);
              pre!.setString("mvid", "");
              _afterPayment(orderid!, signature!, paymentId!);

              // openCheckout();

              // Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => ShowInVoiceId(user.Invoice)),);
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'COD') {
              showLongToast(' Your Booking is Sucessfull');
              dbmanager.deleteallProducts();
              Constant.itemcount = 0;
              Constant.carditemCount = 0;
              cartItemcount(Constant.carditemCount);
              pre!.setString("mvid", "");

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(user.Invoice)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'UPI/QRCODE') {
              showLongToast('Your Booking is Sucessfull');
              dbmanager.deleteallProducts();
              Constant.itemcount = 0;
              Constant.itemcount = 0;
              Constant.itemcount = 0;
              pre!.setString("mvid", "");

//
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId(user.Invoice)),
              );
            } else if (user.success.toString() == "true" &&
                i == (prodctlist1.length - 1) &&
                paytype == 'THROUGH ACCOUNTS') {
              showLongToast('Your Booking is Sucessfull');
              dbmanager.deleteallProducts();
              Constant.itemcount = 0;
              Constant.itemcount = 0;
              pre!.setString("mvid", "");

//          openCheckout();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowInVoiceId2(user.Invoice)),
              );
            } else {
              // showLongToast(' Somting went wrong');
            }
          });
        }
      } catch (Exception) {
        throw ("Unable to uplod product detail");
      }
      // }

      /*  else{
        setState(() {

          pmv=prodctlist1[i].mv;

          // print(' set state after if ${pmv}'+i.toString());
        });
          int p;
        for( p=0;p<i;p++){
          setState(() {
            prodctlist1.removeAt(0);
            print("list length"+prodctlist1.length.toString());

          });

        }

        if(p==i){

          _getInvoice1(paytype);
          break;


        }

      }*/
    }
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
      gravity: Platform.isAndroid ? ToastGravity.BOTTOM : ToastGravity.TOP,
    );
  }

  void showLongToastCenter(String s) {
    Fluttertoast.showToast(
      msg: s,
      webPosition: "center",
      toastLength: Toast.LENGTH_LONG,
      gravity: Platform.isAndroid ? ToastGravity.CENTER : ToastGravity.CENTER,
    );
  }

  Future _afterPayment(
      String orderid, String signature, String paymentId) async {
    var map = <String, dynamic>{};

    print(mobile1);
    print(Constant.name);
    print(user_name);
    print(paymentId);
    print(orderid);
    print(signature);
    print(Constant.email);
    print(user_name);
    print(finalamount.toString());
    print(invoiceid);

    map['phone'] = mobile1;
    map['name'] = Constant.name;
    map['razorpay_payment_id'] = paymentId ?? "";
    map['razorpay_order_id'] = orderid ?? "";
    map['razorpay_signature'] = signature ?? "";
    map['email'] = Constant.email;
    map['username'] = user_name;
    map['price'] = finalamount.toString();
    map['purpose'] = invoiceid;
    final response = await http
        .post(Uri.parse(Constant.base_url + 'verifyUser.php'), body: map);

    try {
      if (response.statusCode == 200) {
        print("Your  order is  sucessfull");
        showLongToast('Your Booking is Sucessfull');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowInVoiceId(invoiceid.toString())),
        );
      }
    } catch (Exception) {}
  }

  bool checkBoxValue = false;
  double Onedayprice = 0.00;
  String fast_text = "";
  standardDelivery() {
//add this below the minimum fee
//     Onedayprice=double.parse(user1.fast_price);
//     fast_text=user1.fast_text;
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border:
              Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
          color: Colors.tealAccent.withOpacity(0.2)),
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
              activeColor: AppColors.tela,
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  checkBoxValue = newValue!;
                  print(checkBoxValue);
                  if (checkBoxValue) {
                    finalamount = finalamount! + Onedayprice;
                  } else {
                    print(finalamount);
                    finalamount = finalamount! - Onedayprice;
                  }

                  // checkBoxValue?finalamount+Onedayprice:finalamount-Onedayprice;
                });
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                fast_text,
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "$Onedayprice \u{20B9} chargess",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
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
    return returnStr;
  }

  String textval = "Select Date";
  String textval1 = "Select Time";

  _displayDialog(BuildContext context) async {
    String formattedDate1 = DateFormat('dd/MM/yyyy ').format(DateTime.now());
    var now = DateTime.now();
    print(DateFormat('HH').format(now));
    dynamic currentTime = DateFormat('HH').format(now);
    // dynamic currentTime = await DateFormat.jm().format(DateTime.now());
    String compair =
        currentTime.toString().substring(0, 2).replaceAll(":", "").trim();
    // print(compair);
    // print(formattedDate1);
    // print(compair);
    List<String> time;

    if (formattedDate1 == textval && int.parse(compair) >= 8) {
      log("hdjshfsjd----------------------------->>$compair");
      switch (int.parse(compair)) {
        // case 7:
        //   time = [
        //     //"7.00AM to 7.30AM",
        //     // "7.30AM to 8.00AM",
        //     // "8.00AM to 8.30AM",
        //     "8.30AM to 9.00AM",
        //     "9.00AM to 9.30AM",
        //     "9.30AM to 10.00AM",
        //     "10.00AM to 10.30AM",
        //     "10.30AM to 11.00AM",
        //     "11.00AM to 11.30AM",
        //     "11.30AM to 12.00PM",
        //     "12.00PM to 12.30PM",
        //     "12.00PM to 01.00PM",
        //     "01.00PM to 01.30PM",
        //     "01.30PM to 02.00PM",
        //     "02.00PM to 02.30PM",
        //     "02.30PM to 03.00PM",
        //     "03.00PM to 03.30PM",
        //     "03.30PM to 04.00PM",
        //     "04.00PM to 04.30PM",
        //     "04.30PM to 05.00PM",
        //     "05.00PM to 05.30PM",
        //     "05.30PM to 06.00PM",
        //   ];
        //   break;
        case 8:
          time = [
            // "8.00AM to 8.30AM",

            "9.00AM to 10.00AM",
            "10.00AM to 11.00AM",
            "11.00AM to 12.00PM",
            "12.00PM to 01.00PM",
            "01.00PM to 02.00PM",
            "02.00PM to 03.00PM",
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 9:
          time = [
            "10.00AM to 11.00AM",
            "11.00AM to 12.00PM",
            "12.00PM to 01.00PM",
            "01.00PM to 02.00PM",
            "02.00PM to 03.00PM",
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 10:
          time = [
            "11.00AM to 12.00PM",
            "12.00PM to 01.00PM",
            "01.00PM to 02.00PM",
            "02.00PM to 03.00PM",
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 11:
          time = [
            "12.00PM to 01.00PM",
            "01.00PM to 02.00PM",
            "02.00PM to 03.00PM",
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 12:
          time = [
            "01.00PM to 02.00PM",
            "02.00PM to 03.00PM",
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 13:
          time = [
            "02.00PM to 03.00PM",
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 14:
          time = [
            "03.00PM to 04.00PM",
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 15:
          time = [
            "04.00PM to 05.00PM",
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 16:
          time = [
            "05.00PM to 06.00PM",
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 17:
          time = [
            "06.00PM to 07.00PM",
            "07.00PM to 08.00PM",
          ];
          break;
        case 18:
          time = [
            "07.00PM to 08.00PM",
          ];
          break;

        default:
          time = ["No time is available"];
          break;
      }
    } else {
      time = [
        "8.00AM to 09.00AM",
        "9.00AM to 10.00AM",
        "10.00AM to 11.00AM",
        "11.00AM to 12.00PM",
        "12.00PM to 01.00PM",
        "01.00PM to 02.00PM",
        "02.00PM to 03.00PM",
        "03.00PM to 04.00PM",
        "04.00PM to 05.00PM",
        "05.00PM to 06.00PM",
        "06.00PM to 07.00PM",
        "07.00PM to 08.00PM",
        // "7.00AM to 7.30AM",
        // "7.30AM to 8.00AM",
        // "8.00AM to 8.30AM",
        // "8.30AM to 9.00AM",
        // "9.00AM to 9.30AM",
        // "9.30AM to 10.00AM",
        // "10.00AM to 10.30AM",
        // "10.30AM to 11.00AM",
        // "11.00AM to 11.30AM",
        // "11.30AM to 12.00PM",
        // "12.00PM to 12.30PM",
        // "12.00PM to 01.00PM",
        // "01.00PM to 01.30PM",
        // "01.30PM to 02.00PM",
        // "02.00PM to 02.30PM",
        // "02.30PM to 03.00PM",
        // "03.00PM to 03.30PM",
        // "03.30PM to 04.00PM",
        // "04.00PM to 04.30PM",
        // "04.30PM to 05.00PM",
        // "05.00PM to 05.30PM",
        // "05.30PM to 06.00PM",
        // "06.00PM to 06.30PM",
        // "06.30PM to 07.00PM",
        // "07.00PM to 0.30PM",
        // "07.30PM to 08.00PM",
      ];
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Select Time'),
            content: SizedBox(
              width: double.maxFinite,
              height: time.length * 56.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: time.length,
                  itemBuilder: (BuildContext context, int index) {
                    log(time.length.toString());
                    return Container(
                      width: time[index] != 0 ? 130.0 : 230.0,
                      color: Colors.white,
                      margin: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            textval1 = time[index];
                            Navigator.pop(context);
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: Text(
                                    time[index],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
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

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(const Duration(days: 30))))) {
      return true;
    }
    return false;
  }

  DateTime? selectedDate;

  showCalander() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      selectableDayPredicate: _decideWhichDayToEnable,
    ).then((date) {
      setState(() {
        selectedDate = date!;
        String formattedDate =
            DateFormat('dd/MM/yyyy ').format(selectedDate ?? DateTime.now());
        textval = formattedDate;

        print(formattedDate);
      });
    });
  }

  void _applycoupancode(String val) {
    if (coupanController.text.length > 4) {
      Coupan coupan;
      getCoupan(coupanController.text).then((usersFromServe) {
        setState(() {
          // prodctlist1
          coupan = usersFromServe!;
          if (coupan.status == "true") {
            String? fortype = coupan.data!.couponCodes[0].fortype;

            if (int.parse(coupan.data!.couponCodes[0].mv_id.toString()) > 0) {
              if (coupan.data!.couponCodes[0].mv_id ==
                  "${pre!.getString("mvid")}") {
                if (fortype == "first") {
                  trackInvoice1(Constant.username).then((usersFromServe) {
                    setState(() {
                      list = usersFromServe!;
                      print("InVOICE LIST  ${list.length}");
                      list.isNotEmpty
                          ? showLongToast("Invalid and Expire Coupon")
                          : checkvalue(coupan);
                      // getCoupanVal(coupan);
                    });
                  });
                } else {
                  // getCoupanVal(coupan);
                  checkvalue(coupan);
                }
              } else {
                setState(() {
                  applyButtonLoader = false;
                });
                showLongToast(" Coupon is not applied for this vendor");
              }
            } else {
              if (fortype == "first") {
                trackInvoice1(Constant.username).then((usersFromServe) {
                  setState(() {
                    list = usersFromServe!;
                    print("InVOICE LIST  ${list.length}");
                    if (list.isNotEmpty) {
                      applyButtonLoader = false;
                      showLongToast("Invalid and Expire Coupon");
                    } else {
                      checkvalue(coupan);
                    }
                  });
                });
              } else {
                checkvalue(coupan);
              }
            }
          } else {
            showLongToast("Invalid Or Expire Coupon");
            setState(() {
              difference = 0.0;
              applyButtonLoader = false;
            });
          }
        });
      });
    } else {
      showLongToast("Invalid Or Expire Coupon");
      setState(() {
        difference = 0.0;
        applyButtonLoader = false;
      });
    }
  }

  checkvalue(Coupan coupan) {
    if (coupan.data!.couponCodes[0].pro_id!.length > 0) {
      // print("product Id  ${prodctlist1[0].pid}");
      // print("product Id  ${coupan.data.couponCodes[0].pro_id}");
      print("length------>${prodctlist1.length}");
      for (var i = 0; i < prodctlist1.length; i++) {
        if (prodctlist1[i].pid!.trim() ==
            coupan.data!.couponCodes[0].pro_id!.trim()) {
          //getCoupanVal(coupan);
          if (coupan.data!.couponCodes[0].type == "per") {
            double differ = double.parse(calDiscount1(
                prodctlist1[i].pprice.toString(),
                coupan.data!.couponCodes[0].val.toString()));
            print("differ$differ");
            String val = calDiscount(calcutateAmount.toString(),
                coupan.data!.couponCodes[0].val.toString());
            String val1 = calDiscount1(calcutateAmount.toString(),
                coupan.data!.couponCodes[0].val.toString());

            setState(() {
              discountval_flag = true;
              if (differ >
                  double.parse(coupan.data!.couponCodes[0].maxVal.toString())) {
                setState(() {
                  difference = double.parse(
                      coupan.data!.couponCodes[0].maxVal.toString());
                  discountval_flag = true;
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                });
                showLongToast("Coupon code applied successfully...");
              } else {
                difference = differ;
                finalamount = finalamount! - difference!;
              }
              applyButtonLoader = false;
              hideApplyButton = true;
              showLongToast("Coupon code applied successfully...");
            });
          } else {
            setState(() {
              difference =
                  double.parse(coupan.data!.couponCodes[0].val.toString());
              discountval_flag = true;
              finalamount = finalamount! - difference!;
            });
            applyButtonLoader = false;
            hideApplyButton = true;
            showLongToast("Coupon code applied successfully...");
          }
          break;
        } else {
          if (i == prodctlist1.length - 1) {
            print("called--------->2");
            setState(() {
              applyButtonLoader = false;
            });
            showLongToast("Invalid Or Expire Coupon");
          }
        }
      }
    } else {
      print("called--------->3");
      calcutateAmount = Constant.totalAmount;
      getCoupanVal(coupan);

      print("calcutateAmount  $calcutateAmount");
    }
  }

  getCoupanVal(Coupan coupan) {
    setState(() {
      coupancode = coupanController.text;
      String name = Constant.username;
      String? usernamevalue = coupan.data!.couponCodes[0].userId;
      int length = coupan.data!.couponCodes[0].userId!.length;
      if (double.parse(coupan.data!.couponCodes[0].minVal.toString()) <
          calcutateAmount! + 1) {
        print("if----------->1");
        if (length > 3) {
          print("if----------->2");
          if (name.contains(usernamevalue!)) {
            print("if----------->3");
            if (coupan.data!.couponCodes[0].type == "per") {
              print("if----------->4");
              double differ = double.parse(calDiscount1(
                  calcutateAmount.toString(),
                  coupan.data!.couponCodes[0].val.toString()));
              String val = calDiscount(calcutateAmount.toString(),
                  coupan.data!.couponCodes[0].val.toString());
              String val1 = calDiscount1(calcutateAmount.toString(),
                  coupan.data!.couponCodes[0].val.toString());
              print("value1  $val");
              setState(() {
                discountval_flag = true;

                if (differ >
                    double.parse(
                        coupan.data!.couponCodes[0].maxVal.toString())) {
                  setState(() {
                    difference = double.parse(
                        coupan.data!.couponCodes[0].maxVal.toString());
                    discountval_flag = true;
                    finalamount = finalamount! - difference!;
                    applyButtonLoader = false;
                    hideApplyButton = true;
                  });
                  showLongToast("Coupon code applied successfully...");
                } else {
                  difference = double.parse(val1);
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                  showLongToast("Coupon code applied successfully...");
                }
              });
            } else {
              setState(() {
                difference =
                    double.parse(coupan.data!.couponCodes[0].val.toString());
                discountval_flag = true;
                print(difference);
                finalamount = finalamount! - difference!;
                applyButtonLoader = false;
                hideApplyButton = true;
              });
              showLongToast("Coupon code applied successfully...");
            }
          } else {
            setState(() {
              applyButtonLoader = false;
            });
            showLongToast("Invalid Or Expire Coupon");
          }
        } else {
          print("else called---->");
          if (coupan.data!.couponCodes[0].type == "per") {
            double differ = double.parse(calDiscount1(
                calcutateAmount.toString(),
                coupan.data!.couponCodes[0].val.toString()));

            String val = calDiscount(calcutateAmount.toString(),
                coupan.data!.couponCodes[0].val.toString());
            String val1 = calDiscount1(calcutateAmount.toString(),
                coupan.data!.couponCodes[0].val.toString());

            setState(() {
              discountval_flag = true;
              if (differ >
                  double.parse(coupan.data!.couponCodes[0].maxVal.toString())) {
                setState(() {
                  difference = double.parse(
                      coupan.data!.couponCodes[0].maxVal.toString());
                  discountval_flag = true;
                  finalamount = finalamount! - difference!;
                  applyButtonLoader = false;
                  hideApplyButton = true;
                });
                showLongToast("Coupon code applied successfully...");
              } else {
                difference = double.parse(val1);
                finalamount = finalamount! - difference!;
              }
              applyButtonLoader = false;
              hideApplyButton = true;
              showLongToast("Coupon code applied successfully...");
            });
          } else {
            setState(() {
              difference =
                  double.parse(coupan.data!.couponCodes[0].val.toString());
              discountval_flag = true;
              finalamount = finalamount! - difference!;
            });
            applyButtonLoader = false;
            hideApplyButton = true;
            showLongToast("Coupon code applied successfully...");
          }
        }
      } else {
        applyButtonLoader = false;
        showLongToast(
            "Coupon is only valid for orders above ${coupan.data!.couponCodes[0].minVal}");
      }
    });
  }

  String calDiscount1(String byprice, String discount2) {
    String returnStr;
    double discount = 0.0;
    returnStr = discount.toString();
    double byprice1 = double.parse(byprice);
    double discount1 = double.parse(discount2);

    discount = ((byprice1 * discount1) / 100.0);

    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }

  void orderConfirmation(void Function() onTap) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/confirmation.png"))),
            ),
            const Center(
              child: Text(
                "CONFIRMATION?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Are You Sure!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Do you want Place Booking!?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void checkPincodePOPUP() async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                //color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 150,
                color: Colors.red,
              ),
            ),
            const Center(
              child: Text(
                "Sorry!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Currently Slots Are Full At This Location....",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
            const SizedBox(
              height: 10,
            ),
            // SizedBox(
            //   height: 30,
            // ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // InkWell(
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.pop(context);
                //   },
                //   child: Container(
                //     width: 200,
                //     height: 40,
                //     decoration: BoxDecoration(
                //         color: Colors.red,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Center(
                //         child: Text(
                //       "Change Address",
                //       style: TextStyle(
                //         fontSize: 16,
                //         color: Colors.white,
                //       ),
                //     )),
                //   ),
                // ),
              ],
            )
          ],
        );
      },
    );
  }
}
