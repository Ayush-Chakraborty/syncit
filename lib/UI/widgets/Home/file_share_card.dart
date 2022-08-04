import 'package:flutter/material.dart';
import 'package:syncit/UI/widgets/card.dart';

class FileShareCard extends StatelessWidget {
  const FileShareCard({Key? key}) : super(key: key);

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
                "File Share",
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
            "Last received file:",
            style: TextStyle(fontSize: 15),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            margin: EdgeInsets.symmetric(vertical: 15),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Text("OPEN",
                      style: TextStyle(
                          // color:
                          )),
                ]),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_present),
                    SizedBox(width: 10),
                    Text(
                      "Select Files",
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
