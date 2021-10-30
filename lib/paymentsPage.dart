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

  Future<void> closeDialog(FamilyMember hoh) async {
      
      Text responseMessage;

      if(!hoh.assessmentStatus.created) {
        
        try{

          Invoice invoice = await paypal.createInvoice(hoh, items);

          responseMessage = Text("Invoice successfully sent to: " + hoh.email);
          
          hoh.assessmentStatus.created = true;
          hoh.assessmentStatus.invoiceId = invoice.id;
          hoh.assessmentStatus.invoice = invoice;
          hoh.assessmentStatus.position = AssessmentPosition.hoh;
          setState(() {
            itemList = invoice.items.createItemList();
            paymentList = invoice.payments;
            totalPaid = invoice.totalPaid;
            totalAmt = invoice.amt;
          });
          
          ref.child(hoh.id).set(FamilyMember.toMap(hoh));
          items.assessments.forEach((member) {
            if(member.id != hoh.id) {
              member.assessmentStatus.created = true;
              member.assessmentStatus.invoiceId = invoice.id;
              member.assessmentStatus.invoice = invoice;
              member.assessmentStatus.position = AssessmentPosition.participant;
              ref.child(member.id).set(FamilyMember.toMap(member));
            }
          });
        
        } on PaypalError catch (e) {
        
          responseMessage = Text(
            "Unable to create and send invoice. Please note error code: ${e.code} - ${e.reason}, and contact Terrence Pledger for further assistance",
            style: TextStyle(
              color: Colors.red,
            ),
          );

        }

      }
      else {
        
        try {
          await paypal.modifyInvoice(context, hoh, items);
          hoh.assessmentStatus.invoice.items.assessments.forEach((member) {
            if(!items.assessments.contains(member)) {
              ref.child(member.id).update({'assessmentStatus': {'created': false}});
            }
          });
          items.assessments.forEach((member) {
            print(hoh.id);
            print(member.id);
            if(member.id != hoh.id) {
              member.assessmentStatus.created = true;
              member.assessmentStatus.invoiceId = current.assessmentStatus.invoice.id;
              member.assessmentStatus.invoice = current.assessmentStatus.invoice;
              member.assessmentStatus.position = AssessmentPosition.participant;
              ref.child(member.id).set(FamilyMember.toMap(member));
            }
          });
          responseMessage = Text(
            "Successfully updated invoice!"
          );
        }
        on PaypalError catch (e) {
          responseMessage = Text(
            "Unable to modify and re-send invoice. Please note error code: ${e.code} - '${e.reason}' and contact Terrence Pledger for further assistance",
            style: TextStyle(
              color: Colors.red,
            ),
          );
        }

      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: responseMessage, duration: Duration(seconds: 15),)
      );

      return;

    }

  void loadMembers() async {
    
    if(signIn.currentUser != null) {
      
      setState(() {
        choices = [];
        selected = {};
      });

      await ref.once('value').then((query) async {
        
        String id;
        current = await FamilyMember.toMember(
          query.snapshot.val().entries.firstWhere(
            (e) {
              return e.value['verifiedId']==signIn.currentUser.id;
            }
          ).value
        );
        current.id = id;

        if(current.assessmentStatus.created) {
          current.assessmentStatus.invoice = await paypal.loadInvoice(current.assessmentStatus.invoiceId);
        }

        setState(() {
          choices.add(current);
          selected[current] = current.assessmentStatus.created;
        });

        for (var child in query.snapshot.val().entries) {
          if(child.value['verifiedId'] != signIn.currentUser.id) {
            FamilyMember member = await FamilyMember.toMember(child.value);
            member.id = child.key;
            bool contained = current.assessmentStatus.created ? current.assessmentStatus.invoice.items.assessments.contains(member) : false;
            print(items.createItemList());
            print(member.name + " : " + contained.toString());
            setState(() {
              if(!member.assessmentStatus.created || contained) {
                print("inside");
                choices.add(member);
                selected[member] = contained;
              }
            });
          }
        }
      
      });

    }

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
                padding: EdgeInsets.all(6),
                child: Text(                
                  "Select All Family Members Below That Need to Register For the Reunion",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Text(                
                  "** If Someone Is Missing, Click the Create Button to Make Their Account **",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.black,
                    decoration: TextDecoration.none
                  ),
                  textAlign: TextAlign.center,
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
                    searchResults.sort((a, b) => a.name.compareTo(b.name));
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
                                  title: Text(
                                    searchResults.elementAt(index).displayInfo(), 
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none
                                    ),
                                  ), 
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
                        onPressed: () async {
                          
                          bool confirmed;
                            
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("AlertDialog"),
                                content: Text(
                                  "Confirm you would like to create an invoice with the selections?",
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed:  () {
                                      confirmed = false;
                                      Navigator.of(context).pop();
                                    } 
                                  ),
                                  TextButton(
                                    child: Text("Confirm"),
                                    onPressed:  () {
                                      confirmed = true;
                                      Navigator.of(context).pop();
                                    }
                                  )
                                ],
                              );
                            },
                          );

                          if(confirmed) {
                            await closeDialog(current);
                          }
                          loadPage();
                          // showGeneralDialog(
                          //   context: context, 
                          //   barrierDismissible: false,
                          //   pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondAnimation) {
                          //     return StatefulBuilder(
                          //       builder: (BuildContext context, StateSetter setstate23) {
                          //         return Center(
                          //           child: Wrap(
                          //             children: [
                          //               Card(
                          //                 color: Colors.lightBlueAccent,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.all(8.0),
                          //                   child: Column(
                          //                     mainAxisSize: MainAxisSize.min,
                          //                     mainAxisAlignment: MainAxisAlignment.center,
                          //                     children: [
                          //                       Padding(
                          //                         padding: const EdgeInsets.all(20.0),
                          //                         child: Text(
                          //                           "Select Head of Household for This Purchase",
                          //                           style: TextStyle(fontWeight: FontWeight.bold)
                          //                         ),
                          //                       ),
                          //                       Padding(
                          //                         padding: const EdgeInsets.all(8.0),
                          //                         child: Container(
                          //                           color: Colors.white,
                          //                           child: Padding(
                          //                             padding: const EdgeInsets.all(15.0),
                          //                             child: DropdownButton(
                          //                               value: hoh,
                          //                               dropdownColor: Colors.white,
                          //                               style: TextStyle(color: Colors.black),
                          //                               items: List.generate(choices.length, (index) {
                          //                                 return DropdownMenuItem<FamilyMember>(
                          //                                   value: choices.elementAt(index), 
                          //                                   child: Padding(
                          //                                     padding: const EdgeInsets.all(8.0),
                          //                                     child: Text(
                          //                                       choices.elementAt(index).name,
                          //                                       style: TextStyle(
                          //                                         color: Colors.black
                          //                                       ),
                          //                                     ),
                          //                                   )
                          //                                 );
                          //                               }),
                          //                               onChanged: (member) {
                          //                                 setstate23(() {
                          //                                   hoh = member;
                          //                                 });
                          //                               },
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment: MainAxisAlignment.center,
                          //                         mainAxisSize: MainAxisSize.min,
                          //                         children: [
                          //                           Padding(
                          //                             padding: const EdgeInsets.all(8.0),
                          //                             child: ElevatedButton(
                          //                               onPressed: selectedTrue.isNotEmpty ? () async {
                          //                                 if(await closeDialog(true, hoh)) {
                          //                                   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          //                                     setState(() {
                          //                                       purchased = true;                                      
                          //                                     });
                          //                                   });
                          //                                   loadPage();
                          //                                 }
                          //                               } : null,
                          //                               child: Text("Submit"),
                          //                             ),
                          //                           ),
                          //                           Padding(
                          //                             padding: const EdgeInsets.all(8.0),
                          //                             child: ElevatedButton(
                          //                               onPressed: () {closeDialog(false, hoh);}, 
                          //                               child: Text("Cancel")
                          //                             ),
                          //                           )
                          //                         ],
                          //                       )
                          //                     ],
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         );
                          //       } 
                          //     );
                          //   }
                          // );
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
                "Payment Status: \$$totalPaid/\$$totalAmt",
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
                                      "\$" + double.parse(itemList.elementAt(index)["unit_amount"]["value"].toString()).toStringAsFixed(2),
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
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                launch(current.assessmentStatus.invoice.link.toString());
                              },
                              child: Text(
                                "Make Payment"
                              ) 
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                modifyItems();
                              },
                              child: Text("Modify Items")
                            ),
                          )
                        ],
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

  void modifyItems() async {

    current.assessmentStatus.invoice.items.assessments.forEach(
      (member) {
        setState(() {
          selected[member] = true;
        });
      }
    );

    setState(() {
      items = current.assessmentStatus.invoice.items;
      pageBody = showPurchasePage;
    });

  }

  void showCreateMembers() {

    CreateMemberPopup(context, setState, (name, email, number, location, dob, tSize) {
      List<FamilyMember> membersToAdd = [];
      membersToAdd.add(
        FamilyMember(name.text, email.text, location, dob)
      );
      membersToAdd.forEach(
        (member) {
          setState(() {
            member.addPhone(number.text);
            member.id = ref.push(FamilyMember.toMap(member)).key;
            member.tSize = tSize;
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