import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

bool isPredicted;

class PredictorPage extends StatefulWidget {
  @override
  _PredictorPageState createState() => _PredictorPageState();
}

class _PredictorPageState extends State<PredictorPage> {
  VideoPlayerController videoPlayerController;
  CameraController _cameraController;
  FlutterTts flutterTts = FlutterTts();
  var timer;

  int _currentPosition = 0;

  Future<void> _initVideoPlayer() async {
    videoPlayerController =
        VideoPlayerController.asset('assets/videos/trikonasana.mp4')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          })
          ..setVolume(1)
          ..play()
          ..addListener(() {
            final bool isPlaying = videoPlayerController.value.isPlaying;

            if (isPlaying) {
              _currentPosition = videoPlayerController.value.position.inSeconds;
              print("CURRENT POS: $_currentPosition");
            }
            // setState(() {
            //   if (_currentPosition == 21) {
            //     videoPlayerController.pause().whenComplete(() {
            //       flutterTts.setSpeechRate(0.8);
            //       // flutterTts.speak("Recognizing the step");
            //     });
            //   } else if (_currentPosition == 40) {
            //     videoPlayerController.pause();
            //   } else if (_currentPosition == 80) {
            //     videoPlayerController.pause();
            //   } else if (_currentPosition == 104) {
            //     videoPlayerController.pause();
            //   }
            //   Future.delayed(Duration(seconds: 10))
            //       .whenComplete(() => videoPlayerController.play());
            // });
          });
    // ..setLooping(true);
  }

  @override
  void initState() {
    isPredicted = false;
    super.initState();

    _initVideoPlayer();

    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    // timer = Timer(Duration(seconds: 30), () {
    //   setState(() {
    //     isPredicted = true;
    //   });
    // });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isPredicted = true;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                ),
                child: Center(
                  child: Text(
                    "TRIANGLE POSE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              videoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController),
                    )
                  : Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _cameraController.value.isInitialized
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: AspectRatio(
                              aspectRatio: _cameraController.value.aspectRatio,
                              child: CameraPreview(_cameraController),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _predictionStatus(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            videoPlayerController.value.isPlaying
                ? videoPlayerController.pause()
                : videoPlayerController.play();
          });
        },
        child: Icon(
          videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }

  Widget _predictionStatus() {
    if (isPredicted) {
      // firstTime = false;
      videoPlayerController.setVolume(0);
      flutterTts.setSpeechRate(0.5);
      flutterTts.speak("Mountain pose successfully complete!");
      videoPlayerController.pause();
      // _videoController?.dispose();
      // Timer(Duration(seconds: 5), () {
      //   Navigator.of(context).pop();
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) {
      //         return DashboardScreen();
      //       },
      //     ),
      //   );
      // });
    }
    return isPredicted
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Successful',
                style: TextStyle(color: Colors.greenAccent, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 30,
                ),
              )
            ],
          )
        : Column(
            children: <Widget>[
              Text(
                'Processing',
                style: TextStyle(color: Colors.amber, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.amber,
                  ),
                ),
              )
            ],
          );
  }
}
