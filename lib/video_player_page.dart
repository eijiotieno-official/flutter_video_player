import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class VideoPlayerPage extends StatefulWidget {
  final File file;
  const VideoPlayerPage({super.key, required this.file});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  //declare video player controller variable
  VideoPlayerController? videoPlayerController;

  //Duration variable to store the current duration of the playing video
  Duration currentDuration = Duration.zero;
  //Duration variable to store the total duration of the video
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    //assign the declared videoPlayerController VideoPlayerController construct for playing video file
    //Pass the file as a parameter for the construct
    videoPlayerController = VideoPlayerController.file(widget.file)
      ..initialize().then(
        (_) {
          setState(() {
            //assign the video duration to totalDuration
            totalDuration = videoPlayerController!.value.duration;
          });
          //play the video after being initialized
          videoPlayerController!.play();
          //add a listener to listen to updates for the currentDuration variable
          videoPlayerController!.addListener(
            () {
              setState(() {
                currentDuration = videoPlayerController!.value.position;
              });
            },
          );
        },
      );
  }

  @override
  void dispose() {
    //always dispose the videoPlayerController when leaving this page
    videoPlayerController!.dispose();
    super.dispose();
  }

  //don't forget to subscribe to _eijiotieno

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player Page"),
        centerTitle: true,
      ),
      body: videoPlayerController == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                //widget that displays the video
                Center(
                  child: GestureDetector(
                    onTap: () {
                      //pause the video
                      setState(() {
                        videoPlayerController!.pause();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  ),
                ),
                //widget that indicates if the video is paused
                if (!videoPlayerController!.value.isPlaying)
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        //play the video
                        setState(() {
                          videoPlayerController!.play();
                        });
                      },
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                //display video progress
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ProgressBar(
                      progress: currentDuration,
                      total: totalDuration,
                      onSeek: (value) {
                        setState(() {
                          videoPlayerController!.seekTo(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
