import 'dart:math';

import 'package:flutter/material.dart';

class ClipboardScreen extends StatelessWidget {
  const ClipboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Copy on one device, paste on another device"),
        Text("Copy on one device, paste on another device"),
      ],
    );
  }
}
