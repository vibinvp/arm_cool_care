import 'dart:io';
import 'package:flutter/material.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/model/UserUpdateModel.dart';
import 'package:arm_cool_care/screen/checkout.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DliveryInfo extends StatefulWidget {
  const DliveryInfo({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DliveryInfo> {
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

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final profilescaffoldkey = GlobalKey<ScaffoldState>();
  final resignofcause = TextEditingController();
  String? _dropDownValue1;
  Future<File>? profileImg;

  @override
  void initState() {
    getUserInfo();
    super.initState();
//    getImaformation();
  }

/*  getImage(BuildContext context) async {
    imageshow1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageshow1 != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: imageshow1.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1, ratioY: 1),
          compressQuality: 85,
          maxWidth: 800,
          maxHeight: 800,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false

          ),

          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );

      this.setState((){
        imageshow1 = cropped;

      });
      Navigator.of(context).pop();
    }
    String imagevalue1 = (imageshow1).toString();
    imagevalue = imagevalue1.substring(7,(imagevalue1.lastIndexOf('')-1)).trim();

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      base64Image = base64Encode(imageshow1.readAsBytesSync());
      _image = new File('$imagevalue');
      print('Image Path $_image');
    });
  }




  Future<void> _sowchoiceDiloge(){

    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text('MAke a Choice'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Gallery'),
                onTap: (){
                  getImage(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  _OpenCamera(context);
                },
              )
            ],
          ),
        ),
      );

    });
  }*/

/*
  _OpenCamera(BuildContext context) async{
    var newImage = await ImagePicker.pickImage(source: ImageSource.camera);

    if(newImage!=null) {
      String imagevalue1 = (newImage).toString();
      imagevalue =
          imagevalue1.substring(7, (imagevalue1.lastIndexOf('') - 1)).trim();

//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      this.setState(() {
        base64Image = base64Encode(imageshow1.readAsBytesSync());
        _image = new File('$imagevalue');
        print('Image Path $_image');
      });
    }

  }*/

  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? name = pre.getString("name");
    String? email = pre.getString("email");
    String? mobile = pre.getString("mobile");
    String? pin = pre.getString("pin");
    String? city = pre.getString("city");
    String? address = pre.getString("address");
    String? sex = pre.getString("sex");
    user_id = pre.getString("user_id");
    print(user_id);
    if (Constant.image == null) {
    } else {
      url = Constant.image;
    }

    setState(() {
      nameController.text = name!;
      emailController.text = email!;
      stateController.text = '';
      pincodeController.text = pin!;
      mobileController.text = mobile!;
      cityController.text = city!;
      resignofcause.text = address!;
      _dropDownValue1 = sex;
      url = Constant.image;
      print(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.teal[50],
          title: Text(
            "Delivery Information",
            style: TextStyle(color: Colors.teal[200]),
          )),
      key: profilescaffoldkey,
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: const Color(0xffFFFFFF),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[],
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
                                        'Name',
                                        style: TextStyle(
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
                                      enabled: !_status,
                                      autofocus: !_status,
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
                                        'Email ID',
                                        style: TextStyle(
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
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      controller: mobileController,
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return " Please enter the mobile No";
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: false,
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
                                      child: const Text(
                                        'Pin Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: const Text(
                                        'State',
                                        style: TextStyle(
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
                                        controller: pincodeController,
                                        keyboardType: TextInputType.number,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return " Please enter the pincode";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Pin Code"),
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
                                      child: const Text(
                                        'City',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: const Text(
                                        'Gender',
                                        style: TextStyle(
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
                                      enabled: !_status,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: DropdownButton(
                                  hint: _dropDownValue1 == null
                                      ? const Text('Select gender')
                                      : Text(
                                          _dropDownValue1!,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                  isExpanded: true,
                                  iconSize: 30.0,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  items: [
                                    'Male',
                                    'Female',
                                  ].map(
                                    (val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    setState(
                                      () {
                                        _dropDownValue1 = val;
                                      },
                                    );
                                  },
                                ),
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15.0),
                            child: Container(
                                child: TextFormField(
                                    maxLines: 4,
                                    keyboardType: TextInputType
                                        .number, // Use mobile input type for emails.
                                    controller: resignofcause,
                                    validator: (String? value) {
                                      print("Length${value!.length}");
                                      if (value.isEmpty && value.length > 10) {
                                        return " Please enter the  address";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Enter the address',
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
                  child: const Text("Place Order"),
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
                  // textColor: Colors.white,
                  // color: Colors.green,
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        setInfo();
//                              _getEmployee();
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
          /*  Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        SystemNavigator.pop();
                      }
                      setState(() {
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),*/
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

  Future setInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", emailController.text);
    pref.setString("name", nameController.text);
    pref.setString("city", cityController.text);
    pref.setString("address", resignofcause.text);
    pref.setString("sex", _dropDownValue1!);
    pref.setString("mobile", mobileController.text);
    pref.setString("pin", pincodeController.text);
    pref.setString("state", stateController.text);
    pref.setBool("isLogin", true);
//        print(user.name);
    Constant.email = emailController.text;
    Constant.name = nameController.text;

    if (Constant.isLogin) {
      // Navigator.push(context,
      //     new MaterialPageRoute(builder: (context) => CheckOutPage()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  void _showLongToast(String message) {
    final snackbar = SnackBar(content: Text(message));
    // profilescaffoldkey.currentState!.showSnackBar(snackbar);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
