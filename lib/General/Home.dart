import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:arm_cool_care/BottomNavigation/categories.dart';
import 'package:arm_cool_care/BottomNavigation/profile.dart';
import 'package:arm_cool_care/BottomNavigation/screenpage.dart';
import 'package:arm_cool_care/BottomNavigation/wishlist.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/Web/WebviewTermandCondition.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/locatization/language.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/screen/custom_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'drawer.dart';

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  MyApp1State createState() => MyApp1State();
}

class MyApp1State extends State<MyApp1> {
  static int countval = 0;
  SharedPreferences? pref;
  final addController = TextEditingController();

  // final translator =GoogleTranslator();
  void gatinfoCount() async {
    pref = await SharedPreferences.getInstance();

    int? Count = pref!.getInt("itemCount");
    bool? ligin = pref!.getBool("isLogin");
    String? userid = pref!.getString("user_id");
    String? image = pref!.getString("pp");
    String? lval = pref!.getString("language");
    setState(() {
      lngval = lval ?? "en";
      Constant.image = image!;
      print(image);
      print("Constant.image=image");
      Constant.user_id = userid!;
      Constant.isLogin = ligin!;
      Constant.carditemCount = Count!;
      countval = Count;
      //      print(Constant.carditemCount.toString()+"itemCount");
    });
  }

