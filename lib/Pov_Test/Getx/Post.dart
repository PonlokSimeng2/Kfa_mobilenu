import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({super.key});

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Seleziona",
          allViewTitle: "Tutte le foto",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception {
      // handle error
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildGridView(),
          ),
          ElevatedButton(
            onPressed: loadAssets,
            child: const Text("Select Images"),
          ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        return AssetThumb(
          asset: images[index],
          width: 300,
          height: 300,
        );
      }),
    );
  }
}
