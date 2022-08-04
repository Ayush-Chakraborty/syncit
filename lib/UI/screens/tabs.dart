import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:syncit/UI/screens/home.dart';
import 'package:syncit/UI/screens/received_files.dart';
import 'package:syncit/UI/screens/received_folder.dart';
import 'package:syncit/UI/screens/shared.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      body: Container(
          color: Color.fromRGBO(230, 230, 230, 1),
          padding: EdgeInsets.only(top: media.viewPadding.top),
          child: _tabIndex == 0 ? Home() : ReceivedFiles()),
      bottomNavigationBar: Container(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: GNav(
            tabs: const [
              GButton(
                icon: Icons.share,
                text: "Share",
              ),
              GButton(
                icon: Icons.folder,
                text: "Received Files",
              ),
            ],
            gap: 8,
            tabBackgroundColor: Colors.black26,
            color: Colors.white,
            activeColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            onTabChange: (index) => setState(() => _tabIndex = index),
          ),
        ),
      ),
    );
  }
}
