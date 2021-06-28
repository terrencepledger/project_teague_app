
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:project_teague_app/polling.dart';
import 'package:project_teague_app/signIn.dart';

class ActivitiesPage extends StatefulWidget {

  SignIn signIn;

  ActivitiesPage(SignIn signIn, { Key key })
  {
    this.signIn = signIn;
  }

  @override
  _ActivitiesPage createState() => _ActivitiesPage(signIn);

}

class _ActivitiesPage extends State<ActivitiesPage> {

  SignIn signIn;
  DatabaseReference ref;

  List<PollOptions> items = [
    PollOptions('Riverwalk Boat Ride', Activity.Riverwalk),
    PollOptions('Almao Tour', Activity.Alamo),
    PollOptions('Six Flags', Activity.SixFlags),
    PollOptions('Sea World', Activity.SeaWorld),
    PollOptions('Natural Bridge Caverns', Activity.Caverns),
    PollOptions('San Antonio Zoo', Activity.Zoo),
    PollOptions('Double Decker Bus Tour', Activity.Bus),
    PollOptions('San Marcos Outlet', Activity.Shopping),
    PollOptions("Ripley's Believe It or Not", Activity.Ripleys),
    PollOptions('Splashtown Waterpark', Activity.Splashtown),
    PollOptions('Extreme Escape', Activity.Escape),
  ];

  _ActivitiesPage(SignIn signIn) {

    this.signIn = signIn;
    
  }

  Widget poll() {

    Widget x = Container();

    Widget show() {
      final pollKey = GlobalKey<PollState>();
      return StatefulBuilder(builder: (context2, setState) {
          
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Poll(
                key: pollKey,
                items: items,
                owner: "117585163810491599357",
                userId: signIn.currentUser.id
              ),
            ],
          ),
        );

      });
    }

    if(signIn.currentUser != null)
    {
      x = show();
    }
    else {
      x = Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Card(
          child: Column(
            children: [
              SelectableText("Must sign in to your primary google account"),
              SignInButton(
                Buttons.GoogleDark, onPressed: () async {
                  await signIn.handleSignIn();
                  if(signIn.currentUser != null) {
                    setState(() {
                      x = show(); 
                    });
                  }
                },
              )
            ]
          )
        ),
      );
    }

    return x;

  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8, bottom: 8),
                child: SelectableText(
                  "There are a lot of FUN things to do in San Antonio and we've compiled a list of activities. "
                  + "Please note all prices listed are the current 2021 prices and are SUBJECT TO CHANGE for 2022. "
                  + "Since this is our FAMILY REUNION, and we'd be able to get group rate discounts, we would like to do some of the activities as a group. "
                  + "With that in mind we are asking everyone to select their top (4) choices and the ones with the most votes will be the activities we do as a group."
                  + " Select from the following list, and then click the submit button below to view the results.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              poll()
            ],
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );

  }

}

class Poll extends StatefulWidget {

  List<PollOptions> items;
  String owner;
  String userId;
  
  Poll({this.items, this.owner, this.userId, Key key}) : super(key: key);

  @override
  State<Poll> createState() => PollState(items, owner, userId);

}

class PollState extends State<Poll> {

  DatabaseReference ref;

  String owner;
  String userId;
  List<PollOptions> items;
  List selection = [];
  int max = 4;

  PollState(this.items, this.owner, this.userId) {
    this.items = items;
    ref = database().ref('results');
    ref.once('value').then(
      (query) {
        if(query.snapshot.val()[userId] != null) {updateData();}
      }
    );
    initItems();
  }

  void update(List<PollOptions> items) {
    setState(() {
      this.items = items;
      initItems();
    });
  }

  void updateData() {

    print("HELLO");
    Map<Activity, int> data = Map.fromIterable(Activity.values,
      key: (activity) => activity,
      value: (activity) => 0
    );
    int total;

    ref.once('value').then((query){
      query.snapshot.forEach( (child) {
        (child.val() as List).forEach( (val) {
          Activity activity = Activity.values.elementAt(val);
          data[activity]+=1; 
        });
      });
      total = query.snapshot.numChildren();
      items.forEach((item) {
        double updated = data[item.value] / total;
        item.x.update(updated);
      });
    });

  }

  void initItems() {
    items.forEach(
      (item) {
        item.setOnClick(
          () {
            setState(() {
              selection.add(item.value.index);
            });
            if(selection.length == max) {
              items.forEach((ele) { ele.x.disable(); });
            }
          }
        );
      }
    );
  }

  void submit() {

    ref.child(userId).set(selection);

    updateData();

    reset();

  }

  void reset() {

    items.forEach((element) {element.x.enable();});
    setState(() {
      selection = [];  
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: List.generate(
              items.length, (index) => items.elementAt(index)
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Row(
              children: [
                Spacer(),
                Expanded(child: SizedBox(height: 50, child: ElevatedButton(onPressed: selection.length == 0 ? null : () {submit();}, child: Text("Submit")))),
                Spacer(),
                Expanded(child: SizedBox(height: 50, child: ElevatedButton(onPressed: selection.length == 0 ? null : () {reset();}, child: Text("Reset")))),
                Spacer()
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          )
        ],
      ),
    );
  }

}