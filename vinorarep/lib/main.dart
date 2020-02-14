import 'package:flutter/material.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'root_page.dart';
import 'package:splashscreen/splashscreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,        
        title: 'VinoraRep',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: SplashScreen1(title: 'VinoraRep'),
      ),
    );
  }
}
class SplashScreen1 extends StatefulWidget {
  SplashScreen1({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new RootPage(),
      title: new Text(
        'Welcome to VinoraRep',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      
      image: Image.asset("images/logo1.png"),
      loadingText: Text("Loading ..."),
      gradientBackground: new LinearGradient(
          colors: [Colors.cyan, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      
      loaderColor: Colors.red,
    );
  }
}
