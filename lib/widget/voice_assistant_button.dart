import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoiceAssistantButton extends StatefulWidget {
  @override
  _VoiceAssistantButtonState createState() => _VoiceAssistantButtonState();
}

class _VoiceAssistantButtonState extends State<VoiceAssistantButton> {
  bool _isOpen = true;
  IconData fabIcon = Icons.mic;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return FloatingActionButton(
      heroTag: 'voice_assistant',
      onPressed: () {
        setState(() {
          _isOpen = _isOpen == false ? true : false;
          _isOpen ? fabIcon = Icons.mic : fabIcon = Icons.stop;
        });
        if (_isOpen) {
          Navigator.of(context).pop();
        } else {
          showBottomSheet(
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
                                  'Hi there! I am Sofia. Let\'s get started with the beginners track.',
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
                                  'Hi there! I am Sofia. ',
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
        }
      },
      backgroundColor: Colors.pinkAccent[700],
      child: Icon(fabIcon, color: Colors.white),
    );
  }
}
