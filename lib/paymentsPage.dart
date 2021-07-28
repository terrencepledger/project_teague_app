import 'dart:ui';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_panel/flutter_search_panel.dart';
import 'package:flutter_search_panel/search_item.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:intl/intl.dart';
import 'package:project_teague_app/paypal.dart';
import 'package:project_teague_app/signIn.dart';
import 'package:url_launcher/url_launcher.dart';
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
  DatabaseReference ref;

  Paypal paypal;

  bool purchased = false;

  InvoiceItems items = InvoiceItems();

  List<FamilyMember> choices = [];
  Map<FamilyMember, bool> selected = {};

  FamilyMember current;

  Widget pageBody = Container();
  Widget showPurchaseStatus;
  Widget showPurchasePage;

  List itemList = [];
  List<Payment> paymentList = [];
  double totalPaid = -1;
  double totalAmt = -1;

  TextEditingController searchController = TextEditingController();

  _PaymentsPage(SignIn signIn) {

    this.signIn = signIn;
    
  }

  @override
  void initState() { 
    super.initState();

    ref = database().ref('members');

    paypal = Paypal(context);

    loadMembers();

  }

  Future<bool> closeDialog(bool submitted, FamilyMember hoh) async {

      Navigator.of(context).pop();

      if(submitted) {
        
        Text responseMessage;

        try{

          Invoice invoice = await paypal.createInvoice(hoh, items);

          responseMessage = Text("Invoice successfully sent to: " + hoh.email);
          
          hoh.assessmentStatus.created = true;
          hoh.assessmentStatus.invoiceId = invoice.id;
          hoh.assessmentStatus.invoice = invoice;
          setState(() {
            current = hoh;
            itemList = invoice.items.createItemList();
            paymentList = invoice.payments;
            totalPaid = invoice.totalPaid;
            totalAmt = invoice.amt;
          });
          ref.child(hoh.id).set(FamilyMember.toMap(hoh));

          return true;
        
        } on PaypalError catch (e) {
        
          responseMessage = Text(
            "Unable to create and send invoice. Please note error code: ${e.code} - ${e.reason}, and contact Terrence Pledger for further assistance",
            style: TextStyle(
              color: Colors.red,
            ),
          );

        } finally {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: responseMessage, duration: Duration(seconds: 8),)
          );

        }

      }
      else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Purchase canceled, try again."), duration: Duration(seconds: 2),)
        );

        return false;

      }

    }

  void loadMembers() async {
    
    // setState(() {
    //   choices = [];
    //   selected = {};
    // });

    await ref.once('value').then((query) async {
      
      List temp = [];
      query.snapshot.forEach((child) {
        temp.add(child);
      }); 
      for (var item in temp) {
        FamilyMember member = await FamilyMember.toMember(item.val());
        member.id = item.key;
        setState(() {
          if(signIn.currentUser != null) {
            if(member.id == signIn.currentUser.id) {
              current = member;
            }
          }
          choices.add(member);
          selected[member] = false;
        });
      }

    });
    loadPage();

  }

  void loadPage() async {
    List searchResults = choices;
    showPurchasePage = StatefulBuilder(
      builder: (BuildContext context2, StateSetter setstate2) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setstate2(
                      () {
                        if(value.isEmpty) {
                          searchResults = choices;
                          return;
                        }
                        searchResults = choices.where((choice) => choice.displayInfo().toUpperCase().contains(value.toUpperCase())).toList();
                      }
                    );
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(.7),
                  borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
                  border: Border.all(
                    color: Colors.blue.withOpacity(.7),
                    width: 2,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context2, index) {
                    searchResults.sort((a, b) => a.name.split(" ").last.compareTo(b.name.split(' ').last));
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                child: CheckboxListTile(
                                  title: Text(searchResults.elementAt(index).displayInfo(), style: TextStyle(color: Colors.black),), 
                                  value: selected[searchResults.elementAt(index)],
                                  onChanged: (boolVal) {
                                    setstate2(() {
                                      selected[choices.elementAt(index)] = boolVal;
                                    });
                                    if(boolVal) {
                                      items.addMember(searchResults.elementAt(index));
                                    }
                                    else {
                                      items.removeMember(searchResults.elementAt(index));
                                    }
                                  },
                                )
                              ),
                            ),
                          ),
                        ]
                      ),
                    );
                  }
                )
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: choices.length,
                //   itemBuilder: (context2, index) {
                //     choices.sort((a, b) => a.name.split(" ").last.compareTo(b.name.split(' ').last));
                //     // if () {
                //     //   return Padding(
                //     //     padding: const EdgeInsets.all(8.0),
                //     //     child: Row(
                //     //       mainAxisSize: MainAxisSize.min,
                //     //       children: [
                //     //         Padding(
                //     //           padding: const EdgeInsets.all(8.0),
                //     //           child: MyBullet(),
                //     //         ),
                //     //         Expanded(
                //     //           child: Padding(
                //     //             padding: const EdgeInsets.all(8.0),
                //     //             child: Align(
                //     //               alignment: Alignment.centerLeft,
                //     //               child: CheckboxListTile(
                //     //                 title: Text(choices.elementAt(index).displayInfo(), style: TextStyle(color: Colors.black),), 
                //     //                 value: selected[choices.elementAt(index)],
                //     //                 onChanged: (boolVal) 
                //     //                 {
                //     //                   setstate2(() {
                //     //                     selected[choices.elementAt(index)] = boolVal;
                //     //                   });
                //     //                   if(boolVal) {
                //     //                     items.addMember(choices.elementAt(index));
                //     //                   }
                //     //                   else {
                //     //                     items.removeMember(choices.elementAt(index));
                //     //                   }
                //     //                 }
                //     //               )
                //     //             ),
                //     //           ),
                //     //         ),
                //     //       ]
                //     //     ),
                //     //   );
                //     // } 
                //     // else 
                //     if (searchController.text.isEmpty || choices[index].allInfo().toLowerCase()
                //       .contains(searchController.text.toLowerCase()) ||
                //       choices[index].allInfo().toLowerCase()
                //       .contains(searchController.text.toLowerCase())
                //     ) {
                      
                //     } else {
                //       return Container();
                //     }
                //   }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SelectableText("Total: \$${items.getTotal().toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          List<FamilyMember> selectedTrue = [];
                          selected.entries.where((member) => member.value).toList()
                            .forEach((element) {selectedTrue.add(element.key);});
                          FamilyMember hoh = selectedTrue.length > 0 ? selectedTrue.first : null;
                          showGeneralDialog(
                            context: context, 
                            barrierDismissible: false,
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondAnimation) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setstate23) {
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
                                                    "Select Head of Household family member that is making this purchase",
                                                    style: TextStyle(fontWeight: FontWeight.bold)
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: DropdownButton(
                                                        value: hoh,
                                                        dropdownColor: Colors.white,
                                                        style: TextStyle(color: Colors.black),
                                                        items: List.generate(choices.length, (index) {
                                                          return DropdownMenuItem<FamilyMember>(
                                                            value: choices.elementAt(index), 
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                choices.elementAt(index).name,
                                                                style: TextStyle(
                                                                  color: Colors.black
                                                                ),
                                                              ),
                                                            )
                                                          );
                                                        }),
                                                        onChanged: (member) {
                                                          setstate23(() {
                                                            hoh = member;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: ElevatedButton(
                                                        onPressed: selectedTrue.isNotEmpty ? () async {
                                                          if(await closeDialog(true, hoh)) {
                                                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                              setState(() {
                                                                purchased = true;
                                                                pageBody = showPurchaseStatus;
                                                              });
                                                            });
                                                            loadPage();
                                                          }
                                                        } : null,
                                                        child: Text("Submit"),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {closeDialog(false, hoh);}, 
                                                        child: Text("Cancel")
                                                      ),
                                                    )
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
                        }, 
                        child: Text("Purchase")
                      ),
                    )
                  ]
                ),
              )
            ],
          )
        );    
      }
    );
    
    showPurchaseStatus = StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Payment Status: $totalPaid/$totalAmt",
                style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.none
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Items",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Table(
                          defaultColumnWidth: FixedColumnWidth(200),
                          children: [ 
                            TableRow(
                              children: [
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold,)),
                                )),  
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold,)),
                                ))
                              ]
                            ),
                            ...
                            List.generate(itemList.length, 
                              (index) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                      itemList.elementAt(index)["description"].toString().split("2022 ").last,
                                      style: TextStyle(color: Colors.black),
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                      double.parse(itemList.elementAt(index)["unit_amount"]["value"].toString()).toStringAsFixed(2),
                                      style: TextStyle(color: Colors.black),
                                    )),
                                  ),
                                ]
                              )
                            )
                          ]
                        )
                      )
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Payments",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Table(
                          defaultColumnWidth: FixedColumnWidth(200),
                          children: [ 
                            TableRow(
                              children: [
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Payment ID", style: TextStyle(fontWeight: FontWeight.bold,)),
                                )), 
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold,)),
                                )), 
                                Center(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold,)),
                                ))
                              ]
                            ),
                            ...
                            List.generate(paymentList.length, 
                              (index) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(paymentList.elementAt(index).id)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(DateFormat("MM-dd-yyyy").format(paymentList.elementAt(index).date))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text("\$${paymentList.elementAt(index).amt.toStringAsFixed(2)}")),
                                  )
                                ]
                              )
                            )
                          ]
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: ElevatedButton(
                        onPressed: () {
                          launch(current.assessmentStatus.invoice.link.toString());
                        },
                        child: Text(
                          "Make Payment"
                        ) 
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if(signIn.currentUser != null) {
      if(current.assessmentStatus.created) {
        try {
          current.assessmentStatus.invoice = await paypal.loadInvoice(current.assessmentStatus.invoiceId);
          setState(() {
            itemList = current.assessmentStatus.invoice.items.createItemList();
            paymentList = current.assessmentStatus.invoice.payments;
            totalPaid = current.assessmentStatus.invoice.totalPaid;
            totalAmt = current.assessmentStatus.invoice.amt;
            pageBody = showPurchaseStatus;
          });
        } on PaypalError catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unable to load invoice: ${current.assessmentStatus.invoiceId}. Contact Terrence Pledger with code ${e.code} - ${e.reason}"))
          );
          setState(() {
            pageBody = showPurchasePage;
          });
        } 
      }
      else {
        setState(() {
          pageBody = showPurchasePage;
        });
      }
    }
    else {

      setState(() {
        
        pageBody = Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Card(
            child: Column(
              children: [
                SelectableText("Must sign in to your primary google account"),
                SignInButton(
                  Buttons.GoogleDark, onPressed: () async {
                    await signIn.handleSignIn();
                    if(signIn.currentUser != null) {
                      loadMembers();
                    }
                    else
                      print("else");
                  },
                )
              ]
            )
          ),
        );

      });

    }
  
  }

  void showCreateMembers() {

    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController number = TextEditingController();
    Location location = Location("", "");
    DateTime dob;

    bool valid() {

      if(name.text != null && email.text != null && location.state != null && location.city != null
        && number.text.length == 10 && dob != null
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
                                  setState(() {
                                    member.addPhone(number.text);
                                    member.id = ref.push(FamilyMember.toMap(member)).key;
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
            pageBody,
          ],
        ),
      )
    );

  }

}

class ListSearchDelegate extends SearchDelegate{

  List listItems;

  ListSearchDelegate(this.listItems, {Key key}): super();

  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    List subList;

    subList = query != '' ? listItems.where((item) => item.contains(query)).toList() : 
      listItems ;

    return ListView.builder(
        itemCount: subList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subList[index]),
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}