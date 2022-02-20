// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:typed_data';

import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:flutter/material.dart';
import 'package:saifu_sign/widget/drop_zone.dart';
import 'package:saifu_sign/widget/scan_dialog.dart';
import 'package:tab_container/tab_container.dart';

class VerifyInterface extends StatefulWidget {
  const VerifyInterface({Key key}) : super(key: key);

  @override
  State<VerifyInterface> createState() => _VerifyInterfaceState();
}

class _VerifyInterfaceState extends State<VerifyInterface> {
  final messageController = TextEditingController(), addressController = TextEditingController(), signedMessageController = TextEditingController();
  FocusNode fMessage, fAddress, fSignedMessage;
  TabContainerController tabNavigator;
  Uint8List fileData;
  Uint8List signedFileData;

  @override
  void initState() {
    fMessage = FocusNode();
    fAddress = FocusNode();
    tabNavigator = TabContainerController(length: 2);
    super.initState();
  }

  void verifySignature() {
    var decodeSucceeded = false;
    var result = false;
    if (tabNavigator.index == 0) {
      try {
        try {
          // Check is the signature provided is json and correct
          var decode = jsonDecode(signedMessageController.text);
          decodeSucceeded = true;
          var ec = getP256();
          var publicKey = PublicKey.fromHex(ec, addressController.text);
          var decodeSignature = Signature.fromCompactHex(decode['data']['sig']);
          result = verify(publicKey, messageController.text.codeUnits, decodeSignature);
        } catch (e) {
          final snackBar = SnackBar(
            width: 400,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(20),
            content: Text(
              "Public HEX address issue: " + e,
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // Json check failed, does nothing and continues with regular text signature
        }
        if (decodeSucceeded == false) {
          var ec = getP256();
          var publicKey = PublicKey.fromHex(ec, addressController.text);
          var decodeSignature = Signature.fromCompactHex(signedMessageController.text);
          result = verify(publicKey, messageController.text.codeUnits, decodeSignature);
        }

        if (result == true) {
          final snackBar = SnackBar(
            width: 400,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(20),
            content: Text(
              'Signature is true and verified',
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            width: 400,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            padding: EdgeInsets.all(20),
            content: Text(
              'Signature is false and not verified',
              textAlign: TextAlign.center,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
          width: 400,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          padding: EdgeInsets.all(20),
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      // One is signed and one is not signed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 500,
      child: IntrinsicWidth(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: 600,
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
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  fAddress.unfocus();
                  FocusScope.of(context).requestFocus(fSignedMessage);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter public address (HEX):",
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
            SizedBox(
              width: 500,
              height: 280,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 600,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 600,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextField(
                          enabled: true,
                          maxLines: 4,
                          controller: signedMessageController,
                          focusNode: fSignedMessage,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            fSignedMessage.unfocus();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            hintText: "Enter the Signed Message",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      signedMessageController.text = await showDialog(context: context, builder: (BuildContext context) => ScanDialog());
                                    },
                                    icon: Icon(
                                      Icons.qr_code_scanner_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropZone(
                            onDroppedFile: (dynamic val) => setState(() {
                              fileData = val;
                            }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropZone(
                            onDroppedFile: (dynamic val) => setState(() {
                              signedFileData = val;
                            }),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.grey[50],
                          child: Center(child: Text("Soon")),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Spacer(),
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
                          onPressed: () {
                            verifySignature();
                          },
                          child: Text(
                            "Verify Message",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
