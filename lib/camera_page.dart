import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoder/geocoder.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final firestoreInstance = FirebaseFirestore.instance;
  int picnum;

  LocationData locationData;
  String formattedDate;
  List list = [];

  int buttonstate = 0;
  var coordinatetoaddress;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    DateTime now = DateTime.now();
    formattedDate = DateFormat('MMdd').format(now);
    _initializeControllerFuture = _controller.initialize();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    final coordinates = new Coordinates(locationData.latitude, locationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    coordinatetoaddress = addresses.first;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('請拍攝坑洞')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: InkWell(
        splashColor: Colors.blue,
        onLongPress: () async {
          try {
            final ImagePicker _picker = ImagePicker();
            final XFile pickedimage = await _picker.pickImage(source: ImageSource.gallery);
            final imagetoup = pickedimage.path;
            list.clear();
            var result = await firestoreInstance
                .collection("$formattedDate")
                .orderBy("name")
                .get();
            result.docs.forEach((res) {
              setState(() {
                list.add(res.data());
              });
            });
            if (list.isEmpty == true)
              picnum = 1;
            else
              picnum = list.last["name"] + 1;
            await firestoreInstance
                .collection("$formattedDate")
                .doc('${formattedDate}_$picnum')
                .set({
              "name": picnum,
              "hole": "",
              "date": "${formattedDate}_$picnum",
              "type": "",
            }).then((_) {});
            firebase_storage.FirebaseStorage.instance
                .ref('$formattedDate/${formattedDate}_$picnum.jpeg')
                .putFile(File(imagetoup));
            Fluttertoast.showToast(
                msg: "上傳成功!照片名稱為${formattedDate}_$picnum!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          } catch (e) {
            print(e);
          }
        },
        child: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              if (buttonstate == 0) {
                buttonstate = 1;
              } else if (buttonstate == 1) {
                buttonstate = 0;
              }
              switch (buttonstate) {
                case 1:
                  while (buttonstate == 1) {
                    list.clear();
                    var result = await firestoreInstance
                        .collection("$formattedDate")
                        .orderBy("name")
                        .get();
                    result.docs.forEach((res) {
                      setState(() {
                        list.add(res.data());
                      });
                    });
                    if (list.isEmpty == true)
                      picnum = 1;
                    else
                      picnum = list.last["name"] + 1;
                    final image = await _controller.takePicture();
                    final imagetoupload = image.path;
                    retrieveLocation();
                    await firestoreInstance
                        .collection("$formattedDate")
                        .doc('${formattedDate}_$picnum')
                        .set({
                      "name": picnum,
                      "hole": "",
                      "location": "${coordinatetoaddress.locality}",
                      "address": "${coordinatetoaddress.addressLine}",
                      "date": "${formattedDate}_$picnum",
                      "type": "",
                    }).then((_) {});
                    firebase_storage.FirebaseStorage.instance
                        .ref('$formattedDate/${formattedDate}_$picnum.jpeg')
                        .putFile(File(imagetoupload));
                    Fluttertoast.showToast(
                        msg: "成功拍攝!照片名稱為${formattedDate}_$picnum!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    await Future.delayed(const Duration(seconds: 5), () {});
                  }
                  break;

                case 0:
                  Fluttertoast.showToast(
                      msg: "停止拍攝",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  break;
              }
            } catch (e) {
              print(e);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
