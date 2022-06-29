// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:saifu_sign/webcam/qr_code_scanner_web.dart';

class ScanDialog extends StatefulWidget {
  const ScanDialog({Key key}) : super(key: key);

  @override
  State<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
  bool scan = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 50,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[100], width: 1), borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: SizedBox(
            width: 350,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  )
                ],
              ),
              Center(
                  child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(0.0),
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
                              }
                            }))),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                  child: Text("Close",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ))))))
                ])
              ]))
            ])));
  }
}
