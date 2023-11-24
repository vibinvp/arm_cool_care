import 'package:flutter/material.dart';
import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:arm_cool_care/General/Home.dart';

class ShowInVoiceId2 extends StatefulWidget {
  final String invoice;
  const ShowInVoiceId2(this.invoice, {Key? key}) : super(key: key);

  @override
  _ShowInVoiceIdState createState() => _ShowInVoiceIdState();
}

class _ShowInVoiceIdState extends State<ShowInVoiceId2> {
  Future<bool> _onBackPressed() async {
    bool? result = await showDialog<bool?>(
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
    );

    return result ?? false;
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
                      const SizedBox(
                        height: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: ListTile(
                          title: const Center(
                            child: Text(
                              "Order Placed",
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
                              // ... Your existing code

                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.green),
                                child: Row(
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
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
