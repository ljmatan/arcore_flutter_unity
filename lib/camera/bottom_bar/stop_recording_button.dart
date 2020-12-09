import 'dart:async';
import 'package:flutter/material.dart';

class StopRecordingButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StopRecordingButtonState();
  }
}

class _StopRecordingButtonState extends State<StopRecordingButton> {
  Timer _timer;

  bool _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _visible = !_visible),
    );
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _visible = !_visible),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: Icon(
        Icons.panorama_fish_eye,
        color: Colors.white,
        size: 64,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
