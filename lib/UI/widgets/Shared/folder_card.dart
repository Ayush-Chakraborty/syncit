import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncit/UI/widgets/card.dart';

class FolderCard extends StatelessWidget {
  final String image;
  final String text;
  final void Function() onTap;
  FolderCard({required this.image, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: CardWidget(
              child:
                  AspectRatio(aspectRatio: 1, child: SvgPicture.asset(image)),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: PopupMenuButton(
              itemBuilder: ((context) => [
                    PopupMenuItem(
                        child: Row(children: const [
                      Icon(
                        Icons.folder_open,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Change Folder Location")
                    ]))
                  ]),
              icon: const Icon(Icons.more_horiz),
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          )
        ]),
      ),
    );
  }
}
