import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/StyleDecoration/styleDecoration.dart';
import 'package:arm_cool_care/dbhelper/wishlistdart.dart';
import 'package:arm_cool_care/screen/detailpage1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewWishList extends StatefulWidget {
  const NewWishList({super.key});

  @override
  WishlistState createState() => WishlistState();
}

class WishlistState extends State<NewWishList> {
  final DbProductManager1 dbmanager = DbProductManager1();
  static List<WishlistsCart>? prodctlist1;
  double totalamount = 0;

  final int _count = 1;
  bool islogin = false;

  void gatinfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    islogin = pref.get("isLogin") as bool;
    setState(() {
      Constant.isLogin = islogin;
    });
  }

  @override
  void initState() {
//    openDBBB();
    super.initState();
    gatinfo();
    dbmanager.getProductList().then((usersFromServe) {
      setState(() {
        prodctlist1 = usersFromServe;
        for (var i = 0; i < prodctlist1!.length; i++) {
          totalamount =
              totalamount + double.parse(prodctlist1![i].pprice.toString());
        }

        Constant.totalAmount = totalamount;
        Constant.itemcount = prodctlist1!.length;
        Constant.wishlist = prodctlist1!.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.tela,
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          "Wishlist",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
//          createHeader(),
//          createSubTitle(),
          Expanded(
              child: ListView.builder(
            itemCount: prodctlist1 == null ? 0 : prodctlist1!.length,
            itemBuilder: (BuildContext context, int index) {
              if (prodctlist1!.isNotEmpty) {
                WishlistsCart item = prodctlist1![index];
                var i = item.pQuantity;

                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      dbmanager.deleteProducts((item.id!));
                      setState(() {
//                          Constant.itemcount--;
//                              Constant.totalAmount= Constant.totalAmount-double.parse(item.pprice);
                      });

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(" Product is remove"),
                          duration: Duration(seconds: 1)));
                    } else {
                      dbmanager.deleteProducts(item.id!);

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(" Product is remove "),
                          duration: Duration(seconds: 1)));
                    }
                    // Remove the item from the data source.
                    setState(() {
                      prodctlist1!.removeAt(index);
                      Constant.wishlist--;
                      _countList(Constant.wishlist--);

//                        Constant.totalAmount= Constant.totalAmount-double.parse(item.pprice);
//                        Constant.itemcount--;
                    });
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    padding: const EdgeInsets.all(5.0),
                    child: const Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    height: 100.0,
                    decoration: const BoxDecoration(color: Colors.red),
                    padding: const EdgeInsets.all(5.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails1(item.pid.toString())),
                        );
                        print('Card tapped.');
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 8, left: 8, top: 8, bottom: 8),
                                  width: 110,
                                  height: 160,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14)),
                                      color: Colors.blue.shade200,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            Constant.Product_Imageurl +
                                                item.pimage.toString(),
                                          ))),
                                ),
                                Expanded(
                                  flex: 100,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(
                                              right: 8, top: 4),
                                          child: Text(
                                            item.pname ?? 'name',
                                            maxLines: 2,
                                            softWrap: true,
                                            style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)
                                                .copyWith(fontSize: 14),
                                          ),
                                        ),
                                        /* SizedBox(height: 6),
                                        Text(
                                          'COLOR ${item.pcolor}',
                                          style:
                                              TextStyle(fontWeight: FontWeight.w400, color: Colors.black).copyWith(color: Colors.grey, fontSize: 14),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Size ${item.psize}',
                                          style:
                                              TextStyle(fontWeight: FontWeight.w400, color: Colors.black).copyWith(color: Colors.grey, fontSize: 14),
                                        ),*/
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                item.pprice == null
                                                    ? '100'
                                                    : '\u{20B9} ${double.parse(item.pprice.toString()).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.w700,
                                                ).copyWith(color: Colors.green),
                                              ),
//                                                Padding(
//                                                  padding: const EdgeInsets.all(8.0),
//                                                  child: Row(
//                                                    mainAxisAlignment: MainAxisAlignment.center,
//                                                    crossAxisAlignment: CrossAxisAlignment.end,
//                                                    children: <Widget>[
//                                                      InkWell(
//                                                        onTap: (){
//                                                          if(i!=1){
//
//                                                            setState(() {
//                                                              i--;
//                                                            });
//                                                          }
//
//                                                        },
//                                                        child: Icon(
//                                                          Icons.remove,
//                                                          size: 24,
//                                                          color: Colors.grey.shade700,
//                                                        ),
//                                                      ),
//                                                      Container(
//                                                        color: Colors.grey.shade200,
//                                                        padding: const EdgeInsets.only(
//                                                            bottom: 2, right: 12, left: 12),
//                                                        child: Text(
//                                                            item.pQuantity==null?'1':'${i}'
//
//                                                        ),
//                                                      ),
//                                                      InkWell(
//                                                        onTap: (){
//
//                                                          setState(() {
//                                                            i++;
//                                                          });
//
//                                                        },
//                                                        child: Icon(
//                                                          Icons.add,
//                                                          size: 24,
//                                                          color: Colors.grey.shade700,
//                                                        ),
//                                                      )
//                                                    ],
//                                                  ),
//                                                )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 10, top: 8),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  color: Colors.red),
                              child: InkWell(
                                onTap: () {
                                  dbmanager.deleteProducts(item.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(" Product is remove"),
                                          duration: Duration(seconds: 1)));
                                  setState(() {
                                    prodctlist1!.removeAt(index);
//                                      Constant.itemcount--;
//                                      Constant.totalAmount= Constant.totalAmount-double.parse(item.pprice);
                                    Constant.wishlist--;
                                    _countList(Constant.wishlist--);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
//          footer(context),
        ],
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: const TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black)
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 30),
                child: Text(
                  '\u{20B9} ${Constant.totalAmount}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.greenAccent.shade700,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
//          RaisedButton(
//            onPressed: () {
//
//              if(Constant.isLogin){
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => DliveryInfo()),
//                );}
//
//              else{
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SignInPage()),
//                );
//              }
//            },
//            color: Colors.amberAccent,
//            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(24))),
//            child: Text(
//              "Buy Now",
//
//            ),
//          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 12, top: 12),
      child: Text(
        "SHOPPING CART",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        'Total (${Constant.itemcount}) Items',
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  String calDiscount(String totalamount) {
    setState(() {
      Constant.totalAmount = double.parse(totalamount);
    });
    return Constant.totalAmount.toStringAsFixed(2).toString();
  }

  Future _countList(int val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("wcount", val);
  }
}
