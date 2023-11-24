import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/Home.dart';

class TransactionSuccessful extends StatefulWidget {
  const TransactionSuccessful({Key? key}) : super(key: key);

  @override
  State<TransactionSuccessful> createState() => _TransactionSuccessfulState();
}

class _TransactionSuccessfulState extends State<TransactionSuccessful> {
  //  _onBackPressed() {
  //   return showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text(''),
  //           content: const Text('Do you want to continue Shopping?'),
  //           actions: <Widget>[
  //             GestureDetector(
  //               onTap: () => Navigator.of(context).pop(false),
  //               child: const Text(""),
  //             ),
  //             const SizedBox(height: 16),
  //             GestureDetector(
  //               onTap: () => Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => MyApp1()),
  //               ),
  //               child: const Text("YES"),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false;

  // }
  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(''),
            content: const Text('Do you want to continue Shopping?'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const Text(""),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp1()),
                ),
                child: const Text("YES"),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        child: AspectRatio(
          aspectRatio: 100 / 100,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.teal[50],
            ),
            child: Center(
              child: Container(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 150),
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Image.asset(
                                'assets/gifs/transaction_successful.gif'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: ListTile(
                          title: const Center(
                            child: Text(
                              "Transaction Successful",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp1()),
                                      );
                                    },
                                    child: const Center(
                                      child: Text(
                                        "Continue Shopping ?",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
