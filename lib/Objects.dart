import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Activity {
  Riverwalk, Alamo, SixFlags, SeaWorld,
  Caverns, Zoo, Bus, Shopping, Ripleys, 
  Splashtown, Escape, Aquatica
}

enum FamilyMemberTier {
  Adult, Child
}

enum InvoiceStatus {
  complete, inProgress, sent, cancelled, other
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

  static Map<String, dynamic> toMap(AssessmentStatus assessmentStatus) {

    Map<String, dynamic> object = {};
    
    object['created'] = assessmentStatus.created;
    object['invoiceId'] = assessmentStatus.invoiceId;

    return object;

  }

  static AssessmentStatus toAssessmentStatus(Map<String, dynamic> object) {
    
    bool created = object['created'];
    String invoiceId = object["invoiceId"];

    AssessmentStatus ret = AssessmentStatus();
    ret.created = created;
    ret.invoiceId = invoiceId;

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
  Age age;
  FamilyMemberTier tier;
  AssessmentStatus assessmentStatus = AssessmentStatus();

  bool registered = false;
  DateTime registeredDate;

  FamilyMember(this.name, this.email, this.location, this.dob) {
    age = Age.dateDifference(fromDate: dob, toDate: DateTime.now());
    tier = age.years > 13 ? FamilyMemberTier.Adult : FamilyMemberTier.Child; 
  }

  FamilyMember addPhone(String givenPhone) { phone = givenPhone; return this; }

  String displayInfo() {

    String date = DateFormat('MM/dd/yyyy').format(dob);
    return "${name.split(' ').last}, ${name.split(' ').first}; $date";

  }

  String allInfo() {

    String date = DateFormat('MM/dd/yyyy').format(dob);
    return "${name.split(' ').last}, ${name.split(' ').first}; $email;${phone != null ? " $phone; " : null}${ location.city}, ${location.state}; $date";

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

    return object;

  }

  static Future<FamilyMember> toMember(Map<String, dynamic> object) async {

    String name = object['name'];
    String email = object['email'];
    Location location = Location(
      object['location']['state'],
      object['location']['city']
    );
    String phone = object['phone'];
    DateTime dob = DateTime.fromMillisecondsSinceEpoch(object['dob']);
    AssessmentStatus assessmentStatus = AssessmentStatus.toAssessmentStatus(object["assessmentStatus"]);
    FamilyMember ret = FamilyMember(name, email, location, dob);
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
        status = InvoiceStatus.sent;
        break;
      case "PARTIALLY_PAID":
        status = InvoiceStatus.inProgress;
        break;
      case "PAID":
        status = InvoiceStatus.complete;
        break;
      case "CANCELLED":
        status = InvoiceStatus.cancelled;
        break;
      default:
        status = InvoiceStatus.other;
    }

    DateTime startedDate = DateFormat("yyyy-MM-dd").parse(details["invoice_date"]);
    bool viewed = object["viewed_by_recipient"] == "true";

    double amt = double.parse(object["amount"]["value"]);

    InvoiceItems items = InvoiceItems();
    for (var item in object["items"]) {
      switch (item["name"]) {
        case "Child Assessement":
        case "Adult Assessment":
          var split = item["description"].toString().split(': ').last.split(" (");
          String name = split.first;
          String id = split.last.split(')').first;
          FamilyMember member;
          await database().ref("members").child(id).once('value').then((value) async {
            member = await FamilyMember.toMember(value.snapshot.val());
            member.id = id;
          });
          items.addMember(member);
          break;
        default:
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

  List<FamilyMember> tickets = [];
  // Map<Activity, List<FamilyMember>> activities = {};
  // List<TShirtOrder> tshirts = [];

  void addMember(FamilyMember member) {
    tickets.add(member);
  }

  // void addActivity(Activity activity, List<FamilyMember> members) {
  //   activities[activity] = members;
  // }

  void removeMember(FamilyMember member) {
    tickets.removeWhere((given) => given.id == member.id);
  }

  List<Map<String, Object>> createItemList() {

    List<Map<String, Object>> ret = [];

    tickets.forEach((theMember) {

      Map<String, Object> temp = {}; 
      
      temp["name"] = theMember.tier.toString().split('.').last + " Assessment";
      temp["description"] = "KC Teague 2022 Assessment for: ${theMember.name} (${theMember.id})";
      temp["quantity"] = "1";
      temp["unit_amount"] = {
        "currency_code": "USD",
        "value": (theMember.tier == FamilyMemberTier.Adult ? 100.00 : 90.00).toStringAsFixed(2)
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

    tickets.forEach((member) { 
      total += (member.tier == FamilyMemberTier.Adult ? 100 : 90);
    });

    return total;

  }

  static List<Map<String, dynamic>> toMap(InvoiceItems items) {

    List<Map<String, dynamic>> ret = [];

    items.tickets.forEach((theMember) {

      Map<String, Object> temp = {}; 

      temp["type"] = "member";
      temp["id"] = theMember.id;

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

  static Future<InvoiceItems> fromMap(List<Map<String, dynamic>> object) async {

    InvoiceItems items = InvoiceItems();

    for (var item in object) {

      switch (item["type"]) {
        case "member":
          FamilyMember member;
          await database().ref("members").child(item["id"])
          .once('value').then((value) async => member = await FamilyMember.toMember(value.snapshot.val())); 
          items.addMember(member);
          break;
        default:
      }

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

    }

    return items;

  }

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
