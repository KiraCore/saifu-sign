// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saifu_sign/widget/drop_zone.dart';
import 'package:saifu_sign/widget/scan_dialog.dart';
import 'package:saifu_sign/widget/sign_saifu_request.dart';
import 'package:saifu_sign/widget/sign_saifu_scan.dart';

import 'package:tab_container/tab_container.dart';

class SignSaifu extends StatefulWidget {
  const SignSaifu({Key key}) : super(key: key);

  @override
  State<SignSaifu> createState() => _SignSaifuState();
}

class _SignSaifuState extends State<SignSaifu> {
  final messageController = TextEditingController(), addressController = TextEditingController(), signedMessageController = TextEditingController();
  FocusNode fMessage, fAddress, fSigned;
  TabContainerController tabNavigator;
  dynamic fileData;
  bool signed = false;

  @override
  void initState() {
    fMessage = FocusNode();
    fAddress = FocusNode();
    fSigned = FocusNode();
    tabNavigator = TabContainerController(length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: TextField(
              maxLines: 1,
              controller: addressController,
              focusNode: fAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                fAddress.unfocus();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                hintText: "Enter your public address {optional}",
                suffixIcon: IconButton(
                  onPressed: () async {
                    addressController.text = await showDialog(context: context, builder: (BuildContext context) => ScanDialog());
                  },
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: false,
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: TextField(
                maxLines: 8,
                style: TextStyle(
                  fontSize: 18,
                ),
                controller: messageController,
                focusNode: fMessage,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  fMessage.unfocus();
                  FocusScope.of(context).requestFocus(fAddress);
                },
                decoration: InputDecoration(
                    hintText: "Add the message you want to sign",
                    contentPadding: EdgeInsets.all(20),
                    suffixIcon: IconButton(
                      onPressed: () {
                        messageController.clear();
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                      ),
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 500,
            height: 150,
            child: TabContainer(
              tabExtent: 50,
              tabEdge: TabEdge.left,
              controller: tabNavigator,
              tabs: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.format_color_text_rounded), Text("Text")],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file_outlined),
                    Text("File"),
                  ],
                ),
              ],
              color: Colors.grey[100],
              childPadding: EdgeInsets.all(10),
              enableFeedback: true,
              children: [
                Container(
                  width: 600,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextField(
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    controller: messageController,
                    focusNode: fMessage,
                    textInputAction: TextInputAction.next,
                    onTap: () {
                      setState(() {
                        signed = false;
                      });
                    },
                    onSubmitted: (_) {
                      fMessage.unfocus();
                      FocusScope.of(context).requestFocus(fAddress);
                    },
                    decoration: InputDecoration(
                        hintText: "Enter your message:",
                        contentPadding: EdgeInsets.all(20),
                        suffixIcon: IconButton(
                          onPressed: () {
                            messageController.clear();
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                          ),
                        ),
                        border: InputBorder.none),
                  ),
                ),
                DropZone(
                    onDroppedFile: (dynamic val) => setState(() {
                          fileData = val;
                        }),
                    onBoolChange: (bool val) => setState(() {
                          signed = val;
                        })),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromRGBO(41, 141, 255, 0.67), Color.fromRGBO(52, 74, 230, 1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () async {
                          Map<String, dynamic> qrMessage = {
                            "type": "sign_txt",
                            "data": {"network": "eth", "address": addressController.text, "msg": messageController.text, "version": "1", "format": "saifu"}
                            //"0x" + hex.encode(messageController.text.codeUnits)
                          };
                          List saifuQR = [jsonEncode(qrMessage)];
                          await showDialog(barrierDismissible: false, context: context, builder: (_) => SignSaifuDialog(saifuQR)).then((value) async {
                            if (value == true) {
                              var data = await showDialog(barrierDismissible: false, context: context, builder: (_) => SignSaifuScan());

                              setState(() {
                                signedMessageController.text = data;
                                signed = true;
                              });
                            }
                          });
                        },
                        child: Text(
                          "Saifu Sign",
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          Visibility(
            visible: signed,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Generated Signed Message:",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.grey[50],
                  child: TextField(
                    controller: signedMessageController,
                    enabled: true,
                    readOnly: true,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: () {
                                var decode = jsonDecode(signedMessageController.text);
                                Clipboard.setData(ClipboardData(text: decode['data']['sig']));

                                final snackBar = SnackBar(
                                  width: 400,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.blue[800],
                                  padding: EdgeInsets.all(20),
                                  content: const Text(
                                    'Signed Message is copied!',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              child: Text(
                                "Copy Signature",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: signedMessageController.text));

                                final snackBar = SnackBar(
                                  width: 400,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.blue[800],
                                  padding: EdgeInsets.all(20),
                                  content: const Text(
                                    'Signed Message is copied!',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              child: Text(
                                "Copy Json",
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
          ),
        ],
      ),
    );
  }
}
