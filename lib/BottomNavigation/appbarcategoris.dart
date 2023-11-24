import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final double height;

  const CustomAppBar(
      {super.key,
      @required this.height = kToolbarHeight,
      required super.preferredSize,
      required super.child});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      height: preferredSize.height,
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Material(
          color: Colors.teal[50],
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: TextField(
                  style: TextStyle(color: Colors.green[900]),
                  decoration: InputDecoration(
                    hintText: 'Search Your Product',
                    hintStyle: TextStyle(color: Colors.teal[200]),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
