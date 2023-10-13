import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewGalleryPage extends StatefulWidget {
  final List images;
  final String? heroTag;
  late final PageController controller;
  PhotoViewGalleryPage({
    super.key,
    required this.images,
    index = 0,
    this.heroTag,
  }) {
    controller = PageController(initialPage: index);
  }

  @override
  State<PhotoViewGalleryPage> createState() => _PhotoViewGalleryPageState();
}

class _PhotoViewGalleryPageState extends State<PhotoViewGalleryPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: PhotoViewGallery.builder(
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                backgroundDecoration: null,
                pageController: widget.controller,
                enableRotation: true,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.images[index]),
                    heroAttributes: widget.heroTag != null
                        ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                        : null,
                  );
                }),
          ),
          Positioned(
              child: Center(
                  child: Text("${currentIndex + 1}/${widget.images.length}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)))),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
