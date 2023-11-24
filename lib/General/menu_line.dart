import 'package:flutter/material.dart';

import 'AppConstant.dart';

class OpenFlutterMenuLine extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  const OpenFlutterMenuLine(
      {Key? key,
      @required this.title,
      @required this.subtitle,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title!,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle!,
          style: const TextStyle(
              color: AppColors.lightGray, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
