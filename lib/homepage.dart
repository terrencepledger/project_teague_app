import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_teague_app/Objects.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project_teague_app/infoPages.dart';
import 'package:project_teague_app/signIn.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  
  List<Widget> items = [];
  CarouselController sliderController = CarouselController();

  @override
  void initState() { 
    super.initState();
    setState(() {
      items.addAll([
        CarouselItem(OverviewSlide(), sliderController),
        CarouselItem(HotelSlide(), sliderController),
        CarouselItem(FittedBox(child: Text("Intro Text x3")), sliderController)
      ]);    
    }); 
  }

  void showPurchaseDialog() async {
    
    List<FamilyMember> selected = [];
    List<MultiSelectItem<FamilyMember>> choices = [
      MultiSelectItem(FamilyMember("A", "a@a.com", "KCK", 10), "A"),MultiSelectItem(FamilyMember("B", "b@a.com", "KCK", 32), "B"),
      MultiSelectItem(FamilyMember("C", "c@a.com", "KCK", 15), "C"),
    ];
    
    void showCreateMembers() {

      List<TextEditingController> names = [];
      List<TextEditingController> emails = [];
      List<TextEditingController> locations = [];
      List<TextEditingController> ages = [];
      
      Row inputRow() { 
        names.add(TextEditingController());
        emails.add(TextEditingController());
        locations.add(TextEditingController());
        ages.add(TextEditingController());
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
                  controller: ages.last,
                  style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Age"
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
                            locations.elementAt(i).text.isNotEmpty && ages.elementAt(i).text.isNotEmpty
                          ) {
                            membersToAdd.add(
                              FamilyMember(names.elementAt(i).text, emails.elementAt(i).text,
                                locations.elementAt(i).text, int.parse(ages.elementAt(i).text)
                              )
                            );
                          }
                        }
                        setState(() {
                          choices.addAll(membersToAdd.map((e) => MultiSelectItem(e, e.displayInfo())).toList());
                        });
                        Navigator.of(context).pop();
                      }, child: Text("Submit")),
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
                              child: Text("Create Members")
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
                                        title: Text("Select Members"),
                                        items: choices,
                                        onConfirm: (items) {
                                          updateMembers(items);
                                        },
                                      ),
                                      selected.length == 0 ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("No Members Selected",
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
                                              child: Text(selected.elementAt(index).displayInfo(), style: Theme.of(context).textTheme.headline5,),
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
                                  child: ElevatedButton(onPressed: () {}, child: Text("Purchase")),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Total: \$${(selected.length * 3).toStringAsFixed(2)}")
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

    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            items: items,
            carouselController: sliderController,
            options: CarouselOptions(
              aspectRatio: 13/7,
              enlargeCenterPage: true,
              viewportFraction: 1,
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showPurchaseDialog();
                }, 
                child: Text("Purchase Tickets!", 
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        )
      ],
    );

  }

}