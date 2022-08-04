import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:syncit/UI/widgets/card.dart';
import 'package:provider/provider.dart';
import 'package:syncit/share.dart';

class ConnectCTA extends StatefulWidget {
  const ConnectCTA({Key? key}) : super(key: key);

  @override
  State<ConnectCTA> createState() => _ConnectCTAState();
}

class _ConnectCTAState extends State<ConnectCTA> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CardWidget(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Disconnected",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ThemeColor.red,
                fontSize: 16)),
        OutlinedButton(
          style: ButtonStyle(
              side: MaterialStateProperty.all(
                  const BorderSide(color: ThemeColor.green))),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      insetPadding: const EdgeInsets.all(10),
                      title: Row(
                        children: [
                          const Text("Scan QR Code"),
                          Expanded(child: Container()),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: ThemeColor.red,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: width * 0.9,
                        width: width * 0.9,
                        child: MobileScanner(
                            allowDuplicates: false,
                            onDetect: (barcode, args) {
                              context
                                  .read<Share>()
                                  .onQrDetect(barcode.rawValue);
                              Navigator.pop(context);
                            }),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ));
          },
          child: const Text("CONNECT",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.green,
                  fontSize: 16)),
        ),
      ],
    ));
  }
}
