import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  CardWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 12.0,
                spreadRadius: 3.0,
                color: Colors.black12)
          ]),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: const EdgeInsets.only(top: 25),
      child: child,
    );
  }
}
