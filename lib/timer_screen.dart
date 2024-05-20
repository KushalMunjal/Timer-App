import 'dart:async';
import 'package:flutter/material.dart';
import 'counter_down.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration duration = Duration();
  Timer? timer;
  List<String> lapTimes = []; // List to store lap times
  bool stopped = true;
  bool isTimerPaused = false;

  void initState() {
    super.initState();
  }

  void startTimer() {
    if (isTimerPaused) {
      isTimerPaused = false;
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        addTime();
        setState(() {});
      });
    }
    stopped = false;
  }

  void stopTimer() {
    timer?.cancel();
    stopped = true;
    isTimerPaused = false;
    setState(() {});
  }

  void pauseTimer() {
  if (!stopped) {
    if (isTimerPaused) {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        addTime();
        setState(() {});
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
    lapTimes.clear();
    duration = Duration();
    setState(() {});
  }

  void addTime() {
    duration = Duration(seconds: duration.inSeconds + 1);
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    String hr = twoDigits(duration.inHours);
    String min = twoDigits(duration.inMinutes.remainder(60));
    String sec = twoDigits(duration.inSeconds.remainder(60));

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
              ElevatedButton(
                onPressed: stopped ? startTimer : stopTimer,
                child: Text(stopped ? 'START' : 'STOP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pauseTimer,
                child: Text(isTimerPaused ? 'RESUME' : 'PAUSE'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add current time to lapTimes list
                  String lapTime = '$hr:$min:$sec';
                  lapTimes.add(lapTime);
                  setState(() {});
                },
                child: Text('LAP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text('RESET'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: lapTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Lap ${index + 1}: ${lapTimes[index]}'),
                );
              },
            ),
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
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CounterDown(); // Navigate to the new screen
            }));
          }
        },
  ),

    );
  }
}

Widget digitDisplay(String val) {
  return Container(
    alignment: Alignment.center,
    height: 100,
    width: 100,
    decoration: BoxDecoration(
        color: Colors.purple, borderRadius: BorderRadius.circular(20)),
    child: Text(
      val,
      style: TextStyle(
        fontSize: 60,
        color: Colors.white,
      ),
    ),
  );
}
