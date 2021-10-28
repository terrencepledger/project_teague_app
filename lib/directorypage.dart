import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'Objects.dart';

class DirectoryPage extends StatefulWidget {
  @override
  _DirectoryPageState createState() => _DirectoryPageState();

}

class _DirectoryPageState extends State<DirectoryPage> {
  
  DatabaseReference famRef;

  double fontSize;
  double padding;

  List<FamilyMember> members = [];
  List<FamilyMember> searched = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    
    super.initState();

    famRef = database().ref('members');
    loadMembers();

}

  void checkSize() {

    double tempSize;
    double tempPadding;
    switch (getType(context)) {
      case ScreenType.Desktop:
        tempSize = 25;
        tempPadding = 8;
        break;
      case ScreenType.Tablet:
        tempSize = 20;
        tempPadding = 6;
        break;
      default:
        tempSize = 15;
        tempPadding = 3;
    }

    setState(() {
      fontSize = tempSize;
      padding = tempPadding;
    });

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

    CreateMemberPopup(context, setState, (name, email, number, location, dob, tshirt) {
      List<FamilyMember> membersToAdd = [];
      membersToAdd.add(
        FamilyMember(name.text, email.text, location, dob)
      );
      membersToAdd.forEach(
        (member) {
          member.addPhone(number.text);
          member.id = famRef.push(FamilyMember.toMap(member)).key;
          member.tshirt = tshirt;
        }
      );
      setState(() {
        members.addAll(membersToAdd);
      });
      Navigator.of(context).pop();
    }).show();
    
  }

  @override
  Widget build(BuildContext context) {
    checkSize();
    return SingleChildScrollView(
      child: Column(
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
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              onPressed: () => showCreateMembers(),
              child: Text("Create Family Member")
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Container(), 
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: SelectableText(
                        "Name", 
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: fontSize
                        ),
                      ),
                    ), 
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: SelectableText(
                        "Email", 
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: fontSize
                        ),
                      ),
                    ), 
                    // Padding(
                    //   padding: EdgeInsets.all(padding),
                    //   child: SelectableText(
                    //     "Phone", 
                    //     style: Theme.of(context).textTheme.headline5.copyWith(
                    //       fontWeight: FontWeight.bold,
                    //       decoration: TextDecoration.underline,
                    //       fontSize: fontSize
                    //     ),
                    //   ),
                    // ), 
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: SelectableText(
                        "Location", 
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: fontSize
                        ),
                      ),
                    ), 
                    // Padding(
                    //   padding: EdgeInsets.all(padding),
                    //   child: SelectableText(
                    //     "Date of Birth", 
                    //     style: Theme.of(context).textTheme.headline5.copyWith(
                    //       fontWeight: FontWeight.bold,
                    //       decoration: TextDecoration.underline,
                    //       fontSize: fontSize
                    //     ),
                    //   ),
                    // )
                  ]
                ),
                ...
                List.generate(
                  members.length,
                  // ignore: missing_return
                  (index) {
                    members.sort((a, b) => a.name.split(" ").last.compareTo(b.name.split(' ').last));
                    if (searchController.text.isEmpty) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(padding * 2),
                            child: MyBullet(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: SelectableText(members.elementAt(index).name, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: SelectableText(members.elementAt(index).email, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(padding),
                          //   child: SelectableText(members.elementAt(index).phone, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          // ),
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: SelectableText(members.elementAt(index).location.displayInfo(), style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(padding),
                          //   child: SelectableText(DateFormat('MM/dd/yyyy').format(members.elementAt(index).dob), style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          // ),
                          // Expanded(
                          //   child: Align(
                          //     child: IconButton(onPressed: () {print("Edit ${members[index].name}");}, icon: Icon(Icons.edit)),
                          //     alignment: Alignment.centerRight,
                          //   )
                          // )
                        ]
                      );
                    } 
                    else if (members[index].displayInfo().toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                      members[index].displayInfo().toLowerCase()
                      .contains(searchController.text.toLowerCase())
                    ) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MyBullet(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(members.elementAt(index).name, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(members.elementAt(index).email, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: SelectableText(members.elementAt(index).phone, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(members.elementAt(index).location.displayInfo(), style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: SelectableText(DateFormat('MM/dd/yyyy').format(members.elementAt(index).dob), style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                          // ),
                          // Expanded(
                          //   child: Align(
                          //     child: IconButton(onPressed: () {print("Edit ${members[index].name}");}, icon: Icon(Icons.edit)),
                          //     alignment: Alignment.centerRight,
                          //   )
                          // )
                        ]
                      );
                    }
                    else {
                      return TableRow(
                        children: [
                          Container(), Container(), Container(), Container()
                        ]
                      );
                    }
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

}