// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:saifu_sign/widget/header.dart';
import 'package:saifu_sign/widget/sign.dart';
import 'package:saifu_sign/widget/toggle.dart';
import 'package:saifu_sign/widget/verify.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool signInterface = true;
  bool useSaifu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Header(
                    signInterface,
                    (bool val) => setState(() {
                          signInterface = val;
                        })),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: signInterface,
                          child: ToggleWidget(
                              useSaifu,
                              (bool val) => setState(() {
                                    useSaifu = val;
                                  })),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 100,
                                ),
                              ],
                            ),
                            child: signInterface ? SignInterface(useSaifu: useSaifu) : VerifyInterface())
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
