import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sofia/screens/home_page.dart';

import 'screens/login_page.dart';
import 'screens/name_page.dart';
import 'utils/sign_in.dart';

List<CameraDescription> cameras = [];
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sofia: yoga trainer',
      home: (uid != null && authSignedIn != false)
          ? detailsUploaded ? HomePage() : NamePage()
          : LoginPage(),
    );
  }
}
