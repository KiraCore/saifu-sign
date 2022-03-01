// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:typed_data';

import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sacco/utils/bip39.dart';
import 'package:saifu_sign/services/file_transfer_services.dart';
import 'package:saifu_sign/widget/drop_zone.dart';
import 'package:saifu_sign/widget/scan_dialog.dart';
import 'package:tab_container/tab_container.dart';
import 'package:bip39/bip39.dart' as bip39;

class SignNormal extends StatefulWidget {
  const SignNormal({Key key}) : super(key: key);

  @override
  State<SignNormal> createState() => _SignNormalState();
}

class _SignNormalState extends State<SignNormal> {
  final messageController = TextEditingController(), addressController = TextEditingController(), signedMessageController = TextEditingController(), jsonController = TextEditingController();
  FocusNode fMessage, fAddress, fSigned, fJson;
  TabContainerController tabNavigator;
  Uint8List fileData;
  bool signed = false;
  bool validMnemonic = false;

  @override
  void initState() {
    fMessage = FocusNode();
    fAddress = FocusNode();
    fSigned = FocusNode();
    fJson = FocusNode();
    tabNavigator = TabContainerController(length: 2);
    super.initState();
  }

  void signMessage() {
    var ec = getP256();
    var priv = PrivateKey.fromBytes(ec, Bip39.mnemonicToSeed(addressController.text));

    if (tabNavigator.index == 0) {
      //var pub = priv.publicKey;
      var message = messageController.text;
      var sig = signature(priv, message.codeUnits);
      var hashSignature = sig.toCompactHex();

      Map<String, dynamic> qrMessage = {
        "type": "sign_txt",
        "data": {"network": "eth", "address": priv.publicKey.toCompressedHex(), "msg": message, "sig": hashSignature, "version": "1", "format": "saifu"}
      };
      var signedJson = jsonEncode(qrMessage);

      setState(() {
        signedMessageController.text = signedJson;
        signed = true;
      });
    } else {
      var base64data = FileTransferServices().generateBase64data(fileData);
      var sig = signature(priv, base64data.codeUnits);
      var hashSignature = sig.toCompactHex();
      Map<String, dynamic> qrMessage = {
        "type": "sign_txt",
        "data": {"network": "eth", "address": priv.publicKey.toCompressedHex(), "msg": base64data, "sig": hashSignature, "version": "1", "format": "saifu"}
      };
      var signedJson = jsonEncode(qrMessage);

      setState(() {
        signedMessageController.text = signedJson;
        signed = true;
      });
    }
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
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                fAddress.unfocus();
                FocusScope.of(context).requestFocus(fMessage);
              },
              onChanged: (val) {
                if (addressController.text.isNotEmpty || addressController.text.length > 5) {
                  bool isValid = bip39.validateMnemonic(addressController.text);
                  setState(() {
                    validMnemonic = isValid;
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                hintText: "Enter your mnemonic phrases:",
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
          Center(
              child: addressController.text.isNotEmpty && addressController.text.length > 5
                  ? validMnemonic == false
                      ? Text("invalid mnemonic phases")
                      : Container()
                  : Container()),
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
                maxLines: 4,
                style: TextStyle(
                  fontSize: 18,
                ),
                controller: messageController,
                focusNode: fMessage,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  fMessage.unfocus();
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
                Visibility(
                  visible: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_outlined),
                      Text("File"),
                    ],
                  ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: validMnemonic ? [Color.fromRGBO(41, 141, 255, 0.67), Color.fromRGBO(52, 74, 230, 1)] : [Color.fromRGBO(41, 141, 255, 0.32), Color.fromRGBO(52, 74, 230, 0.5)],
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
                          if (validMnemonic) signMessage();

                          // var decodeSignature = Signature.fromCompactHex(hashSignature);
                          //var publicKey = PublicKey.fromHex(ec, pub.toCompressedHex());
                          //var result = verify(publicKey, message.codeUnits, decodeSignature);
                        },
                        child: Text(
                          "Sign Message",
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
                Text(
                  'Generated Signed Message:',
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: TextField(
                    controller: signedMessageController,
                    enabled: true,
                    readOnly: true,
                    maxLines: 8,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: Visibility(
                        visible: false,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: signedMessageController.text));

                                  final snackBar = SnackBar(
                                    width: 400,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.blue[800],
                                    padding: EdgeInsets.all(20),
                                    content: Text(
                                      'Signed Message is copied!',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                },
                                icon: Icon(
                                  Icons.copy_all_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                    'Signature hash copied!',
                                    textAlign: TextAlign.center,
                                  ),
                                );
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
                                    'All of generated signature is copied!',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              child: Text(
                                "Copy All",
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
