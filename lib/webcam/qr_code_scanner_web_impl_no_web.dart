// ignore_for_file: prefer_const_constructors_in_immutables, no_logic_in_create_state, unnecessary_this, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/widgets.dart';

class QrCodeCameraWebImpl extends StatefulWidget {
  final void Function(String qrValue) qrCodeCallback;
  final Widget child;
  final BoxFit fit;
  final Widget Function(BuildContext context, Object error) onError;

  QrCodeCameraWebImpl({
    Key key,
    @required this.qrCodeCallback,
    this.child,
    this.fit = BoxFit.cover,
    this.onError,
  })  : assert(qrCodeCallback != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    throw FittedBox(
      fit: this.fit,
      child: Container(
        child: Text('it is not in web environment'),
      ),
    );
  }
}
