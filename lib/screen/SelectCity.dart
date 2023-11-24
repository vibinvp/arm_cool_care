import 'dart:io';

import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/General/Home.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCity extends StatefulWidget {
  const SelectCity({super.key});

  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  SharedPreferences? pref;
  void setcity(String val, String cityid) async {
    pref = await SharedPreferences.getInstance();
    pref!.setString('city', val);
    pref!.setString('cityid', cityid);
    setState(() {
      Constant.cityid = cityid;
      Constant.citname = val;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp1()),
      );
    });
    // snapshot.data[index].loc_id
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a dialog and wait for the user's response
        bool? shouldPop = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Warning'),
            content: const Text('Do you really want to exit'),
            actions: [
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  // If 'Yes' is pressed, pop the route
                  Navigator.pop(c, true);
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  // If 'No' is pressed, do not pop the route
                  Navigator.pop(c, false);
                },
              ),
            ],
          ),
        );

        // Return the user's choice
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.tela1,
        appBar: AppBar(
          backgroundColor: AppColors.tela,
          // leading: Padding(padding: EdgeInsets.only(left: 0.0),
          //     child:InkWell(
          //       onTap: (){
          //         if (Navigator.canPop(context)) {
          //           Navigator.pop(context);
          //         } else {
          //           SystemNavigator.pop();
          //         }
          //       },
          //
          //       child: Icon(
          //         Icons.arrow_back,size: 30,
          //         color: Colors.white,
          //       ),
          //
          //     )
          // ),

          actions: const <Widget>[],
          title: Text("SELECT CITY",
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          color: AppColors.tela1,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: getPcity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,

                          // color: Colors.white,
                          margin: const EdgeInsets.only(right: 10),

                          child: InkWell(
                            onTap: () {
                              setcity(snapshot.data![index].places.toString(),
                                  snapshot.data![index].loc_id.toString());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text(
                                        snapshot.data![index].places.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
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
      ),
    );
  }
}
