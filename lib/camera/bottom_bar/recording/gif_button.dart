import 'dart:async';
import 'package:flutter/material.dart';

class GIFRecordButton extends StatefulWidget {
  final Function startGIFRecording;

  GIFRecordButton({@required this.startGIFRecording});

  @override
  State<StatefulWidget> createState() {
    return _GIFRecordButtonState();
  }
}

class _GIFRecordButtonState extends State<GIFRecordButton> {
  int _value = 3500;

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: 64,
        width: 64,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(
            value: _value / 3500,
            valueColor: AlwaysStoppedAnimation(Colors.amber.shade300),
            strokeWidth: 5.5,
          ),
        ),
      ),
      onTap: _value != 3500
          ? null
          : () {
              widget.startGIFRecording();
              _timer = Timer.periodic(
                const Duration(milliseconds: 10),
                (timer) {
                  setState(() {
                    if (_value != 0)
                      _value -= 10;
                    else {
                      timer.cancel();
                      _value = 3500;
                    }
                  });
                },
              );
            },
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }
}
