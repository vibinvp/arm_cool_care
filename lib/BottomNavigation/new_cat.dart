import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/dbhelper/database_helper.dart';
import 'package:arm_cool_care/model/CategaryModal.dart';

import 'package:arm_cool_care/screen/secondtabview.dart';

class My_Cat extends StatefulWidget {
  const My_Cat({super.key});

  @override
  _My_CatState createState() => _My_CatState();
}

class _My_CatState extends State<My_Cat> {
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
    getData("0").then((usersFromServe) {
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
      body: Stack(
        children: [
          flag
              ? sub_cat_list != null
                  ? sub_cat_list.isNotEmpty
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            child: show_cat_subnam(),
                          ),
                        )
                      : const Row()
                  : const Row()
              : const Row(),
          cat_list != null
              ? cat_list.isNotEmpty
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: show_catnam(),
                      ),
                    )
                  : const Row()
              : const Row(),
        ],
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
                          child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 25,
                        color: AppColors.black,
                      )),
                    )
                  ],
                ),
                const Divider(
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
                        style: const TextStyle(
                            color: AppColors.black, fontSize: 12),
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
                const Divider(
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
                                                              "${Constant.base_url}manage/uploads/p_category/" +
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
                                    itemCount: snapshot.data!.length,
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
