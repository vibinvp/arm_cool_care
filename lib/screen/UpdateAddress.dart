import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:arm_cool_care/Auth/newMap.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/AddressModel.dart';
import 'package:arm_cool_care/model/RegisterModel.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'ShowAddress.dart';

class UpDateAddress extends StatefulWidget {
  final UserAddress address;
  final String valu;
  const UpDateAddress(this.address, this.valu, {super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UpDateAddress> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String? status = '';
  String? user_id;
  String url =
      "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  final _formKeyad = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();
  final profilescaffoldkey = GlobalKey<ScaffoldState>();
  final landnmarkController = TextEditingController();

  int selectedRadio = 1;
  setSelectRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (3 == selectedRadio) {
        setState(() {
          _status = true;
        });
      } else if (2 == selectedRadio) {
        setState(() {
          _status = false;
          labelController.text = "Office";
        });
      } else {
        setState(() {
          _status = false;
          labelController.text = "Home";
        });
      }
    });
  }

  Position? position;

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position!.latitude;
      Constant.longitude = position!.longitude;
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    setState(() {
      nameController.text = widget.address.fullName!;
      emailController.text = widget.address.email!;
      stateController.text = widget.address.state!;
      pincodeController.text = widget.address.pincode!;
      mobileController.text = widget.address.mobile!;
      cityController.text = widget.address.city!;
      address1.text = widget.address.address1!;
      address2.text = widget.address.address2!;
      landnmarkController.text = widget.address.landmark!;
      if (widget.address.label == "Home") {
        selectedRadio = 1;
        labelController.text = widget.address.label!;
      } else if (widget.address.label == "Office") {
        selectedRadio = 2;
        labelController.text = widget.address.label!;
      } else {
        _status = true;

        selectedRadio = 3;
        labelController.text = widget.address.label!;
      }
    });
  }

  Widget getLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: TextFormField(
        controller: labelController,
        validator: (String? value) {
          if (value!.isEmpty) {
            return " Please enter the label";
          }
          return null;
        },
        decoration: const InputDecoration(hintText: "Enter Label"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColors.tela,
          title: Text(
            "${getTranslated(context, 'add4')}",
            style: const TextStyle(color: Colors.white),
          )),
      key: profilescaffoldkey,
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Form(
                    key: _formKeyad,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            title: Text("${getTranslated(context, 'home')}"),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedRadio,
                            title: Text("${getTranslated(context, 'of')} "),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedRadio,
                            title: Text("${getTranslated(context, 'o')} "),
                            onChanged: (val) {
                              print("Radio $val");
                              setSelectRadio(val!);
                            },
                            activeColor: Colors.red,
                          ),
                          _status ? getLabel() : const Row(),
                          const Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        '${getTranslated(context, 'name')}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the name";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 5.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            '${getTranslated(context, 'add5')}',
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapClass(
                                                textEditingController: address1,
                                                cityController: cityController,
                                                stateController:
                                                    stateController,
                                                pincodeController:
                                                    pincodeController,
                                              )),
                                    );
                                  },
                                  child: _getEditIcon()),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                                child: TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType
                                        .text, // Use mobile input type for emails.
                                    controller: address1,
                                    validator: (String? value) {
                                      print("Length${value!.length}");
                                      if (value.isEmpty && value.length > 10) {
                                        return " Please enter the  address";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address1',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ),
                                    ))),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Email Id',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          /* Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(

                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType.text, // Use mobile input type for emails.
                                    controller: address2,
                                    validator: (String value){
                                      print("Length${value.length}");
                                      if(value.isEmpty && value.length>10){
                                        return " Please enter the  address";
                                      }
                                    },


                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address2',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),
                                    )

                                )
                            ),
                          ),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '${getTranslated(context, 'email')}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),*/
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: emailController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the email id";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          const Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Landmark',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          /* Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(

                                child: new TextFormField(
                                    maxLines: 2,
                                    keyboardType: TextInputType.text, // Use mobile input type for emails.
                                    controller: address2,
                                    validator: (String value){
                                      print("Length${value.length}");
                                      if(value.isEmpty && value.length>10){
                                        return " Please enter the  address";
                                      }
                                    },


                                    decoration: new InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address2',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),

//                                      icon: new Icon(Icons.queue_play_next),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54, width: 3.0),
                                      ),
                                    )

                                )
                            ),
                          ),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        '${getTranslated(context, 'email')}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),*/
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: landnmarkController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the landmark";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter landmark"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(
                                        '${getTranslated(context, 'mob')}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(
                                        '${getTranslated(context, 'st')}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: TextFormField(
                                        controller: mobileController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return " Please enter the mobile No";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile No"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: stateController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the state";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter State"),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(
                                        '${getTranslated(context, 'city')}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Text(
                                        '${getTranslated(context, 'pin')}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.all(0.0),
                            child: Row(children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      controller: cityController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the city";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter City"),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: TextFormField(
                                      controller: pincodeController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6)
                                      ],
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the pin code";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Pin Code"),
                                    ),
                                  ),
                                ),
                              ),
