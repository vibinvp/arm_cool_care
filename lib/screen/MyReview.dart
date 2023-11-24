import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/StyleDecoration/styleDecoration.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/locatization/language_constant.dart';
import 'package:arm_cool_care/model/MyReviewModel.dart';
import 'package:arm_cool_care/screen/detailpage1.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReview extends StatefulWidget {
  const MyReview({super.key});

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<MyReview> {
  Future<void> getUserInfo() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String? userid = pre.getString("user_id");
    setState(() {
      Constant.user_id = userid!;
    });
  }

  int line = 2;
  String textval = "Show more";
  bool flag = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    print(Constant.user_id);
    print("Constant.user_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tela,
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "${getTranslated(context, 'mr')}",
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: myReview(Constant.user_id),
//          future: myReview("2345"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.length);
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Review item = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails1(
                                        item.product.toString())),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        item.productName ?? "",
                                        overflow: TextOverflow.fade,
                                        style: CustomTextStyle
                                            .textFormFieldMedium
                                            .copyWith(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: RatingBar.builder(
                                            initialRating: double.parse(
                                                item.stars.toString()),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          )),
                                    ],
                                  ),
                                  ReadMoreText(
                                    item.review.toString(),
                                    // expandingButtonColor: Colors.green,
                                  ),

//                                  Row(
//                                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Expanded(
//                                        child: Container(
//                                          padding: EdgeInsets.only(top: 10),
//                                          child: Text(item.review!=null?item.review:"",
//                                            maxLines: line,
//                                            overflow: TextOverflow.ellipsis,
//                                            style: CustomTextStyle.textFormFieldSemiBold
//                                                .copyWith(fontSize: 15, color: Colors.black54),
//                                          ),
//                                        ),
//                                      ),
//
//                                    ],
//                                  ),
                                  /*  Row(
                                    mainAxisAlignment:  MainAxisAlignment.end,

                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {

                                            if(flag){
                                              setState(() {
                                                line=15;
                                                textval="Show less";
                                                flag=false;
                                              });

                                            }
                                            else{
                                              setState(() {
                                                line=2;
                                                textval="Show more";
                                                flag=true;
                                              });

                                            }


                                        },
                                        color: AppColors.red,
                                        padding: EdgeInsets.only( left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(24))),
                                        child: Text(
                                          textval,style: TextStyle(color: Colors.black),

                                        ),
                                      ),
                                    ],
                                  ),*/
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          item.dates.toString(),
                                          style: CustomTextStyle
                                              .textFormFieldSemiBold
                                              .copyWith(
                                                  fontSize: 15,
                                                  color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
