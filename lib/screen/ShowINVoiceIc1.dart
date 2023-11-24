// import 'package:flutter/material.dart';
// import 'package:arm_cool_care/General/AppConstant.dart';
// import 'package:arm_cool_care/General/Home.dart';

// class ShowInVoiceId1 extends StatefulWidget {
//   final String invoice;
//   const ShowInVoiceId1(this.invoice, {Key? key}) : super(key: key);

//   @override
//   _ShowInVoiceIdState createState() => _ShowInVoiceIdState();
// }

// class _ShowInVoiceIdState extends State<ShowInVoiceId1> {
//   Future<bool?>? _onBackPressed() async {
//     bool? result = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text(''),
//         content: const Text('Do you want to continue Shopping?'),
//         actions: <Widget>[
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(false),
//             child: const Text(""),
//           ),
//           const SizedBox(height: 16),
//           GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyApp1()),
//             ),
//             child: const Text("YES"),
//           ),
//         ],
//       ),
//     );

//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Container(
//         child: AspectRatio(
//           aspectRatio: 100 / 100,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: Colors.teal[50],
//             ),
//             child: Center(
//               child: Container(
//                 child: Card(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Center(
//                         child: Container(
//                           margin: const EdgeInsets.only(top: 50),
//                           child: SizedBox(
//                             height: 300,
//                             width: double.infinity,
//                             child: Image.asset('assets/images/upi.jpeg'),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 0.0),
//                         child: ListTile(
//                           title: const Center(
//                             child: Text(
//                               "Order Placed",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 0.0, bottom: 1),
//                                     child: Container(
//                                       margin: const EdgeInsets.only(
//                                           top: 10.0, bottom: 10.0),
//                                       height: 30,
//                                       width: 70,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       child: const Center(
//                                         child: Text('Order ID',
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                               color: Colors.green,
//                                               fontWeight: FontWeight.w700,
//                                             )),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: const EdgeInsets.only(
//                                         top: 10.0, bottom: 10.0),
//                                     height: 30,
//                                     width: 140,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         widget.invoice,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontStyle: FontStyle.normal,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               const Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.all(5.0),
//                                     child: Text(
//                                       "Phone Pe :",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                           color: Colors.black),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(5.0),
//                                     child: Text(
//                                       "8105222216",
//                                       style: TextStyle(
//                                           fontSize: 20, color: Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.all(5.0),
//                                     child: Text(
//                                       "Google Pay :",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                           color: Colors.black),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(5.0),
//                                     child: Text(
//                                       "8105222216",
//                                       style: TextStyle(
//                                           fontSize: 20, color: Colors.black),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                 padding:
//                                     const EdgeInsets.only(top: 10, bottom: 10),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: AppColors.green),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => MyApp1()),
//                                         );
//                                       },
//                                       child: const Center(
//                                         child: Text(
//                                           "Continue Shopping ?",
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             fontSize: 22,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
