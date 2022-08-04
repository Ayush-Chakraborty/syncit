// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncit/UI/screens/desktop_layout.dart';
import 'package:syncit/UI/screens/tabs.dart';
import 'package:syncit/share.dart';
import 'package:flutter/src/material/theme_data.dart' as Theme;
import 'package:google_fonts/google_fonts.dart';

// import 'clipboard.dart';
import 'package:fluent_ui/src/styles/theme.dart' as FluentTheme;
import 'package:flutter/src/material/colors.dart' as Colors;

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => Share())],
    child: const MyHomePage(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // return MaterialApp(
//     //   title: 'Byte Transfer',
//     //   theme: ThemeData(
//     //       primarySwatch: Colors.blue, textTheme: GoogleFonts.kanitTextTheme()),
//     //   home: DeskTopLayout(),
//     // );

//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    if (Platform.isWindows)
    // context.read<Share>().desktopInitialSetup();
    // else
    if (Platform.isAndroid) context.read<Share>().mobileSetup();
  }

  @override
  void dispose() {
    super.dispose();
    context.read<Share>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? MaterialApp(
            title: 'Byte Transfer',
            theme: Theme.ThemeData(
                primarySwatch: Colors.Colors.blue,
                textTheme: GoogleFonts.kanitTextTheme()),
            home: Tabs(),
          )
        : FluentApp(
            title: 'Byte Transfer',
            theme: FluentTheme.ThemeData(
                activeColor: Colors.Colors.blue, fontFamily: 'kanit'),
            home: DeskTopLayout(),
          );
  }
}

/*
Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isScanning
          ? Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) => _onQrDetect(barcode.rawValue)),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Text("Number of files: ${numFiles.toString()}"),
                  if (Platform.isAndroid)
                    ElevatedButton(
                        onPressed: () => setState(() {
                              _isScanning = true;
                            }),
                        child: const Text(" Scan & Connect")),
                  ElevatedButton(
                      onPressed: _disconnectSocket,
                      child: const Text("Disconnect")),
                  ElevatedButton(
                      onPressed: () async {
                        _files = await FileClient.pickfiles();
                      },
                      child: const Text("Pick files")),
                  ElevatedButton(
                      onPressed: () => communicationChannel?.sendFiles(_files),
                      child: const Text("Send files")),
                  ElevatedButton(
                      onPressed: () =>
                          secondaryCommunicationChannel?.clipBoardHandler(),
                      child: const Text("Sync ClipBoard")),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       if (_clipboardSyncing)
                  //         clipboard?.cancel();
                  //       else
                  //         clipboard = clipboardSync().listen((data) {
                  //           if (!_isFileSharing) _socket?.add(data);
                  //         });
                  //     },
                  //     child: Text(
                  //         _clipboardSyncing ? "Stop sync" : "Sync Clipboard")),
                  if (Platform.isWindows)
                    ElevatedButton(
                        onPressed: () async {
                          final path = await FileClient.pickFolder();
                          if (path != null)
                            communicationChannel?.changeDestinationPath(path);
                        },
                        child: const Text("Select Destination Folder")),
                  Text(_isConnected ? "Connected" : "Not Connected"),
                  Text("${_percentageSent.toStringAsFixed(2)} %"),
                  if (Platform.isWindows && _qrCode.isNotEmpty)
                    QrImage(
                      data: _qrCode,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
*/
