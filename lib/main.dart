import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(AdvancedTimerApp());
}

class AdvancedTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Timer App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TimerHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerHomePage extends StatefulWidget {
  @override
  _TimerHomePageState createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage>
    with SingleTickerProviderStateMixin {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isCountdown = false;
  int _countdownSeconds = 10; // Default countdown
  int _remainingSeconds = 10;
  TextEditingController _controller = TextEditingController(text: "10");

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 100), (_) {
        setState(() {});
      });
    }
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {});
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {});
  }

  void _startCountdown() {
    int? inputSeconds = int.tryParse(_controller.text);
    if (inputSeconds == null || inputSeconds <= 0) return;

    _countdownSeconds = inputSeconds;
    _remainingSeconds = _countdownSeconds;

    _timer?.cancel();
    _isCountdown = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _isCountdown = false;
        }
      });
    });
  }

  void _resetCountdown() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _countdownSeconds;
      _isCountdown = false;
    });
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }

  @override
  Widget build(BuildContext context) {
    double progress = _isCountdown
        ? _remainingSeconds / (_countdownSeconds > 0 ? _countdownSeconds : 1)
        : _stopwatch.isRunning
        ? (_stopwatch.elapsedMilliseconds % 60000) / 60000
        : 0;

    String displayTime = _isCountdown
        ? "${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}"
        : _formatTime(_stopwatch.elapsedMilliseconds);

    return Scaffold(
      appBar: AppBar(title: Text("Advanced Timer App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Text(
                  displayTime,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _isCountdown ? "Countdown Timer" : "Stopwatch",
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Countdown seconds",
                ),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isCountdown ? null : _startStopwatch,
                  child: Text("Start Stopwatch"),
                ),
                ElevatedButton(
                  onPressed: _isCountdown ? null : _stopStopwatch,
                  child: Text("Stop Stopwatch"),
                ),
                ElevatedButton(
                  onPressed: _isCountdown ? null : _resetStopwatch,
                  child: Text("Reset Stopwatch"),
                ),
                ElevatedButton(
                  onPressed: _startCountdown,
                  child: Text("Start Countdown"),
                ),
                ElevatedButton(
                  onPressed: _resetCountdown,
                  child: Text("Reset Countdown"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
