import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaperworld/firebase_options.dart';
import 'package:wallpaperworld/test.dart';
import 'package:wallpaperworld/views/screens/FullScreen.dart';
import 'package:wallpaperworld/views/screens/category.dart';
import 'package:wallpaperworld/views/screens/home.dart';
import 'package:wallpaperworld/views/screens/testads.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  //for initialaze facebook ads
  // AdHelper.init();


  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(Test());
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Guru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Test(),
    );
  }
}

