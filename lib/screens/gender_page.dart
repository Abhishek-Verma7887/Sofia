import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofia/screens/age_page.dart';
import 'package:sofia/utils/sign_in.dart';

String userName;

class GenderPage extends StatefulWidget {
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final textController = TextEditingController(text: name.split(' ')[0]);
  FocusNode textFocusNode;
  List<bool> isSelected = [false, false, false];
  List<String> genderList = ['Male', 'Female', 'Non Binary'];

  String selectedGender;

  AppBar appBar = AppBar(
    centerTitle: true,
    title: Text(
      '',
      style: TextStyle(color: Colors.deepOrangeAccent[700], fontSize: 30),
    ),
    backgroundColor: Color(0xFF5cb798),
    elevation: 0,
  );

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
  }

  String _validateString(String value) {
    if (value.isEmpty) {
      return 'Name Can\'t Be Empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF5cb798),
            // Color(0xFFffe6e1), --> color for the other cover
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: screenSize.height / 5),
                height: screenSize.height - appBar.preferredSize.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: screenSize.height / 80,
                      ),
                      child: Text(
                        'QUOTE',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendTera(
                          fontSize: screenSize.height / 60,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenSize.width / 15,
                          right: screenSize.width / 15,
                          bottom: screenSize.height / 50),
                      child: Text(
                        'Yoga is a mirror to look at ourselves from within.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: screenSize.height / 50,
                          color: Color(0xFF284e41),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SvgPicture.asset(
                        'assets/images/intro_2.svg',
                        width: MediaQuery.of(context).size.width,
                        semanticsLabel: 'Cover Image',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: screenSize.height / 50,
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: ToggleButtons(
                          splashColor: Colors.transparent,
                          borderWidth: screenSize.width / 60,
                          borderColor: Colors.transparent,
                          fillColor: Colors.black12,
                          disabledBorderColor: Colors.black,
                          disabledColor: Colors.transparent,
                          color: Color(0xFF284e41),
                          selectedColor: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          children: <Widget>[
                            RotatedBox(
                              quarterTurns: 3,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  screenSize.width / 30,
                                ),
                                child: Text(
                                  'MALE',
                                  style: TextStyle(
                                    fontSize: screenSize.width / 12,
                                  ),
                                ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  screenSize.width / 30,
                                ),
                                child: Text(
                                  'FEMALE',
                                  style: TextStyle(
                                    fontSize: screenSize.width / 12,
                                  ),
                                ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  screenSize.width / 30,
                                ),
                                child: Text(
                                  'NON BINARY',
                                  style: TextStyle(
                                    fontSize: screenSize.width / 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          isSelected: isSelected,
                          onPressed: (int index) {
                            setState(() {
                              for (int indexBtn = 0;
                                  indexBtn < isSelected.length;
                                  indexBtn++) {
                                if (indexBtn == index) {
                                  isSelected[indexBtn] = !isSelected[indexBtn];
                                  selectedGender = genderList[index];
                                  print('GENDER: $selectedGender');
                                } else {
                                  isSelected[indexBtn] = false;
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        size: screenSize.width / 10,
                        color: selectedGender != null
                            ? Color(0xFF284e41)
                            : Colors.black12,
                      ),
                      onPressed: selectedGender != null
                          ? () {
                              textFocusNode.unfocus();
                              userName = textController.text;
                              print('DONE EDITING');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AgePage();
                                  },
                                ),
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // For Showing a progress indicator
          // SafeArea(
          //   child: Container(
          //     child: LinearProgressIndicator(
          //       backgroundColor: Color(0xFFffe6e1),
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
          //       value: 1/3,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
