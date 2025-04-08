import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<String> getUserData(String filed) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return userDoc[filed] ?? 'Unknown';
}

Widget buildUserData({
  var filed,
  Color color = Colors.black,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w400,
}) {
  return FutureBuilder<String>(
    future: getUserData(filed),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text(
          'Loading...',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        );
      }
      if (snapshot.hasError) {
        return Text(
          'Error loading name',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        );
      }
      return Text(
        '${snapshot.data}',
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    },
  );
}
