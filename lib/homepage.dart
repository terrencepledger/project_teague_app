import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_teague_app/Objects.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project_teague_app/infoPages.dart';
import 'package:project_teague_app/signIn.dart';

class HomePage extends StatefulWidget {

  SignIn signIn;
  Function navigate;

  HomePage(this.signIn, this.navigate, { Key key });

  @override
  _HomePage createState() => _HomePage(signIn, navigate);

}

class _HomePage extends State<HomePage> {

  SignIn signIn;
  Function navigate;
  List<Widget> items = [];
  CarouselController sliderController = CarouselController();
  DatabaseReference ref;

  _HomePage(this.signIn, this.navigate);

  @override
  void initState() { 
    super.initState();

    Database db = database();
    ref = db.ref('users');

    setState(() {
      items.addAll([
        CarouselItem(OverviewSlide(), sliderController),
        CarouselItem(HotelSlide(), sliderController),
        CarouselItem(ActivitiesSlide(navigate), sliderController)
      ]);    
    }); 

  }

  void showPurchaseDialog() async {
    
    List<FamilyMember> selected = [];
    List<MultiSelectItem<FamilyMember>> choices = [
      MultiSelectItem(FamilyMember("A", "a@a.com", "KCK", "10"), "A"),MultiSelectItem(FamilyMember("B", "b@a.com", "KCK", "32"), "B"),
      MultiSelectItem(FamilyMember("C", "c@a.com", "KCK", "15"), "C"),
    ];
    
    void showCreateMembers() {

      List<TextEditingController> names = [];
      List<TextEditingController> emails = [];
      List<TextEditingController> locations = [];
      List<TextEditingController> dobs = [];
      
      Row inputRow() { 
        names.add(TextEditingController());
        emails.add(TextEditingController());
        locations.add(TextEditingController());
        dobs.add(TextEditingController());
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                child: TextFormField(
                  controller: locations.last,
                  style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                  decoration: InputDecoration(
                    labelText: "Location"
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: dobs.last,
                  style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Date of Birth"
                  ),
                ),
              ),
            ),
          ],
        );
      }

      List<Widget> inputRows = [inputRow()];

      showDialog(context: context, builder: 
        (buildContext) {
          return StatefulBuilder(builder: (context, setState) {
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
                            inputRows.add(inputRow());  
                          }
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(onPressed: () {
                        List<FamilyMember> membersToAdd = [];
                        for (var i = 0; i < names.length; i++) {
                          if(names.elementAt(i).text.isNotEmpty && emails.elementAt(i).text.isNotEmpty &&
                            locations.elementAt(i).text.isNotEmpty && dobs.elementAt(i).text.isNotEmpty
                          ) {
                            membersToAdd.add(
                              FamilyMember(names.elementAt(i).text, emails.elementAt(i).text,
                                locations.elementAt(i).text, dobs.elementAt(i).text
                              )
                            );
                          }
                        }
                        setState(() {
                          choices.addAll(membersToAdd.map((e) => MultiSelectItem(e, e.displayInfo())).toList());
                        });
                        Navigator.of(context).pop();
                      }, child: SelectableText("Submit")),
                    )
                  ]
                ),
              ),
            );
          });
        }  
      );

    }

    showDialog(context: context, 
      builder: (buildContext) {
        
        return StatefulBuilder(builder: (context, setState) {
          
          void updateMembers(List<FamilyMember> members) {
            
            setState(() {
              selected = members;
            });

          }
          
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                children: [Card(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(12, 12))),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => showCreateMembers(),
                              child: SelectableText("Create Members")
                            )
                          ], 
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue.withOpacity(.7),
                                    borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(.7),
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MultiSelectDialogField<FamilyMember>(
                                        selectedColor: Colors.white24,
                                        searchable: true,
                                        backgroundColor: Colors.lightBlue.withOpacity(0.85),
                                        chipDisplay: MultiSelectChipDisplay<FamilyMember>.none(),
                                        buttonText: Text("Click Here", style: Theme.of(context).textTheme.headline5,),
                                        title: SelectableText("Select Members"),
                                        items: choices,
                                        onConfirm: (items) {
                                          updateMembers(items);
                                        },
                                      ),
                                      selected.length == 0 ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SelectableText("No Members Selected",
                                              textAlign: TextAlign.left, 
                                              style: Theme.of(context).textTheme.headline5.merge(
                                                TextStyle(color: Colors.white, fontStyle: FontStyle.italic)
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: selected.length,
                                        itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            MyBullet(),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: SelectableText(selected.elementAt(index).displayInfo(), style: Theme.of(context).textTheme.headline5,),
                                            )
                                          ]
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(onPressed: () {}, child: SelectableText("Purchase")),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: SelectableText("Total: \$${(selected.length * 3).toStringAsFixed(2)}")
                                ),
                              ),
                            ]
                          )
                        ],
                      ),
                    )
                  ),
                )],
              ),
            ),
          );
        
        });
        
      }

    );

  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: CarouselSlider(
              items: items,
              carouselController: sliderController,
              options: CarouselOptions(
                aspectRatio: 15/7,
                enlargeCenterPage: true,
                viewportFraction: 1,
              )
            ),
          ),
        ],
      ),
    );

  }

}