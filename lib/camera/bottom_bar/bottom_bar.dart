import 'package:arcore_flutter/camera/bottom_bar/filter_menu/filter_menu.dart';
import 'package:arcore_flutter/camera/bottom_bar/recording/countdown.dart';
import 'package:arcore_flutter/camera/bottom_bar/recording/gif_button.dart';
import 'package:arcore_flutter/camera/bottom_bar/stop_recording_button.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final Function(String, [String]) changeFilter;
  final Function takePhoto,
      changeCamera,
      startGIFRecording,
      stopGIFRecording,
      startVideoRecording,
      stopVideoRecording;

  BottomBar({
    Key key,
    @required this.changeFilter,
    @required this.takePhoto,
    @required this.changeCamera,
    @required this.startGIFRecording,
    @required this.stopGIFRecording,
    @required this.startVideoRecording,
    @required this.stopVideoRecording,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomBarState();
  }
}

class BottomBarState extends State<BottomBar> {
  bool _bottomBarVisible = false;

  void showBottomBar() => setState(() => _bottomBarVisible = true);

  bool _filtersVisible = false;

  final GlobalKey<FilterMenuState> _filterMenuKey =
      GlobalKey<FilterMenuState>();

  bool _gifMode = false;
  bool _recordingMode = false;
  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _bottomBarVisible ? 1 : 0,
      duration: const Duration(seconds: 3),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black38,
                    Colors.black12.withOpacity(0),
                  ],
                ),
              ),
              child: SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilterMenu(
                _filterMenuKey,
                changeFilter: widget.changeFilter,
              ),
              SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 64,
                          child: IconButton(
                            icon: Icon(_gifMode ? Icons.camera_alt : Icons.gif),
                            onPressed: () {
                              setState(
                                () {
                                  if (_gifMode)
                                    widget.stopGIFRecording();
                                  else {
                                    if (_recording) {
                                      widget.stopVideoRecording();
                                      _recording = false;
                                    }
                                    if (_recordingMode) _recordingMode = false;
                                  }
                                  _gifMode = !_gifMode;
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.emoji_emotions),
                              onPressed: () => _filtersVisible
                                  ? {
                                      _filtersVisible = false,
                                      _filterMenuKey.currentState.hide(),
                                    }
                                  : {
                                      _filtersVisible = true,
                                      _filterMenuKey.currentState.show(),
                                    },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Stack(
                                children: [
                                  if (_recordingMode)
                                    SizedBox(
                                      width: 64,
                                      child: Center(
                                        child: Countdown(
                                          recording: _recording,
                                          stopVideoRecording:
                                              widget.stopVideoRecording,
                                        ),
                                      ),
                                    ),
                                  GestureDetector(
                                    child: _gifMode
                                        ? GIFRecordButton(
                                            startGIFRecording:
                                                widget.startGIFRecording,
                                          )
                                        : _recording
                                            ? StopRecordingButton()
                                            : Icon(
                                                Icons.panorama_fish_eye,
                                                color: _recordingMode &&
                                                        !_recording
                                                    ? Colors.red.shade300
                                                    : Colors.white,
                                                size: 64,
                                              ),
                                    onTap: () {
                                      if (_recordingMode && !_recording) {
                                        widget.startVideoRecording();
                                        setState(() => _recording = true);
                                      } else if (_recordingMode && _recording) {
                                        setState(() => _recording = false);
                                        widget.stopVideoRecording();
                                      } else {
                                        widget.takePhoto();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_rear),
                              onPressed: () => widget.changeCamera(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 64,
                          child: IconButton(
                            icon: Icon(
                              _recordingMode
                                  ? Icons.camera_alt
                                  : Icons.videocam,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_recording) {
                                  widget.stopVideoRecording();
                                  _recording = false;
                                } else if (_gifMode) {
                                  widget.stopGIFRecording();
                                  _gifMode = false;
                                }
                                _recordingMode = !_recordingMode;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
