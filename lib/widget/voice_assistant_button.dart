import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofia/speech/output_speech.dart';

class VoiceAssistantButton extends StatefulWidget {
  @override
  _VoiceAssistantButtonState createState() => _VoiceAssistantButtonState();
}

class _VoiceAssistantButtonState extends State<VoiceAssistantButton> {
  PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FlutterTts flutterTts;

  String _assistantText = '';
  String _userText = '';

  dynamic languages;
  String language;
  double volume = 0.6;
  double pitch = 0.9;
  double rate = 0.5;

  bool _isOpen = true;
  IconData fabIcon = Icons.mic;

  // Future _speak() async {
  //   var result = await flutterTts.speak("Hello World");
  //   if (result == 1) setState(() => ttsState = TtsState.playing);
  // }

  Future _speak(String speechText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    // _controller.setState(() {
    //   _assistantText = speechText;
    // });

    await flutterTts.speak(speechText);

    // if (speechText != null) {
    //   if (speechText.isNotEmpty) {
    //     await flutterTts.speak(speechText);
    //   }
    // }
    // await Future.delayed(Duration(seconds: 4));
  }

  Future _pause() async {
    await flutterTts.pause();
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();
  }

  @override
  initState() {
    super.initState();
    initTts();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return FloatingActionButton(
      heroTag: 'voice_assistant',
      onPressed: () async {
        setState(() {
          _isOpen = _isOpen == false ? true : false;
          _assistantText = '';
        });

        if (_isOpen) {
          fabIcon = Icons.mic;
          _stop();
        } else {
          fabIcon = Icons.stop;
        }

        if (_isOpen) {
          Navigator.of(context).pop();
        } else {
          _controller = showBottomSheet(
            elevation: 5,
            context: context,
            builder: (context) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: screenSize.height / 20,
                    left: screenSize.width / 30,
                    right: screenSize.width / 30,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height / 40),
                        child: Text(
                          'SOFIA',
                          style: GoogleFonts.montserrat(
                              color: Colors.white38,
                              fontSize: 22,
                              letterSpacing: 5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: screenSize.width / 5,
                                ),
                                child: Text(
                                  _assistantText,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: screenSize.width / 5),
                                child: Text(
                                  _userText,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height: screenSize.height * 0.30,
            ),
          );

          await _speak('');
          flutterTts.setCompletionHandler(() async {
            _controller.setState(() {
              _assistantText = greetings1;
            });
            await Future.delayed(Duration(milliseconds: 600));
            await _speak(greetings1);
            flutterTts.setCompletionHandler(() async {
              _controller.setState(() {
                _assistantText = greetings2;
              });
              await Future.delayed(Duration(milliseconds: 600));
              await _speak(greetings2);
              flutterTts.setCompletionHandler(() async {
                _controller.setState(() {
                  _assistantText = askToStartWithBeginners;
                });
                await Future.delayed(Duration(milliseconds: 600));
                await _speak(askToStartWithBeginners);
                flutterTts.setCompletionHandler(() async {
                  flutterTts.stop();
                });
              });
            });
          });

          // flutterTts.getVoices;

          // await _speak(greetings2);
          // flutterTts.setCompletionHandler(() async {
          //   _controller.setState(() {
          //     _assistantText = greetings2;
          //   });
          // });

          // await _speak(askToStartWithBeginners);
          // flutterTts.setCompletionHandler(() async {
          //   _controller.setState(() {
          //     _assistantText = askToStartWithBeginners;
          //   });
          // });
        }
      },
      backgroundColor: Colors.pinkAccent[700],
      child: Icon(fabIcon, color: Colors.white),
    );
  }
}
