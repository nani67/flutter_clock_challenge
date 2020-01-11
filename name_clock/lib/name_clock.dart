import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'package:intl/intl.dart';


enum _Element {
  background,
  text,
  triangleOneColor,
  triangleOneTwentyDegreesColor,
  triangleOneThirtyDegreesColor,
  triangleOneFourtyDegreesColor,
  triangleTwoColor,
  triangleTwoTwentyDegreesColor,
  triangleTwoThirtyDegreesColor,
  triangleTwoFourtyDegreesColor,
  centerTriangleColorOne,
  centerTriangleColorTwo,
  hourTimingColor,
  minuteColorTiming,
}

//Light theme
final _lightTheme = {
  _Element.background: Color(0xFF987654),
  _Element.triangleOneColor: Color(0xFFEF5350),
  _Element.triangleOneTwentyDegreesColor: Color(0xFFAB47BC),
  _Element.triangleOneThirtyDegreesColor: Color(0xFF5C6BC0),
  _Element.triangleOneFourtyDegreesColor: Color(0xFF26C6DA),
  _Element.triangleTwoColor: Color(0xFFEC407A),
    _Element.triangleTwoTwentyDegreesColor: Color(0xFFD4E157),
  _Element.triangleTwoThirtyDegreesColor: Color(0xFF9CCC65),
  _Element.triangleTwoFourtyDegreesColor: Color(0xFF66BB6A),
  _Element.hourTimingColor: Color(0xFF1B5E20),
  _Element.minuteColorTiming: Color(0xFF1A237E),
  _Element.centerTriangleColorOne: Color(0xFFBA68C8),
  _Element.centerTriangleColorTwo: Color(0xFFFF7043),
};

//Dark theme
final _darkTheme = {
  _Element.background: Color(0xFF654321),
  _Element.triangleOneColor: Color(0xFFB71C1C),
  _Element.triangleOneTwentyDegreesColor: Color(0xFF4A148C),
  _Element.triangleOneThirtyDegreesColor: Color(0xFF1A237E),
  _Element.triangleOneFourtyDegreesColor: Color(0xFF006064),
  _Element.triangleTwoColor: Color(0xFF880E4F),
  _Element.triangleTwoTwentyDegreesColor: Color(0xFF827717),
  _Element.triangleTwoThirtyDegreesColor: Color(0xFF33691E),
  _Element.triangleTwoFourtyDegreesColor: Color(0xFF1B5E20),
  _Element.hourTimingColor: Colors.amber,
  _Element.minuteColorTiming: Color(0xFF4DD0E1),
  _Element.centerTriangleColorOne: Color(0xFF4A148C),
  _Element.centerTriangleColorTwo: Color(0xFFBF360C),

};

class NameClock extends StatefulWidget {
  const NameClock(this.model);
  final ClockModel model;
  @override
  NameClockState createState() => NameClockState();
}

