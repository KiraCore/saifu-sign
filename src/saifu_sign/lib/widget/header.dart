// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  bool signInterface;

  final Function(bool) onBoolChange;

  Header(this.signInterface, this.onBoolChange, {Key key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool enableSaifu = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Colors.grey[400]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.signInterface == true ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.signInterface = true;
                      widget.onBoolChange(true);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign",
                      style: TextStyle(fontSize: 24, color: widget.signInterface == true ? Colors.grey[400] : Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.signInterface == true ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.signInterface = false;
                      widget.onBoolChange(false);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Verify",
                      style: TextStyle(fontSize: 24, color: widget.signInterface == true ? Colors.white : Colors.grey[400]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
