import 'package:flutter/material.dart';
import 'dart:async';
import 'timer_screen.dart';

class CounterDown extends StatefulWidget { 
  const CounterDown({Key? key}) : super(key: key);

  @override
  State<CounterDown> createState() => _CounterDownState(); 
}

class _CounterDownState extends State<CounterDown> { 
  Duration? duration;
  Timer? timer;
  bool isTimerRunning = false;
  bool isTimerPaused = false;

  void startTimer({required int hours, required int minutes, required int seconds}) {
    duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (duration!.inSeconds <= 0) {
        stopTimer();
        setState(() {});
      } else {
        duration = Duration(seconds: duration!.inSeconds - 1);
        setState(() {});
      }
    });
    isTimerRunning = true;
    isTimerPaused = false;
  }

  void stopTimer() {
    timer?.cancel();
    isTimerRunning = false;
    isTimerPaused = false;
    setState(() {
      
    });
  }

  void pauseResumeTimer() {
  if (isTimerRunning) {
    if (isTimerPaused) {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (duration!.inSeconds <= 0) {
          stopTimer();
          setState(() {});
        } else {
          duration = Duration(seconds: duration!.inSeconds - 1);
          setState(() {});
        }
      });
    } else {
      timer?.cancel();
    }
    isTimerPaused = !isTimerPaused;
    setState(() {});
  }
}

  void resetTimer() {
    stopTimer();
    duration = null;
    isTimerPaused = false;
  setState(() {});
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    String hr = duration == null ? "00" : twoDigits(duration!.inHours);
    String min = duration == null ? "00" : twoDigits(duration!.inMinutes.remainder(60));
    String sec = duration == null ? "00" : twoDigits(duration!.inSeconds.remainder(60));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 15,),
              Text(
                  "Hours :",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black, 
                  ),
                ),
              digitDisplay(hr),
               Text(
                  "Minutes :",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black, 
                  ),
                ),
              digitDisplay(min),
               Text(
                  "Seconds :",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black, 
                  ),
                ),
              digitDisplay(sec),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (!isTimerRunning) {
                        _showTimeInputDialog(context);
                      }
                    },
                    child: Text('START'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isTimerRunning ? stopTimer : () {},
                    child: Text('STOP'),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: isTimerRunning ? pauseResumeTimer : () {},
                    child: Text(isTimerPaused ? 'RESUME' : 'PAUSE'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: resetTimer,
                    child: Text('RESET'),
                  ),
                ],
              ),
            ],
            
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.timer),
        label: 'Timer',
      ),
      // Add more items as needed
      BottomNavigationBarItem(
        icon: Icon(Icons.refresh),
        label: 'Counter Down Timer',
      ),
    ],
    onTap: (int index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TimerScreen(); // Navigate to the new screen
            }));
          }
        },
  ),

    );
  }

  Widget digitDisplay(String val) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _showTimeInputDialog(BuildContext context) async {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Set Timer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              controller: hoursController,
              decoration: InputDecoration(labelText: 'Hours',hintText: 'Enter Value below 24'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: minutesController,
              decoration: InputDecoration(labelText: 'Minutes',hintText: 'Enter Value below 60'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: secondsController,
              decoration: InputDecoration(labelText: 'Seconds',hintText: 'Enter Value below 60'),
            ),
            if (hours > 23 || minutes > 59 || seconds > 59)
              Text(
                'Please enter values less than or equal to 23 hours, 59 minutes, and 59 seconds.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              hours = int.tryParse(hoursController.text) ?? 0;
              minutes = int.tryParse(minutesController.text) ?? 0;
              seconds = int.tryParse(secondsController.text) ?? 0;

              if (hours <= 23 && minutes <= 59 && seconds <= 59) {
                startTimer(hours: hours, minutes: minutes, seconds: seconds);
                Navigator.of(context).pop();
              } else {
                setState(() {});
              }
            },
            child: Text('Start'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
}
