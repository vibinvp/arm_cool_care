import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/Auth/widgets/custom_shape.dart';
import 'package:arm_cool_care/Auth/widgets/customappbar.dart';
import 'package:arm_cool_care/Auth/widgets/responsive_ui.dart';
import 'package:arm_cool_care/Auth/widgets/textformfield.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/RegisterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name;
  String? mobile;
  bool checkBoxValue = false, flag = false;
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false;
  bool _medium = false;
  bool isLoading = false;
  TextEditingController namelController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController sponsorController = TextEditingController();
  String? message;
  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = <String, dynamic>{};
    map['shop_id'] = Constant.Shop_id;
    map['name'] = namelController.text;
    map['mobile'] = mobileController.text;
    map['email'] = emailController.text;
    map['password'] = '';
    map['cities'] = cityController.text;
    map['sponsor'] = cityController.text;
    final response = await http
        .post(Uri.parse(Constant.base_url + 'api/step3.php'), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      RegisterModel user = RegisterModel.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "User Registered Successfully") {
        setState(() {
          flag = false;
        });
        _showLongToast(user.message);
        pref.setString("email", user.email);
        pref.setString("name", user.name);
        pref.setString("city", user.city);
        pref.setString("address", user.address);
        pref.setString("mobile", user.username);
        pref.setString("user_id", user.userId);
        pref.setString("pp", user.pp);

        pref.setBool("isLogin", true);
        Constant.email = user.email;
        Constant.name = user.name;
        Constant.isLogin = true;
        Constant.image = user.pp;
        if (user.pp == null) {
          Constant.image = "";
        } else {
          Constant.image = user.pp;
        }
        Constant.image = user.pp;

//        pref.setString("mobile",phoneController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        _showLongToast(user.message);
      }
    } else {
      throw Exception("Unable to get Employee list");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gatinfo();
  }

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.get("name").toString();
    mobile = pref.get("mobile").toString();
    setState(() {
      namelController.text = name!;
      mobileController.text = mobile!;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: const EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height! / 35,
                ),
                button(),
                // infoTextRow(),
                // socialIconsRow(),
                signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height! / 8
                  : (_medium ? _height! / 7 : _height! / 6.5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.boxColor1, AppColors.boxColor2],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height! / 15
                  : (_medium ? _height! / 15 : _height! / 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.boxColor1, AppColors.boxColor2],
                ),
              ),
            ),
          ),
        ),

        /* Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: (){
                print('Adding photo');
              },

              child: Icon(Icons.add_a_photo, size: _large? 40: (_medium? 33: 31),color: Colors.orange[200],)),
        ),*/
//        Positioned(
//          top: _height/8,
//          left: _width/1.75,
//          child: Container(
//            alignment: Alignment.center,
//            height: _height/23,
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color:  Colors.orange[100],
//            ),
//            child: GestureDetector(
//                onTap: (){
//                  print('Adding photo');
//                },
//                child: Icon(Icons.add_a_photo, size: _large? 22: (_medium? 15: 13),)),
//          ),
//        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 60.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height! / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height! / 60.0),
            emailTextFormField(),
            // SizedBox(height: _height / 60.0),
            // passwordTextFormField(),
            SizedBox(height: _height! / 60.0),
            lastNameTextFormField(),

            // isLoading
            //     ? Center(
            //         child: CircularProgressIndicator(
            //           color: AppColors.tela,
            //         ),
            //       )
            //     : Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Check Referral Code",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           MaterialButton(
            //             onPressed: () {
            //               setState(() {
            //                 isLoading = true;
            //               });
            //               getRefferalDetails(sponsorController.text);
            //             },
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             color: AppColors.sellp,
            //             textColor: AppColors.white,
            //             child: Text("Check"),
            //           )
            //         ],
            //       ),
            // message != null
            //     ? Text(
            //         "${message}",
            //         style: TextStyle(
            //             color: message == "Incorrect Referral Code..." ? AppColors.boxColor1 : AppColors.sellp, fontWeight: FontWeight.bold),
            //       )
            //     : Container(),
            flag ? circularIndi() : const Row(),
          ],
        ),
      ),
    );
  }

  getRefferalDetails(String username) async {
    print("hellllllo");
    try {
      var link = "${Constant.base_url}api/username.php?reffer_id=$username";
      var response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == "true") {
          setState(() {
            message = responseData["name"];
          });
        } else if (responseData["message"] == "User Not Found...!") {
          setState(() {
            message = "Incorrect Referral Code...";
            sponsorController.clear();
          });
        }
      } else {
        setState(() {
          message = "Something went wrong...";
          sponsorController.clear();
        });
      }
    } catch (e) {}
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: namelController,
      icon: Icons.person,
      hint: "${getTranslated(context, 'name')}",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: cityController,
      icon: Icons.person,
      hint: " ${getTranslated(context, 'city')}",
    );
  }

  Widget sponsorTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: sponsorController,
      icon: Icons.person,
      hint: "Referral Code (optional)",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "${getTranslated(context, 'email')}",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: mobileController,
      icon: Icons.phone,
      hint: "${getTranslated(context, 'mob')}",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
      obscureText: true,
      icon: Icons.lock,
      hint: "${getTranslated(context, 'pa')}",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  checkBoxValue = newValue!;
                });
              }),
          Text(
            "${getTranslated(context, 'i')}",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ))),
      onPressed: () {
        if (namelController.text.length < 2) {
          _showLongToast("Name is Empty !");
        } else if (mobileController.text.length != 10) {
          _showLongToast("Please enter ten desigt No ");
        } else if (emailController.text.length < 2) {
          _showLongToast("Enter the email");
        } else if (cityController.text.length < 3) {
          _showLongToast("Enter the city name ");
        } else {
          setState(() {
            flag = true;
          });
          _getEmployee();
        }
      },
      child: Text(
        '${getTranslated(context, 'sinup')}',
        style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
      ),
    );

//      RaisedButton(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//       onPressed: () {
//         if (namelController.text.length < 2) {
//           _showLongToast("Name is Empty !");
//         } else if (mobileController.text.length != 10) {
//           _showLongToast("Please enter ten desigt No ");
//         } else if (emailController.text.length < 2) {
//           _showLongToast("Enter the email");
//         } else if (cityController.text.length < 3) {
//           _showLongToast("Enter the city name ");
//         } else {
//           setState(() {
//             flag = true;
//           });
//           _getEmployee();
//         }
//       },
//       textColor: Colors.white,
//       padding: const EdgeInsets.all(0.0),
//       child: Container(
//         alignment: Alignment.center,
// //        height: _height / 20,
//         width: _large ? _width / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//           gradient: LinearGradient(
//             colors: <Color>[AppColors.boxColor1, AppColors.boxColor2],
//           ),
//         ),
//         padding: const EdgeInsets.all(12.0),
//         child: Text(
//           '${getTranslated(context, 'sinup')}',
//           style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
//         ),
//       ),
//     );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget socialIconsRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 80.0),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/googlelogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/fblogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          /* CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/twitterlogo.png"),
          ),*/
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.boxColor1,
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Widget circularIndi() {
    return const Align(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
