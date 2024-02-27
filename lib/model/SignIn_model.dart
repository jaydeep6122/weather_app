import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/screen/Home.dart';

userSignIn(context, String email, String password) async {
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Get.offAll(Home());
    // Sign-in successful, navigate to the next screen or perform any other action.
    print('User signed in: ${userCredential.user!.uid}');
    var user = await Hive.openBox("user");
    user.put("user", true);
  } catch (e) {
    print('Sign-in failed: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text('An error occurred during login. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
