import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {

  static Widget tryLaunch(String text, String url) {

    void _launch() async {
      await canLaunch(url) ? await launch(url) : print("cant launch $url");

    }

    return InkWell(child: Text(text), onTap: _launch,);

  }

} 

class OverviewSlide extends StatelessWidget {

  Function navigate;

  OverviewSlide(this.navigate, {Key key}) : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SelectableText(
                "Welcome Teague Family!",
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              SelectableText(
                "July 29th - July 31st, 2022",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText("\nFor this year, the reunion will be held at the River Walk in San Antonio, Texas"),
              SelectableText("\nTo access more information such as the hotel, activities list,"),
              SelectableText("activities poll, and assessment details, click on the arrows below"),
              SelectableText("\nBut be sure to head to the directory page and 'create a family member', as this"),
              SelectableText("will gather your information and add you to the Teague Family Directory, which is"),
              SelectableText("necessary in order to pay for the assessment."),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(onPressed: () {navigate(1);}, child: Text("Directory")),
              )
            ]
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
              SelectableText(
                "Springhill Suites Hotel",
                textAlign: TextAlign.center,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              SelectableText(
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
        // fit: BoxFit.cover,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10.0, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SelectableText(
                  "San Antonio Activities",
                  textAlign: TextAlign.center,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: '\nRiver Walk Boat Ride',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.goriocruises.com/");
                    }
                  ),
                  TextSpan(
                    text: " - \$13.50 / ages 1-5 \$7.50 / ages 65+ \$10.50,\n"
                  ),
                  TextSpan(
                    text: "The Alamo Tour",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.thealamo.org/");
                    }
                  ),
                  TextSpan(
                    text: "  - FREE,\n"
                  ),
                  TextSpan(
                    text: "Six Flags",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.sixflags.com/fiestatexas/store/tickets#!");
                    }
                  ),
                  TextSpan(
                    text: " - \$29.99 (online ticket price),\n"
                  ),
                  TextSpan(
                    text: "Sea World",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://seaworld.com/san-antonio");
                    }
                  ),
                  TextSpan(
                    text: " - \$54.99 (must reserve ahead),\n"
                  ),
                  TextSpan(
                    text: "Aquatica",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://seaworld.com/san-antonio/#:~:text=Watch%20Video-,Aquatica,-This%20tropical%20paradise");
                    }
                  ),
                  TextSpan(
                    text: " - \$39.99 (must reserve ahead),\n"
                  ),
                  TextSpan(
                    text: "Splashtown Waterpark",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.splashtownsa.com/");
                    }
                  ),
                  TextSpan(
                    text: " - under 48\" \$29.99 / Adults \$34.99,\n"
                  ),
                  TextSpan(
                    text: "Extreme Escape (Colonnade)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.extremeescape.com/colonnade");
                    }
                  ),
                  TextSpan(
                    text: " - \$31.99 (must reserve ahead),\n"
                  ),
                  TextSpan(
                    text: "San Antonio Zoo",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://sazoo.org/experiences/");
                    }
                  ),
                  TextSpan(
                    text: " - ages 3-11 \$25.99 / ages 12+ \$29.99,\n"
                  ),
                  TextSpan(
                    text: "Double Decker Bus Tour",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.citysightseeingsanantonio.com/en/hop-on-hop-off-24");
                    }
                  ),
                  TextSpan(
                    text: " - \$37.89,\n"
                  ),
                  TextSpan(
                    text: "Natural Bridge Caverns",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://naturalbridgecaverns.com/");
                    }
                  ),
                  TextSpan(
                    text: " - Adult zip rails & rope course: \$26.99; Tykes zip rails & rope course: \$8.99; Maze: \$9.99; Climbing walls: \$9.99,\n"
                  ),
                  TextSpan(
                    text: "Ripley's Believe it or Not (4D Movie Theater)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://www.ripleys.com/sanantonio/attractions/moving-theater/");
                    }
                  ),
                  TextSpan(
                    text: " - ages 3 - 11 \$8.99 (must be over 43\") / ages 12+ \$14.99,\n"
                  ),
                  TextSpan(
                    text: "Shopping at San Marcos Outlet or The Shops at La Contera\n",
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),  
              ]),
                textAlign: TextAlign.left,
              ),
              ElevatedButton(onPressed: () { navigate(2); }, child: Text("Vote For Your Favorites!"))
            ],
          ),
        ),
      )  
    );
  }
  
}