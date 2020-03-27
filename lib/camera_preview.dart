import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:galleryapp/image_picker_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PhotoCameraPreview extends StatefulWidget {
  @override
  _PhotoCameraPreviewState createState() => _PhotoCameraPreviewState();
}

class _PhotoCameraPreviewState extends State<PhotoCameraPreview> {
  CameraController controller;

  void getCameraPreview() {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      availableCameras().then((List<CameraDescription> cameras) {
        controller = CameraController(cameras.first, ResolutionPreset.max);
        controller.initialize().then((_) {
          if (!mounted) return;
          setState(() {});
        });
      });
    });
  }

  @override
  void initState() {
    getCameraPreview();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: controller != null && controller.value.isInitialized
                ? Hero(
                    tag: 'camera',
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(
                        controller,
                      ),
                    ),
                  )
                : Container(),
          ),
          Hero(
            tag: 'take_image',
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 50.0,
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SafeArea(
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Hero(
                        tag: 'camera',
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(
                            controller,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Hero(
                        tag: 'take_image',
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                bottom: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              try {
                                final path = join(
                                  (await getTemporaryDirectory()).path,
                                  '${DateTime.now()}.png',
                                );

                                await controller.takePicture(path);
                                File image =
                                    await FlutterExifRotation.rotateImage(
                                        path: path);
                                Uint8List byteImage = await image.readAsBytes();
                                AssetEntity savedImage = await PhotoManager
                                    .editor
                                    .saveImage(byteImage);

                                Provider.of<ImagePickerProvider>(
                                  context,
                                  listen: false,
                                ).setImage(savedImage);

                                Navigator.pop(context);
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
