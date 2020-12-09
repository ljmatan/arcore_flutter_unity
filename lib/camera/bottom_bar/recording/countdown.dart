import 'dart:async';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final bool recording;
  final Function stopVideoRecording;

  Countdown({
    @required this.recording,
    @required this.stopVideoRecording,
  });

  @override
  State<StatefulWidget> createState() {
    return _CountdownState();
  }
}

class _CountdownState extends State<Countdown> {
  int _timeRemaining = 60;

  Timer _timer;

  void _setTimer() => _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(
            () {
              _timeRemaining--;
              if (_timeRemaining == 0) {
                _timeRemaining = 60;
                timer.cancel();
                widget.stopVideoRecording();
                _timer = null;
              }
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    if (widget.recording && _timer == null)
      _setTimer();
    else if (!widget.recording && _timer != null && _timer.isActive) {
      _timer.cancel();
      _timeRemaining = 60;
    }
    return Text(
      _timeRemaining.toString() + 's',
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w200,
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }
}
