import 'package:carousel_slider/carousel_slider.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_teague_app/paypal.dart';
import 'package:quiver/core.dart';
import 'package:universal_html/js.dart';
import 'package:url_launcher/url_launcher.dart';

enum Activity {
  Riverwalk, Alamo, SixFlags, SeaWorld,
  Caverns, Zoo, Bus, Shopping, Ripleys, 
  Escape, Aquatica
}

enum MenuPage {
  Home, Directory, Activities, Registration, FAQ 
}

enum AssessmentPosition {

  Hoh, Participant

}

enum FamilyMemberTier {
  Adult, Child, Baby
}

enum InvoiceStatus {
  Complete, InProgress, Sent, Cancelled, Other
}

enum ScreenType { Watch, Handset, Tablet, Desktop }

enum TshirtSize { 
  Youth_XS, Youth_S, Youth_M, Youth_L, Youth_XL,
  S, M, L, XL, XXL, XXXL, XXXXL
}

enum InputError {
  Name, Email, Number, Member_Shirt, Order_Shirt, 
  Location, DoB, Delivery
}

ScreenType getType(BuildContext context) {

 double deviceWidth = MediaQuery.of(context).size.shortestSide;


 if (deviceWidth > 800) return ScreenType.Desktop;
 if (deviceWidth > 526) return ScreenType.Tablet;
 if (deviceWidth > 200) return ScreenType.Handset;
 
 return ScreenType.Watch;

}

class UrlLauncher {

  static Widget tryLaunch(String text, String url) {

    void _launch() async {
      await canLaunch(url) ? await launch(url) : print("cant launch $url");

    }

    return InkWell(child: Text(text), onTap: _launch,);

  }

} 

class CreateMemberPopup {
  
  BuildContext context;
  Function setState;
  void Function(TextEditingController name, TextEditingController email, TextEditingController number, Location location, DateTime dob, TshirtSize tSize, bool directoryMember) _onPressed;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  Location location = Location("", "");
  DateTime dob;
  TshirtSize size;
  bool isDirectoryMember = true;

  CreateMemberPopup(this.context, this.setState, this._onPressed);

  bool valid() {

    List<InputError> errors = [];

    if(name.text.length < 1) {
      errors.add(InputError.Name);
    } 
    if(!email.text.contains("@")) {
      errors.add(InputError.Email);
    }
    if(location.state == null) {
      errors.add(InputError.Location);
    }
    if(dob == null) {
      errors.add(InputError.DoB);
    } 
    if(number.text.length != 10) {
      errors.add(InputError.Number);
    } 
    if(size == null) {
      errors.add(InputError.Member_Shirt);
    }
     
    if(errors.isEmpty) {
      return true;
    }
    else {
      showErrorDialog(context, "Create Member Error", errors);
      return false;      
    }

  }

