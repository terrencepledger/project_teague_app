import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'Objects.dart';

class PollOptions extends StatefulWidget {

  String title;
  Activity value;
  _PollOptionsState x;

  PollOptions(this.title, this.value) {
    x = _PollOptionsState(title, value);
  }

  void setOnClick(Function func) {
    x.onClick = func;
  }

  @override
  _PollOptionsState createState() { 
    return x;
  }

}

class _PollOptionsState extends State<PollOptions> {
  
  String title;
  Activity value;
  Function onClick;
  double percentage = 1;
  bool isDisabled = false;
  Color buttonColor = Colors.blue;

  _PollOptionsState(this.title, this.value);

  void setOnClick(Function func) {
    onClick = func;
  }

  void update(double percent) {
    setState(() {
      percentage = percent;
    });
  }

  void disable() {
    setState(() {
      isDisabled = true;
    });
  }

  void enable() {
    setState(() {
      buttonColor = Colors.blue;
      isDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        onPressed: isDisabled ? null : () { onClick.call(); setState(() { isDisabled = true; buttonColor = Colors.green;});},
        child: LinearPercentIndicator(
          animation: true,
          lineHeight: 33.0,
          animationDuration: 0,
          percent: percentage,
          alignment: MainAxisAlignment.start,
          center: Align(alignment: Alignment.centerLeft, child: Text(title, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: buttonColor,
        ),
      ),
    );
  }

}

