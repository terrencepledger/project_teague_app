import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class OverviewSlide extends StatelessWidget {

  OverviewSlide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: const [Colors.lightBlueAccent, Colors.white30, Colors.white30, Colors.lightBlueAccent])),
      child: Padding(
        padding:
          new EdgeInsets.only(top:10, right: 25, bottom: 30, left: 30),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Teague Family!\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                Text(
                  "July 29th - July 31st, 2022",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\nFor this year, the reunion will be held at the\nRiver Walk in San Antonio, Texas"
                  + "\n\nThere are a lot of FUN things to do in San Antonio and we've compiled a list of activities.\n"
                  + "Please note all prices listed are the current 2021 prices and are SUBJECT TO CHANGE for 2022.\n\n"
                  + "Since this is our FAMILY REUNION, we would like to do some of the activities\nas a group and we'd be able to get group rate discounts.\n"
                  + "With that in mind we are asking everyone to select their top (4) choices and\nthe ones with the most votes will be the activities we do as a group.\n\n"
                  + "Click the arrows to see more info on the hotel, the activities list, and the assessment info.\n",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class HotelSlide extends StatelessWidget {
  const HotelSlide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: const [Colors.lightBlueAccent, Colors.white30, Colors.white30, Colors.lightBlueAccent])),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.only(top:0, left: 10, right: 10, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Springhill Suites Hotel",
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Text(
                "\nSpringhill Suites by Marriot has agreed to reserve several rooms\nat a rate of \$129 plus tax per night from July 29 to 31, 2022"
                + "\n\nAddress: 524 South Saint Mary’s Street\nSan Antonio, Texas 78205\n\nCall here to book: (210)354-1333\nBe sure to mention the event is Teague Family Reunion",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )  
    );
  }
  
}

class ActivitiesSlide extends StatelessWidget {
  
  Function navigate;

  ActivitiesSlide(this.navigate, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: const [Colors.lightBlueAccent, Colors.white30, Colors.white30, Colors.lightBlueAccent])),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "San Antonio Activities",
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Text(
                "\nRiver Walk Boat Ride - \$13.50 / ages 1-5 \$7.50 / ages 65+ \$10.50,\nThe Alamo Tour - FREE,\nSix Flags - \$29.99 (online ticket price),\n" +
                "Sea World - \$54.99 (must reserve ahead),\nAquatica - \$39.99 (must reserve ahead)," +
                "\nSplashtown Waterpark - under 48\" \$29.99 / Adults \$34.99,\nExtreme Escape (Colonnade) - \$31.99 (must reserve ahead),\n" 
                "San Antonio Zoo - ages 3-11 \$25.99 / ages 12+ \$29.99,\nDouble Decker Bus Tour - \$37.89,\nShopping at San Marcos Outlet or The Shops at La Contera,"
                "\n"
                "Ripley's Believe it or Not (4D Movie Theater):",
                textAlign: TextAlign.left,
              ),
              Text(
                "ages 3 - 11 \$8.99 (must be over 43\") / ages 12+ \$14.99\n\n",
                textAlign: TextAlign.center
              ),
              ElevatedButton(onPressed: () { navigate(2); }, child: Text("Vote!"))
            ],
          ),
        ),
      )  
    );
  }
  
}