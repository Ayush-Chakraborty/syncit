import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:syncit/UI/widgets/Shared/sharing_card.dart';

class CurrentShare extends StatelessWidget {
  const CurrentShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selected Files :",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text("CANCEL"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ThemeColor.red),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: Platform.isAndroid ? 8 : 15)))),
            ),
            SizedBox(width: 25),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text("SEND"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ThemeColor.green),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: Platform.isAndroid ? 8 : 15)))),
            ),
          ],
        ),
        SizedBox(height: 20),
        Platform.isAndroid
            ? ListView.builder(
                itemBuilder: ((context, index) => SharingCard()),
                // controller: ScrollController(),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(right: 20, left: 15, bottom: 10),
                itemCount: 10)
            : Expanded(
                child: ListView.builder(
                    itemBuilder: ((context, index) => SharingCard()),
                    controller: ScrollController(),
                    padding:
                        const EdgeInsets.only(right: 20, left: 15, bottom: 10),
                    itemCount: 10),
              ),
      ],
    );
  }
}
