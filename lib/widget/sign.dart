// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:saifu_sign/widget/sign_normal.dart';
import 'package:saifu_sign/widget/sign_saifu.dart';

class SignInterface extends StatelessWidget {
  SignInterface({
    Key key,
    this.useSaifu,
  }) : super(key: key);

  final bool useSaifu;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: useSaifu ? SignSaifu() : SignNormal(),
        ),
      ],
    );
  }
}
