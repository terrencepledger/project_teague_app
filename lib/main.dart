import 'package:flutter/material.dart';
import 'package:project_teague_app/directorypage.dart';

import 'homepage.dart';

void main() {
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
  _AppState createState() => _AppState();
  
}

class _AppState extends State<App> {

  Widget pageBody = HomePage();
  Widget pageTitle = Text("Home");

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
              onPressed: () {
                setState(() {
                  pageBody = HomePage();
                  pageTitle = Text('Home');
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text('Directory'),
              onPressed: () {
                setState(() {
                  pageBody = DirectoryPage();
                  pageTitle = Text('Directory');
                });
              },
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
        title: Column(
          children: [
            Text("KC Teague Family Reunion 2022"),
            pageTitle
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