import 'package:csc_picker/csc_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'Objects.dart';

class DirectoryPage extends StatefulWidget {
  @override
  _DirectoryPageState createState() => _DirectoryPageState();

}

class _DirectoryPageState extends State<DirectoryPage> {
  
  DatabaseReference famRef;

  List<FamilyMember> members = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    
    super.initState();

    famRef = database().ref('members');
    loadMembers();

}

  void loadMembers() {
    
    famRef.once('value').then((query) async {
      List temp = [];
      query.snapshot.forEach((child) {
        temp.add(child);
      }); 
      for (var item in temp) {
        FamilyMember member = await FamilyMember.toMember(item.val());
        member.id = item.key;
        setState(() {
          members.add(member);
        });
      }
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
                                  member.addPhone(number.text);
                                  member.id = famRef.push(FamilyMember.toMap(member)).key;
                                }
                              );
                              setState(() {
                                members.addAll(membersToAdd);
                              });
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {});
            },
            style: TextStyle(color: Colors.black),
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Enter Search Here",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))
              )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () => showCreateMembers(),
            child: Text("Create Family Member")
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              members.sort((a, b) => a.name.split(" ").last.compareTo(b.name.split(' ').last));
              if (searchController.text.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyBullet(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(members.elementAt(index).allInfo(), style: Theme.of(context).textTheme.headline5,),
                      ),
                      // Expanded(
                      //   child: Align(
                      //     child: IconButton(onPressed: () {print("Edit ${members[index].name}");}, icon: Icon(Icons.edit)),
                      //     alignment: Alignment.centerRight,
                      //   )
                      // )
                    ]
                  ),
                );
              } 
              else if (members[index].allInfo().toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
                members[index].allInfo().toLowerCase()
                .contains(searchController.text.toLowerCase())
              ) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyBullet(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SelectableText(members.elementAt(index).allInfo(), style: Theme.of(context).textTheme.headline5,),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Align(
                      //     child: IconButton(onPressed: () {print("Edit ${members[index].name}");}, icon: Icon(Icons.edit)),
                      //     alignment: Alignment.centerRight,
                      //   )
                      // )
                    ]
                  ),
                );
              } else {
                return Container();
              }
          }),              
        ),
      ],
    );
  }

}