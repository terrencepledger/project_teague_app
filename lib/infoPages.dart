import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project_teague_app/paypal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'package:universal_html/html.dart' as html;
import 'Objects.dart';

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

    switch (getType(widget.context)) {
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
                    "\nFor hotel information, weekend activities,",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "and the T-Shirt order form,",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "click on the arrows below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nWhen registering, follow",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "the instructions at the top.",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "You are not registered until you",
                    style: TextStyle(
                      fontSize: widget.textSize,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "receive an invoice via email.",
                    style: TextStyle(
                      fontSize: widget.textSize,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nTo begin registration, click on",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "the register button below!",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: ElevatedButton(onPressed: () {widget.navigate(MenuPage.Registration);}, child: Text("Register")),
            )
          ]
        ),
      ),
    );
  
  }

}

class ItinerarySlide extends StatefulWidget {
  
  BuildContext context;

  Function navigate;

  double textSize;

  ItinerarySlide(this.context, this.navigate, {Key key}) : super(key: key);

  @override
  _ItinerarySlideState createState() => _ItinerarySlideState();

}

class _ItinerarySlideState extends State<ItinerarySlide> {
  
  void checkSize() {

    double tempTextSize;

    switch (getType(widget.context)) {
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
                    "Weekend Itinerary",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize + 12
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: SelectableText(
                    "\Friday - Meet and Greet, Sign In, T-Shirt Pick Up",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "A time to reconnect with familiar faces",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "and meet new family members!",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nSaturday - A Day Full of Fun in the Sun",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "Let's get out and explore",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "San Antonio together!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nSunday - Banquet (A Dress Up Affair)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "💎 It's time to shine! 💎",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),                
              ],
            ),
            Spacer(),
            Spacer()
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

    switch (getType(widget.context)) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    "Springhill Suites Hotel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize + 12
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\nReservation Link',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: widget.textSize + 8,
                      ),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launch("https://www.marriott.com/events/start.mi?id=1635366658609&key=GRP");
                      }
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: SelectableText(
                    "\nWe have reserved rooms at the Springhill Suites",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "by Marriott @ \$129.00 plus tax per night.",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nThey offer 1 King bed with pull out sofa",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "or 2 Queen beds with pull out sofa",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nTo reserve your room, click the above link",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: Text.rich(
                    TextSpan(
                      text: 'or you may call ',
                      style: TextStyle(
                        fontSize: widget.textSize
                      ),
                      children: [
                        TextSpan(
                          text: "(210) 354-1333",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize,
                          ),
                          recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launch("tel:+1 210 354 1333");
                          }
                        ),
                        TextSpan(
                          text: ".",
                          style: TextStyle(
                            fontSize: widget.textSize
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "\nBe sure to mention Teague Family Reunion!",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
              ],
            ),
            Spacer()
          ]
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     FittedBox(
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           SelectableText(
        //             ,
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               decoration: TextDecoration.underline,
        //               // fontSize: widget.textSize + 12
        //             ),
        //           ),
        //           
        //         ],
        //       ),
        //     ),
        //     Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         FittedBox(
        //           child: SelectableText(
        //              
        //           ),
        //         ),
        //         FittedBox(
        //           child: SelectableText(
        //             "" 
        //           ),
        //         ),
        //         FittedBox(
        //           child: RichText(
        //             text: TextSpan(
        //               text: ' ',
        //               children: [
        //                 
        //               ]
        //             )
        //           ),
        //         ),
        //       ],
        //     ),
        //   ]
        // ),  
      )  
    );
  }

}

class AirportSlide extends StatefulWidget {

  BuildContext context;

  double textSize;

  AirportSlide(this.context, {Key key}) : super(key: key);

  @override
  _AirportSlideState createState() => _AirportSlideState();

}

class _AirportSlideState extends State<AirportSlide> {
  
