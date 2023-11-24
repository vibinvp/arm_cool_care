import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/AddressModel.dart';
import 'package:http/http.dart' as http;
import 'package:arm_cool_care/model/RegisterModel.dart';
import 'package:arm_cool_care/screen/checkout.dart';

import 'AddAddress.dart';
import 'UpdateAddress.dart';

class ShowAddress extends StatefulWidget {
  final String valu;
  const ShowAddress(this.valu, {super.key});
  @override
  _ShowAddressState createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  List<UserAddress> add = [];

//  void checkAddress(){
//    if(widget.valu=="0"&& add.length>0){
//      Navigator.push(context,
//        MaterialPageRoute(builder: (context) => AddAddress()),);
//
//    }
//  }
  bool _status = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress().then((usersFromServe) {
      setState(() {
        add = usersFromServe!;
        print(add.toString());
        if (add.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAddress(widget.valu)),
          );
          _status = true;
//        checkAddress();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tela,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAddress(widget.valu)),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.telamoredeep),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
              // color: AppColors.telamoredeep,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                "${getTranslated(context, 'add3')}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "${getTranslated(context, 'add2')}",
          maxLines: 2,
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ),
      ),
      body:
          // _status?screen():
          Container(
        child: add.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: add.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if (widget.valu == "0") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckOutPage(add[index])),
                        );
                      } else {
//                showLongToast("Please Ente  the address!");
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
//            margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 5.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            add[index].label != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 6),
                                        child: Text(
                                          add[index].label ?? "",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(),

                            add[index].fullName != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Text(
                                          add[index].fullName != null
                                              ? add[index].fullName! + " ,"
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(),

                            add[index].address1!.length > 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Text(
                                            add[index].address1 ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 0,
                                  ),

                            add[index].address2!.length > 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Text(
                                            add[index].address2 ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(),

                            add[index].city != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Text(
                                            add[index].city != null
                                                ? add[index].city! +
                                                    ", " +
                                                    add[index]
                                                        .state
                                                        .toString() +
                                                    ", " +
                                                    add[index]
                                                        .pincode
                                                        .toString()
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(),

//                  setContainer("Name",add[index].fullName),
                            setContainer("${getTranslated(context, 'mob')}",
                                add[index].mobile.toString()),
                            setContainer("${getTranslated(context, 'email')}",
                                add[index].email.toString()),

                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 2, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpDateAddress(add[index],
                                                        widget.valu)),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.teladep),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                        ),
//              splashColor: AppColors.tela,
                                        // color: AppColors.teladep,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(20.0),
                                        // ),
                                        child: Text(
                                          "${getTranslated(context, 'u')}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckOutPage(add[index])),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.black),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                          ),
                                        ),
//              splashColor: AppColors.tela,
                                        // color: AppColors.black,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(20.0),
                                        // ),
                                        child: Text(
                                          "${getTranslated(context, 'nex')}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print("Delete");

//                _deleteAdderss(add[index].addId);
//                add.removeAt(index);
                                        showDilogueReviw(context, index);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.red),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                      ),
                                      // color: Colors.red,
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(20.0)),
                                      child: Text(
                                        "${getTranslated(context, 'd')}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
//                  getAction(context,index),
//                  setContainer("City",add[index].city),
//                  setContainer("State",add[index].state),
//                  setContainer("Pin",add[index].pincode),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget getAction(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 2, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpDateAddress(add[index], widget.valu),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.teladep),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
//              splashColor: AppColors.tela,
                // color: AppColors.teladep,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20.0),
                // ),
                child: const Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: () {
//                _deleteAdderss(add[index].addId);
//                add.removeAt(index);
                showDilogueReviw(context, index);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
              // color: Colors.red,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20.0)),
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setContainer(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              title != null ? '$title:' : "",
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              value ?? "",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _deleteAdderss(String id, int index) async {
    var map = <String, dynamic>{};
    map['add_id'] = id;
    map['shop_id'] = Constant.Shop_id;
    map['X-Api-Key'] = Constant.API_KEY;
    map['user_id'] = Constant.user_id;

    final response = await http.post(
        Uri.parse(Constant.base_url + 'manage/api/user_address/delete/'),
        body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      setState(() {
        add.removeAt(index);
      });
//
//      Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShowAddress()),);
      showLongToast(user.message);

//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Unable to get Employee list");
    }
  }

  showDilogueReviw(BuildContext context, int index) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 130.0,
        width: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Do you want to delete!'),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancle !',
                      style: TextStyle(color: Colors.red, fontSize: 18.0),
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      _deleteAdderss(add[index].addId.toString(), index);

//                  Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => ShowAddress()),);
                    },
                    child: Text(
                      'ok !',
                      style:
                          TextStyle(color: AppColors.success, fontSize: 18.0),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Widget screen() {
    return Center(
      child: InkWell(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: <Color>[Colors.orange, Colors.deepOrange.shade900],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: const Text(
                "No address found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
//            Text("No address found  ",style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddAddress(widget.valu)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.telamoredeep),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
                // color: AppColors.telamoredeep,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20.0)),
                child: const Text(
                  "Add Address",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
