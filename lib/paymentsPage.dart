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

  double size = 18;
  double padding = 4;

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
  
  void checkSize() {

    double tempSize;
    double tempPadding;
    switch (getType(context)) {
      case ScreenType.Desktop:
        tempSize = 22;
        tempPadding = 6;
        break;
      case ScreenType.Tablet:
        tempSize = 18;
        tempPadding = 4;
        break;
      default:
        tempSize = 13;
        tempPadding = 2;
    }

    setState(() {
      padding = tempPadding;
      size = tempSize;
    });

  }

  Future<void> closeDialog(FamilyMember hoh) async {
      
      Text responseMessage;

      if(!hoh.assessmentStatus.created) {
        
        try{

          Invoice invoice = await paypal.createAssessmentInvoice(hoh, items);

          responseMessage = Text("Invoice successfully sent to: " + hoh.email);
          
          hoh.assessmentStatus.created = true;
          hoh.assessmentStatus.invoiceId = invoice.id;
          hoh.assessmentStatus.invoice = invoice;
          hoh.assessmentStatus.position = AssessmentPosition.Hoh;
          setState(() {
            itemList = invoice.items.createItemList();
            paymentList = invoice.payments;
            totalPaid = invoice.totalPaid;
            totalAmt = invoice.amt;
          });
          
          ref.child(hoh.id).update({'assessmentStatus': AssessmentStatus.toMap(hoh.assessmentStatus)});
          
          items.assessments.forEach((member) {
            if(member.id != hoh.id) {
              member.assessmentStatus.created = true;
              member.assessmentStatus.invoiceId = invoice.id;
              member.assessmentStatus.invoice = invoice;
              member.assessmentStatus.position = AssessmentPosition.Participant;
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
          await paypal.modifyAssessmentInvoice(context, hoh, items);
          hoh.assessmentStatus.invoice.items.assessments.forEach((member) {
            if(!items.assessments.contains(member)) {
              ref.child(member.id).update({'assessmentStatus': {'created': false}});
            }
          });
          items.assessments.forEach((member) {
            if(member.id != hoh.id) {
              member.assessmentStatus.created = true;
              member.assessmentStatus.invoiceId = current.assessmentStatus.invoice.id;
              member.assessmentStatus.invoice = current.assessmentStatus.invoice;
              member.assessmentStatus.position = AssessmentPosition.Participant;
              ref.child(member.id).update({'assessmentStatus': AssessmentStatus.toMap(member.assessmentStatus)});
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
              id = e.key;
              return e.value['verification'] != null && e.value['verification']['verifiedId']==signIn.currentUser.id;
            }
          ).value
        );
        current.id = id;

        if(current.assessmentStatus.created) {
          current.assessmentStatus.invoice = await paypal.loadInvoice(current.assessmentStatus.invoiceId);
        }

        setState(() {
          choices.add(current);
          selected[current] = true;
          items.addMember(current);
        });

        for (var child in query.snapshot.val().entries) {
          if((child.value['verification'] == null) || (child.value['verification']['verifiedId'] != signIn.currentUser.id)) {
            FamilyMember member = await FamilyMember.toMember(child.value);
            member.id = child.key;
            bool contained = current.assessmentStatus.created ? current.assessmentStatus.invoice.items.assessments.contains(member) : false;
            setState(() {
              if(!member.assessmentStatus.created || contained) {
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
          padding: EdgeInsets.all(padding + 3),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(padding + 1),
                child: Text(                
                  "Please 'Create A Family Member' For Each Person Attending the Reunion.\nThis Will Add Them To Your Registration. If you are only registering yourself, click submit below.",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: size + 3,
                    color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Text(                
                  "** Once All Are Created, Click Submit Below To Create An Invoice **",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: size
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
                padding: EdgeInsets.all(padding + 2),
                child: ElevatedButton(
                  onPressed: () => showCreateMembers(setstate2),
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
                      padding: EdgeInsets.all(padding - 1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: MyBullet(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CheckboxListTile(
                                  title: Text(
                                    searchResults.elementAt(index).displayInfo(), 
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size,
                                      decoration: TextDecoration.none
                                    ),
                                  ), 
                                  value: selected[searchResults.elementAt(index)],
                                  onChanged: (boolVal) {
                                    if(choices.elementAt(index) != current) {
                                      setstate2(() {
                                        selected[choices.elementAt(index)] = boolVal;
                                      });
                                      if(boolVal) {
                                        items.addMember(searchResults.elementAt(index));
                                      }
                                      else {
                                        items.removeMember(searchResults.elementAt(index));
                                      }
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
                padding: EdgeInsets.only(top: padding + 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SelectableText("Total: \$${items.getTotal().toStringAsFixed(2)}",
                        style: TextStyle(fontSize: size + 2, fontWeight: FontWeight.bold),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: padding + 2),
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
                        child: Text("Submit")
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

        Widget modifyButton = ElevatedButton(
          onPressed: () => modifyItems(),
          child: Text("Modify Registration")
        );
        Widget tooltipButton = Tooltip(
          message: "Only the Head of Household is able to modify the registration",
          child: ElevatedButton(
            onPressed: null,
            child: Text("Modify Registration"),
          ),
        );

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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(                
                                  "If You Would Like To Add/Remove More Family Members, Click Modify",
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                    color: Colors.black,
                                    decoration: TextDecoration.none
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Row(
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
                                child: current.assessmentStatus.position == AssessmentPosition.Hoh ? modifyButton : tooltipButton
                              )
                            ],
                          ),
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
      items = InvoiceItems.clone(current.assessmentStatus.invoice.items);
      pageBody = showPurchasePage;
    });

  }

  void showCreateMembers(Function setState2) {

    CreateMemberPopup(context, setState2, (name, email, number, location, dob, tSize, isDirectoryMember) {
      List<FamilyMember> membersToAdd = [];
      membersToAdd.add(
        FamilyMember(name.text, email.text, location, dob)
      );
      membersToAdd.forEach(
        (member) {
          setState2(() {
            member.addPhone(number.text);
            member.tSize = tSize;
            if(!isDirectoryMember) {
              member.isDirectoryMember = false;
            }
            member.id = ref.push(FamilyMember.toMap(member)).key;
            choices.add(member);
            items.addMember(member);
            selected[member] = true;
          });
        }
      );
      Navigator.of(context).pop();
    }).show();

  }

  @override
  Widget build(BuildContext context) {
    checkSize();
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