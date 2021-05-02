import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  
  final Widget item;
  final CarouselController sliderController;

  CarouselItem(this.item, this.sliderController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Expanded(child: item),
          Row(children: [
            IconButton(iconSize: 100, icon: Icon(Icons.arrow_back), onPressed: () {sliderController.previousPage();}),
            IconButton(iconSize: 100, icon: Icon(Icons.arrow_forward), onPressed: () {sliderController.nextPage();})
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
        ]
      )
    );
  }

}

class MyBullet extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

}

class FamilyMember{

  String name;
  String email;
  String location;
  String phone;
  int age;

  bool registered = false;
  DateTime registeredDate;

  FamilyMember(this.name, this.email, this.location, this.age) {
    // name = name.characters.first.toUpperCase() + name.characters.getRange(1).join();
  }

  FamilyMember addPhone(String givenPhone) { phone = givenPhone; return this; }

  String displayInfo() {

    return "${name.split(' ').last}, ${name.split(' ').first}; $location; $age";

  }

  String allInfo() {

    return "${name.split(' ').last}, ${name.split(' ').first}; $email;${phone != null ? " $phone; " : null}$location; $age";

  }

}