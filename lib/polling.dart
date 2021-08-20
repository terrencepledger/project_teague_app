import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Objects.dart';

class PollOptions extends StatefulWidget {

  String title;
  Activity value;
  _PollOptionsState x;
  double fontSize;
  double padding;

  PollOptions(this.title, this.fontSize, this.padding, this.value) {
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
    print(widget.fontSize);
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ).merge(ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(Size(0, 0)),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(0))
        )),
        onPressed: isDisabled ? null : () { onClick.call(); setState(() { isDisabled = true; buttonColor = Colors.green;});},
        child: LinearPercentIndicator(
          animation: true,
          lineHeight: widget.fontSize + 4,
          animationDuration: 0,
          percent: percentage,
          alignment: MainAxisAlignment.start,
          center: Align(alignment: Alignment.centerLeft, child: Text(title, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize),)),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: buttonColor,
        ),
      ),
    );
  }

}

