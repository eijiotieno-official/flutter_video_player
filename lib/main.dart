import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_player/video_player_page.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variable to hold the picked video file
  File? file;
  //function to help us pick a video file
  Future pickVideo() async {
    await ImagePicker().pickVideo(source: ImageSource.gallery).then(
      (value) {
        if (value != null) {
          setState(() {
            file = File(value.path);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player App"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //pick a video
          Center(
            child: ElevatedButton(
              onPressed: () {
                //call pickVideo function
                pickVideo();
              },
              child: const Text("Pick a video"),
            ),
          ),
          if (file != null)
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text(file!.path),
            ),
          if (file != null)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VideoPlayerPage(file: file!);
                      },
                    ),
                  );
                },
                child: const Text("View video"),
              ),
            ),
        ],
      ),
    );
  }
}
