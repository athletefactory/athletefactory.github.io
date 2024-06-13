import 'dart:typed_data';
import 'package:athlete_factory/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../models/category.dart';
import '../models/sport.dart';


String storageBucketPath = !isTesting?"gs://athlete-factory-15e30.appspot.com":"gs://athletefactory-c575a.appspot.com";

Future<Uint8List> getData(Uint8List imageBytes, String imagePath, String imageDownloadURL, Function setState) async {
  try{
    imageDownloadURL = await FirebaseStorage.instance.ref().child("$storageBucketPath/$imagePath").getDownloadURL();
    var response = await http.get(Uri.parse(imageDownloadURL));
    if (response.statusCode == 200) {
      setState(() {
        imageBytes = response.bodyBytes;
      });

    } else {
      throw Exception('Failed to load image');
    }
    debugPrint(imageDownloadURL.toString());
    return imageBytes;
  }
  catch (e) {
    debugPrint("Error - $e");
    return Uint8List(0);
  }
}

Future<Map<String, dynamic>> getDataMap(int imageIndex, Uint8List imageBytes, String imagePath, String imageDownloadURL, Function setState) async {
  try{
    imageDownloadURL = await FirebaseStorage.instance.ref().child("$storageBucketPath/$imagePath").getDownloadURL();
    var response = await http.get(Uri.parse(imageDownloadURL));
    if (response.statusCode == 200) {
      setState(() {
        imageBytes = response.bodyBytes;
      });

    } else {
      throw Exception('Failed to load image');
    }
    debugPrint(imageDownloadURL.toString());
    return {
      'imageBytes': imageBytes,
      'imageIndex': imageIndex,
    };
  }
  catch (e) {
    debugPrint("Error - $e");
    return {};
  }
}

bool isEmpty = false;

Map<int,Uint8List> webImages = {};
Future selectFile(int imageIdx, dynamic currentPickedFile, String imageToAttach, Function setState) async {

  final result = await FilePicker.platform.pickFiles();
  if (result == null) return;

  setState(() {
    currentPickedFile = result.files.first;
  });
}

Future<Uint8List> pickImage(Uint8List imageBytes, Function setState) async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if(image != null){
    var f = await image.readAsBytes();
    setState(() {
      imageBytes = f;
    });
    return imageBytes;
  }
  return Uint8List(0);
}

Future<void> uploadFileWeb(int userIndex, dynamic pickedFile) async {
  final path = 'Mentors/mentor_$userIndex/picture_0.jpg';
  Reference storageReference = FirebaseStorage.instance.ref().child(path);

  UploadTask uploadTask = storageReference.putData(pickedFile);

  await uploadTask.whenComplete(() async {
    String downloadURL = await storageReference.getDownloadURL();
  });
}

List<Uint8List> renderImages(int imageAmount, AsyncSnapshot<dynamic> snapshot, int snapshotIndex,String folderName, String type, Function setState){

  int index = 0;
  int imageIndex = 0;
  List<Uint8List> imagesBytes = [];

  while(imageIndex < imageAmount){
    Uint8List currentImageBytes = Uint8List(0);
    imagesBytes.add(currentImageBytes);
    getDataMap(imageIndex, currentImageBytes, "$folderName/${snapshot.data[snapshotIndex]['$imageIndex']['$type-name']}/${snapshot.data[snapshotIndex]['$imageIndex']['$type-name']}_0.jpg", '', setState).
    then((result) {
      imagesBytes[result['imageIndex']] = result['imageBytes'];
      index++;
      if(index == imageAmount){
        if(snapshotIndex == 0){
          Sport.imagesRendered = true;
        }
        else{
          CategoryClass.imagesRendered = true;
        }
      }
    }).catchError((error) {
      debugPrint("Error - $error");
    });

    imageIndex++;
  }
  return imagesBytes;
}