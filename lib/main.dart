import 'package:csc_picker/csc_picker.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_teague_app/Objects.dart';
import 'package:project_teague_app/activitiesPage.dart';
import 'package:project_teague_app/directorypage.dart';
import 'package:project_teague_app/paymentsPage.dart';

import 'homepage.dart';
import 'signIn.dart';

void main() {
  if (firebase.apps.isEmpty) {
    firebase.initializeApp(
      apiKey: "AIzaSyBhlfX8XnrV7pWWt-aIvk9VPAboGmi-6nw",
      authDomain: "kcteaguesite.firebaseapp.com",
      databaseURL: "https://kcteaguesite-default-rtdb.firebaseio.com",
      projectId: "kcteaguesite",
      storageBucket: "kcteaguesite.appspot.com",
    );
  }else {
    firebase.app(); // if already initialized, use that one
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KC Teague Family Reunion Site',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          subtitle2: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
          headline3: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black)
        )
      ),
      home: App(),
    );
  }
  
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState(SignIn());
  
}

class _AppState extends State<App> {

  int current = 0;

  SignIn signIn;
  String displayName = "";

  Widget pageBody;
  Widget pageTitle;

  List<FamilyMember> members = [];
  List<FamilyMember> unverified = [];
  FamilyMember memberToAssign;

  DatabaseReference ref;

  _AppState(SignIn signIn) {

    this.signIn = signIn;
    pageTitle = Text("Home", textAlign: TextAlign.left,);
    pageBody = HomePage(signIn, navigate);
    
    Database db = database();
    ref = db.ref('members');
    
    Function func = (String name) {
      setState(() {
        displayName = name;
      });
      loadMembers();
      checkUser();
    };

    signIn.listener(func);

  }

  void loadMembers() async {
    
    await ref.once('value').then((query) async {
      
      List temp = [];
      if(query.snapshot.hasChildren()) {
        query.snapshot.forEach((elem) => temp.add(elem));
        for (var child in temp) {
          FamilyMember member = await FamilyMember.toMember(child.val());
          member.id = child.key;
          setState(() {
            if(child.val()["verifiedId"] == null) {
              unverified.add(member);
            }
            members.add(member);
          });
        }

        memberToAssign = unverified.length > 0 ? unverified.elementAt(0) : null;
      }
      
    });

  }

  void checkUser() {

    ref.orderByChild("verifiedId").equalTo(signIn.currentUser.id)
    .limitToFirst(1).once('value').then(
      (value) {
        if(value.snapshot.val()==null) {
          assignMember();
        }
      }
    );

  }

  void assignMember() {
    
    showGeneralDialog(
      context: context, 
      barrierDismissible: false,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState2) {
            return Center(
              child: Wrap(
                children: [
                  Card(
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Select A Member to Assign to Your ID",
                              style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: DropdownButton(
                                  value: memberToAssign,
                                  dropdownColor: Colors.white,
                                  style: TextStyle(color: Colors.black),
                                  items: List.generate(unverified.length, (index) {
                                    return DropdownMenuItem<FamilyMember>(
                                      value: unverified.elementAt(index), 
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          unverified.elementAt(index).name,
                                          style: TextStyle(
                                            color: Colors.black
                                          ),
                                        ),
                                      )
                                    );
                                  }),
                                  onChanged: (member) {
                                    setState2(() {
                                      memberToAssign = member;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: memberToAssign != null ? () {
                                    print(memberToAssign.name);
                                    ref.child(memberToAssign.id).update({"verifiedId": signIn.currentUser.id});
                                    Navigator.of(context).pop();
                                  } : null,
                                  child: Text("Submit"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Or Create A New Member",
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () => createMember(),
                                  child: Text("Create Member"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } 
        );
      }
    );

  }

  void createMember() {

    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController number = TextEditingController();
    Location location = Location("", "");
    DateTime dob;

    bool valid() {

      if(name.text != null && email.text != null && location.state != null && location.city != null
        && dob != null && number.text.length == 10
      )
        return true;
      else {
        return false;      
      }

    }

    Future showAlertDialog(BuildContext context2) {

      String error = "";

      if(number.text.length != 10)
        error += "Please enter a valid phone number\n";
      if(!email.text.contains("@"))
        error += "Please enter a valid email address\n";
      else
        error += "To submit a new member, all fields must be entered. Please fill in all fields and submit again.";

      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () { Navigator.pop(context2); },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Create Member Error"),
        content: Text(
          error, style: TextStyle(color: Colors.black),
        ),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      return showDialog(
        context: context2,
        builder: (BuildContext context2) {
          return alert;
        },
      );

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


    showDialog(context: context, builder: 
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
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 4),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(valid()) {
                              memberToAssign = FamilyMember(name.text, email.text, location, dob);
                              memberToAssign.id = signIn.currentUser.id;
                              memberToAssign.addPhone(number.text);
                              ref.child(memberToAssign.id).set(FamilyMember.toMap(memberToAssign));
                              ref.child(memberToAssign.id).update({"verifiedId": memberToAssign.id});
                              setState(() {
                                members.add(memberToAssign);
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            else
                            {
                              showAlertDialog(context);
                            }
                          }, 
                          child: Text("Create and Assign")
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
          );
        });
      }  
    );

  }

  void navigate(int page) {

    if(page == current) {
      return;
    }
    else{
      current = page;
    }

    Widget x;
    String y;

    switch (page) {
      case 0:
          x = HomePage(signIn, navigate);
          y = 'Home';
        break;
      case 1: 
          x = DirectoryPage();
          y = 'Directory';
        break;
      case 2: 
        x = ActivitiesPage(signIn);
        y = 'Activities Poll';
        break;
      case 3: 
        x = PaymentsPage(signIn);
        y = 'Payment';
      break;
    }

    setState(() {
      pageBody = x;
      pageTitle = Text(y, textAlign: TextAlign.left,);
    });

  }

  Widget menu() {
    
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Home'),
              onPressed: () { navigate(0); },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Directory'),
              onPressed: () { navigate(1); }
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Activites Poll'),
              onPressed: () { navigate(2); },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Payment'),
              onPressed: () { navigate(3); },
            ),
          ),

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("KC Teague Family Reunion 2022", textAlign: TextAlign.left,),
                  pageTitle
                ],
              ),
            ),Spacer(), Expanded(flex: 1, child: Text(displayName, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,))
          ],
        ),
      ),
      body: Column(
        children: [
          menu(), Expanded(child: pageBody)
        ],
      )
    );
  }

}