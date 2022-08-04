import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncit/UI/widgets/card.dart';

class ClipBoardCard extends StatelessWidget {
  const ClipBoardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Clipboard sync",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              Icon(
                Icons.info,
                size: 20,
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Last synced item:",
            style: TextStyle(fontSize: 15),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Fluttertoast.showToast(msg: "message is copied to clipboard");
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      child: Text(
                        "akhbskn hsnjknjak uihsajnns jhaj a sbhns",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: Colors.black54),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.copy,
                      color: Colors.black45,
                      size: 18,
                    )
                  ]),
            ),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sync),
                    SizedBox(width: 10),
                    Text(
                      "Sync",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
