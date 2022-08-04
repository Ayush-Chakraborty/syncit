// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncit/UI/widgets/Shared/folder_card.dart';
// import 'package:syncit/UI/widgets/card.dart';
// import 'package:syncit/services/file_client.dart';

// class ReceivedFolders extends StatefulWidget {
//   const ReceivedFolders({Key? key}) : super(key: key);

//   @override
//   State<ReceivedFolders> createState() => _ReceivedFoldersState();
// }

// class _ReceivedFoldersState extends State<ReceivedFolders> {
//   // late Saf saf;

//   static const folderChannel = MethodChannel('com.byte.transfer/open_folder');
//   @override
//   void initState() {
//     super.initState();
//     Permission.storage.request();
//     // saf = Saf("Android/dcim");
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final FileManagerController controller = FileManagerController();
//     final media = MediaQuery.of(context);
//     return Container(
//       width: double.infinity,
//       child: SingleChildScrollView(
//         child: Wrap(
//           alignment: WrapAlignment.spaceEvenly,
//           runAlignment: WrapAlignment.center,
//           spacing: 50,
//           children: [
//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
//               child: FolderCard(
//                   image: 'assets/images.svg',
//                   text: "Images",
//                   onTap: openFolder),
//             ),
//             // ConstrainedBox(
//             //   constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
//             //   child: FileManager(
//             //     controller: controller,
//             //     builder: (context, snapshot) {
//             //       final List<FileSystemEntity> entities = snapshot;
//             //       return ListView.builder(
//             //         itemCount: entities.length,
//             //         itemBuilder: (context, index) {
//             //           return Card(
//             //             child: ListTile(
//             //               leading: FileManager.isFile(entities[index])
//             //                   ? Icon(Icons.feed_outlined)
//             //                   : Icon(Icons.folder),
//             //               title: Text(FileManager.basename(entities[index])),
//             //               onTap: () {
//             //                 if (FileManager.isDirectory(entities[index])) {
//             //                   controller.openDirectory(
//             //                       entities[index]); // open directory
//             //                 } else {
//             //                   // Perform file-related tasks.
//             //                 }
//             //               },
//             //             ),
//             //           );
//             //         },
//             //       );
//             //     },
//             //   ),
//             // ),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
//               child: FolderCard(
//                 image: 'assets/videos.svg',
//                 text: "Videos",
//                 // onTap: () => FileClient.openFolder("video"),
//               ),
//             ),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
//               child: FolderCard(
//                 image: 'assets/music.svg',
//                 text: "Audios",
//                 onTap: () => FileClient.openFolder("audio"),
//               ),
//             ),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
//               child: FolderCard(
//                 image: 'assets/document.svg',
//                 text: "Documents",
//                 onTap: () => FileClient.openFolder("doc"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future openFolder() async {
//     final path = await FileClient.getPath("image");
//     await folderChannel.invokeMethod('open_folder', path);
//   }
// }