  void checkSize() {

    double tempTextSize;

    switch (getType(widget.context)) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    "San Antonio Airport Transportation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: widget.textSize + 12
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\nReservation Link',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: widget.textSize + 8,
                      ),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launch("https://25387.partner.viator.com//tours/San-Antonio/Arrival-Private-Transfer-San-Antonio-Airport-SAT-to-San-Antonio-by-Sedan-Car/d910-40380P842?mcid=61846");
                      }
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: SelectableText(
                    "\nPre-book a one-way private transfer service from",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "the San Antonio International Airport (SAT) to the hotel.\n",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
                FittedBox(
                  child: SelectableText(
                    "11 Adults × \$24.10 per person = \$265.10",
                    style: TextStyle(
                      fontSize: widget.textSize
                    ),
                  ),
                ),
              ],
            ),
            Spacer()
          ]
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

    switch (getType(widget.context)) {
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
                          text: " - Adult zip rails & rope course: \$26.99;\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                        TextSpan(
                          text: "Tykes zip & rope course: \$8.99; Maze: \$9.99;\n",
                          style: TextStyle(
                            fontSize: widget.textSize
                          )
                        ),
                        TextSpan(
                          text: "Climbing walls: \$9.99,\n",
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
                          text: "Ripley's 4D Movie Theater",
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
                              launch("https://aquatica.com/san-antonio/");
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
                          text: "River Walk and 3-Day Bus Tour",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                            fontSize: widget.textSize
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch("https://25387.partner.viator.com//tours/San-Antonio/San-Antonio-River-Walk-Cruise-and-72-Hour-Hop-On-Hop-Off-Pass/d910-10152P14?mcid=61846");
                          }
                        ),
                        TextSpan(
                          text: " - \$49.99,\n",
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
                onPressed: () { widget.navigate(MenuPage.Activities); }, 
                child: Text("Vote For Your Favorites!")
              ),
            )
          ],
        ),
      )  
    );
  
  }

}

class TshirtFormSlide extends StatefulWidget {
  
  BuildContext context;

  Function navigate;

  double textSize;

  TshirtFormSlide(this.context, this.navigate, {Key key}) : super(key: key);

  @override
  _TshirtFormSlideState createState() => _TshirtFormSlideState();

}

class _TshirtFormSlideState extends State<TshirtFormSlide> {
  
