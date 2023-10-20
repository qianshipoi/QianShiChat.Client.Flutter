import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  const PhotoViewPage(
      {super.key,
      required this.imageProvider,
      required this.loadingChild,
      required this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      required this.heroTag});

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: PhotoView(
                imageProvider: widget.imageProvider,
                loadingBuilder: (context, event) => widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                minScale: widget.minScale,
                maxScale: widget.maxScale,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
                enableRotation: true,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: Get.back,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
