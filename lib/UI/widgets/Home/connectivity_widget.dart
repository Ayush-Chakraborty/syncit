import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:syncit/share.dart';

class Connectivity extends StatefulWidget {
  const Connectivity({Key? key}) : super(key: key);

  @override
  State<Connectivity> createState() => _ConnectivityState();
}

class _ConnectivityState extends State<Connectivity> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            if (context.read<Share>().isConnected) {
              context.read<Share>().disconnectSocket();
              return;
            }
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
          child: Container(
            decoration: BoxDecoration(
                color: context.watch<Share>().isConnected
                    ? ThemeColor.red
                    : ThemeColor.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 12.0,
                      spreadRadius: 3.0,
                      color: Colors.black12)
                ]),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            width: double.infinity,
            child: Text(
              context.watch<Share>().isConnected ? "DISCONNECT" : "CONNECT",
              style: TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
