import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofia/screens/track_page.dart';
import 'package:sofia/speech/output_speech.dart';
import 'package:sofia/utils/database.dart';
import 'package:sofia/utils/sign_in.dart';
import 'package:sofia/widget/voice_assistant_button.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  final bool afterCompletion;
  HomePage({this.afterCompletion = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database database = Database();

  List<Widget> result = [];
  FlutterTts flutterTts = FlutterTts();

  GlobalKey<ScaffoldState> _key = GlobalKey();
  PersistentBottomSheetController _controller;
  // var timer;

  var screenSize;

  int _currentPosition = 0;

  String _assistantText = '';
  String _userText = '';

  bool _isListening = false;

  // For text to speech
  double volume = 0.8;
  double pitch = 1;
  double rate = Platform.isAndroid ? 0.8 : 0.6;

  // For speech to text
  final SpeechToText speech = SpeechToText();

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];

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

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
    );

    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  Future<void> startListening() async {
    _isListening = true;
    lastWords = "";
    lastError = "";
    await speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 10),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      partialResults: true,
    );
    setState(() {});
  }

  Future<void> stopListening() async {
    await speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
    _controller.setState(() {
      String input = lastWords.split(' - ')[0];
      _userText = input[0].toUpperCase() + input.substring(1);
    });
    print(lastWords);
    print('USER INPUT: $_userText');

    // To check if the speech was recognized
    // with good probability
    if (result.finalResult && !_isListening) {
      stopListening();
      // Checking the recognized words
      if (_userText == 'Yes') {
        stopListening();
        _controller.setState(() {
          _assistantText = startWithTrack;
        });
        _speak(startWithTrack);
      } else if (_userText == 'No') {
        stopListening();
        setState(() {
          _isListening = false;
        });
        _controller.setState(() {
          _isListening = false;
        });

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => HomePage(afterCompletion: true),
        //   ),
        // );
      } else {
        _controller.setState(() {
          _assistantText = notRecognized;
        });
        _speak(notRecognized);
        stopListening();
        flutterTts.setCompletionHandler(() async {
          _hasSpeech ? null : await initSpeechState();
          !_hasSpeech || speech.isListening ? null : await startListening();
        });
      }
    } else {
      // If speech not recognized
      // stopListening();
      // _controller.setState(() {
      //   _assistantText = notRecognized;
      //   _speak(notRecognized);
      // });
    }
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    // setState(() {
    //   lastError = "${error.errorMsg} - ${error.permanent}";
    // });
  }

  void statusListener(String status) {
    print(
      "Received listener status: $status, listening: ${speech.isListening}",
    );
    setState(() {
      lastStatus = "$status";
      // speech.isListening ? _isListening = true : _isListening = false;
    });

    _controller.setState(() {
      speech.isListening ? _isListening = true : _isListening = false;
    });
    if (!_isListening) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => HomePage(afterCompletion: true),
      //   ),
      // );
    }
  }

  @override
  void initState() {
    super.initState();

    // widget.afterCompletion
    //     ? Timer(Duration(seconds: 4), () {
    //         _controller = _key.currentState.showBottomSheet(
    //           (_) => Container(
    //             decoration: BoxDecoration(
    //               color: Colors.black87,
    //               borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(10),
    //                 topRight: Radius.circular(10),
    //               ),
    //             ),
    //             child: Container(
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                   // bottom: screenSize.height / 20,
    //                   left: 16,
    //                   right: 16,
    //                 ),
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: EdgeInsets.only(top: 10),
    //                       child: Text(
    //                         'SOFIA',
    //                         style: GoogleFonts.montserrat(
    //                             color: Colors.white38,
    //                             fontSize: 22,
    //                             letterSpacing: 5,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         mainAxisSize: MainAxisSize.max,
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Row(),
    //                           Align(
    //                             alignment: Alignment.centerLeft,
    //                             child: Padding(
    //                               padding: EdgeInsets.only(
    //                                 right: 20,
    //                               ),
    //                               child: Text(
    //                                 _assistantText,
    //                                 style: TextStyle(
    //                                     color: Colors.white, fontSize: 16),
    //                               ),
    //                             ),
    //                           ),
    //                           Align(
    //                             alignment: Alignment.centerRight,
    //                             child: Padding(
    //                               padding: EdgeInsets.only(left: 30),
    //                               child: Text(
    //                                 _userText,
    //                                 style: TextStyle(
    //                                     color: Colors.white54, fontSize: 16),
    //                               ),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     Visibility(
    //                       maintainAnimation: true,
    //                       maintainSize: true,
    //                       maintainState: true,
    //                       visible: _isListening,
    //                       child: Padding(
    //                         padding: EdgeInsets.only(top: 10),
    //                         child: LinearProgressIndicator(
    //                           backgroundColor: Colors.black12,
    //                           valueColor: new AlwaysStoppedAnimation<Color>(
    //                             Colors.grey[700],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             height: 200,
    //           ),
    //         );

    //         flutterTts.stop();
    //       })
    //     : null;

    // Timer(Duration(seconds: 5), () {
    //   // _speak('');
    //   flutterTts.setCompletionHandler(() async {
    //     _controller.setState(() {
    //       _assistantText = oneCompletionString;
    //     });
    //     await Future.delayed(Duration(milliseconds: 600));
    //     await _speak(oneCompletion);
    //     flutterTts.setCompletionHandler(() async {
    //       await flutterTts.stop();
    //       _controller.setState(() {
    //         _assistantText = exploreTracks;
    //       });
    //       await Future.delayed(Duration(milliseconds: 600));
    //       await _speak(exploreTracks);
    //       flutterTts.setCompletionHandler(() async {
    //         await flutterTts.stop();
    //         Navigator.of(context).pop();
    //       });
    //     });
    //   });
    // });

    // For uploading tracks to the database
    // database.uploadTracks();
  }

  generateChildren(var screenSize, String trackName) {
    result.add(
      Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenSize.width / 20,
            right: screenSize.width / 20,
            bottom: screenSize.height / 30,
          ),
          child: Material(
            child: Card(
              elevation: 3,
              shadowColor: Color(0xFFffc7b8),
              color: Color(0xFFffe5de),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenSize.width / 10),
              ),
              // height: screenSize.height / 10,
              // width: double.maxFinite,
              // decoration: BoxDecoration(
              //   color: Color(0xFFffe5de),
              //   borderRadius: BorderRadius.all(
              //     Radius.circular(20),
              //   ),
              // ),
              child: InkWell(
                borderRadius: BorderRadius.circular(screenSize.width / 10),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrackPage(
                        trackName: trackName,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height / 80,
                    bottom: screenSize.height / 60,
                    left: screenSize.width / 15,
                    right: screenSize.width / 20,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            trackName.toUpperCase(),
                            style: GoogleFonts.openSans(
                              fontSize: screenSize.width / 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height / 8,
                        width: screenSize.height / 5,
                        child: Image.asset('assets/images/$trackName.png'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Color(0xFFffe5de),
      //   centerTitle: true,
      //   title: Text(
      //     '',
      //     style: TextStyle(color: Color(0xFFf3766e)),
      //   ),
      // ),
      floatingActionButton: VoiceAssistantButton(),
      body: FutureBuilder(
        future: database.retrieveTracks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String beginnersTrackName = snapshot.data[0].data['name'];
            Widget _nameView() {
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3F0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: screenSize.height / 20,
                      top: screenSize.height / 20,
                    ),
                    child: Text(
                      'Hi, ${name.split(' ')[0]}!',
                      style: GoogleFonts.lato(
                        fontSize: screenSize.width / 15.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }

            Widget _beginnersTrack() {
              return Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width / 20,
                  right: screenSize.width / 20,
                  bottom: screenSize.height / 30,
                ),
                child: Card(
                  elevation: 3,
                  shadowColor: Color(0xFFffc7b8),
                  color: Color(0xFFffe5de),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenSize.width / 10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height / 60,
                      bottom: screenSize.height / 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 80,
                            bottom: screenSize.height / 60,
                            left: screenSize.width / 80,
                            right: screenSize.width / 20,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: screenSize.width * 0.50,
                                child: Center(
                                  child: Text(
                                    beginnersTrackName.toUpperCase(),
                                    style: GoogleFonts.openSans(
                                      fontSize: screenSize.width / 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Image.asset(
                                    'assets/images/$beginnersTrackName.png'),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.80,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TrackPage(
                                    trackName: beginnersTrackName,
                                  ),
                                ),
                              );
                            },
                            color: Color(0xFFffc7b8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                screenSize.height / 30,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: screenSize.height / 60,
                                bottom: screenSize.height / 60,
                              ),
                              child: Text(
                                'START NOW',
                                style: GoogleFonts.poppins(
                                  letterSpacing: 2,
                                  color: Colors.black54,
                                  fontSize: screenSize.height / 38,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            result.clear();

            result.add(_nameView());
            result.add(SizedBox(height: screenSize.height / 30));
            result.add(_beginnersTrack());
            result.add(Padding(
              padding: EdgeInsets.only(
                bottom: screenSize.height / 40,
              ),
              child: Center(
                child: Text(
                  'EXPLORE',
                  style: TextStyle(
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width / 25,
                      color: Colors.black54),
                ),
              ),
            ));

            for (int i = 1; i < snapshot.data.length; i++) {
              String trackName = snapshot.data[i].data['name'];
              generateChildren(screenSize, trackName);
            }

            return Container(
              color: Color(0xFFFFF3F0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: result,
              ),
            );
          }
          return Container(
            color: Color(0xFFFFF3F0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color(0xFFffc7b8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
