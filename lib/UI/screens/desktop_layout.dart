import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncit/Constants/colors.dart';
import 'package:syncit/UI/screens/clipboard_sreen.dart';
import 'package:syncit/UI/screens/received_files.dart';
import 'package:syncit/UI/screens/received_folder.dart';
import 'package:syncit/UI/widgets/Home/drag_and_drop.dart';
import 'package:fluent_ui/src/styles/color.dart' as FluentUi;
import 'package:syncit/UI/widgets/qrcode.dart';
import 'package:flutter/src/material/outlined_button.dart' as Button;
import 'package:flutter/src/material/icon_button.dart' as IconButton;
import 'package:flutter/src/material/button_style.dart' as Style;
import 'package:flutter/src/material/dialog.dart' as Dialog;
import 'package:provider/provider.dart';
import 'package:syncit/share.dart';

class DeskTopLayout extends StatefulWidget {
  const DeskTopLayout({Key? key}) : super(key: key);

  @override
  State<DeskTopLayout> createState() => _DeskTopLayoutState();
}

class _DeskTopLayoutState extends State<DeskTopLayout> {
  var _index = 0;
  // final share=context.
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
        body: NavigationView(
      appBar: NavigationAppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Byte Transfer",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ))),
          ),
          automaticallyImplyLeading: false,
          leading: Image.asset('assets/icon.png', height: 25)),
      pane: NavigationPane(
          selected: _index,
          items: [
            PaneItem(icon: Icon(Icons.share_rounded), title: Text("Share")),
            PaneItem(icon: Icon(Icons.folder), title: Text("Received Files")),
            // PaneItem(icon: Icon(Icons.content_paste), title: Text("Clipboard")),
          ],
          onChanged: (index) => setState(() => _index = index),
          footerItems: [
            PaneItem(
              icon: Icon(Icons.info),
              title: Text("Transfer files faster than ever"),
            ),
            PaneItem(
              icon: Icon(
                Icons.offline_bolt,
              ),
              title: Text("Completely offline!"),
            ),
            PaneItem(
              icon: Icon(
                Icons.offline_bolt,
                color: Color.fromRGBO(0, 0, 0, 0),
              ),
              title: Text(""),
            )
          ],
          header: Container(
            padding: EdgeInsets.only(left: 18, top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 13,
                  color: context.watch<Share>().isConnected
                      ? ThemeColor.green
                      : ThemeColor.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  context.watch<Share>().isConnected
                      ? "Connected"
                      : "Disconnected",
                  style: TextStyle(
                      color: context.watch<Share>().isConnected
                          ? ThemeColor.green
                          : ThemeColor.red),
                ),
                Expanded(child: Container()),
                Button.OutlinedButton(
                    child: Text(
                      context.watch<Share>().isConnected
                          ? "Disconnect"
                          : "Get Qr Code",
                      style: TextStyle(
                          color: context.watch<Share>().isConnected
                              ? ThemeColor.red
                              : ThemeColor.green),
                    ),
                    style: Style.ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          color: context.watch<Share>().isConnected
                              ? ThemeColor.red
                              : ThemeColor.green)),
                    ),
                    onPressed: () {
                      context.read<Share>().isConnected
                          ? context.read<Share>().disconnectSocket()
                          : Dialog.showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: QrCode(),
                                    insetPadding: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    title: Row(
                                      children: [
                                        const Text("QR Code"),
                                        Expanded(child: Container()),
                                        IconButton.IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(
                                            Icons.close_rounded,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ));
                    }),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          )),
      content: NavigationBody(
        index: 0,
        children: [
          Container(
            width: media.size.width,
            height: media.size.height,
            padding: const EdgeInsets.all(15.0),
            color: Color.fromRGBO(230, 230, 230, 1),
            child: Center(child: getWidget(_index)),
          )
        ],
      ),
    ));
  }
}

Widget getWidget(int index) {
  if (index == 0)
    return DragDrop();
  else if (index == 1)
    return ReceivedFiles();
  else
    return ClipboardScreen();
}
/*
Container(
      color: Color.fromARGB(255, 243, 240, 236),
      width: media.size.width,
      height: media.size.height,
      child: Column(
        children: [
          SizedBox(height: 25),
          Text("Byte Transfer".toUpperCase(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2))),
          Text(
            "Transfer files faster than ever",
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          Text("Completely Offline!",
              style: TextStyle(color: Colors.black54, fontSize: 18)),
          SizedBox(height: 25),
          Expanded(child: Center(child: DragDrop())),
          SizedBox(height: 25),
        ],
      ),
    )

    */