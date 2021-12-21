import 'dart:async';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'hole_page.dart';
import 'instruction_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: Text('道路坑洞辨識'),
          ),
          body: Homepage(),
        ));
  }
}

class Homepage extends StatelessWidget {
  void pushToCamera(BuildContext context) async {
    final cameras = await availableCameras();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: cameras.first),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 350,
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.shade200,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 10.0,
                        spreadRadius: 2.0),
                    BoxShadow(
                        color: Colors.blue.shade200, offset: Offset(1.0, 1.0)),
                    BoxShadow(color: Colors.blue.shade200)
                  ]),
              child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 50),
                    primary: Colors.white,
                  ),
                  child: const Text('相機'),
                  onPressed: () {
                    this.pushToCamera(context);
                  }),
            ),
            Container(
              width: 350,
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.orange.shade100,
                        offset: Offset(3.0, 3.0),
                        blurRadius: 10.0,
                        spreadRadius: 2.0),
                    BoxShadow(
                        color: Colors.orange.shade100,
                        offset: Offset(1.0, 1.0)),
                    BoxShadow(color: Colors.orange.shade100)
                  ]),
              child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 50),
                    primary: Colors.white,
                  ),
                  child: const Text('坑洞資料'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Holepage()));
                  }),
            ),
            Container(
              width: 350,
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.pink.shade200,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 10.0,
                        spreadRadius: 2.0),
                    BoxShadow(
                        color: Colors.pink.shade200, offset: Offset(1.0, 1.0)),
                    BoxShadow(color: Colors.pink.shade200)
                  ]),
              child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 50),
                    primary: Colors.white,
                  ),
                  child: const Text('使用說明'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Instructionspage()));
                  }),
            ),
          ],
        ));
  }
}

