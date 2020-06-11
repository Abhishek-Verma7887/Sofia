import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofia/screens/gender_page.dart';
import 'package:sofia/utils/sign_in.dart';

String age;

class AgePage extends StatefulWidget {
  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  TextEditingController textController;
  FocusNode textFocusNode;

  String errorString;
  bool _isEditing = false;

  AppBar appBar = AppBar(
    centerTitle: true,
    title: Text(
      '',
      style: TextStyle(color: Colors.deepOrangeAccent[700], fontSize: 30),
    ),
    backgroundColor: Color(0xFFfeafb6),
    elevation: 0,
  );

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.text = null;
    textFocusNode = FocusNode();
  }

  String _validateString(String value) {
    value = value.trim();

    if (textController.text != null) {
      if (value.isEmpty) {
        return 'Age Can\'t Be Empty';
      } else if (!isNumeric(value)) {
        return 'Age should be numeric';
      }
    }

    return null;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    var sceeenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar,
      body: Container(
        color: Color(0xFFfeafb6),
        // Color(0xFFffe6e1), --> color for the other cover
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: sceeenSize.height - appBar.preferredSize.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: SvgPicture.asset(
                    'assets/images/intro_3.svg',
                    width: sceeenSize.width,
                    semanticsLabel: 'Cover Image',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: sceeenSize.width / 10,
                    left: sceeenSize.width / 10,
                    bottom: sceeenSize.height / 10,
                  ),
                  child: TextField(
                    focusNode: textFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      color: Color(0xFFc31304),
                      fontSize: 25,
                    ),
                    controller: textController,
                    cursorColor: Colors.deepOrange,
                    autofocus: false,
                    onChanged: (value) {
                      // setState(() {
                      //   textController.text = value;
                      // });
                      setState(() {
                        _isEditing = true;
                      });

                      // _validateString(value);
                    },
                    onSubmitted: (value) {
                      textFocusNode.unfocus();
                      _validateString(value);
                      age = textController.text.trim();
                      age.contains('.') ? age = age.split('.')[0] : age = age;

                      print('DONE EDITING');
                      print('AGE: $age');
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return GenderPage();
                      //     },
                      //   ),
                      // );
                    },
                    decoration: InputDecoration(
                      suffix: IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          size: 30,
                          color: Color(0xFFc31304),
                        ),
                        onPressed: () {
                          textFocusNode.unfocus();
                          age = textController.text.trim();
                          age.contains('.')
                              ? age = age.split('.')[0]
                              : age = age;

                          print('DONE EDITING');
                          print('AGE: $age');
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return GenderPage();
                          //     },
                          //   ),
                          // );
                        },
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepOrangeAccent[700]),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF734435)),
                      ),
                      labelText: 'Enter your age',
                      labelStyle:
                          TextStyle(color: Color(0xFF734435), fontSize: 18),
                      hintText: 'Used for tracking your fitness',
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                      errorText: _isEditing
                          ? _validateString(textController.text)
                          : null,
                      errorStyle:
                          TextStyle(fontSize: 15, color: Colors.redAccent[800]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
