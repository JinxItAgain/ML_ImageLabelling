import 'package:flutter/material.dart';
import 'customModel.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: customModel(),  //CustomModel
      //home: ImageLabelling(title: 'Image Labelling'), //Google pre-trained model
    );
  }
}

