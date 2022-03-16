import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareManager {
  Future screenshotShare(Uint8List bytes, String message) async {
    final directory = await getApplicationDocumentsDirectory();
    final screenshot = File('${directory.path}/screenshot.png');
    screenshot.writeAsBytesSync(bytes);
    await Share.shareFiles([screenshot.path], text: message);
  }
}