// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class DropZone extends StatefulWidget {
  final Function(dynamic) onDroppedFile;
  final Function(bool) onBoolChange;
  DropZone({
    Key key,
    this.onDroppedFile,
    this.onBoolChange,
  }) : super(key: key);

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  DropzoneViewController controller;
  bool fileDropped = false;
  String fileName = "";
  String fileType = "";
  Uint8List fileData;
  bool signed = false;

  Future acceptFile(dynamic event) async {
    //final bytes = await controller.getFileSize(event);
    //final url = await controller.createFileUrl(event);

    var name = event.name;
    var type = await controller.getFileMIME(event);
    Uint8List data = await controller.getFileData(event);

    setState(() {
      fileName = name;
      fileType = type;
      fileData = data;
    });

    return fileData;
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);

    return Stack(
      children: [
        DropzoneView(
          operation: DragOperation.copy,
          cursor: CursorType.grab,
          onCreated: (ctrl) => controller = ctrl,
          onHover: () {},
          onLeave: () {},
          onError: (ev) => setState(() {
            final snackBar = SnackBar(
              width: 400,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(20),
              content: const Text(
                'Failed to upload the file',
                textAlign: TextAlign.center,
              ),
            );
            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }),
          onDrop: (ev) async {
            _dialog.show(message: 'Loading...', type: SimpleFontelicoProgressDialogType.normal);
            await acceptFile(ev);
            setState(() {
              signed = false;
              fileDropped = true;
              widget.onBoolChange(signed);
              widget.onDroppedFile(fileData);
            });
            _dialog.hide();
          },
        ),
        InkWell(
          onTap: () async {
            final events = await controller.pickFiles();
            _dialog.show(message: 'Loading...', type: SimpleFontelicoProgressDialogType.normal);
            await acceptFile(events.first);
            _dialog.hide();
            if (events.isEmpty) return;
            setState(() {
              signed = false;
              fileDropped = true;

              widget.onBoolChange(signed);
              widget.onDroppedFile(fileData);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 125,
                height: 125,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !fileDropped,
                      child: Column(
                        children: [
                          Icon(Icons.download_rounded),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Choose a file",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                              ),
                              Flexible(
                                child: Text(
                                  " or drag it here",
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: fileDropped,
                      child: Column(
                        children: [
                          Text(
                            fileName,
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            fileType,
                            style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w100),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
