import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelling extends StatefulWidget {
  ImageLabelling({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ImageLabellingState createState() => _ImageLabellingState();
}

class _ImageLabellingState extends State<ImageLabelling> {

  final picker = ImagePicker();

  File? _image;
  List<ImageLabel>? _labels;



  Future<void> _getImageAndDetectLabels() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      final  visionImage = InputImage.fromFile(image);
      final ImageLabeler labeler = GoogleMlKit.vision.imageLabeler();
      final List<ImageLabel> labels = await labeler.processImage(visionImage);

      setState(() {
        _image = image;
        _labels = labels;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Image Labeling')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_image == null || _labels == null)
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select an image to check its labels',
                  textAlign: TextAlign.center,
                ),
              ],
            )
                : Column(
              children: [
                Image.file(
                  _image!,
                  height: 240.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Identified labels: ',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  _labels!
                      .map((label) => '${label.label} '
                      'with confidence ${label.confidence.toStringAsFixed(2)}')
                      .join('\n'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(height: 16.0),
                Text('Want to check next image?'),
              ],
            ),
            SizedBox(height: 16.0),
            RaisedButton(
              onPressed: _getImageAndDetectLabels,
              child: Text(
                'OPEN IMAGE',
                style: TextStyle(color: Colors.black),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
