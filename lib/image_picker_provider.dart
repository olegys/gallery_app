import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerProvider with ChangeNotifier {
  List<AssetEntity> _images = [];
  List<AssetEntity> _selectedImages = [];
  List<AssetEntity> _savedImages = [];

  List<AssetEntity> get images => _images;
  List<AssetEntity> get selectedImages => _selectedImages;
  List<AssetEntity> get savedImages => _savedImages;

  bool isShowImagePicker = false;

  int getSelectedImageIndex(AssetEntity asset) {
    return _selectedImages.indexWhere(
      (s) => s.id == asset.id,
    );
  }

  void setImages(List<AssetEntity> images) {
    _images = images;

    notifyListeners();
  }

  void setSelectedImage(AssetEntity image) {
    _selectedImages.contains(image)
        ? _selectedImages.remove(image)
        : _selectedImages.add(image);

    notifyListeners();
  }

  void setImage(AssetEntity image) {
    _images.insert(1, image);
    _selectedImages.add(image);

    notifyListeners();
  }

  void showImagePickerModal(bool isShow) {
    isShowImagePicker = isShow;

    notifyListeners();
  }

  DateTime _startDt = DateTime.now().subtract(Duration(days: 365 * 8));
  DateTime _endDt = DateTime.now().add(Duration(days: 10));

  DateTime get startDt => _startDt;
  DateTime get endDt => _endDt;

  FilterOptionGroup makeOption() {
    final dtCond = DateTimeCond(
      min: startDt,
      max: endDt,
      asc: false,
    );

    return FilterOptionGroup()..dateTimeCond = dtCond;
  }

  void getPhotos(BuildContext context) {
    _images.clear();
    Future.delayed(Duration(milliseconds: 200)).then(
      (value) => PhotoManager.requestPermission().then((permission) {
        List<AssetEntity> images = [null];
        if (permission) {
          PhotoManager.getAssetPathList(
            type: RequestType.image,
            filterOption: makeOption(),
          ).then((List<AssetPathEntity> albums) {
            if (albums.length != 0) {
              print(albums);
              AssetPathEntity selectedAlbum = albums[0];
              selectedAlbum
                  .getAssetListRange(start: 0, end: selectedAlbum.assetCount)
                  .then((List<AssetEntity> imageList) {
                images.addAll(imageList);

                setImages(images);
              });
            } else {
              setImages(images);
            }
          });
        } else {
          Navigator.pop(context);
        }
      }),
    );
  }
}