class NameClockState extends State<NameClock> with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  //Creating a list of controllers for easier accessing of variables
  var controllersForSixTriangles = new List(6);

  @override
  void initState() {
    super.initState();

    //For each of the controller, we instantiate a AnimationController with different Duration
    controllersForSixTriangles[0] = new AnimationController(duration: new Duration(milliseconds: 500), vsync: this);
    controllersForSixTriangles[1] = new AnimationController(duration: new Duration(milliseconds: 600), vsync: this);
    controllersForSixTriangles[2] = new AnimationController(duration: new Duration(milliseconds: 700), vsync: this);
    controllersForSixTriangles[3] = new AnimationController(duration: new Duration(milliseconds: 800), vsync: this);
    controllersForSixTriangles[4] = new AnimationController(duration: new Duration(milliseconds: 900), vsync: this);
    controllersForSixTriangles[5] = new AnimationController(duration: new Duration(milliseconds: 1000), vsync: this);

    //Starting each AnimationController
    for(AnimationController animController in controllersForSixTriangles) {
      animController.addListener(() {
        setState(() {

        });
      });

      //Front and back transition for the triangles
      animController.repeat(reverse: true);
    }

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(NameClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {

    });
  }


  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 20;

    final defaultStyleForHourTime = TextStyle(
      color: colors[_Element.hourTimingColor],
      fontFamily: 'JosefinSans',
      fontSize: fontSize,
    );

    final defaultStyleForMinuteTime = TextStyle(
      color: colors[_Element.minuteColorTiming],
      fontFamily: 'JosefinSans',
      fontSize: fontSize,
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
          child: Stack(
            children: <Widget>[

              //1st triangle drawn at the back of all other triangles (left)
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: TriangleOne(colors[_Element.triangleOneColor]),
              ),

              //1st triangle drawn at the back of all other triangles (right)
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: TriangleTwo(colors[_Element.triangleTwoColor]),
              ),

              //Minute hand string's second number literal (considered as Character)
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                right: offset,
                top: 0,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(seconds: 1),
                  style: defaultStyleForMinuteTime,
                  child: Text(minute[1]),
                ),
              ),

              //Hour hand string's first number literal (considered as Character)
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                left: offset, top: 0,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(seconds: 1),
                  style: defaultStyleForHourTime,
                  child: Text(hour[0]),
                ),
              ),


              //All the other triangles show up within RotationTransition Widget

                RotationTransition(
                  turns: Tween(begin: 20/360, end: 15/360).animate(controllersForSixTriangles[0]),
                  alignment: FractionalOffset.bottomLeft,
                  child:
                  CustomPaint(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    painter: TriangleOne(colors[_Element.triangleOneTwentyDegreesColor]),
                  ),
                ),

              RotationTransition(
                turns: Tween(begin: 1 - 15/360, end: 1 - 20/360).animate(controllersForSixTriangles[1]),
                alignment: FractionalOffset.bottomRight,
                child:
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: TriangleTwo(colors[_Element.triangleTwoTwentyDegreesColor]),
                ),
              ),

              RotationTransition(
                turns: Tween(begin: 25/360, end: 30/360).animate(controllersForSixTriangles[2]),
                alignment: FractionalOffset.bottomLeft,
                child:
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: TriangleOne(colors[_Element.triangleOneThirtyDegreesColor]),
                ),
              ),

              RotationTransition(
                turns: Tween(begin: 1 - 30/360, end: 1 - 25/360).animate(controllersForSixTriangles[3]),
                alignment: FractionalOffset.bottomRight,
                child:
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: TriangleTwo(colors[_Element.triangleTwoThirtyDegreesColor]),
                ),
              ),

              RotationTransition(
                turns: Tween(begin: 40/360, end: 35/360).animate(controllersForSixTriangles[4]),
                alignment: FractionalOffset.bottomLeft,
                child:
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: TriangleOne(colors[_Element.triangleOneFourtyDegreesColor]),
                ),
              ),

              //Hour hand string's second number literal (considered as Character)
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: offset * offset / 1.8, left: offset * offset / 1.33,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(seconds: 1),
                  style: defaultStyleForHourTime,
                  child: Text(hour[1]),
                ),
              ),

              RotationTransition(
                turns: Tween(begin: 1 - 35/360, end: 1 - 40/360).animate(controllersForSixTriangles[5]),
                //turns: AlwaysStoppedAnimation(-40 / 360),
                alignment: FractionalOffset.bottomRight,
                child:
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: TriangleTwo(colors[_Element.triangleTwoFourtyDegreesColor]),
                ),
              ),

              //Center triangle which is back of the front triangle
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: CenterTriangleOne(colors[_Element.centerTriangleColorOne]),
              ),

              //Minute hand string's first number literal (considered as Character)
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: offset * offset / 1.8, right: offset * offset / 1.33,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(seconds: 1),
                  style: defaultStyleForMinuteTime,
                  child: Text(minute[0]),
                ),
              ),

              //Last triangle (front ones)
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: CenterTriangleTwo(colors[_Element.centerTriangleColorTwo]),
              ),

              //Weather based icons in the center of the screen (top of triangles)
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            getWeatherBasedicon(widget.model.weatherString),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),

              //Temperature
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child:
                        Image.asset(
                          "assets/temp.png",
                          width: MediaQuery.of(context).size.width / 20,
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child:
                        Text(
                          widget.model.temperatureString,
                          textScaleFactor: 1.2,
                        ),
                      ),
                    ],
                  ),


                  //Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child:
                        Image.asset(
                          "assets/loc_black.png",
                          width: MediaQuery.of(context).size.width / 20,
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child:
                        Text(widget.model.location,
                          textScaleFactor: 1.2,),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
      ),
    );
  }


  Widget getWeatherBasedicon(String string) {
    String thePath;
    switch(string) {
      case 'cloudy': thePath = "assets/cloudy.png"; break;
      case 'foggy': thePath = "assets/foggy.png"; break;
      case 'rainy': thePath = "assets/rainy.png"; break;
      case 'snowy': thePath = "assets/snowy.png"; break;
      case 'sunny': thePath = "assets/sunny.png"; break;
      case 'thunderstorm': thePath = "assets/thunder.png"; break;
      case 'windy': thePath = "assets/windy.png"; break;
      default: thePath = "assets/cloudy.png"; break;
    }
    return
      Image.asset(
        thePath,
        width: MediaQuery.of(context).size.width / 7,
        height: MediaQuery.of(context).size.height / 7,
      );
  }
}



class CenterTriangleOne extends CustomPainter {
  Color thisIsColor;

  CenterTriangleOne(Color color) {
    thisIsColor = color;
  }

  @override
  void paint(Canvas canvas, Size size) {

    final Paint paint = Paint();
    paint.color = thisIsColor;
    var traingleOne = Path();
    traingleOne.moveTo(size.width, size.height);
    traingleOne.lineTo(size.width/2, size.height/2);
    traingleOne.lineTo(0, size.height );
    traingleOne.close();

    canvas.drawPath(traingleOne, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

}




class CenterTriangleTwo extends CustomPainter {
  Color thisIsColor;

  CenterTriangleTwo(Color color) {
    thisIsColor = color;
  }

  @override
  void paint(Canvas canvas, Size size) {

    final Paint paint = Paint();
    paint.color = thisIsColor;
    var traingleOne = Path();
    traingleOne.moveTo(size.width, size.height);
    traingleOne.lineTo(size.width/2, size.height/1.5);
    traingleOne.lineTo(0, size.height );
    traingleOne.close();

    canvas.drawPath(traingleOne, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

}


class TriangleOne extends CustomPainter {
  Color triangleColor;

  TriangleOne(Color color) {
    triangleColor = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = triangleColor;
    var traingleOne = Path();
    traingleOne.lineTo(size.width / 2, 0);
    traingleOne.lineTo(0, size.height);
    traingleOne.close();

    canvas.drawPath(traingleOne, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class TriangleTwo extends CustomPainter {
  Color triangleColor;

  TriangleTwo(Color color) {
    triangleColor = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = triangleColor;
    var triangleTwo = Path();
    triangleTwo.moveTo(size.width / 2, 0);
    triangleTwo.lineTo(size.width, 0);
    triangleTwo.lineTo(size.width, size.height);
    triangleTwo.close();

    canvas.drawPath(triangleTwo, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}