  Position? position;
  getAddress(double lat, double long) async {
    //final coordinates = Coordinates(lat, long);

    var addresses = await placemarkFromCoordinates(lat, long);
    var first = addresses.first;
    setState(() {
      var address = first.subLocality.toString() +
          " " +
          first.locality.toString() +
          " " +
          first.subAdministrativeArea.toString() +
          " " +
          first.thoroughfare.toString();

      addController.text = address.replaceAll("null", "");
      // print('Rahul ${address}');
      // pref.setString("lat", lat.toString());
      // pref.setString("lat", lat.toString());
      // pref.setString("add", address.toString().replaceAll("null", ""));
    });
    // setState(() {
    //   // valArea=first.subLocality+ " "+first.subAdminArea.toString()+" "+first.featureName.toString()+" "+first.thoroughfare.toString()+""+first.postalCode.toString();
    //   var address =
    //       "${first.subLocality} ${first.subAdminArea} ${first.featureName} ${first.thoroughfare}";
    //   print('Rahul $address');
    //   pref!.setString("lat", lat.toStringAsFixed(7));
    //   pref!.setString("add", address.toString().replaceAll("null", ""));
    // });
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      Constant.latitude = position!.latitude;
      Constant.longitude = position!.longitude;
      print(' lat ${Constant.latitude},${Constant.longitude}');
      getAddress(Constant.latitude, Constant.longitude);
    });
  }

  void _changelanguage(Language language) async {
    Locale locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, locale);
  }

  int count = 0;
  @override
  void initState() {
    _getCurrentLocation();
    //  getData();
    // TODO: implement initState
    super.initState();
    // translator = GoogleTranslator();
    gatinfoCount();
  }

  String? lngval;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Screen _screen = Screen();
  final Cgategorywise _categories = Cgategorywise("");
  //final My_Cat _categories = My_Cat();
  final WishList _cartitem = WishList();
  final ProfileView _profilePage = ProfileView();
  final WebViewClass _webview =
      WebViewClass("", Constant.base_url + "ratekart");
  final CustomOrder _customOrder = CustomOrder();
  final int _current = 0;
  int _selectedIndex = 0;
  Widget _showPage = Screen();
  Widget _PageChooser(int page) {
    switch (page) {
      case 0:
        _onItemTapped(0);
        return _screen;
        break;
      case 1:
        _onItemTapped(1);
        return _categories;
        break;
      // case 2:
      //   _onItemTapped(2);
      //   return _customOrder;
      //   break;
      case 2:
        _onItemTapped(2);
        return _cartitem;
        break;
      case 3:
        _onItemTapped(3);
        return _webview;
        break;
      case 4:
        _onItemTapped(4);
        return _profilePage;
        break;
      default:
        return Container(
          child: const Center(
            child: Text('No Page is found'),
          ),
        );
    }
  }

  String? appname;
  String? hm, cat, cart, hlp;
  static String? cathome;
  bool check = false;
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              scrollable: true,
              title: const Text('Please Select City'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: FutureBuilder(
                    future: getPcity(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width:
                                    snapshot.data![index] != 0 ? 130.0 : 230.0,
                                color: Colors.white,
//                                margin: EdgeInsets.only(right: 10),

                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      check = true;
                                      pref!.setBool("firstTimeOpen", false);
                                      pref!.setString(
                                          'city',
                                          snapshot.data![index].places
                                              .toString());
                                      pref!.setString(
                                          'cityid',
                                          snapshot.data![index].loc_id
                                              .toString());
                                      Constant.cityid = snapshot
                                          .data![index].loc_id
                                          .toString();
                                      Constant.citname = snapshot
                                          .data![index].places
                                          .toString();
                                    });
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MyApp1()),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.all(10),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: Text(
                                              snapshot.data![index].places
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Divider(
                                      //
                                      //   color: AppColors.black,
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: check ? Colors.green : Colors.grey),
                  ),
                  onPressed: () {
                    // check
                    //     ?
                    Navigator.pop(context);
                    // : showLongToast(" Select city");
                  },
                )
              ],
            ),
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pref!.getBool("firstTimeOpen") == null) {
        // _displayDialog(context);
      }
    });
    return WillPopScope(
      onWillPop: () async {
        // drawer is open then first close it
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else {
          showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                    title: const Text('Warning'),
                    content: const Text('Do you really want to exit'),
                    actions: [
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () => {
                          exit(0),
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.pop(c, false),
                      ),
                    ],
                  ));
        }
        // we can now close the app.
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,

        drawer: const Drawer(
          child: AppDrawer(),
        ),
        appBar: AppBar(
          title: Text(
            Constant.appname,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),

          // search box commented
          /*Container(
        margin: EdgeInsets.only(top: 10,bottom: 0),

          height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(

                  width: MediaQuery.of(context).size.width/1.5-40,
                  margin: EdgeInsets.only(top: 10,bottom: 15),
                  child: Material(

                    color: Colors.white,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserFilterDemo()),
                        );
                      },

                        child:Padding(padding: EdgeInsets.only(top:5.0),
                          child:
                          TextField(

                            enabled: false,
                            obscureText: false,
                            decoration: InputDecoration(
                                hintText: "Search Product",
                                hintStyle: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.tela,
                                )),


                          ),)),
                  ),
                ),

              ],
            ),
          ),*/
          /* Container(
              height: 40,
              margin: EdgeInsets.only(top: 5,bottom: 5),
              child: Center(
                // padding: EdgeInsets.only(top: 3),
                child: Text('${getTranslated(context, 'appname')}',
                // child: Text('${lng_trans("JAI KISAN",lngval)!=null?lng_trans("JAI KISAN",lngval):Constant.appname}',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18,color: Colors.white),),
              )),*/
          elevation: 0.0,
          backgroundColor: AppColors.tela,
//                backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 13.0),
          //     child: InkWell(
          //       onTap: () => _displayDialog(context),
          //       child: Icon(
          //         Icons.add_location_alt_sharp,
          //         color: Colors.black,
          //         size: 30.0,
          //       ),
          //     ),
          //   ),
          // ],

          /* actions: <Widget>[

           */ /* Container(
              // width: 30,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(right:10.0),
              child: DropdownButton<Language>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                onChanged: (Language language) {
                  print(language.name);
                  _changelanguage(language);
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Text(
                        //   e.flag,
                        //   style: TextStyle(fontSize: 10),
                        // ),
                        Text(e.name)
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),*/ /*
*/ /*
            InkWell(
              onTap: (){
                _displayDialog(context);


                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => UserFilterDemo()),
                // );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 0,right: 10),
                child: Icon(Icons.add_location,color: Colors.white,size: 30,),
              ),
            ),
*/ /*


            InkWell(
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WishList()),);
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20,right: 30),
                    child: Icon(Icons.shopping_cart,color: Colors.white,size: 22,),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15,bottom: 20,top: 0),
                      child: Container(

                        padding: const EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.homeiconcolor,
                        ),
                        child: Text('${Constant.carditemCount}',
                            style: TextStyle(color: Colors.white, fontSize: 15.0)),
                      ),
                    ),

                  ),
                  // ScreenState.showCircle(),
                ],
              ),
            ),




          ],*/
          /* bottom: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: Container(

          margin: EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: InkWell(
//            onTap: () {
//              showSearch(context: context, delegate: DataSerch(SplashScreenState.filteredUsers));
//
//              print('ontap method');
//            },
            child: Material(

              color: AppColors.teladep,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.tela,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(

                child:Padding(padding: EdgeInsets.only(top:5.0),
              child:
              TextField(
                  onTap:(){
//                    showSearch(context: context, delegate: DataSerch(SplashScreenState.filteredUsers));


                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserFilterDemo()),
                    );
                  },
    style: TextStyle(
    color: Colors.green[900]),
                decoration: InputDecoration(

                  hintText: 'Search Your Product',
                  hintStyle: TextStyle(color: AppColors.tela),

                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),)),
            ),
          ),
        ),

      ),*/
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon:

                  /* Image.asset("assets/images/home.png",
                  color: _selectedIndex == 0 ? AppColors.tela : AppColors.homeiconcolor,
                  height: 28,width: 28,fit:BoxFit.fill), */

                  Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0
                    ? AppColors.homeiconcolor
                    : AppColors.black,
                size: 25,
              ),
              label: "home"
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category_rounded,
                color: _selectedIndex == 1
                    ? AppColors.homeiconcolor
                    : AppColors.black,
                size: 25,
              ),
              label:"cat",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.add,
            //     color: _selectedIndex == 2 ? AppColors.homeiconcolor : AppColors.tela,
            //     size: 25,
            //   ),
            //   title: Text('Upload List', style: TextStyle(fontSize: 12)),
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_sharp,
                color: _selectedIndex == 2
                    ? AppColors.homeiconcolor
                    : AppColors.black,
                size: 25,
              ),
              label: ' ${getTranslated(context, 'mcart')}',
              
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(
                Icons.design_services_sharp,
                color: _selectedIndex == 3
                    ? AppColors.homeiconcolor
                    : AppColors.black,
                size: 25,
              ),
              label:   'Spare Parts'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.perm_identity,
                color: _selectedIndex == 4
                    ? AppColors.homeiconcolor
                    : AppColors.black,
                size: 25,
              ),
              label: '${getTranslated(context, 'ac')}',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.onselectedBottomicon,
          backgroundColor: AppColors.tela,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
//          debugPrint("Current Index is $index");
            setState(() {
              _showPage = _PageChooser(index);
            });
          },
        ),

        body: Container(
            color: AppColors.tela,
//    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
            child: _showPage),
      ),
    );
  }
}