  Future<void> selectDOB(Function setState) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime.fromMillisecondsSinceEpoch(-2208967200000),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textSelectionTheme: ThemeData.light().textSelectionTheme.copyWith(
              // selectionColor: Colors.black,
              // selectionHandleColor: Colors.white
            )       
          ),
          child: child
        );
      }
    );
    DateTime now = new DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    if (picked != null && picked != today) {
      setState(() {
        dob = picked;
      });
    }
  }

  Widget locationPicker(Function setState) {

    return Center(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        padding: EdgeInsets.all(20),
        child: CSCPicker(
          showStates: true,

          showCities: true,

          flagState: CountryFlag.DISABLE,

          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            border:
                Border.all(color: Colors.grey.shade300, width: 1)
          ),

          disabledDropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.shade300,
            border:
                Border.all(color: Colors.grey.shade300, width: 1)
          ),

          defaultCountry: DefaultCountry.United_States,

          selectedItemStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),

          dropdownHeadingStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),

          dropdownItemStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),

          dropdownDialogRadius: 10.0,

          searchBarRadius: 10.0,

          onStateChanged: (value) {
            setState(() {
              location.state = value;
            });
          },

          onCityChanged: (value) {
            setState(() {
              location.city = value;  
            });
          },

          onCountryChanged: (val) {},

        )
      ),
    );

  }

  static void showErrorDialog(BuildContext context, String title, List<InputError> errors) {

    List<String> outputList = [];

    for (InputError error in errors) {
      switch (error) {
        case InputError.Name:
          outputList.add("Please enter a valid name");
          break;
        case InputError.Number:
          outputList.add("Please enter a valid phone number");
          break;
        case InputError.Email:
          outputList.add("Please enter a valid email address");
          break;
        case InputError.Member_Shirt:
          outputList.add("Please select a T-Shirt size");
          break;
        case InputError.Order_Shirt:
          outputList.add("Please select a size for each T-Shirt, or remove extras");
          break;
        case InputError.Location:
          outputList.add("Please enter a valid location");
          break;
        case InputError.Delivery:
          outputList.add("Please enter a valid delivery address, or select 'Pick up'");
          break;
        case InputError.DoB:
          outputList.add("Please choose a valid birthdate");
          break;
        default:
          outputList.add("Unknown Error, please check info and try again");
      }
    }

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          outputList.length,
          (index) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: MyBullet(),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    outputList.elementAt(index), style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          }
        ),
      ), 
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  Future<void> show() {

    if(getType(context) == ScreenType.Desktop) {
      return showDialog(
        barrierDismissible: false,
        context: context, builder: 
        (buildContext) {
          return StatefulBuilder(builder: (context, setState2) {
            return AlertDialog(
              content: Container(
                constraints: BoxConstraints(
                  minWidth: 650
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [ 
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: name,
                              style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                              decoration: InputDecoration(
                                labelText: "Full Name"
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: email,
                              style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email"
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: number,
                            decoration: InputDecoration(
                              labelText: "Phone Number"
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                            style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: locationPicker(setState),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {selectDOB(setState2);}, 
                              child: Text((dob == null) ? "Enter Date of Birth" : DateFormat('MM/dd/yyyy').format(dob))
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
                                child: Checkbox(value: isDirectoryMember, onChanged: (changed) {
                                  setState2(
                                    () {
                                      isDirectoryMember = changed;
                                    }
                                  );
                                }),
                              ),
                              Text("Add to Directory?", style: Theme.of(context).textTheme.headline5,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
                          child: Column(
                            children: [
                              Text("Tshirt Size", style: Theme.of(context).textTheme.headline5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton(
                                    hint: Text("Select Size"),
                                    value: size,
                                    dropdownColor: Colors.white,
                                    style: TextStyle(color: Colors.black),
                                    items: List.generate(TshirtSize.values.length, (index) {
                                      return DropdownMenuItem<TshirtSize>(
                                        value: TshirtSize.values.elementAt(index), 
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                        size = newSize;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, right: 4),
                          child: ElevatedButton(
                            onPressed: () async {
                              if(valid()) {
                                _onPressed.call(name, email, number, location, dob, size, isDirectoryMember);
                              }
                            },
                            child: Text("Create")
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              )
            );
          });
        }  
      );

    }

    else {
      return showDialog(
        barrierDismissible: false,
        context: context, builder: 
        (buildContext) {
          return StatefulBuilder(builder: (context, setState2) {
            return AlertDialog(
              content: Container(
                // constraints: BoxConstraints(
                //   minWidth: 650
                // ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [ 
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            controller: name,
                            style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                            decoration: InputDecoration(
                              labelText: "Full Name"
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            controller: email,
                            style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email"
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            controller: number,
                            decoration: InputDecoration(
                              labelText: "Phone Number"
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                            style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: locationPicker(setState),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () {selectDOB(setState2);}, 
                            child: Text((dob == null) ? "Enter Date of Birth" : DateFormat('MM/dd/yyyy').format(dob))
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Tshirt Size", style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButton(
                            hint: Text("Select Size"),
                            value: size,
                            dropdownColor: Colors.white,
                            style: TextStyle(color: Colors.black),
                            items: List.generate(TshirtSize.values.length, (index) {
                              return DropdownMenuItem<TshirtSize>(
                                value: TshirtSize.values.elementAt(index), 
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
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
                                size = newSize;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, right: 4),
                      child: ElevatedButton(
                        onPressed: () async {
                          if(valid()) {
                            await showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Add To Directory?"),
                                  content: Text(
                                    "Is this person a Teague Family Member that should be added to the directory?",
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => {
                                        _onPressed.call(name, email, number, location, dob, size, true),
                                        Navigator.of(context).pop()
                                      },
                                      child: Text("Yes")
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        _onPressed.call(name, email, number, location, dob, size, false),
                                        Navigator.of(context).pop()
                                      },
                                      child: Text("No")
                                    ),
                                  ],
                                );
                              } 
                            );

                          }
                        }, 
                        child: Text("Next")
                      ),
                    ),
                  ]
                ),
              )
            );
          });
        }  
      );
    }

  }

}

class Age {

  double years;
  int months;
  int days;

  static Age dateDifference(
    {@required DateTime fromDate, @required DateTime toDate}
  ) {
    Age age = Age();
    Duration diff = toDate.difference(fromDate);
    age.years = diff.inDays / 365;
    age.days = diff.inDays;
    age.months = diff.inDays ~/ 30;
    return age;
  }

}

class AssessmentStatus {

  bool created = false;
  String invoiceId;
  Invoice invoice;
  AssessmentPosition position;

  static Map<String, dynamic> toMap(AssessmentStatus assessmentStatus) {

    Map<String, dynamic> object = {};
    
    object['created'] = assessmentStatus.created;
    if(assessmentStatus.created) {
      object['invoiceId'] = assessmentStatus.invoiceId;
      object['position'] = assessmentStatus.position.toString().split('.')[1];
    }

    return object;

  }

  static AssessmentStatus toAssessmentStatus(Map<String, dynamic> object) {
    
    bool created = object['created'];

    AssessmentStatus ret = AssessmentStatus();
    ret.created = created;
    if(ret.created) {
      ret.invoiceId = object["invoiceId"];
      ret.position = AssessmentPosition.values.firstWhere(
        (pos) {
          return pos.toString().toLowerCase() == "AssessmentPosition.".toLowerCase() + object['position'].toString().toLowerCase();
        }
      );
    }    

    return ret; 

  }

}

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

class TshirtDelivery {

  bool needDelivery = true;

  String address = "";


}

class Location {

  String state;
  String city;

  Location(this.state, this.city);

  String displayInfo() => city + ", " + state;

}

class FAQ {

  String question;
  String answer;

  FAQ(
    this.question, this.answer
  );

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

class TshirtOrder {

  String id;

  TshirtDelivery delivery = TshirtDelivery();
  Map<TshirtSize, int> quantities = {};
  List<TshirtSize> _shirts = [];

  String orderName = "";
  String orderNumber = "";
  String orderEmail = "";

  TshirtOrder() {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void addShirt(TshirtSize shirt) {

    _shirts.add(shirt);

    int x = 0;
    _shirts.forEach((_shirt) { 
      if (shirt == _shirt) {
        x++;
      }
    });

    quantities[shirt] = x;

  }

  void removeShirt(TshirtSize shirt) {

    _shirts.remove(shirt);

    int x = 0;
    _shirts.forEach((_shirt) { 
      if (shirt == _shirt) {
        x++;
      }
    });

    quantities[shirt] = x;

  }

  double getTotal() {

    double total = 0;
    for (TshirtSize shirt in _shirts) {
      
      if(shirt==null) {
        continue;
      }
      
      switch (shirt) {
        case TshirtSize.Youth_XS:
        case TshirtSize.Youth_XL:
        case TshirtSize.Youth_S:
        case TshirtSize.Youth_M:
        case TshirtSize.Youth_L:
          total += 10;
          break;
        default:
          if (shirt != null) {
            total += 15;
          }
          break;
      }

    }

    return total;

  }

  List<TshirtSize> getShirts() {
    return _shirts;
  }

}

class Verification {
  
  String verifiedId;
  String email;

  Verification(this.verifiedId, this.email);

}

class FamilyMember{

  String id;
  String name;
  String email;
  Location location;
  String phone;
  DateTime dob;
  Age age;
  FamilyMemberTier tier;
  AssessmentStatus assessmentStatus = AssessmentStatus();
  TshirtSize tSize;
  Verification verification;
  bool isDirectoryMember = true;

  bool registered = false;
  DateTime registeredDate;

  FamilyMember(this.name, this.email, this.location, this.dob) {
    age = Age.dateDifference(fromDate: dob, toDate: DateTime.now());
    if(age.years > 11) {
      tier = FamilyMemberTier.Adult;
    }
    else if(age.years > 4) {
      tier = FamilyMemberTier.Child;
    }
    else
      tier = FamilyMemberTier.Baby;
  }

  FamilyMember addPhone(String givenPhone) { phone = givenPhone; return this; }

  String displayInfo() {

    // String date = DateFormat('MM/dd/yyyy').format(dob);
    return "$name - $email";

  }

  String allInfo() {

    String date = DateFormat('MM/dd/yyyy').format(dob);
    return "${name.split(' ').last}, ${name.split(' ').first}; $email;${phone != null ? " $phone; " : null}${ location.city}, ${location.state}; $date";

  }

  int get hashCode => hash2(id.hashCode, name.hashCode);

  @override
  bool operator ==(Object other) {
    return (other is FamilyMember && other.id == id);
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
    object['assessmentStatus'] = AssessmentStatus.toMap(member.assessmentStatus);
    if(member.tSize != null) {
      object["tSize"] = member.tSize.toString().split('.')[1].split('_').join(" ");
    }
    if(member.verification != null) {
      object['verification'] = { 
        "verifiedId": member.verification.verifiedId, 
        "email": member.verification.email
      };
    }
    object['isDirectoryMember'] = member.isDirectoryMember;

    return object;

  }

  static Future<FamilyMember> toMember(Map<String, dynamic> object) async {
    
    String name = object['name'];
    String email = object['email'];
    String state = object['location']['state'];
    String city = "";
    if(object['location']['city'] != null) {
      city = object['location']['city'];
    }
    Location location = Location(
      state, city
    );
    String phone = object['phone'];
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(object['dob']);
    AssessmentStatus assessmentStatus = AssessmentStatus.toAssessmentStatus(object["assessmentStatus"]);
    FamilyMember ret = FamilyMember(name, email, location, dob);
    if(object.containsKey("tSize")) {
      TshirtSize size = TshirtSize.values.firstWhere(
        (e) {
          String temp = object['tSize'].toString();
          if(temp.contains(" ")) {
            temp = temp.split(' ').join("_");
          }
          return e.toString() == ("TshirtSize." + temp); 
        }
      );
      ret.tSize = size;
    }
    if(object.containsKey("verification")) {
      ret.verification = Verification(object['verification']['verifiedId'], object['verification']['email']);
    }
    if(object['isDirectoryMember'] == false) {
      ret.isDirectoryMember = false;
    }
    ret.addPhone(phone);
    ret.assessmentStatus = assessmentStatus;

    return ret; 

  }

}

class Invoice{

  String id;
  String invNum;
  Uri link;
  InvoiceStatus status;
  DateTime startedDate;
  bool viewed;
  double amt;
  InvoiceItems items = InvoiceItems();
  double totalPaid = 0;
  List<Payment> payments;

  Invoice(this.id, this.invNum, this.link, this.status, this.startedDate, this.viewed, this.amt);

  static Future<Invoice> toInvoice(Map<String, dynamic> object) async {
  
    Map<String, dynamic> details = object["detail"];

    String id = object['id'];
    String invNum = details["invoice_number"];
    Uri link = Uri.parse(details["metadata"]["recipient_view_url"]);
    InvoiceStatus status;
    
    switch (object["status"]) {
      case "SENT":
        status = InvoiceStatus.Sent;
        break;
      case "MARKED_AS_PAID":
      case "PARTIALLY_PAID":
        status = InvoiceStatus.InProgress;
        break;
      case "PAID":
        status = InvoiceStatus.Complete;
        break;
      case "CANCELLED":
        status = InvoiceStatus.Cancelled;
        break;
      default:
        status = InvoiceStatus.Other;
    }

    DateTime startedDate = DateFormat("yyyy-MM-dd").parse(details["invoice_date"]);
    bool viewed = object["viewed_by_recipient"] == "true";

    double amt = double.parse(object["amount"]["value"]);

    InvoiceItems items = InvoiceItems();
    for (var item in object["items"]) {
      switch (item["name"]) {
        case "T-Shirt Order Form Purchase":
          TshirtSize size = TshirtSize.values.firstWhere((element) => element.name == item["description"].toString().split('T-Shirt Size: ').last.split(' ').join('_'));
          for (var i = 0; i < int.parse(item['quantity']); i++) {
            items.shirtsOrder.addShirt(size);
          }
          List<String> orderInfo = details["memo"].toString().split('Order Info: ').last.split(', ');
          items.shirtsOrder.id = orderInfo[0];
          items.shirtsOrder.orderName = orderInfo[1];
          items.shirtsOrder.orderEmail = orderInfo[2];
          items.shirtsOrder.orderNumber = orderInfo[3];
          if(orderInfo[4] != "null") {
            items.shirtsOrder.delivery.needDelivery = true;
            items.shirtsOrder.delivery.address = orderInfo[4];
          }
          break;
        case "T-Shirt Purchase":
        case "Child Assessment":
        case "Adult Assessment":
          var split = item["description"].toString().split(': ').last.split(" (");
          String id = split.last.split(')').first;
          FamilyMember member;
          await database().ref("members").child(id).once('value').then((value) async {
            member = await FamilyMember.toMember(value.snapshot.val());
            member.id = id;
          });
          items.addMember(member);
          break;
      }
    }

    List<Payment> payments = [];
    double totalPaid = 0;
    var transactions = object["payments"] != null ? object["payments"]["transactions"] : null;
    if(transactions != null) {
      for (var payment in transactions) {
        Payment temp = Payment.fromMap(payment);
        totalPaid += temp.amt;
        payments.add(temp);
      }
    }

    Invoice ret = Invoice(id, invNum, link, status, startedDate, viewed, amt);
    ret.items = items;
    ret.totalPaid = totalPaid;
    ret.payments = payments;
    return ret; 

  }

}

class InvoiceItems{

  TshirtOrder shirtsOrder = TshirtOrder();
  List<FamilyMember> assessments = [];
  // Map<Activity, List<FamilyMember>> activities = {};
  // List<TShirtOrder> tshirts = [];

  void addMember(FamilyMember member) {
    assessments.add(member);
  }

  // void addActivity(Activity activity, List<FamilyMember> members) {
  //   activities[activity] = members;
  // }

  void removeMember(FamilyMember member) {
    assessments.removeWhere((given) => given.id == member.id);
  }

  List<Map<String, Object>> createItemList() {

    List<Map<String, Object>> ret = [];

    shirtsOrder.quantities.keys.forEach((size) { 
      
      if(size == null) {
        return;
      }

      Map<String, Object> temp = {};

      String sizeName = size.name.split('_').join(' ');

      temp['name'] = "T-Shirt Order Form Purchase";
      temp['description'] = "T-Shirt Size: $sizeName";
      temp['quantity'] = shirtsOrder.quantities[size];
      
      var cost;
      switch (size) {
        case TshirtSize.Youth_XS:
        case TshirtSize.Youth_XL:
        case TshirtSize.Youth_S:
        case TshirtSize.Youth_M:
        case TshirtSize.Youth_L:
          cost = 10;
          break;
        default:
          cost = 15;
          break;
      }

      temp["unit_amount"] = {
        "currency_code": "USD",
        "value": cost.toStringAsFixed(2)
      };

      ret.add(temp);

    });

    assessments.forEach((theMember) {

      Map<String, Object> temp = {}; 
      
      temp["name"] = theMember.tier == FamilyMemberTier.Baby ? "T-Shirt Purchase" : theMember.tier.toString().split('.').last + " Assessment";
      String item = theMember.tier == FamilyMemberTier.Baby ? "T-Shirt Purchase" : "Assessment";
      temp["description"] = "KC Teague 2022 $item for: ${theMember.name} (${theMember.id})";
      temp["quantity"] = "1";
      var cost;
      switch (theMember.tier) {
        case FamilyMemberTier.Adult:
          cost = 100;
          break;
        case FamilyMemberTier.Child:
          cost = 30;
          break;
        case FamilyMemberTier.Baby:
          cost = 10;
          break;
        default:
      } 
      temp["unit_amount"] = {
        "currency_code": "USD",
        "value": cost.toStringAsFixed(2)
      };

      ret.add(temp);

    });

    // activities.forEach((activity, members) {
      
    //   ret["name"] = activity.toString().split(".").last;
    //   ret["description"] = "Group activity ticket";
    //   ret["quantity"] = "1";

    //   int amt;

    //   switch (activity) {
    //     case Activity.Riverwalk:
    //       amt = 14;
    //       break;
    //     case Activity.SixFlags:
    //       amt = 30;
    //       break;
    //     case Activity.SeaWorld:
    //       amt = 55;
    //       break;
    //     case Activity.Aquatica:
    //       amt = 40;
    //       break;
    //     case Activity.Splashtown:
    //       amt = ;
    //       break;
    //     default:
    //   }

    //   ret["unit_amount"] = 

    // })

    return ret;

  }

  double getTotal() {

    double total = 0;

    assessments.forEach((member) {
      var toAdd;
      switch (member.tier) {
        case FamilyMemberTier.Adult:
          toAdd = 100;
          break;
        case FamilyMemberTier.Child:
          toAdd = 30;
          break;
        case FamilyMemberTier.Baby:
          toAdd = 10;
          break;
        default:
      }
      total += toAdd;
    });

    total += shirtsOrder.getTotal();

    return total;

  }

  static clone(InvoiceItems oldItems) {

    InvoiceItems newItems = InvoiceItems();

    oldItems.assessments.forEach((element) {
      newItems.addMember(element);
    });

    newItems.shirtsOrder = oldItems.shirtsOrder;

    //oldItems.activities

    return newItems;

  }

  // static List<Map<String, dynamic>> toMap(InvoiceItems items) {

  //   List<Map<String, dynamic>> ret = [];

  //   if(items.shirtsOrder._shirts.isNotEmpty) {
  //     ret.add({
  //       "type": "shirt"
  //     })
  //   }

  //   items.assessments.forEach((theMember) {

  //     Map<String, Object> temp = {}; 

  //     temp["type"] = "member";
  //     temp["id"] = theMember.id;

  //     ret.add(temp);

  //   });

  //   // activities.forEach((activity, members) {
      
  //   //   ret["name"] = activity.toString().split(".").last;
  //   //   ret["description"] = "Group activity ticket";
  //   //   ret["quantity"] = "1";

  //   //   int amt;

  //   //   switch (activity) {
  //   //     case Activity.Riverwalk:
  //   //       amt = 14;
  //   //       break;
  //   //     case Activity.SixFlags:
  //   //       amt = 30;
  //   //       break;
  //   //     case Activity.SeaWorld:
  //   //       amt = 55;
  //   //       break;
  //   //     case Activity.Aquatica:
  //   //       amt = 40;
  //   //       break;
  //   //     case Activity.Splashtown:
  //   //       amt = ;
  //   //       break;
  //   //     default:
  //   //   }

  //   //   ret["unit_amount"] = 

  //   // })

  //   return ret;

  // }

  // static Future<InvoiceItems> fromMap(List<Map<String, dynamic>> object) async {

  //   InvoiceItems items = InvoiceItems();

  //   for (var item in object) {

  //     switch (item["type"]) {
  //       case "member":
  //         FamilyMember member;
  //         await database().ref("members").child(item["id"])
  //         .once('value').then((value) async => member = await FamilyMember.toMember(value.snapshot.val())); 
  //         items.addMember(member);
  //         break;
  //       default:
  //     }

  //     // activities.forEach((activity, members) {
        
  //     //   ret["name"] = activity.toString().split(".").last;
  //     //   ret["description"] = "Group activity ticket";
  //     //   ret["quantity"] = "1";

  //     //   int amt;

  //     //   switch (activity) {
  //     //     case Activity.Riverwalk:
  //     //       amt = 14;
  //     //       break;
  //     //     case Activity.SixFlags:
  //     //       amt = 30;
  //     //       break;
  //     //     case Activity.SeaWorld:
  //     //       amt = 55;
  //     //       break;
  //     //     case Activity.Aquatica:
  //     //       amt = 40;
  //     //       break;
  //     //     case Activity.Splashtown:
  //     //       amt = ;
  //     //       break;
  //     //     default:
  //     //   }

  //     //   ret["unit_amount"] = 

  //     // })

  //   }

  //   return items;

  // }

}

class Payment {

  String id;
  DateTime date;
  double amt;

  Payment.fromMap(Map<String, dynamic> object) {

    id = object["payment_id"];
    amt = double.parse(object["amount"]["value"]);
    date = DateFormat("yyyy-MM-dd").parse(object["payment_date"]);

  }

}
