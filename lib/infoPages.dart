import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OverviewSlide extends StatelessWidget {
  const OverviewSlide({Key key}) : super(key: key);

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Teague Family!\n\nJuly 29th - July 31st, 2022",
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Text(
                "\nFor this year, the reunion will be held at the\nRiver Walk in San Antonio, Texas"
                + "\n\nYou can find more info on the following pages.\n\nBe sure to purchase your tickets\nand vote for your favorite activities!\n",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
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
      child: Padding(
        padding:
          new EdgeInsets.only(top:0, right: 25, bottom: 10, left: 30),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Springhill Suites Hotel",
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              Text(
                "\nSpringhill Suites by Marriot has agreed to reserve several rooms\nat a rate of \$129 plus tax per night from July 28 to 30"
                + "\n\nAddress: 524 South Saint Mary’s Street\nSan Antonio, Texas 78205\n\nCall here to book: (210) 354-1333\nBe sure to mention the event is Teague Family Reunion",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )  
      ),
    );
  }
  
}