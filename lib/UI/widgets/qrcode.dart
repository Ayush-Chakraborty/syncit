import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncit/share.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _getQr();
  }

  void _getQr() async {
    await context.read<Share>().desktopInitialSetup();
    setState(() {
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: _loading
          ? QrImage(
              data: context.watch<Share>().qrCode,
              version: QrVersions.auto,
              size: 200.0,
            )
          : null,
    );
  }
}
