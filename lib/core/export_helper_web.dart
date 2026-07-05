import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart';

void downloadJsonFile(String filename, String content) {
  final blob = Blob(
    <BlobPart>[Uint8List.fromList(utf8.encode(content)).toJS].toJS,
  );
  final url = URL.createObjectURL(blob);
  final anchor = HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  URL.revokeObjectURL(url);
}
