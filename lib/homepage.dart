import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_teague_app/Objects.dart';
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

  double aspect;

  _HomePage(this.signIn, this.navigate);

  @override
  void initState() { 
    super.initState();

    setState(() {
      items.addAll([
        CarouselItem(OverviewSlide(context, navigate), sliderController),
        CarouselItem(ItinerarySlide(context, navigate), sliderController),
        CarouselItem(AirportSlide(context), sliderController),
        CarouselItem(HotelSlide(context), sliderController),
        CarouselItem(ActivitiesSlide(context, navigate), sliderController),
        CarouselItem(TshirtFormSlide(context, navigate), sliderController)
      ]);    
    }); 

  }

  void checkAspect() {

    switch (getType(context)) {
      case ScreenType.Desktop:
        aspect = 16/10;
        break;
      case ScreenType.Tablet:
        aspect = 4/3;
        break;
      default:
        aspect = 9/12;
    }

  }

  @override
  Widget build(BuildContext context) {
    checkAspect();
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
                aspectRatio: aspect,
                // enlargeCenterPage: true,
                viewportFraction: 1,
              )
            ),
          ),
        ],
      ),
    );

  }

}