import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Objects.dart';

class UrlLauncher {

  static Widget tryLaunch(String text, String url) {

    void _launch() async {
      await canLaunch(url) ? await launch(url) : print("cant launch $url");

    }

    return InkWell(child: Text(text), onTap: _launch,);

  }

} 

// ignore: must_be_immutable
class OverviewSlide extends StatefulWidget {
  
  BuildContext context;

  Function navigate;

  double textSize;

  OverviewSlide(this.context, this.navigate, {Key key}) : super(key: key);

  @override
  _OverviewSlideState createState() => _OverviewSlideState();

}

class _OverviewSlideState extends State<OverviewSlide> {
  
  void checkSize() {

    double tempTextSize;

    switch (getType(context)) {
      case ScreenType.Desktop:
        tempTextSize = 30;
        break;
      case ScreenType.Tablet:
        tempTextSize = 22;
        break;
      default:
        tempTextSize = 16;
    }

    setState(() {
      widget.textSize = tempTextSize;
    });

  }

  @override
  Widget build(BuildContext context) {
    
    checkSize();
    
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    "Welcome Teague Family!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize + 12
                    ),
                  ),
                  SelectableText(
                    "July 29th - July 31st, 2022",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.textSize + 8,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: SelectableText(
                    "\nFor this year, the reunion will be held at the",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "River Walk in San Antonio, Texas",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nTo access more information",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "such as the hotel, activities list,",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "activities poll, and assessment details,\nclick on the arrows below",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nBut be sure to head to the directory page",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "and 'create a family member', as this",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "will gather your information and add you to",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "the Teague Family Directory,",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "which is necessary for the assessment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(onPressed: () {widget.navigate(1);}, child: Text("Directory")),
            )
          ]
        ),
      ),
    );
  }

}

class HotelSlide extends StatefulWidget {

  BuildContext context;

  double textSize;

  HotelSlide(this.context, {Key key}) : super(key: key);

  @override
  _HotelSlideState createState() => _HotelSlideState();

}

class _HotelSlideState extends State<HotelSlide> {
  
  void checkSize() {

    double tempTextSize;

    switch (getType(context)) {
      case ScreenType.Desktop:
        tempTextSize = 30;
        break;
      case ScreenType.Tablet:
        tempTextSize = 22;
        break;
      default:
        tempTextSize = 16;
    }

    setState(() {
      widget.textSize = tempTextSize;
    });

  }

  @override
  Widget build(BuildContext context) {
    
    checkSize();
    
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: const [Colors.lightBlueAccent, Colors.white30, Colors.white30, Colors.lightBlueAccent])),
      child: Padding(
        padding: EdgeInsets.only(top:15, left: 10, right: 10, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SelectableText(
                  "Springhill Suites Hotel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: widget.textSize + 12
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SelectableText(
                    "\nSpringhill Suites by Marriot has agreed to reserve several rooms\nat a rate of \$129 plus tax per night from July 29 to 31, 2022"
                    + "\n\nAddress: 524 South Saint Mary’s Street\nSan Antonio, Texas 78205\n\nCall here to book: (210)354-1333\nBe sure to mention the event is Teague Family Reunion",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )  
    );
  }

}

class ActivitiesSlide extends StatefulWidget {
  
  BuildContext context;

  Function navigate;

  double textSize;

  ActivitiesSlide(this.context, this.navigate, {Key key}) : super(key: key);

  @override
  _ActivitiesSlideState createState() => _ActivitiesSlideState();

}

class _ActivitiesSlideState extends State<ActivitiesSlide> {
  
  void checkSize() {

    double tempTextSize;

    switch (getType(context)) {
      case ScreenType.Desktop:
        tempTextSize = 20;
        break;
      case ScreenType.Tablet:
        tempTextSize = 15;
        break;
      default:
        tempTextSize = 12;
    }

    setState(() {
      widget.textSize = tempTextSize;
    });

  }

  @override
  Widget build(BuildContext context) {
    
    checkSize();
    
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
          colors: const [Colors.lightBlueAccent, Colors.white30, Colors.white30, Colors.lightBlueAccent])),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                  "San Antonio Activities",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: widget.textSize + 12
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '\nRiver Walk Boat Ride',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.goriocruises.com/");
                          }
                        ),
                        TextSpan(
                          text: " - \$13.50 / ages 1-5 \$7.50 / ages 65+ \$10.50,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ],
                    ),
                  )
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "The Alamo Tour",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.thealamo.org/");
                          }
                        ),
                        TextSpan(
                          text: "  - FREE,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Six Flags",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.sixflags.com/fiestatexas/store/tickets#!");
                          }
                        ),
                        TextSpan(
                          text: " - \$29.99 (online ticket price),\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Sea World",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://seaworld.com/san-antonio");
                          }
                        ),
                        TextSpan(
                          text: " - \$54.99 (must reserve ahead),\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Aquatica",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://seaworld.com/san-antonio/#:~:text=Watch%20Video-,Aquatica,-This%20tropical%20paradise");
                          }
                        ),
                        TextSpan(
                          text: " - \$39.99 (must reserve ahead),\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Splashtown Waterpark",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.splashtownsa.com/");
                          }
                        ),
                        TextSpan(
                          text: " - under 48\" \$29.99 / Adults \$34.99,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Extreme Escape (Colonnade)",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.extremeescape.com/colonnade");
                          }
                        ),
                        TextSpan(
                          text: " - \$31.99 (must reserve ahead),\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "San Antonio Zoo",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://sazoo.org/experiences/");
                          }
                        ),
                        TextSpan(
                          text: " - ages 3-11 \$25.99 / ages 12+ \$29.99,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Double Decker Bus Tour",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.citysightseeingsanantonio.com/en/hop-on-hop-off-24");
                          }
                        ),
                        TextSpan(
                          text: " - \$37.89,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Natural Bridge Caverns",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://naturalbridgecaverns.com/");
                          }
                        ),
                        TextSpan(
                          text: " - Adult zip rails & rope course: \$26.99; Tykes zip rails & rope course: \$8.99;\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                        TextSpan(
                          text: " Maze: \$9.99; Climbing walls: \$9.99,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Ripley's Believe it or Not (4D Movie Theater)",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://www.ripleys.com/sanantonio/attractions/moving-theater/");
                          }
                        ),
                        TextSpan(
                          text: " - ages 3 - 11 \$8.99 (must be over 43\") / ages 12+ \$14.99,\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                      ]
                    )
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      text: "Shopping at San Marcos Outlet or The Shops at La Contera\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.textSize
                      )
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () { widget.navigate(2); }, 
                child: Text("Vote For Your Favorites!")
              ),
            )
          ],
        ),
      )  
    );
  
  }

}
