import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

class WidgetToImageConverter {
 static Future<ui.Image> captureWidget(
      Widget widget, {
        Size size = const Size(300, 300),
        double pixelRatio = 1.0,
      }) async {
    // 创建离屏渲染环境
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    final RenderView renderView = RenderView(
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: pixelRatio,
      ),
      view: ui.PlatformDispatcher.instance.implicitView!,
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = repaintBoundary;
    renderView.child = repaintBoundary;

    final RenderObjectToWidgetElement<RenderBox> rootElement =
    RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    var image = await repaintBoundary.toImage(
      pixelRatio: pixelRatio,
    );

    return image;
  }
}

// 使用示例
class ShareableCard extends StatefulWidget {
  @override
  _ShareableCardState createState() => _ShareableCardState();
}

class _ShareableCardState extends State<ShareableCard> {
  final GlobalKey _cardKey = GlobalKey();

  Future<void> _shareCard() async {
    try {
      RenderRepaintBoundary boundary =
      _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();

        // 使用 XFile 分享图片
        final XFile file = XFile.fromData(
          buffer,
          mimeType: 'image/png',
          name: 'card.png',
        );
        await Share.shareXFiles([file]);
      }
    } catch (e) {
      print('截图失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _cardKey,
          child: Card(
            child: Container(
              width: 300,
              height: 200,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('分享卡片', style: TextStyle(fontSize: 24)),
                  Text('这是一张可以截图分享的卡片'),
                  Icon(Icons.share, size: 48),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _shareCard,
          child: Text('分享卡片'),
        ),
      ],
    );
  }
}
