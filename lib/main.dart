import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:project_teague_app/activitiesPage.dart';
import 'package:project_teague_app/directorypage.dart';

import 'homepage.dart';
import 'signIn.dart';

void main() {
  initializeApp(
    apiKey: "AIzaSyBhlfX8XnrV7pWWt-aIvk9VPAboGmi-6nw",
    authDomain: "kcteaguesite.firebaseapp.com",
    databaseURL: "https://kcteaguesite-default-rtdb.firebaseio.com",
    projectId: "kcteaguesite",
    storageBucket: "kcteaguesite.appspot.com",
  );
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

  SignIn signIn;
  String displayName = "";

  Widget pageBody;
  Widget pageTitle;

  _AppState(SignIn signIn) {

    this.signIn = signIn;
    pageTitle = Text("Home", textAlign: TextAlign.left,);
    pageBody = HomePage(signIn, navigate);
    
    Function func = (String name) {
      setState(() {
        displayName = name;
      });
    };

    signIn.listener(func);

  }

  void navigate(int page) {

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