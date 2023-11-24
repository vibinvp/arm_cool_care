import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/General/Home.dart';
import 'package:arm_cool_care/screen/my_bookings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<VideoSplashScreen> {
  VideoPlayerController? playerController;
  VoidCallback? listener;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    getLocation();
    super.initState();
    initializeVideo();

    ///video splash display only 5 second you can change the duration according to your need
    startTime();
    // _firebaseMessaging.getToken().then((token) async {
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   pref.setString("firebaseToken", token);
    //   print("token----->${pref.get("firebaseToken")}");
    //   // Print the Token in Console
    // });
  }

  /*firebaseMessagingConfiguration() {
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackOrder(),
          ),
        );
      },
      onResume: (Map<String, dynamic> message) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrackOrder()),
        );
      },
      onMessage: (Map<String, dynamic> message) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrackOrder()),
        );
      },
    );
  }*/

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    playerController!.setVolume(0.0);
    //playerController.removeListener(listener);
    // Navigator.of(context).pop(VIDEO_SPALSH);
    // Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),);
    checkLogin();
  }

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
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()),):
      // Constant.isLogin==false? Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()),):
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp1()),
      );
    });

    // print(cityname);
  }

  void initializeVideo() {
    playerController = VideoPlayerController.asset('assets/videos/welcome.mp4')
      ..addListener(listener!)
      ..setVolume(1.0)
      ..setLooping(false)
      ..initialize()
      ..play();
  }

  @override
  void deactivate() {
    playerController!.setVolume(0.0);
    playerController!.removeListener(listener!);
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    playerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFFF9DF49),
            body: Stack(children: <Widget>[
              // new Column(
              //   mainAxisAlignment: MainAxisAlignment.center,

              //   // mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     //              Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('assets/images/powered_by.png',height: 25.0,fit: BoxFit.scaleDown,))
              //   ],
              // ),
              // new Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     new Image.asset(
              //       'assets/images/logo.png',
              //       width: animation.value * 250,
              //       height: animation.value * 250,
              //     ),
              //   ],
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 40,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage("assets/images/splashimage.jpeg"),fit: BoxFit.cover)),
                child: (playerController != null
                    ? VideoPlayer(
                        playerController!,
                      )
                    : Container()),
              ),
            ])));
    // )));
  }
}
