import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_in.dart';

class Database {
  Future<void> storeUserData({
    @required String userName,
    @required String gender,
    @required int age,
  }) async {
    DocumentReference documentReferencer =
        documentReference.collection('user_info').document(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "image_url": imageUrl,
      "name": userName,
      "gender": gender,
      "age": age,
    };
    print('DATA:\n$data');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await documentReferencer.setData(data).whenComplete(() {
      print("User Info added to the database");
      prefs.setBool('details_uploaded', true);
    }).catchError((e) => print(e));
  }

  retrieveTracks() {}
}
