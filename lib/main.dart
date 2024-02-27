import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/firebase_options.dart';
import 'package:weather_app/model/weatherdata.dart';
import 'package:weather_app/screen/Home.dart';
import 'package:weather_app/screen/Loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive Initialize
  await Hive.initFlutter();
  Hive.openBox("testBox");
  await localUser();

  Timer(Duration(seconds: 3), () => runApp(const MyApp()));
}

localUser() async {
  var userBox = await Hive.openBox("user");
  try {
    user = userBox.get("user");
  } catch (e) {
    user = false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

bool user = false;

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WeatherdataProvider())
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: user ? Home() : LoginScreen(),
        ));
  }
}
