import 'package:flutter/material.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:syncit/UI/widgets/card.dart';

class SharingCard extends StatelessWidget {
  SharingCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CardWidget(
        child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.photo,
                size: 20,
              ),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  "Background  ajknjndw dnjnmld kmklm image.jpg",
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        // Icon(
        //   Icons.check_circle_rounded,
        //   color: ThemeColor.green,
        //   size: 30,
        // ),
        Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            value: 0.5,
            valueColor: AlwaysStoppedAnimation(ThemeColor.green),
            backgroundColor: Colors.grey,
            strokeWidth: 5,
          ),
        ),
      ],
    ));
  }
}
