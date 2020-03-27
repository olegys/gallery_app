import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:galleryapp/camera_preview.dart';
import 'package:galleryapp/image_picker_provider.dart';
import 'package:provider/provider.dart';

class CustomImagePickerModalScreen extends StatefulWidget {
  final double height;

  CustomImagePickerModalScreen({
    this.height,
  });

  @override
  _CustomImagePickerModalScreenState createState() =>
      _CustomImagePickerModalScreenState();
}

class _CustomImagePickerModalScreenState
    extends State<CustomImagePickerModalScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ImagePickerProvider>(context, listen: false).getPhotos(context);
  }

  @override
  Widget build(BuildContext context) {
    ImagePickerProvider provider =
        Provider.of<ImagePickerProvider>(context, listen: false);

    return Material(
      child: Container(
        height: widget.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                13.0,
                22.0,
                8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        height: 1.28,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Selector<ImagePickerProvider, int>(
              selector: (_, bloc) => bloc.images.length,
              builder: (_, length, __) {
                return Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(
                      0.0,
                    ),
                    itemCount: length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 3.0,
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, i) {
                      if (provider.images[i] == null)
                        return PhotoCameraPreview();
                      return FutureBuilder<Uint8List>(
                        future: provider.images[i].thumbData,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return Image.memory(
                            snapshot.data,
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
