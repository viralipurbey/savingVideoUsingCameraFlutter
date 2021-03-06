import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //File _cameraVideo;
  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';
  double textSize = 20;

  Future<void> _uploadFile(File fileToUpload) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("videos/");
    final StorageUploadTask uploadTask =
                    storageReference.putData(fileToUpload.readAsBytesSync());
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    print("URL is $url");
  }

//// This function will helps you to pick a Video File from Camera
//  VideoPlayerController _cameraVideoPlayerController;
//  _pickVideoFromCamera() async {
//    File video = await ImagePicker.pickVideo(
//      source: ImageSource.camera,
//      preferredCameraDevice: CameraDevice.front,
//      maxDuration: Duration(seconds: 10),
//    );
//    _cameraVideo = video;
//    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
//      ..initialize().then((_) {
//        setState(() {});
//        _cameraVideoPlayerController.play();
//      });
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                child: SizedBox.expand(
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: _takePhoto,
                    child: Text(firstButtonText,
                        style:
                            TextStyle(fontSize: textSize, color: Colors.white)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                  child: SizedBox.expand(
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: _recordVideo,
                  child: Text(secondButtonText,
                      style: TextStyle(
                          fontSize: textSize, color: Colors.blueGrey)),
                ),
              )),
              flex: 1,
            )
          ],
        ),
      ),
    ));
  }

  void _takePhoto() async {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        _uploadFile(recordedImage);
        setState(() {
          firstButtonText = 'saving in progress...';
        });
      }
    });
  }

  void _recordVideo() async {
    ImagePicker.pickVideo(source: ImageSource.camera)
        .then((File recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        _uploadFile(recordedVideo);
        setState(() {
          secondButtonText = 'saving in progress...';
        });
      }
    });
  }
}
