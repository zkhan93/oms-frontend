import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:order/globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

downloadReceipt(int orderId) async {
  var res = await globals.apiClient.getReceipt(orderId);
  await writeFile(res.data, "Order - $orderId.pdf");
}

writeFile(data, String name) async {
  // storage permission ask
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  //   // the downloads folder path
  //   Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
  //   String tempPath = tempDir.path;
  //   var filePath = tempPath + '/$name';
  //   //

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  var filePath = appDocPath + '/$name';

  // the data
  var bytes = ByteData.view(data.buffer);
  final buffer = bytes.buffer;
  // save the data in the path
  var downloaded_file = await File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  OpenFile.open(filePath, type: 'application/pdf');
}
