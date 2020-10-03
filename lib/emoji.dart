import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:movies_app/mainpage.dart';

class EmojiScreen extends StatefulWidget {
  @override
  _EmojiScreenState createState() => _EmojiScreenState();
}

class _EmojiScreenState extends State<EmojiScreen> {
  // List mood = ['angry', 'happy', 'sad'];
  var mood = {0: 'Angry', 1: 'Happy', 2: 'Sad'};
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
                        height: 185.0,
                        width: 185.0,
                        child: Carousel(
                          images: [
                            AssetImage('images/${mood[0]}.png'),
                            AssetImage("images/${mood[1]}.png"),
                            AssetImage("images/${mood[2]}.png"),
                          ],
                          autoplay: false,
                          showIndicator: false,
                          onImageTap: (x) {
                            // Navigator.pushNamed(context, WelcomeScreen.id);
                            print(mood[0]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MainPage(mood[x])));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  'Swipe to your current mood',
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
