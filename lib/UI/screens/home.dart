import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:syncit/UI/widgets/Home/clipboard_card.dart';
import 'package:syncit/UI/widgets/Home/connect_cta.dart';
import 'package:syncit/UI/widgets/Home/connectivity_widget.dart';
import 'package:syncit/UI/widgets/Home/drag_and_drop.dart';
import 'package:syncit/UI/widgets/Home/file_share_card.dart';
import 'package:syncit/UI/screens/shared.dart';
import 'package:syncit/UI/widgets/Shared/sharing_card.dart';
import 'package:provider/provider.dart';
import 'package:syncit/share.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? deviceName;

  @override
  void initState() {
    super.initState();
    getDeviceName().then((value) => setState(() => deviceName = value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text("Byte Transfer",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ))),
          Text(
            "Transfer files faster than ever",
            style: TextStyle(fontSize: 16),
          ),
          Text("Completely offline!", style: TextStyle(fontSize: 15)),
          // Connectivity(),
          Connectivity(),
          SizedBox(
            height: 20,
          ),
          Expanded(child: DragDrop())
        ],
      ),
    );
  }
}

Future<String?> getDeviceName() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    return androidDeviceInfo.model;
  } else {
    WindowsDeviceInfo windowsDeviceInfo = await deviceInfoPlugin.windowsInfo;
    return windowsDeviceInfo.computerName;
  }
}
