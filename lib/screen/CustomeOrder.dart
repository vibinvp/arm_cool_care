import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomeOrder extends StatefulWidget {
  const CustomeOrder({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CustomeOrder> {
  bool _status = false;
  final FocusNode myFocusNode = FocusNode();
  Future<File>? file;
  String status = '';
  String? base64Image, imagevalue;
  File? _image, imageshow1;
  String errMessage = 'Error Uploading Image';
  String? user_id;
  String url =
      "http://chuteirafc.cartacapital.com.br/wp-content/uploads/2018/12/15347041965884.jpg";

  final _formKeyad = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = GlobalKey<ScaffoldState>();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final labelController = TextEditingController();
  String? _dropDownValue1;
  Future<File>? profileImg;

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

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String name = pre.getString("name").toString();
    String email = pre.getString("email").toString();
    String mobile = pre.getString("mobile").toString();
    String pin = pre.getString("pin").toString();
    String city = pre.getString("city").toString();
    String address = pre.getString("address").toString();
    String image = pre.getString("pp").toString();
    user_id = pre.getString("user_id").toString();
    print(user_id);

    setState(() {
      nameController.text = name;
      emailController.text = email;
      stateController.text = 'Karnatka';
      pincodeController.text = pin;
      mobileController.text = mobile;
      cityController.text = city;
      // address1.text= address;
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    if (selectedRadio == 1) {
      setState(() {
        labelController.text = "Home";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.tela,
        title: Container(
            height: 40,
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: Center(
              // padding: EdgeInsets.only(top: 3),
              child: Text(
                "${getTranslated(context, 'appname')}",
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            )),
      ),
      key: profilescaffoldkey,
      body: Container(
        decoration: const BoxDecoration(),
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
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        '${getTranslated(context, 'contact')}:',
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
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
                                        '${getTranslated(context, 'email')}',
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
                                      controller: emailController,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the email id";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                    ),
                                  ),
                                ],
                              )),
                          /*Padding(
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
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      controller:mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return " Please enter the mobile No";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),*/
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
                                          if (value!.isEmpty && value == 10) {
                                            return " Please enter the mobile No";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile No"),
                                      ),
                                    ),
                                  ),
                                ],
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
                                        '${getTranslated(context, 'po')}',
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
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                              child: TextField(
                                  maxLines: 10,
                                  minLines: 4,
                                  controller: address1,
                                  decoration: const InputDecoration(
                                      hintText: 'Orders',
                                      labelText: 'Enter the Orders',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3.0),
                                      ))),
                            ),
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
                  child: const Text("Submit"),
                  style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(
                        AppColors.tela,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  // textColor: Colors.black,
                  // color: AppColors.tela,
                  onPressed: () {
                    setState(() {
                      if (_formKeyad.currentState!.validate()) {
                        _AddAddress();

//                              setInfo();
                      }

//                        _status = true;
//                          FocusScope.of(context).requestFocus(new FocusNode());
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
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: AppColors.pink,
        radius: 14.0,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

//

/*  Future setInfo() async {
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", address1.text);
    pref.setString("sex", _dropDownValue1);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    Constant.email=emailController.text;
    Constant.name=nameController.text;

    if(Constant.isLogin){
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => CheckOutPage()));


    }
    else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInPage()),);
    }

  }*/

  Future _AddAddress() async {
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    print(Constant.Shop_id);
    print(Constant.API_KEY);
    // print(Constant.user_id);
    print(nameController.text);
    print(mobileController.text);
    print(emailController.text);
    print(address1.text);
    print(formatted);

    var map = <String, dynamic>{};
    map['shop_id'] = Constant.Shop_id;
    map['X-Api-Key'] = Constant.API_KEY;
    map['user_ip'] = " ";
    map['name'] = nameController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['massage'] = address1.text;
    map['appointment_dates'] = formatted.toString();
    map['appointment_times'] = "";

    String link = Constant.base_url + "manage/api/contacts/add";
    print(link);
    final response = await http.post(Uri.parse(link), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      print(jsonBody);

      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));

      showLongToast(user.message);
      Navigator.of(context).pop();

      // Navigator.push(context,
      //   MaterialPageRoute(builder: (context) => ShowAddress(widget.valu)),);
//      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Unable to get Employee list");
    }
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
}
