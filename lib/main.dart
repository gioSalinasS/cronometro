import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  // const TimerScreen({super.key});
  
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true,
      appBar: widget.mode == WearMode.active ? AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.watch_later_outlined,size: 17,),
            SizedBox(width: 5,),
            Text("Cronómetro",style: TextStyle(fontSize: 17)),
          ],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 17
        ),
        shadowColor: Colors.black,
        elevation: 25,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 8,
            style: BorderStyle.solid
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(300, 150)
          ),
        ),
      ):null,
      //backgroundColor: widget.mode == WearMode.active ? Colors.white : Colors.black,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
          gradient: widget.mode == WearMode.active
              ? const LinearGradient(
                  colors: [Colors.white,Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(165, 72, 64, 64)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*const Center(
                child: FlutterLogo(),
              ),*/
              Center(
                child: widget.mode == WearMode.active ? null :Text(
                  "Giovanni",
                  style: TextStyle(
                    fontSize: 10,
                      color: widget.mode == WearMode.active
                          ? Colors.black
                          : Colors.white),
                ),
              ),
              Center(
                child: Text(
                  _strCount,
                  style: TextStyle(
                    fontSize: 30,
                      color: widget.mode == WearMode.active
                          ? Colors.black
                          : Colors.white),
                ),
              ),
              _buildWidgetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == WearMode.active) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),topRight: Radius.circular(50)),
                  side: BorderSide(
                    width: 5,
                    color: Color.fromARGB(255, 197, 116, 240),
                    style: BorderStyle.solid
                  ),
                ),
              ),
            ),
            // color: Colors.blue,
            // textColor: Colors.white,
            onPressed: () {
              if (_status == "Start") {
                _startTimer();
              } else if (_status == "Stop") {
                _timer.cancel();
                setState(() {
                  _status = "Continue";
                });
              } else if (_status == "Continue") {
                _startTimer();
              }
            },
            child: _status == "Start" ? Icon(Icons.play_arrow):Icon(Icons.pause),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),topRight: Radius.circular(50)),
                  side: BorderSide(
                    width: 5,
                    color: Color.fromARGB(255, 197, 116, 240),
                    style: BorderStyle.solid
                  ),
                ),
              ),
            ),
            // color: Colors.blue,
            // textColor: Colors.white,
            onPressed: () {
              // ignore: unnecessary_null_comparison
              if (_timer != null) {
                _timer.cancel();
                setState(() {
                  _count = 0;
                  _strCount = "00:00:00";
                  _status = "Start";
                });
              }
            },
            child: const Icon(Icons.restore),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}