import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppConstant.dart';
import 'Home.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  static List<Products> filteredUsers = [];

  var _visible = true;
  String? logincheck;

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      Constant.latitude = position.latitude;
      Constant.longitude = position.longitude;
    });
    print(position);
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? pin = pref.getString("pin");
    String? cityid = pref.getString("cityid");
    bool? val = pref.getBool("isLogin");

    pref.setString("lat", Constant.latitude.toString());
    pref.setString("lng", Constant.longitude.toString());

    print("cityid.length");
    print(val);

    setState(() {
      cityid == null ? Constant.cityid = "" : Constant.cityid = cityid;
      Constant.pinid = pin!;
      val == null ? Constant.isLogin = false : Constant.isLogin = val;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp1()),
      );
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),):
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),):
      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
    });

    // print(cityname);
  }

  AnimationController? animationController;
  Animation<double>? animation;
  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    checkLogin();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp1()),
    );
    //Navigator.push(context, MaterialPageRoute(builder: (context) => SelectButton()),);

    // Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => LoginPage()),
    //     );
  }

  @override
  void initState() {
    super.initState();
    //getLocation();

    search(
      "",
    ).then((usersFromServe) {
      setState(() {
        filteredUsers = usersFromServe!;
//        print(filteredUsers.length.toString()+" jkjg");
      });
    });
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.ease);

    animation!.addListener(() => setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });
    // navigationPage();
    startTime();
    // checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tela,
      body:

          //  Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 600,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("assets/images/logo.png"),
          //         fit: BoxFit.contain),
          //   ),
          //   // child: new Image.asset(
          //   //   'assets/videos/splash.gif',
          //   //   width: MediaQuery.of(context).size.width,
          //   //   height: MediaQuery.of(context).size.height,
          //   // ),
          // ),
          //   ],
          // ),

          Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/spl.png',
                width: animation!.value * 250,
                height: animation!.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
