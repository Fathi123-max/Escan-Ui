import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class gridViewCustom extends StatefulWidget {
  gridViewCustom({super.key, required this.selectedImages});

  List<String> selectedImages;
  @override
  State<gridViewCustom> createState() => _gridViewCustomState();
}

class _gridViewCustomState extends State<gridViewCustom> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1.0,
        children: List<Widget>.from(widget.selectedImages
            .map((path) => GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      path.split('/').last,
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.selectedImages.remove(path);
                        });
                      },
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: Center(
                              child: ExtendedImage.file(
                                File(path),
                                mode: ExtendedImageMode.gesture,
                                initGestureConfigHandler: (_) => GestureConfig(
                                  minScale: 0.9,
                                  animationMinScale: 0.7,
                                  maxScale: 3.0,
                                  animationMaxScale: 3.5,
                                  speed: 1.0,
                                  inertialSpeed: 100.0,
                                  inPageView: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.file(
                          File(path.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList()));
  }
}
