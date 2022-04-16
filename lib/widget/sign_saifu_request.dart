import 'package:flutter/material.dart';
import 'package:saifu_sign/webcam/saifu_fast_qr.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore: must_be_immutable
class SignSaifuDialog extends StatefulWidget {
  List data = [];
  SignSaifuDialog(this.data, {Key key}) : super(key: key);
  @override
  State<SignSaifuDialog> createState() => _SignSaifuDialogState();
}

class _SignSaifuDialogState extends State<SignSaifuDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 50,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
              padding: const EdgeInsets.all(5.0),
              child: SaifuFastQR(
                itemHeight: 400,
                itemWidth: 350,
                data: widget.data,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    )),
                SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.done_rounded,
                      color: Colors.green,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    )),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            "Continue to sign it",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
