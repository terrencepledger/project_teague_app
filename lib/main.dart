import 'dart:developer';

import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_teague_app/Objects.dart';
import 'package:project_teague_app/activitiesPage.dart';
import 'package:project_teague_app/configure_web.dart';
import 'package:project_teague_app/directorypage.dart';
import 'package:project_teague_app/faqpage.dart';
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
  configureApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KC Teague Reunion Site',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          subtitle2: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
          headline3: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black),
        )
      ),
      home: App(),
    );
  }
  
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
  
}

class _AppState extends State<App> {

  int current = 0;
  double titleSize;

  SignIn signIn;
  String displayName = "Anon User";

  StatefulWidget pageBody;
  String pageTitle;

  List<FamilyMember> members = [];
  List<FamilyMember> unverified = [];
  FamilyMember memberToAssign;

  DatabaseReference ref;

  @override
  void initState() {
    
    super.initState();

    this.signIn = SignIn();
    
    Database db = database();
    ref = db.ref('members');

    Function func = (String name) async {
      setState(() {
        displayName = name;
      });
      await checkUser();
    };

    setState(() {
      pageBody = HomePage(signIn, navigate);
      pageTitle = "Home";
    });

    signIn.listener(func);

  }

  @override
  void didChangeDependencies() {
    
    checkSize();
    
    super.didChangeDependencies();
    
  }

  void checkSize() {

    double tempSize;
    switch (getType(context)) {
      case ScreenType.Desktop:
        tempSize = 20;
        break;
      case ScreenType.Tablet:
        tempSize = 15;
        break;
      default:
        tempSize = 10;
    }

    setState(() {
      titleSize = tempSize;
    });

  }

  Future<void> loadMembers() async {
    
    return await ref.once('value').then((query) async {
      
      List temp = [];
      unverified = [];
      if(query.snapshot.hasChildren()) {
        query.snapshot.forEach(
          (elem) {
            temp.add(elem);
          }
        );
        for (var child in temp) {
          FamilyMember member = await FamilyMember.toMember(child.val());
          member.id = child.key;
          setState(() {
            if(child.val()["verification"] == null) {
              unverified.add(member);
            }
            members.add(member);
          });
        }

        memberToAssign = unverified.length > 0 ? unverified.elementAt(0) : null;
      }
      
    });

  }

  Future<void> checkUser() async {

    return await ref.orderByChild("verification/verifiedId").equalTo(signIn.currentUser.id)
    .limitToFirst(1).once('value').then(
      (value) async {
        if(value.snapshot.val()==null) {
          await assignMember();
        }
      }
    );

  }

  Future<void> assignMember() async {
    
    await loadMembers();

    return showGeneralDialog(
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
                              "Select Your Name",
                              style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Colors.black,
                                decoration: TextDecoration.underline  
                              ),
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
                                    ref.child(memberToAssign.id).update({"verification": {'verifiedId': signIn.currentUser.id, 'email': signIn.currentUser.email}});
                                    Navigator.of(context).pop();
                                  } : null,
                                  child: Text("Submit"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    "Or Create Your Account",
                                    style: Theme.of(context).textTheme.headline4.copyWith(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline  
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () => createMember(),
                                  child: Text("Create Your Account"),
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

    CreateMemberPopup(
      context, setState, 
      (name, email, number, location, dob, tSize, isDirectoryMember) {
        memberToAssign = FamilyMember(name.text, email.text, location, dob);
        if(!isDirectoryMember) {
          memberToAssign.isDirectoryMember = false;
        }
        memberToAssign.tSize = tSize;
        memberToAssign.id = signIn.currentUser.id;
        memberToAssign.addPhone(number.text);
        memberToAssign.verification = Verification(signIn.currentUser.id, signIn.currentUser.email);
        ref.child(memberToAssign.id).set(FamilyMember.toMap(memberToAssign));
        setState(() {
          members.add(memberToAssign);
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    ).show();

  }

  void navigate(MenuPage page) {

    checkSize();

    Widget tempPage;
    String tempTitle;

    switch (page) {
      case MenuPage.Home:
          tempPage = HomePage(signIn, navigate);
          tempTitle = 'Home';
        break;
      case MenuPage.Directory: 
          tempPage = DirectoryPage();
          tempTitle = 'Directory';
        break;
      case MenuPage.Activities: 
        tempPage = ActivitiesPage(signIn);
        tempTitle = 'Activities Poll';
        break;
      case MenuPage.Registration: 
        tempPage = PaymentsPage(signIn);
        tempTitle = 'Registration';
        break;
      case MenuPage.FAQ: 
        tempPage = FaqPage();
        tempTitle = 'FAQS';
        break;
      default:
    }

    setState(() {
      pageBody = tempPage;
      pageTitle = tempTitle;
    });

  }

  Widget menu() {
    
    double padding;
    switch (getType(context)) {
      case ScreenType.Desktop:
        padding = 8;
        break;
      case ScreenType.Tablet:
        padding = 4;
        break;
      default:
        padding = 0;
    }

    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.all(padding),
            child: TextButton(
              child: Text('Home'),
              onPressed: () { navigate(MenuPage.Home); },
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(padding),
            child: TextButton(
              child: Text(getType(context) != ScreenType.Handset ?'Directory' : "Dir."),
              onPressed: () { navigate(MenuPage.Directory); }
            ),
          ),

          Padding(
            padding: EdgeInsets.all(padding),
            child: TextButton(
              child: Text(getType(context) != ScreenType.Handset ? 'Activites Poll' : "Act."),
              onPressed: () { navigate(MenuPage.Activities); },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(padding),
            child: TextButton(
              child: Text('Registration'),
              onPressed: () { navigate(MenuPage.Registration); },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(padding),
            child: TextButton(
              child: Text('FAQS'),
              onPressed: () { navigate(MenuPage.FAQ); },
            ),
          ),

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    checkSize();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "KC Teague Family Reunion 2022", 
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: titleSize
                    ),
                  ),
                  Text(
                    pageTitle, 
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: titleSize
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2, 
              child: Text(
                displayName, 
                overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: titleSize
                ),
              )
            )
          ],
        ),
      ),
      body: Column(
        children: [
          menu(), 
          Expanded(child: pageBody)
        ],
      )
    );
  }

}