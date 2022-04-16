// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:saifu_sign/webcam/qr_code_scanner_web.dart';

// ignore: must_be_immutable
class SignSaifuScan extends StatefulWidget {
  const SignSaifuScan({Key key}) : super(key: key);

  @override
  State<SignSaifuScan> createState() => _SignSaifuScanState();
}

class _SignSaifuScanState extends State<SignSaifuScan> {
  bool scan = true;
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350, maxHeight: 300),
                child: QrCodeCameraWeb(
                  fit: BoxFit.contain,
                  qrCodeCallback: (scanData) async {
                    if (mounted) {
                      if (scan == true) {
                        scan = false;
                        Navigator.pop(context, scanData);
                      }

                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SidebarPage()), (Route<dynamic> route) => false);
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
