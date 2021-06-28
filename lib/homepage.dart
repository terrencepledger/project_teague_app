import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_teague_app/Objects.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project_teague_app/infoPages.dart';
import 'package:project_teague_app/signIn.dart';

class HomePage extends StatefulWidget {

  SignIn signIn;
  Function navigate;

  HomePage(this.signIn, this.navigate, { Key key });

  @override
  _HomePage createState() => _HomePage(signIn, navigate);

}

class _HomePage extends State<HomePage> {

  SignIn signIn;
  Function navigate;
  List<Widget> items = [];
  CarouselController sliderController = CarouselController();
  DatabaseReference ref;

  _HomePage(this.signIn, this.navigate);

  @override
  void initState() { 
    super.initState();

    Database db = database();
    ref = db.ref('users');

    setState(() {
      items.addAll([
        CarouselItem(OverviewSlide(navigate), sliderController),
        CarouselItem(HotelSlide(), sliderController),
        CarouselItem(ActivitiesSlide(navigate), sliderController)
      ]);    
    }); 

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: CarouselSlider(
              items: items,
              carouselController: sliderController,
              options: CarouselOptions(
                aspectRatio: 15/7,
                enlargeCenterPage: true,
                viewportFraction: 1,
              )
            ),
          ),
        ],
      ),
    );

  }

}