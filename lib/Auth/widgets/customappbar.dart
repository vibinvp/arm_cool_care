import 'package:arm_cool_care/General/AppConstant.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: height / 10,
        width: width,
        padding: const EdgeInsets.only(left: 15, top: 25),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.boxColor1, AppColors.boxColor2]),
        ),
        /*child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back,),
                onPressed: (){
                  print("pop");
                  //Navigator.of(context).pop();
            })
          ],
        ),*/
      ),
    );
  }
}
