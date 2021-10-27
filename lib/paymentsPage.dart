import 'dart:ui';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

          return false;

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
    
    setState(() {
      choices = [];
      selected = {};
    });

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
            if(item.val()["verifiedId"] == signIn.currentUser.id) {
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
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(                
                  "Select Users to Add to Assessment",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.black
                  )
                ),
              ),
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
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: MyBullet(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
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
                                                    "Select Head of Household for This Purchase",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText("Must sign in to your primary google account"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.GoogleDark, onPressed: () async {
                      await signIn.handleSignIn();
                      if(signIn.currentUser != null) {
                        loadMembers();
                      }
                    },
                  ),
                )
              ]
            )
          ),
        );

      });

    }
  
  }

  void showCreateMembers() {

    CreateMemberPopup(context, setState, (name, email, number, location, dob) {
      List<FamilyMember> membersToAdd = [];
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
    }).show();

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