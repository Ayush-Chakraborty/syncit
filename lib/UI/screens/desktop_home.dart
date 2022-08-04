import 'package:flutter/material.dart';
import 'package:syncit/UI/screens/home.dart';
import 'package:syncit/UI/widgets/Home/clipboard_card.dart';
import 'package:syncit/UI/widgets/Home/file_share_card.dart';
import 'package:syncit/UI/widgets/card.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({Key? key}) : super(key: key);

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  String? deviceName;
  @override
  void initState() {
    super.initState();
    getDeviceName().then((value) => setState(() => deviceName = value));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(height: 25),
                Text(
                  deviceName?.toUpperCase() ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 50),
                Container(width: 350, child: ClipBoardCard()),
                SizedBox(width: 50),
                Container(width: 350, child: FileShareCard()),
              ],
            )
            // FileShareCard()
          ],
        ),
      ),
    );
  }
}
