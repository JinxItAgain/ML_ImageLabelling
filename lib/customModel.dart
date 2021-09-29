import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class customModel extends StatefulWidget {
  @override
  _customModelState createState() => _customModelState();
}

class _customModelState extends State<customModel> {
  bool _loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 36, //the amout of categories our neural network can predict
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Image Labeling Custom Model')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading==true
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
                  'The object is: ${_output![0]["label"]}!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(height: 16.0),
                Text('Want to check next image?'),
              ],
            ),
            SizedBox(height: 16.0),
            RaisedButton(
              onPressed: pickGalleryImage,
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
