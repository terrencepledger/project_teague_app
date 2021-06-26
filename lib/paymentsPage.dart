
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  bool valid(List row) {

    return true;

  }

  void showCreateMembers() {

      List<TextEditingController> names = [];
      List<TextEditingController> emails = [];
      List<Location> locations = [];
      List<DateTime> dobs = [];

      Widget locationPicker(int index) {

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
                  locations[index].state = value;
                });
              },

              onCityChanged: (value) {
                setState(() {
                  locations[index].city = value;  
                });
              },

              onCountryChanged: (val) {},

            )
          ),
        );

      }

      Future<void> selectDOB(Function setState, int index) async {
        print("inside");
        final DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          lastDate: DateTime.now(),
          firstDate: DateTime.fromMicrosecondsSinceEpoch(0)
        );
        print(picked);
        DateTime now = new DateTime.now();
        DateTime today = new DateTime(now.year, now.month, now.day);
        if (picked != null && picked != today) {
          print("doubly inside");
          setState(() {
            dobs[index] = picked;
          });
        }
        print("complete");
        print(picked);
      }

      Widget inputRow(Function setState2) { 
        names.add(TextEditingController());
        emails.add(TextEditingController());
        locations.add(Location("", ""));
        dobs.add(null);
        return StatefulBuilder(builder: (context, setState) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: names.last,
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
                    controller: emails.last,
                    style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email"
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: locationPicker(locations.length - 1),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {selectDOB(setState, dobs.length - 1);}, 
                    child: Text((dobs.last == null) ? "Enter Date of Birth" : DateFormat('MM/dd/yyyy').format(dobs.last))
                  ),
                ),
              ),
            ],
          );
        });
      }

      List<Widget> inputRows = [];

      showDialog(context: context, builder: 
        (buildContext) {
          return StatefulBuilder(builder: (context, setState2) {
            inputRows.length < 1 ? inputRows.add(inputRow(setState2)) : null;
            return AlertDialog(
              content: Container(
                constraints: BoxConstraints(
                  minWidth: 650
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(inputRows.length, (index) => inputRows.elementAt(index)) +
                  [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: IconButton(icon: Icon(
                        Icons.add_circle_outline
                      ), onPressed: () {
                        setState(
                          () {
                            inputRows.add(inputRow(setState2));  
                          }
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          List<FamilyMember> membersToAdd = [];
                          for (var i = 0; i < names.length; i++) {
                            List row = [names.elementAt(i), emails.elementAt(i),
                                  locations.elementAt(i), dobs.elementAt(i)];
                            if(valid(row)) {
                              membersToAdd.add(
                                FamilyMember(names.elementAt(i).text, emails.elementAt(i).text,
                                  locations.elementAt(i), dobs.elementAt(i))
                              );
                            }
                          }
                          membersToAdd.forEach(
                            (member) {
                              setState(() {
                                member.id = famRef.push(FamilyMember.toMap(member)).key;
                                choices.add(member);
                                selected[member] = true;
                              });
                            }
                          );
                          Navigator.of(context).pop();
                        }, 
                        child: Text("Submit")
                      ),
                    )
                  ]
                ),
              ),
            );
          });
        }  
      );

    }

  Widget paymentWidget() {
    
    showDialog(context: context, 
      builder: (buildContext) {
        
        return StatefulBuilder(builder: (context, setState) {
          
          
        
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
                  child: Text("Add Family Members")
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
                    child: SelectableText("Total: \$${(selected.entries.where((element) => element.value).toList().length * 3).toStringAsFixed(2)}")
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