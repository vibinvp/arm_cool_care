import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:arm_cool_care/Auth/signin.dart';
import 'package:arm_cool_care/Auth/widgets/change_password.dart';
import 'package:arm_cool_care/BottomNavigation/profile.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/General/Home.dart';
import 'package:arm_cool_care/Web/WebviewTermandCondition.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/screen/ShowAddress.dart';
import 'package:arm_cool_care/screen/my_bookings.dart';
import 'package:arm_cool_care/screen/my_order.dart';
import 'package:arm_cool_care/screen/newWishlist.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool islogin = false;
  String? name, email, image, cityname, mobile;
  int? wcount;
  SharedPreferences? pref;

  void gatinfo() async {
    pref = await SharedPreferences.getInstance();
    islogin = pref!.getBool("isLogin")!;
    int wcount1 = pref!.get("wcount") as int;
    name = pref!.get("name") as String;
    email = pref!.get("email") as String;
    image = pref!.get("pp") as String;
    cityname = pref!.get("city") as String;
    mobile = pref!.get("mobile") as String;
    print("mobile------->$mobile");
    islogin ??= false;

    // print(islogin);
    setState(() {
      Constant.name = name!;
      Constant.email = email!;
      islogin == null ? Constant.isLogin = false : Constant.isLogin = islogin;
      Constant.image = image!;
      print(Constant.image);

      Constant.citname = cityname!;

      // print( Constant.image.length);
      wcount = wcount1;
    });
  }

  bool check = false;

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Select City'),
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
                              width: snapshot.data![index] != 0 ? 130.0 : 230.0,
                              color: Colors.white,
                              margin: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    check = true;
                                    pref!.setString(
                                        'city',
                                        snapshot.data![index].places
                                            .toString());
                                    pref!.setString(
                                        'cityid',
                                        snapshot.data![index].loc_id
                                            .toString());
                                    Constant.cityid =
                                        snapshot.data![index].loc_id!;
                                    Constant.citname =
                                        snapshot.data![index].places!;

                                    Navigator.pop(context);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp1()),
                                    );
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(10),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
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
                  check
                      ? Navigator.of(context).pop()
                      : showLongToast("Please Select city");
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    gatinfo();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            color: AppColors.tela,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                height: 68,
                color: AppColors.tela,
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 12),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp1()),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Menu",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            if (Constant.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.shopping_bag,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /* USER PROFILE DRAWER Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 40,left: 20),
                  color: AppColors.tela1,
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child:CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.white,
                    child: ClipOval(
                      child: new SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child:Constant.image==null? Image.asset('assets/images/logo.png',):Constant.image.length==1?Image.asset('assets/images/logo.png',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? Image.asset('assets/images/logo.png',):Image.network(
                          Constant.image,
                          fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child:Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),) ,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20,bottom: 20),
                  child:Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
                ),
            /*    InkWell(
                  onTap: (){
                    _displayDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20,bottom: 20),
                    child:Text(Constant.citname!=null?Constant.citname:" ",
                      overflow:TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black),),
                  ),
                ),*/
              ],
            ),*/
          ),

          /* UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/drawer-header.jpg'),
                )),
            currentAccountPicture:  CircleAvatar(
              radius:30,
              backgroundColor: Colors.black,
              backgroundImage:Constant.image==null? AssetImage('assets/images/logo.jpg',):Constant.image.length==1?AssetImage('assets/images/logo.jpg',):Constant.image=="https://www.bigwelt.com/manage/uploads/customers/nopp.png"? AssetImage('assets/images/logo.jpg',):NetworkImage(
                  Constant.image),
            ),
            accountName: Text(islogin?Constant.name:" ",style: TextStyle(color: Colors.black),),
            accountEmail: Text(islogin?Constant.email:" ",style: TextStyle(color: Colors.black),),
          ),*/
          Container(
            child: ListView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: AppColors.tela),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp1()),
                    );
                  },
                ),
                const Divider(),
                ExpansionTile(
                  title: const Text('My Account'),
                  leading: Icon(Icons.person, color: AppColors.tela),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: AppColors.tela,
                          ),
                          title: const Text("My Profile"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileView()),
                            );
                          }),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: AppColors.tela,
                        ),
                        title: const Text("My Bookings"),
                        onTap: () {
                          if (Constant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrackOrder()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_bag,
                          color: AppColors.tela,
                        ),
                        title: const Text("My Orders"),
                        onTap: () {
                          if (Constant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyOrder()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_road,
                          color: AppColors.tela,
                        ),
                        title: const Text("My Addresses"),
                        onTap: () {
                          if (Constant.isLogin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowAddress("1")),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // Divider(),
                /*   ListTile(
                  leading: Icon(Icons.list_alt,
                      color: AppColors.tela),
                  title: Text('Shop By Categories'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Cgategorywise("0")),);
                  },
                ), */

                /* ListTile(
                  leading: Icon(Icons.offline_bolt_rounded,
                      color: AppColors.tela),
                  title: Text('Deals of the Day'),
                  trailing: Text('New',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("day","DEALS OF THE DAY")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.stacked_line_chart,
                      color: AppColors.tela),
                  title: Text('Top Products'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList("top","TOP PRODUCTS")),
                    );
                  },
                ),*/

                /* ListTile(
                  leading: Icon(Icons.traffic,
                      color: AppColors.tela),
                  title: Text('New Arrival'),
                  trailing: Text('',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ProductList("day",
                              Constant.AProduct_type_Name2)),);
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.favorite, color: AppColors.tela),
                  title: Text('My Wishlist'),
                  /* trailing: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(wcount!=null?wcount.toString():'0',
                        style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),*/
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewWishList())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ), */

                /*  ListTile(
                  leading: Icon(Icons.star_border,
                      color: AppColors.tela),
                  title: Text('Rate US',),
                  onTap: () {
                    Navigator.of(context).pop();

                    String os = Platform.operatingSystem; //in your code
                    if (os == 'android') {
                      LaunchReview.launch(
                        androidAppId: "com.freshatdoorstep",);

                    }
                  },
                ),*/
                // ListTile(
                //   leading: Icon(Icons.analytics_rounded,
                //       color: AppColors.tela),
                //   title: Text('Blog'),
                //   trailing: Text('',
                //       style: TextStyle(color: Theme.of(context).primaryColor)),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //
                //     Navigator.push(context, MaterialPageRoute(
                //         builder: (context) => BlogScreen()),
                //     );
                //   },
                // ),ListTile(
                //                   leading: Icon(
                //                     Icons.account_balance_wallet_rounded,
                //                     color: AppColors.tela,
                //                   ),
                //                   title: Text('My Wallet'),
                //                   onTap: () {
                //                     Navigator.of(context).pop();
                //                     if (Constant.isLogin) {
                //                       Get.to(
                //                         () => WalltReport(),
                //                         transition: Transition.zoom,
                //                         duration: Duration(milliseconds: 700),
                //                       );
                //                     } else {
                //                       Get.to(
                //                         () => SignInPage(),
                //                         transition: Transition.zoom,
                //                         duration: Duration(milliseconds: 700),
                //                       );
                //                     }
                //                   },
                //                 ),
                // ListTile(
                //   leading: Icon(
                //     Icons.account_balance_wallet_rounded,
                //     color: AppColors.tela,
                //   ),
                //   title: Text('My Wallet'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     if (Constant.isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WalltReport(),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WalltReport(),
                //         ),
                //       );
                //     }
                //   },
                // ),
                // Divider(),
                // ListTile(
                //   leading: Icon(
                //     Icons.money_sharp,
                //     color: AppColors.tela,
                //   ),
                //   title: Text('My Earnings'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     if (Constant.isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WebViewClass(
                //             "My Earnings",
                //             "${Constant.base_url}Api_earnings.php?username=$mobile&shop_id=${Constant.Shop_id}",
                //           ),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SignInPage(),
                //         ),
                //       );
                //     }
                //   },
                // ),
                // Divider(),
                // ListTile(
                //   leading: Icon(
                //     Icons.favorite,
                //     color: AppColors.tela,
                //   ),
                //   title: Text('My Wishlist'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     if (Constant.isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => NewWishList(),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SignInPage(),
                //         ),
                //       );
                //     }
                //   },
                // ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.password,
                    color: AppColors.tela,
                  ),
                  title: const Text('Change Password'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (Constant.isLogin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.help, color: AppColors.tela),
                  title: const Text('AMC'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "AMC",
                                ""
                                    "${Constant.base_url}amc"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.phone, color: AppColors.tela),
                  title: const Text('Contact Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Contact Us",
                                ""
                                    "${Constant.base_url}contact"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: AppColors.tela),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Privacy Policy",
                                ""
                                    "${Constant.base_url}pp"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.info, color: AppColors.tela),
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "About Us",
                                ""
                                    "${Constant.base_url}about"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.file_copy, color: AppColors.tela),
                  title: const Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewClass(
                                "Terms & Conditions",
                                ""
                                    "${Constant.base_url}tc"))
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                        );
                  },
                ),
                const Divider(),
                /* ListTile(
                  leading:
                  Icon(Icons.file_copy, color: AppColors.tela),
                  title: Text('Terms & Conditions'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("Terms & Conditions","https://www.freshatdoorstep.com/tc"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                /* ListTile(
                  leading:
                  Icon(Icons.question_answer, color: AppColors.tela),
                  title: Text('FAQ'),
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass("FAQ","https://www.freshatdoorstep.com/faq"))
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RateMyAppTestApp())
//                        NewWishList()),
//                      Cat_Product
                    );
                  },
                ),*/
                ListTile(
                    leading: Icon(Icons.share, color: AppColors.tela),
                    title: const Text('Share'),
                    onTap: () {
                      if (Platform.isAndroid) {
                        _shareAndroidApp();
                      } else {
                        _shareIosApp();
                      }
                    }),
                const Divider(),

                Constant.isLogin
                    ? Container()
                    : ListTile(
                        leading: Icon(Icons.lock, color: AppColors.tela),
                        title: const Text('Login'),
                        onTap: () {
                          Navigator.of(context).pop();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                      ),

                ListTile(
                  leading: Icon(Icons.delete, color: AppColors.tela),
                  title: const Text('Delete Account'),
                  onTap: () async {
                    Random random = Random();
                    var randomNumber = random.nextInt(10000);
                    if (Constant.isLogin) {
                      await deleteAccount("customers", "username",
                          "${Constant.username}-D$randomNumber");
                      _callLogoutData();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget rateUs() {
    return InkWell(
        onTap: () {
          String os = Platform.operatingSystem; //in your code
          if (os == 'android') {
            LaunchReview.launch(
              androidAppId:
                  "https://play.google.com/store/apps/details?id=com.chickenista",
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          child: Row(
            children: <Widget>[
              Text(
                "Rate Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }

  Future<void> _callLogoutData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.isLogin = false;
    Constant.email = " ";
    Constant.name = " ";
    Constant.image = " ";
    pref.setString("pp", " ");
    pref.setString("email", " ");
    pref.setString("name", " ");
    pref.setBool("isLogin", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  _shareAndroidApp() {
    Share.share(
        "${"Hi, Looking for Best Deals Online Download " + Constant.appname} app from this link: https://play.google.com/store/apps/details?id=${Constant.packageName}");
  }

  _shareIosApp() {
    Share.share(
        "${"Hi, Looking for Best Deals Online. Download " + Constant.appname} app from this link:${Constant.iosAppLink}");
  }
}
