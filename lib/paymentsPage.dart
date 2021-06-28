
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_teague_app/signIn.dart';

import 'Objects.dart';

class PaymentsPage extends StatefulWidget {

  SignIn signIn;

  PaymentsPage(SignIn signIn, { Key key })
  {
    this.signIn = signIn;
  }

  @override
  _PaymentsPage createState() => _PaymentsPage(signIn);

}

class _PaymentsPage extends State<PaymentsPage> {

  SignIn signIn;
  DatabaseReference payRef;
  DatabaseReference famRef;

  List<FamilyMember> choices = [];
  Map<FamilyMember, bool> selected = {};

  _PaymentsPage(SignIn signIn) {

    this.signIn = signIn;
    payRef = database().ref('payments');
    famRef = database().ref('members');
    loadMembers();
    
  }

  void loadMembers() {
    
    famRef.once('value').then((query) {
      
      query.snapshot.forEach((child){
        FamilyMember member = FamilyMember.toMember(child.val());
        member.id = child.key;
        setState(() {
          choices.add(member);
          selected[member] = false;
        });
      }); 

    });

  }

  void showCreateMembers() {

    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController number = TextEditingController();
    Location location = Location("", "");
    DateTime dob;

    bool valid() {

      if(name.text != null && email.text != null && location.state != null && location.city != null
        && number != null && dob != null
      )
        return true;
      else {
        return false;      
      }

    }

    Future showAlertDialog(BuildContext context2) {

      String error = "";

      if(number.text.length != 9)
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
        firstDate: DateTime.fromMillisecondsSinceEpoch(-2208967200000)
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
                            List<FamilyMember> membersToAdd = [];
                            if(valid()) {
                              membersToAdd.add(
                                FamilyMember(name.text, email.text, location, dob)
                              );
                              membersToAdd.forEach(
                                (member) {
                                  setState(() {
                                    member.id = famRef.push(FamilyMember.toMap(member)).key;
                                    member.addPhone(number.text);
                                    choices.add(member);
                                    selected[member] = true;
                                  });
                                }
                              );
                              Navigator.of(context).pop();
                            }
                            else
                            {
                              showAlertDialog(context);
                            }
                          }, 
                          child: Text("Submit")
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

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => showCreateMembers(),
                  child: Text("Create Family Member")
                )
              ], 
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(.7),
                  borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
                  border: Border.all(
                    color: Colors.blue.withOpacity(.7),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: List.generate(choices.length, (index) => 
                    CheckboxListTile(
                      title: Text(choices.elementAt(index).name, style: TextStyle(color: Colors.black),), 
                      value: selected[choices.elementAt(index)],
                      onChanged: (boolVal) => setState(() {selected[choices.elementAt(index)] = boolVal;}),
                    )
                  )
                ),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SelectableText("Total: \$${(selected.entries.where((element) => element.value).toList().length * 3).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20),
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(onPressed: () {}, child: Text("Purchase")),
                ),
              ]
            )
          ],
        ),
      )
    );

  }

}