//                              Expanded(child:
//
//                              DropdownButton(
//                                hint: _dropDownValue1 == null
//                                    ? Text('Select gender')
//                                    : Text(
//                                  _dropDownValue1,
//                                  style: TextStyle(color: Colors.black),
//                                ),
//                                isExpanded: true,
//                                iconSize: 30.0,
//                                style: TextStyle(color: Colors.black,),
//                                items: [
//                                  'Male',
//                                  'Femail',
//                                ].map(
//                                      (val) {
//                                    return DropdownMenuItem<String>(
//                                      value: val,
//                                      child: Text(val),
//                                    );
//                                  },
//                                ).toList(),
//                                onChanged: (val) {
//                                  setState(
//                                        () {
//                                      _dropDownValue1 = val;
//                                    },
//                                  );
//                                },
//                              ),
//
//                              )
                            ]),
                          ),
                          _getActionButtons(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: Center(
                child: ElevatedButton(
                  child: Text("${getTranslated(context, 'u')}"),
                  // textColor: Colors.white,
                  // color: Colors.green,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    setState(() {
                      if (_formKeyad.currentState!.validate()) {
//                              setInfo();
                        _updateEmployee(widget.address.addId.toString());
                      }

//                        _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20.0)),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return Container(
      margin: const EdgeInsets.only(top: 23),
      child: CircleAvatar(
        backgroundColor: AppColors.tela,
        radius: 18.0,
        child: const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 20.0,
        ),
      ),
    );
  }

//

  Future setInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", address1.text);
    // pref.setString("sex", _dropDownValue1);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    Constant.email = emailController.text;
    Constant.name = nameController.text;

    if (Constant.isLogin) {
//      Navigator.push(context,
//          new MaterialPageRoute(builder: (context) => CheckOutPage()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  SharedPreferences? pref;
  Future _updateEmployee(String id) async {
    pref = await SharedPreferences.getInstance();

    var map = <String, dynamic>{};
    map['add_id'] = id;
    map['shop_id'] = Constant.Shop_id;
    map['X-Api-Key'] = Constant.API_KEY;
    map['user_id'] = Constant.user_id;
    map['full_name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['label'] = labelController.text;
    map['address1'] = address1.text;
    map['address2'] = address2.text ?? "";
    map['city'] = cityController.text;
    map['state'] = stateController.text;
    map['pincode'] = pincodeController.text;
    map['lat'] = pref!.getString("lat") ?? "";
    map['lng'] = pref!.getString("lng") ?? "";
    map['landmark'] = landnmarkController.text;
    print("map---->$map");
    String link = Constant.base_url + "manage/api/user_address/update";
    print(link);
    final response = await http.post(Uri.parse(link), body: map);
    print("res----->${response.body}");
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print("jsonBody=====?$jsonBody");
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      showLongToast(user.message);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),
      );
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Unable to get Employee list");
    }
  }
}
