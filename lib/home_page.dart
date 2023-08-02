import 'dart:async';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double salary = 0.0;
  double hourlyRate = 0.0;
  double timerTime = 0.0;
  Timer? timer;
  bool isPaused = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!isPaused) {
        setState(() {
          timerTime++;
          salary += hourlyRate / 3600;
        });
      }
    });
    setState(() {
      isPaused = false;
    });
  }

  void _pauseTimer() {
    setState(() {
      isPaused = true;
    });
  }

  void _resetTimer() {
    setState(() {
      timerTime = 0.0;
      salary = 0.0;
      isPaused = true;
      timer?.cancel();
      timer = null;
    });
  }

  String _formatDuration(Duration duration) {
    final hh = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    // final ms = (duration.inMilliseconds % 60).toString().padLeft(2, '0');

    return '$hh:$mm:${ss}s'.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculator'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'You\'ve Earned:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              timerTime == 0.0
                  ? const Text('Enter Hourly Rate Below to Start')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                            'Time: ${_formatDuration(Duration(seconds: timerTime.toInt()))}'),
                        Text(
                          '£${salary.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    if (hasFocus) {
                      _focusNode.requestFocus();
                    } else {
                      _focusNode.unfocus();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: TextField(
                    enabled: timer == null,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      prefix: Text('£'),
                      hintText: '69',
                      labelText: 'Enter Hourly Rate...',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        hourlyRate = double.tryParse(value) ?? 0.0;
                        hourlyRate > 0 ? isPaused = true : isPaused = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _focusNode.hasFocus
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // PLAY Button
                FloatingActionButton(
                  onPressed: (hourlyRate > 0 && timer == null) || isPaused
                      ? _startTimer
                      : null,
                  backgroundColor: (hourlyRate > 0 && timer == null) || isPaused
                      ? Colors.blue
                      : Colors.grey,
                  child: const Icon(Icons.play_arrow),
                ),
                // PAUSE Button
                FloatingActionButton(
                  onPressed: timer != null && !isPaused ? _pauseTimer : null,
                  backgroundColor:
                      timer != null && !isPaused ? Colors.blue : Colors.grey,
                  child: const Icon(Icons.pause),
                ),
                // STOP Button
                FloatingActionButton(
                  onPressed: timer != null ? _resetTimer : null,
                  backgroundColor: timer != null ? Colors.blue : Colors.grey,
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
    );
  }
}
