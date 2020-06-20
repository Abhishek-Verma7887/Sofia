import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofia/screens/track_page.dart';
import 'package:sofia/utils/database.dart';
import 'package:sofia/utils/sign_in.dart';
import 'package:sofia/widget/voice_assistant_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database database = Database();
  

  List<Widget> result = [];

  @override
  void initState() {
    super.initState();

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
            String name = snapshot.data[0].data['name'];
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
                      'Hi, Souvik!',
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
                                    name.toUpperCase(),
                                    style: GoogleFonts.openSans(
                                      fontSize: screenSize.width / 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Image.asset('assets/images/$name.png'),
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
                                    trackName: name,
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
