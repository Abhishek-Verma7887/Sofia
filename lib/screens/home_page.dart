import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofia/utils/database.dart';
import 'package:sofia/utils/sign_in.dart';

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
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenSize.width / 20,
            right: screenSize.width / 20,
            bottom: screenSize.height / 30,
          ),
          child: Container(
            height: screenSize.height / 10,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Color(0xFFffe5de),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(trackName),
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
      body: SafeArea(
        child: FutureBuilder(
          future: database.retrieveTracks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String name = snapshot.data[0].data['name'];
              Widget _nameView() {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  child: Container(
                    height: screenSize.height / 3,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Color(0xFFffe5de),
                      // border: Border.all(
                      //   color: Colors.red[500],
                      // ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(screenSize.width / 10),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenSize.height / 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(name),
                          SizedBox(
                            width: screenSize.width * 0.80,
                            child: FlatButton(
                              onPressed: () {},
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

              for (int i = 1; i < snapshot.data.length; i++) {
                String trackName = snapshot.data[i].data['name'];
                generateChildren(screenSize, trackName);
              }

              return Container(
                color: Colors.white,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: result,
                ),
              );

              // return ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount:
              //       snapshot.hasData ? snapshot.data.length - 1 : 0,
              //   itemBuilder: (context, index) {
              //     String name = snapshot.data[index + 1].data['name'];
              //     // print(name);
              //     // print(id);
              //     return Padding(
              //       padding: EdgeInsets.only(
              //         left: screenSize.width / 20,
              //         right: screenSize.width / 20,
              //         bottom: screenSize.height / 30,
              //       ),
              //       child: Container(
              //         height: screenSize.height / 10,
              //         width: double.maxFinite,
              //         decoration: BoxDecoration(
              //           color: Color(0xFFffe5de),
              //           // border: Border.all(
              //           //   color: Colors.red[500],
              //           // ),
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(20),
              //           ),
              //         ),
              //         child: Text(name),
              //       ),
              //     );
              //   },
              // );
            }
            return Container(child: Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}
