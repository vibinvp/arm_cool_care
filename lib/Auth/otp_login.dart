import 'dart:convert';

import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:arm_cool_care/Auth/forgetPassword.dart';
import 'package:arm_cool_care/Auth/widgets/custom_shape.dart';
import 'package:arm_cool_care/Auth/widgets/customappbar.dart';
import 'package:arm_cool_care/Auth/widgets/register.dart';
import 'package:arm_cool_care/Auth/widgets/responsive_ui.dart';
import 'package:arm_cool_care/Auth/widgets/textformfield.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/General/Home.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/LoginModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPLogScreen extends StatelessWidget {
  final String number;

  const OTPLogScreen({Key? key, required this.number}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: OTPLogINScreen(
          number: number,
        ),
      ),
    );
  }
}

class OTPLogINScreen extends StatefulWidget {
  final String number;

  const OTPLogINScreen({Key? key, required this.number}) : super(key: key);
  @override
  _OTPLogINScreenState createState() => _OTPLogINScreenState();
}

class _OTPLogINScreenState extends State<OTPLogINScreen> {
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool _large = false, flag = false;
  bool _medium = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  void _showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future _getEmployee() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var map = <String, dynamic>{};
    map['shop_id'] = Constant.Shop_id;
    map['mobile'] = widget.number;
    map['password'] = passwordController.text;

    final response = await http
        .post(Uri.parse(Constant.base_url + 'api/login.php'), body: map);
    if (response.statusCode == 200) {
      print(response.toString());
      final jsonBody = json.decode(response.body);
      loginModal user = loginModal.fromJson(jsonDecode(response.body));
      print(jsonBody.toString());
      if (user.message.toString() == "Login is Successful") {
        setState(() {
          flag = false;
        });
        _showLongToast(user.message);
        pref.setString("email", user.email);
        pref.setString("name", user.name);
        pref.setString("city", user.city);
        pref.setString("address", user.address);
        pref.setString("sex", user.sex);
        pref.setString("mobile", user.username);
        pref.setString("pin", user.pincode);
        pref.setString("user_id", user.user_id);
        pref.setString("pp", user.pp);
        pref.setBool("isLogin", true);
        print(user.user_id);
        Constant.isLogin = true;
        Constant.email = user.email;
        Constant.name = user.name;
        Constant.user_id = user.user_id;
        Constant.image = user.pp;
        // pref.setString("pp", user.username);

//        pref.setString("mobile",phoneController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp1()),
        );
      } else {
        _showLongToast(user.message);
        setState(() {
          flag = false;
        });
      }
    } else {
      throw Exception("Unable to get Employee list");
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: const EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88, child: CustomAppBar()),
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              // forgetPassTextRow(),
              const SizedBox(height: 12),
              button(),
              //  signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height! / 4
                  : (_medium ? _height! / 3.75 : _height! / 3.5),
              decoration: BoxDecoration(
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
                  ? _height! / 4.5
                  : (_medium ? _height! / 4.25 : _height! / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.boxColor1, AppColors.boxColor2],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height! / 60
                  : (_medium ? _height! / 45 : _height! / 40)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 200,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width! / 20, top: _height! / 100),
      child: Row(
        children: <Widget>[
          Text(
            "${getTranslated(context, 'wel')}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width! / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "${getTranslated(context, 'sign')}",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            // emailTextFormField(),
            // SizedBox(height: _height / 40.0),
            passwordTextFormField(),
            flag ? circularIndi() : const Row(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: nameController,
      icon: Icons.phone_android,
      hint: " ENTER OTP",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "OTP",
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${getTranslated(context, 'fpass')}?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgetPass()),
              );
              print("Routing");
            },
            child: Text(
              "${getTranslated(context, 'rec')}",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.boxColor1),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)))),
      onPressed: () {
        if (passwordController.text.length < 3) {
          _showLongToast("Please enter Valid OTP");
        } else {
          setState(() {
            flag = true;
          });
          _getEmployee();
        }

//          print("Routing to your account");
//          Scaffold
//              .of(context)
//              .showSnackBar(SnackBar(content: Text('Login Successful')));
      },
      child: Container(
        alignment: Alignment.center,
        width:
            _large ? _width! / 4 : (_medium ? _width! / 3.75 : _width! / 3.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[AppColors.boxColor1, AppColors.boxColor2],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('${getTranslated(context, 'sin')}',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height! / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${getTranslated(context, 'dont')} ?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: Text(
              "${getTranslated(context, 'sinup')}",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.boxColor1,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
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
