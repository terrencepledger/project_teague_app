import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarouselItem extends StatelessWidget {
  
  final Widget item;
  final CarouselController sliderController;

  CarouselItem(this.item, this.sliderController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          child: item,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Row(children: [
            IconButton(iconSize: 60, icon: Icon(Icons.arrow_back), onPressed: () {sliderController.previousPage();}),
            IconButton(iconSize: 60, icon: Icon(Icons.arrow_forward), onPressed: () {sliderController.nextPage();})
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),  
      ),
    );
  }

}

class Location {

  String state;
  String city;

  Location(this.state, this.city);

  String displayInfo() => state + ", " + city;

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

  String id;

  String name;
  String email;
  Location location;
  String phone;
  DateTime dob;

  bool registered = false;
  DateTime registeredDate;

  FamilyMember(this.name, this.email, this.location, this.dob) {
    // name = name.characters.first.toUpperCase() + name.characters.getRange(1).join();
  }

  FamilyMember addPhone(String givenPhone) { phone = givenPhone; return this; }

  String displayInfo() {

    String date = DateFormat('MM/dd/yyyy').format(dob);
    return "${name.split(' ').last}, ${name.split(' ').first}; ${location.state}, ${location.city}; $date";

  }

  String allInfo() {

    String date = DateFormat('MM/dd/yyyy').format(dob);
    return "${name.split(' ').last}, ${name.split(' ').first}; $email;${phone != null ? " $phone; " : null}${ location.state}, ${location.city}; $date";

  }

  static Map<String, dynamic> toMap(FamilyMember member) {

    Map<String, dynamic> object = {};
    
    object['name'] = member.name;
    object['email'] = member.email;
    object['location'] = {
      'state': member.location.state, 
      'city': member.location.city
    };
    object['phone'] = member.phone;
    object['dob'] = member.dob.millisecondsSinceEpoch;

    return object;

  }

  static FamilyMember toMember(Map<String, dynamic> object) {

    String name = object['name'];
    String email = object['email'];
    Location location = Location(
      object['location']['state'],
      object['location']['city']
    );
    String phone = object['phone'];
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(object['dob']);

    FamilyMember ret = FamilyMember(name, email, location, dob);
    ret.addPhone(phone);

    return ret; 

  }

}