import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:movies_app/emoji.dart';
import 'package:movies_app/home.dart';
import 'package:movies_app/mainpage.dart';
import 'package:movies_app/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(20.0)),
                ClipOval(
                  child: Material(
                    color: Hexcolor('#6BC7A6'), // button color
                    child: InkWell(
                      splashColor: Colors.white, // inkwell color
                      child: SizedBox(
                          width: 115.0,
                          height: 115.0,
                          child: Icon(
                            Icons.add_a_photo,
                            // color: Hexcolor('#6BC7A6'),
                            size: 79,
                          )),
                      onTap: () {
                        // Navigator.pushNamed(context, CameraScreen.id);
                        // Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => ViewMovie())),
                      },
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  'Capture mood from a camera',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 78.0,
                ),
                ClipOval(
                  child: Material(
                    color: Hexcolor('#6BC7A6'), // button color
                    child: InkWell(
                      splashColor: Colors.white, // inkwell color
                      child: SizedBox(
                        width: 115.0,
                        height: 115.0,
                        child: ImageIcon(
                          AssetImage('images/happy.png'),
                          // color: Hexcolor('#0A5687'),
                          size: 86,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EmojiScreen()));
                      },
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  'Describe mood from an emoji',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(20.0)),
          ],
        ),
      ),
    );
  }
}
