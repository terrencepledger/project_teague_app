import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Objects.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();

}

class _FaqPageState extends State<FaqPage> {

  double padding;
  double fontSize;
  
  List<FAQ> questions; 

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() {

    questions = [
      FAQ(
        "How do I register?", 
        "To begin, head to the registration page and follow the instructions there."
      ),
      FAQ(
        "How much is an assessment?",
        "The assessment is \$100 for ages 12 and up, \$30 for ages 4 - 11. Ages 3 and under are free, but still must be registered if you want to purchase a T-Shirt for them." 
      ),
      FAQ(
        "How do I purchase a T-Shirt?",
        "T-Shirts are included with paid assessment. " + 
        "If you would like to order an extra T-Shirt, head to the home page and navigate through the arrows to find the T-Shirt Order Form."
      )
    ];

  }

  void checkSize() {

    double tempSize;
    double tempPadding;
    switch (getType(context)) {
      case ScreenType.Desktop:
        tempSize = 25;
        tempPadding = 8;
        break;
      case ScreenType.Tablet:
        tempSize = 20;
        tempPadding = 6;
        break;
      default:
        tempSize = 15;
        tempPadding = 3;
    }

    setState(() {
      padding = tempPadding;
      fontSize = tempSize;
    });

  }

  @override
  Widget build(BuildContext context) {
    checkSize();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Frequently Asked Questions",
              style: Theme.of(context).textTheme.headline4
                      .copyWith(color: Colors.black),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Table(
                  children: [
                    TableRow(
                      children: getType(context) == ScreenType.Handset ? 
                      [
                        Container(), 
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: SelectableText(
                            "Question", 
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: fontSize
                            ),
                          ),
                        ), 
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: SelectableText(
                            "Answer", 
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: fontSize
                            ),
                          ),
                        ),
                      ] : 
                      [
                        Container(), 
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: SelectableText(
                            "Question", 
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: fontSize
                            ),
                          ),
                        ), 
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: SelectableText(
                            "Answer", 
                            style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: fontSize
                            ),
                          ),
                        ),
                        Container()
                      ]
                    ),
                    ...                
                    List.generate(
                      questions.length,
                      (index) {
                        return getType(context) != ScreenType.Handset ? TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(padding * 2),
                              child: MyBullet(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(padding),
                              child: SelectableText(questions.elementAt(index).question, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                            ),
                            Padding(
                              padding: EdgeInsets.all(padding),
                              child: SelectableText(questions.elementAt(index).answer, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                            ),
                            Container()
                          ]
                        ) : TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(padding * 2),
                              child: MyBullet(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(padding),
                              child: SelectableText(questions.elementAt(index).question, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                            ),
                            Padding(
                              padding: EdgeInsets.all(padding),
                              child: SelectableText(questions.elementAt(index).answer, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: fontSize),),
                            ),  
                          ]
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}