import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/entry.dart';
import '../presentation/widgets/share_card_widget.dart';

class SharingService {
  SharingService._();
  static final SharingService instance = SharingService._();

  /// Verilen `entry` için anı kartı PNG'si oluşturur ve native share sheet'i açar.
  /// Widget ağacına dokunmadan Overlay ile geçici render kullanır.
  Future<void> shareEntry({
    required BuildContext context,
    required Entry entry,
  }) async {
    final bytes = await _renderCardToBytes(context, entry);
    if (bytes == null) return;
    await _shareImage(bytes);
  }

  Future<Uint8List?> _renderCardToBytes(
    BuildContext context,
    Entry entry,
  ) async {
    final repaintKey = GlobalKey();
    final overlayState = Overlay.of(context);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: -9999,
        top: -9999,
        child: RepaintBoundary(
          key: repaintKey,
          child: ShareCardWidget(entry: entry),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    // Bir frame bekle — widget render edilsin
    await WidgetsBinding.instance.endOfFrame;

    Uint8List? bytes;
    try {
      final boundary =
          repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        bytes = byteData?.buffer.asUint8List();
      }
    } finally {
      overlayEntry.remove();
    }
    return bytes;
  }

  Future<void> _shareImage(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/mirildan_share.png');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
    );
  }
}
