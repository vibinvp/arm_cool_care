import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/CategaryModal.dart';
import 'package:arm_cool_care/screen/SubCategry.dart';
import 'package:arm_cool_care/screen/secondtabview.dart';
import 'package:arm_cool_care/screen/SearchScreen.dart';

class Cgategorywise extends StatefulWidget {
  final String id;
  const Cgategorywise(this.id, {super.key});

  @override
  _CgategorywiseState createState() => _CgategorywiseState();
}

class _CgategorywiseState extends State<Cgategorywise> {
  List<Categary> cat_list = [];
  List<Categary> sub_cat_list = [];

  getlistval(String id) {
    getData(id).then((usersFromServe) {
      if (mounted) {
        setState(() {
          sub_cat_list = usersFromServe!;

//        }
        });
      }
    });
  }

  bool flag = false;

  @override
  void initState() {
    DatabaseHelper.getData("0").then((usersFromServe) {
      if (mounted) {
        setState(() {
          cat_list = usersFromServe!;
          // cat_list.length>0?getlistval(cat_list[0].pcatId):"";
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                //height: 50,
                margin: const EdgeInsets.only(top: 10, bottom: 15),
                width: double.infinity,
                child: Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Material(
                      color: Colors.grey[300],
                      elevation: 0.0,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserFilterDemo()),
                            );
                          },
                          child: TextField(
                            enabled: false,
                            obscureText: false,
                            decoration: InputDecoration(
                                hintText: "Search Services",
                                hintStyle: const TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.black,
                                )),
                          )),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        " Categories",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: getData("0"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: GridView.builder(
                                  itemCount: snapshot.data?.length ?? 0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 175,

                                    // childAspectRatio:
                                    //     (itemWidth / itemHeight),
                                    //childAspectRatio: 1 / 1
                                  ),
                                  itemBuilder: (context, index) {
                                    Categary item = snapshot.data![index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Sbcategory(
                                                  item.pCats.toString(),
                                                  item.pcatId.toString())),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5.0, 5.0, 5.0, 0.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.tela,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              // width: 80,
                                              height: 90,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                child: item.img!.isEmpty
                                                    ? Image.asset(
                                                        "assets/images/logo.png",
                                                        fit: BoxFit.fill)
                                                    : Image.network(
                                                        Constant.base_url +
                                                            "manage/uploads/p_category/" +
                                                            item.img.toString(),
                                                        fit: BoxFit.fill),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                // SizedBox(height: 10.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    item.pCats.toString(),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      color: AppColors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                              // GridView.builder(
                              //   physics: ClampingScrollPhysics(),
                              //   controller: new ScrollController(
                              //       keepScrollOffset: false),
                              //   shrinkWrap: true,
                              //   padding:
                              //       EdgeInsets.only(left: 2, right: 2, top: 6),
                              //   gridDelegate:
                              //       SliverGridDelegateWithFixedCrossAxisCount(
                              //     crossAxisCount: 2,
                              //     mainAxisSpacing: 4,
                              //     crossAxisSpacing: 7,
                              //     // childAspectRatio: 1 / 2,
                              //     mainAxisExtent: 190,
                              //   ),
                              //   itemBuilder: (context, index) {
                              //     Categary item = snapshot.data[index];
                              //     return InkWell(
                              //       onTap: () {
                              //         // var i = list[index].pcatId;
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => Sbcategory(
                              //                   item.pCats, item.pcatId)),
                              //         );
                              //       },
                              //       child: Column(
                              //         children: <Widget>[
                              //           Stack(
                              //             children: [
                              //               Container(
                              //                   decoration: BoxDecoration(
                              //                     // border: Border.all(
                              //                     //     color: AppColors.tela,
                              //                     //     width: 2),
                              //                     borderRadius:
                              //                         BorderRadius.circular(12),
                              //                   ),
                              //                   width: MediaQuery.of(context)
                              //                       .size
                              //                       .width,
                              //                   height: 190,
                              //                   child: ClipRRect(
                              //                     borderRadius:
                              //                         BorderRadius.circular(12),
                              //                     child: item.img.length > 0
                              //                         ? Image.network(
                              //                             Constant.base_url +
                              //                                 "manage/uploads/p_category/" +
                              //                                 item.img,
                              //                             fit: BoxFit.fill,
                              //                           )
                              //                         : AssetImage(
                              //                             "assets/images/logo.png"),
                              //                   )),
                              //               Container(
                              //                 decoration: BoxDecoration(
                              //                   color: Colors.black
                              //                       .withOpacity(0.5),
                              //                   borderRadius:
                              //                       BorderRadius.circular(12),
                              //                 ),
                              //                 width: MediaQuery.of(context)
                              //                     .size
                              //                     .width,
                              //                 height: 190,
                              //                 child: Center(
                              //                   child: Text(
                              //                     item.pCats.toUpperCase(),
                              //                     maxLines: 2,
                              //                     textAlign: TextAlign.center,
                              //                     overflow:
                              //                         TextOverflow.ellipsis,
                              //                     style: TextStyle(
                              //                         fontWeight:
                              //                             FontWeight.bold,
                              //                         fontSize: 15,
                              //                         color: AppColors.white),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           // SizedBox(
                              //           //   height: 7,
                              //           // ),
                              //           // Text(
                              //           //   list[index].pCats,
                              //           //   maxLines: 2,
                              //           //   textAlign: TextAlign.center,
                              //           //   overflow:
                              //           //       TextOverflow.ellipsis,
                              //           //   style: TextStyle(
                              //           //     fontWeight: FontWeight.bold,
                              //           //     fontSize: 14,
                              //           //     color: AppColors.black,
                              //           //   ),
                              //           // ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              //   itemCount: snapshot.data.length == null
                              //       ? 0
                              //       : snapshot.data.length,
                              // );
                              // end gridview.builder
                              // Container(
                              //   child: ListView.separated(
                              //     separatorBuilder: (context, index) {
                              //       return SizedBox(
                              //         height: 15,
                              //       );
                              //     },
                              //     physics: NeverScrollableScrollPhysics(),
                              //     // controller:
                              //     //     new ScrollController(keepScrollOffset: false),
                              //     shrinkWrap: true,
                              //     padding: EdgeInsets.only(
                              //       left: 10,
                              //       right: 10,
                              //     ),
                              //     itemBuilder: (context, index) {
                              //       Categary item = snapshot.data[index];
                              //       return InkWell(
                              //         onTap: () {
                              //           // Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2(item.pcatId,item.pCats)),);
                              //           Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => Sbcategory(
                              //                     item.pCats, item.pcatId)),
                              //           );
                              //         },
                              //         child: Card(
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(20.0),
                              //           ),
                              //           margin: EdgeInsets.zero,
                              //           elevation: 3.0,
                              //           child: Column(
                              //             children: [
                              //               Container(
                              //                 width: MediaQuery.of(context)
                              //                     .size
                              //                     .width,
                              //                 height: MediaQuery.of(context)
                              //                         .size
                              //                         .height *
                              //                     0.18,
                              //                 decoration: BoxDecoration(
                              //                   // border: Border.all(
                              //                   //     color: AppColors.tela,
                              //                   //     width: 2),
                              //                   borderRadius: BorderRadius.only(
                              //                       topLeft:
                              //                           Radius.circular(10),
                              //                       topRight:
                              //                           Radius.circular(10)),
                              //                   image: DecorationImage(
                              //                     fit: BoxFit.fill,
                              //                     image: item.img.length > 0
                              //                         ? NetworkImage(
                              //                             Constant.base_url +
                              //                                 "manage/uploads/p_category/" +
                              //                                 item.img,
                              //                           )
                              //                         : AssetImage(
                              //                             "assets/images/logo.png"),
                              //                   ),
                              //                 ),
                              //                 // margin: EdgeInsets.only(
                              //                 //     left: 5, right: 5, top: 5),
                              //                 /*  child: CircleAvatar(
                              //             radius: 20,
                              //             backgroundColor: Colors.white,
                              //             child: ClipOval(
                              //               child: new SizedBox(
                              //                 width: 40.0,
                              //                 height: 40.0,
                              //                 child:item.img.length>0?Image.network(Constant.base_url + "manage/uploads/p_category/" + item.img, fit: BoxFit.fill):Image.asset("assets/images/logo.png"),
                              //               ),
                              //             ),
                              //           ),*/
                              //               ),
                              //               SizedBox(
                              //                 height: 10,
                              //               ),
                              //               Column(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.center,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.center,
                              //                 children: [
                              //                   Text(
                              //                     item.pCats,
                              //                     maxLines: 2,
                              //                     style: TextStyle(
                              //                         fontSize: 22,
                              //                         fontWeight:
                              //                             FontWeight.w600,
                              //                         color: Colors.black),
                              //                   ),
                              //                 ],
                              //               ),
                              //               SizedBox(
                              //                 height: 10,
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     itemCount: snapshot.data.length == null
                              //         ? 0
                              //         : snapshot.data.length,
                              //   ),
                              // );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int val = -1;
  int grid = -1;
  ShowColor(int index) {
    setState(() {
      val = index;
    });
  }

  GridShowColor(int index) {
    setState(() {
      grid = index;
    });
  }

  Widget show_catnam() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.tela1), color: AppColors.white),
      width: 120,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Screen2(
                                  cat_list[index].pcatId.toString(),
                                  cat_list[index].pCats.toString())),
                        );
                        ShowColor(index);
                      },
                      child: Container(
                        color: val == index ? AppColors.tela1 : AppColors.white,
                        width: 93,
                        height: 40,
                        child: Center(
                          child: Text(
                            cat_list[index].pCats.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: val == index
                                    ? AppColors.white
                                    : AppColors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          getlistval(cat_list[index].pcatId.toString());
                          flag = true;
                          ShowColor(index);
                        });
                      },
                      child: Container(
                          // padding:EdgeInsets.all(1),
                          child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 25,
                        color: AppColors.black,
                      )),
                    )
                  ],
                ),
                Divider(
                  color: AppColors.tela1,
                ),
              ],
            );
          }),
    );
  }

  Widget show_cat_subnam() {
    return Container(
      // width: 150,
      margin: const EdgeInsets.only(left: 100),
      child: ListView.builder(
          // separatorBuilder: (context, index) => Divider(
          //   color: Colors.grey,
          // ),
          shrinkWrap: true,
          primary: false,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: sub_cat_list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    // color: Colors.grey,
                    child: ListTile(
                      title: Text(
                        sub_cat_list[index].pCats.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.black, fontSize: 12),
                      ),
                      trailing: Icon(
                        grid != index
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: AppColors.black,
                      ),
                      onTap: () {
                        if (grid != index) {
                          GridShowColor(index);
                        } else {
                          setState(() {
                            grid = -1;
                          });
                        }
                      },
                    )

                    // Text(sub_cat_list[index].pCats,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: AppColors.black),) ,
                    ),
                Divider(
                  color: AppColors.black,
                ),
                grid == index
                    ? Container(
                        color: AppColors.tela1,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        // height: 90,
                        child: FutureBuilder(
                            future:
                                getData(sub_cat_list[index].pcatId.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: GridView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    controller: ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                      left: 6,
                                      right: 6,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemBuilder: (context, index) {
                                      Categary item = snapshot.data![index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Screen2(
                                                    item.pcatId.toString(),
                                                    item.pCats.toString())),
                                          );
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.white,
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      child: item.img!.length >
                                                              0
                                                          ? Image.network(
                                                              Constant.base_url +
                                                                  "manage/uploads/p_category/" +
                                                                  item.img
                                                                      .toString(),
                                                              fit: BoxFit.fill)
                                                          : Image.asset(
                                                              "assets/images/logo.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                  item.pCats.toString(),
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data?.length ?? 0,
                                  ),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }),
                      )
                    : const Row(),
              ],
            );
          }),
    );
  }
}
