import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nota_diaria/view/Home.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
            imageBackground: AssetImage("assets/fundo.png"),
            seconds: 5,
            // navigateAfterSeconds:Login(),
            navigateAfterSeconds: Home(),
            title: new Text(
              '\n crie sua nota \n  \n surpreenda-se \n ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            //  image: new Image.asset("assets/fundo.png"),
            backgroundColor: Colors.white,
            styleTextUnderTheLoader: new TextStyle(fontSize: 2),
            photoSize: 70.0,
            loaderColor: Colors.blueGrey));
  }
}
