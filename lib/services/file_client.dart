// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_desktop_folder_picker/flutter_desktop_folder_picker.dart';

import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class FileClient {
  static Future<List<PlatformFile>> pickfiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return [];
    return result.files;
  }

  static List<PlatformFile> pickFilesFromIntent(
      List<SharedMediaFile> sharedFileList) {
    List<PlatformFile> files = [];
    for (var sharedFile in sharedFileList) {
      final file = File(sharedFile.path);
      files.add(PlatformFile(
          name: basename(file.path), size: file.lengthSync(), path: file.path));
    }
    return files;
  }

  static Future<String?> pickFolder() async {
    // for desktop
    final directoryPath =
        await FlutterDesktopFolderPicker.openFolderPickerDialog();
    return directoryPath;
  }

  static void openFolder() async {
    final path = await getPath();
    // if (Platform.isWindows) {
    final directory = Directory(path);
    var doesExist = await directory.exists();
    if (!doesExist) {
      await directory.create(recursive: true);
    }
    launch('file://' + path);
  }

  static Future<String> getPath() async {
    if (Platform.isAndroid) {
      final documentPath = await AndroidPathProvider.documentsPath;
      return '$documentPath/Byte Transfer';
    }

    final documentDirectory = await getApplicationDocumentsDirectory();
    final documentPath = documentDirectory.path;
    return '$documentPath\\Byte Transfer';
  }

  static Future<File> createFile(
      {required String fileName, String? path}) async {
    final type = lookupMimeType(fileName)?.split('/')[0];

    if (Platform.isAndroid) {
      // create file based upon file type
      final documentPath = await AndroidPathProvider.documentsPath;
      final directory = Directory('$documentPath/Byte Transfer');
      var doesExist = await directory.exists();
      if (!doesExist) {
        await directory.create(recursive: true);
      }
      return File('${directory.path}/$fileName');
    } else {
      // if destination folder is already selected save file there

      if (path == null) {
        // create file based upon file type in documents folder
        Directory? directory;
        final documentDirectory = await getApplicationDocumentsDirectory();
        final documentPath = documentDirectory.path;
        directory = Directory('$documentPath\\Byte Transfer');

        var doesExist = await directory.exists();
        if (!doesExist) {
          await directory.create(recursive: true);
        }
        path = directory.path;
      }
      return File('$path/$fileName');
    }
  }
}