  void checkSize() {

    double tempTextSize;

    switch (getType(widget.context)) {
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

  void tshirtForm() {

    TshirtOrder order = TshirtOrder();

    bool valid() {

      List<InputError> errors = [];

      if(order.orderName.isEmpty) {
        errors.add(InputError.Name);
      }
      if(order.orderEmail.isEmpty) {
        errors.add(InputError.Email);
      }
      if(order.delivery.needDelivery && order.delivery.address.isEmpty) {
        errors.add(InputError.Delivery);
      }
      
      for (TshirtSize shirt in order.shirts) {
        if(shirt == null) {
          errors.add(InputError.Order_Shirt);
          break;
        }
      }

      if(errors.isEmpty) {
        return true;
      }
      else {
        CreateMemberPopup.showErrorDialog(widget.context, "Order Error", errors);
        return false;
      }

    }
    
    void submit() async {

      // Database db = database();
      // db.ref('shirt-orders').push(TshirtOrder.toMap(order));
      Paypal paypal = Paypal(widget.context);
      var link = await paypal.createOrder(order);
      
      if(link.isNotEmpty) {
        launch(link);
      }

      // onGooglePlay

      // ScaffoldMessenger.of(widget.context).showSnackBar(
      //   SnackBar(
      //     content: Text("Successfully submitted order! Receipt sent to: ${order.orderEmail}"),
      //     duration: Duration(seconds: 6),
      //   )
      // );

    }

    showDialog(context: widget.context, builder: 
        (buildContext) {
          order.shirts.add(null);
          return StatefulBuilder(builder: (context, setState2) {
            
            return getType(context) == ScreenType.Desktop ? AlertDialog(
              content: Container(
                constraints: BoxConstraints(
                  minWidth: 650
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "T-Shirt Order Form",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                                      decoration: InputDecoration(
                                        labelText: "Name On Order", labelStyle: TextStyle(color: Colors.black)
                                      ),
                                      onChanged: (newName) {
                                        order.orderName = newName;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                                      decoration: InputDecoration(
                                        labelText: "Email", labelStyle: TextStyle(color: Colors.black)
                                      ),
                                      onChanged: (newEmail) {
                                        setState2(() {
                                          order.orderEmail = newEmail;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          value: !order.delivery.needDelivery,
                                          onChanged: (val) {
                                            setState2(() {
                                              order.delivery.needDelivery = !val;
                                            });
                                          }
                                        ),
                                        Text(
                                          "Pick Up At Reunion",
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: Colors.black,
                                            decoration: TextDecoration.none
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                order.delivery.needDelivery ? Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                                      decoration: InputDecoration(
                                        labelText: "Delivery Address", labelStyle: TextStyle(color: Colors.black)
                                      ),
                                      onChanged: (address) {
                                        setState2(() {
                                          order.delivery.address = address;
                                        });
                                      },
                                    ),
                                  ),
                                ) : Container(),
                              ],
                            ) 
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("T-Shirts",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black)
                        ),
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  order.shirts.length, 
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            (index + 1).toString() + ".",
                                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              color: Colors.black
                                            ),
                                          ),
                                        ),
                                        DropdownButton<TshirtSize>(
                                          hint: Text(
                                            "Select Size",
                                            style: TextStyle(
                                              color: Colors.black
                                            ),
                                          ),
                                          value: order.shirts.elementAt(index),
                                          dropdownColor: Colors.white,
                                          style: TextStyle(color: Colors.black),
                                          items: List.generate(TshirtSize.values.length, (index) {
                                            return DropdownMenuItem<TshirtSize>(
                                              value: TshirtSize.values.elementAt(index), 
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Text(
                                                  TshirtSize.values.elementAt(index).toString().split('.')[1].split("_").join(" "),
                                                  style: TextStyle(
                                                    color: Colors.black
                                                  ),
                                                ),
                                              )
                                            );
                                          }),
                                          onChanged: (newSize) {
                                            setState2(() {
                                              order.shirts[index] = newSize;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete_forever
                                            ),
                                            onPressed: () {
                                              if(order.shirts.length > 1) {
                                                setState2(() {
                                                  order.shirts.removeAt(index);
                                                });
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ), 
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),                    
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                ),
                                onPressed: () {
                                  setState2(() {
                                    order.shirts.add(null);
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Add Another Shirt",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  decoration: TextDecoration.none
                                ), 
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("Order Total: \$" + (order.getTotal()).toStringAsFixed(2),
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                decoration: TextDecoration.none,
                                color: Colors.black
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                if(valid()) {
                                  Navigator.of(context).pop();
                                  submit();
                                }
                              },
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            ) 
            : AlertDialog(
              content: Container(
                constraints: BoxConstraints(
                  minWidth: 650
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "T-Shirt Order Form",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                                      decoration: InputDecoration(
                                        labelText: "Name On Order", labelStyle: TextStyle(color: Colors.black)
                                      ),
                                      onChanged: (newName) {
                                        setState2(() {
                                          order.orderName = newName;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                                      decoration: InputDecoration(
                                        labelText: "Email", labelStyle: TextStyle(color: Colors.black)
                                      ),
                                      onChanged: (newEmail) {
                                        setState2(() {
                                          order.orderEmail = newEmail;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          value: !order.delivery.needDelivery,
                                          onChanged: (val) {
                                            setState2(() {
                                              order.delivery.needDelivery = !val;
                                            });
                                          }
                                        ),
                                        Text(
                                          "Pick Up At Reunion",
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: Colors.black,
                                            decoration: TextDecoration.none
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                order.delivery.needDelivery ? Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                                      decoration: InputDecoration(
                                        labelText: "Delivery Address", labelStyle: TextStyle(color: Colors.black)
                                      ),
                                      onChanged: (address) {
                                        setState2(() {
                                          order.delivery.address = address;
                                        });
                                      },
                                    ),
                                  ),
                                ) : Container(),
                              ],
                            ) 
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        child: Text("Next"),
                        onPressed: () {
                          showDialog(
                            context: widget.context, 
                            builder: (BuildContext context) {

                              return StatefulBuilder(
                                builder: (BuildContext context, setState2) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text("T-Shirts",
                                            style: Theme.of(context).textTheme.subtitle1.copyWith(
                                              color: Colors.black
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * .6,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 2, color: Colors.black)
                                            ),
                                            child: Scrollbar(
                                              isAlwaysShown: true,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: List.generate(
                                                      order.shirts.length, 
                                                      (index) => Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(6.0),
                                                              child: Text(
                                                                (index + 1).toString() + ".",
                                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                                  color: Colors.black
                                                                ),
                                                              ),
                                                            ),
                                                            DropdownButton<TshirtSize>(
                                                              hint: Text(
                                                                "Select Size",
                                                                style: TextStyle(
                                                                  color: Colors.black
                                                                ),
                                                              ),
                                                              value: order.shirts.elementAt(index),
                                                              dropdownColor: Colors.white,
                                                              style: TextStyle(color: Colors.black),
                                                              items: List.generate(TshirtSize.values.length, (index) {
                                                                return DropdownMenuItem<TshirtSize>(
                                                                  value: TshirtSize.values.elementAt(index), 
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(6.0),
                                                                    child: Text(
                                                                      TshirtSize.values.elementAt(index).toString().split('.')[1].split("_").join(" "),
                                                                      style: TextStyle(
                                                                        color: Colors.black
                                                                      ),
                                                                    ),
                                                                  )
                                                                );
                                                              }),
                                                              onChanged: (newSize) {
                                                                setState2(() {
                                                                  order.shirts[index] = newSize;
                                                                });
                                                              },
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(6.0),
                                                              child: IconButton(
                                                                icon: Icon(
                                                                  Icons.delete_forever
                                                                ),
                                                                onPressed: () {
                                                                  if(order.shirts.length > 1) {
                                                                    setState2(() {
                                                                      order.shirts.removeAt(index);
                                                                    });
                                                                  }
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ), 
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),                    
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add_circle_outline,
                                                    ),
                                                    onPressed: () {
                                                      setState2(() {
                                                        order.shirts.add(null);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    "Add Another Shirt",
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      decoration: TextDecoration.none
                                                    ),                                                    
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text("Order Total: \$" + (order.getTotal()).toStringAsFixed(2),
                                                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                    decoration: TextDecoration.none,
                                                    color: Colors.black
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: ElevatedButton(
                                                  child: Text("Submit"),
                                                  onPressed: () {
                                                    if(valid()) {
                                                      Navigator.of(context).pop();
                                                      submit();
                                                    }
                                                  },
                                                )
                                              ),
                                            ],
                                          ),
                                        )
                                      ]
                                    ),
                                  );
                                },
                              );

                            } 
                          );
                        },
                      ),
                    ),
                  ]
                )
              
              )
            ); 
          });
        }
    );
                

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      "T-Shirt Order Form",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: widget.textSize + 12
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      "** T-Shirts Included in Assessments **",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.textSize + 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  // Container(
                  //   height: widget.textSize * 10,
                  //   width: widget.textSize * 8,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage(
                  //         'images/2022-tshirt.PNG'
                  //       ),
                  //       fit: BoxFit.fill,
                  //     ),
                  //   ),
                  // ),
                  FittedBox(
                    child: SelectableText(
                      "\nIf you would like to order a T-Shirt",
                      style: TextStyle(
                        fontSize: widget.textSize
                      ),
                    ),
                  ),
                  FittedBox(
                    child: SelectableText(
                      "outside of registration, click the order",
                      style: TextStyle(
                        fontSize: widget.textSize
                      ),
                    ),
                  ),
                  FittedBox(
                    child: SelectableText(
                      "button below",
                      style: TextStyle(
                        fontSize: widget.textSize
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: ElevatedButton(onPressed: () {tshirtForm();}, child: Text("Order T-shirt")),
            )
          ]
        ),
      ),
    );
  
  }

}
