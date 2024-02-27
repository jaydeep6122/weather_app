import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/screen/Loginscreen.dart';

userSignup(
  context,
  String email,
  String password,
  String name,
) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Signup successful, navigate to the next screen or perform any other action.
    //print('User signed up: ${userCredential.user!.uid}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Signup Successfully'),
          content: Text("Now You can Login And Enjoy App future"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    var user = await Hive.openBox("user");
    user.put("userData", {"email": email, "password": password, "name": name});
  } catch (e) {
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
