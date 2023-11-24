import 'dart:async';
import 'dart:convert';

import 'package:arm_cool_care/Auth/signup.dart';
import 'package:arm_cool_care/Auth/widgets/custom_shape.dart';
import 'package:arm_cool_care/Auth/widgets/customappbar.dart';
import 'package:arm_cool_care/Auth/widgets/responsive_ui.dart';
import 'package:arm_cool_care/Auth/widgets/textformfield.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/RegisterModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerify extends StatelessWidget {
  const OtpVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Scaffold(
        body: SignInScreen(),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? name;
  String? mobile;
  double? _height;
  double? _width;
  double? _pixelRatio;
  bool? _large;
  bool? _medium;
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  var swatch = Stopwatch();
  bool isLoading = false;

  Timer? _timer;
  int _start = 60;
  String timrvalue = "00:00";

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            timrvalue = "00 : " '$_start';
          }
        },
      ),
    );
  }

  Future<List<OtpModal>?> _getEmployeeotp() async {
    var map = <String, dynamic>{};
    map['shop_id'] = Constant.Shop_id;
    map['otp'] = otpController.text;
    map['mobile'] = mobile;
    final response = await http
        .post(Uri.parse('${Constant.base_url}api/step2.php'), body: map);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      OtpModal user = OtpModal.fromJson(jsonDecode(response.body));
      if (user.message.toString() == "OTP Verified Successfully.") {
        showLongToast(user.message);
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      } else {
        showLongToast(user.message);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      throw Exception("Unable to get Employee list");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    gatinfo();
  }

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.get("name") as String?;
    mobile = pref.get("mobile") as String?;
  }

//  @override
//  void dispose() {
////    _timer.cancel();
//    super.dispose();
//  }

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
              const Opacity(opacity: 0.88, child: CustomAppBar()),
              clipShape(),
              welcomeTextRow(),
//              signInTextRow(),
              form(),

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 30),
                    child: Text(timrvalue),
                  ),
                ],
              ),
//              forgetPassTextRow(),
              SizedBox(height: _height! / 52),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              button(),
//              signUpTextRow(),
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
          opacity: 0.65,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large!
                  ? _height! / 5
                  : (_medium! ? _height! / 5 : _height! / 7),
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
              height: _large!
                  ? _height! / 4.5
                  : (_medium! ? _height! / 4.25 : _height! / 4),
              decoration: const BoxDecoration(
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
              top: _large!
                  ? _height! / 20
                  : (_medium! ? _height! / 45 : _height! / 40)),
          child: Image.asset(
            'assets/images/logo.png',
            height: 200,
            width: 200,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(
        left: _width! / 20,
      ),
      child: const Row(
        children: <Widget>[
          Text(
            "Get Otp Message",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0, right: _width! / 12.0, top: _height! / 40),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height! / 40.0),
//            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: otpController,
      icon: Icons.mobile_screen_share,
      hint: getTranslated(context, 'eo'),
    );
  }

/*  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: passwordController,
      icon: Icons.phone_android,
      obscureText: true,
      hint: "MObile Number",
    );
  }*/

/*  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          )
        ],
      ),
    );
  }*/

  Widget button() {
    return ElevatedButton(
      // elevation: 0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (otpController.text.length != 5) {
          showLongToast("Please enter the valied OTP");
        } else {
          setState(() {
            isLoading = true;
          });
          _getEmployeeotp();
        }
//        Scaffold
//            .of(context)
//            .showSnackBar(SnackBar(content: Text('Login Successful')));
      },
      // textColor: Colors.white,
      // padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: 120,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[AppColors.boxColor1, AppColors.boxColor2],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text("Verify OTP",
            style: TextStyle(fontSize: _large! ? 14 : (_medium! ? 12 : 10))),
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
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large! ? 14 : (_medium! ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.boxColor1,
                  fontSize: _large! ? 19 : (_medium! ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }

  void showLongToast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
