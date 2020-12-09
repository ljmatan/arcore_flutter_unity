import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:io' as io;
import 'bottom_bar/bottom_bar.dart';
import 'effects/flash_effect.dart';

class ARCore extends StatefulWidget {
  @override
  _ARCoreState createState() => _ARCoreState();
}

class _ARCoreState extends State<ARCore> {
  /// Required by the Unity plugin.
  UnityWidgetController _unityWidgetController;

  /// Provides access to BottomBar state.
  final GlobalKey<BottomBarState> _bottomBarKey = GlobalKey();

  /// Callback that connects the created controller to the unity controller,
  /// then displays the bottom button bar.
  ///
  /// Required by the Unity plugin.
  void _onUnityCreated(controller) {
    this._unityWidgetController = controller;
    _bottomBarKey.currentState.showBottomBar();
  }

  /// Communication from Flutter to Unity. Unity C# functions with one optional
  /// parameter are called using this function.
  ///
  /// ARCore Device is the "main" GameObject in the Unity scene, active throughout
  /// the runtime. Most of the custom C# scripts in this project are attached to it.
  void _callUnityFunction(String function, [String parameter = '']) =>
      _unityWidgetController.postMessage('ARCore Device', function, parameter);

  /// Latest file saved to persistentAppData.
  String _latestFile;

  /// Copy file from persistentAppData to gallery and delete the original data.
  Future<void> _moveFile(String filePath) async {
    // Fallback
    if (_latestFile != filePath) {
      _latestFile = filePath;

      // File from persistentAppData folder
      final io.File sourceFile = io.File(filePath);

      // Android device gallery folder name
      final String galleryFolder = '/storage/emulated/0/DCIM/GoVirol/';

      // Filename displayed in the gallery
      final String newFilename =
          DateTime.now().toIso8601String() + '.' + filePath.split('.').last;

      try {
        // Create gallery folder if it doesn't exist
        await io.Directory(galleryFolder).create();

        // Copy file to the gallery folder
        await sourceFile.copy(galleryFolder + newFilename);

        // Delete the file from persistentAppData
        await sourceFile.delete();

        // Refresh Android gallery so the new file is visible
        _callUnityFunction('RefreshGallery', galleryFolder + newFilename);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File not processed: ' + e.toString())),
        );

        throw e;
      }
    }
  }

  /// Communication from Unity to Flutter. A message object is passed from Unity
  /// using the UnityMessageManager.
  void _onUnityMessage(msg) {
    final String message = msg.toString();

    // If a file had been successfully saved into the persistentAppData folder.
    if (message.contains('.jpg') ||
        message.contains('.gif') ||
        message.contains('.mp4')) _moveFile(message);
  }

  /// Model currently in the scene.
  String _currentModel;

  /// Display model into a current Unity scene.
  ///
  /// Sets active state of 3D models attached to FaceAttachment GameObject.
  void _displayModel(String model) => _callUnityFunction('DisplayModel', model);

  /// Remove current model from the Unity scene.
  ///
  /// Sets active state of 3D models attached to FaceAttachment GameObject.
  void _removeModel() => _callUnityFunction('RemoveModel', _currentModel);

  /// Change ARCore face filter. Updates the face texture, and removes and / or
  /// displays an overlaying 3D model.
  void _changeFilter(String textureName, [String model]) {
    // Changes texture displayed over the face mesh.
    _callUnityFunction('ChangeFilter', textureName);

    // If a 3D filter model is selected and there is no 3D model currently displayed
    if (model != null && _currentModel == null) {
      _currentModel = model;
      _displayModel(model);

      // If a 3D filter model is selected and a 3D model is currently displayed
    } else if (model != null && _currentModel != null) {
      _removeModel();
      _currentModel = model;
      _displayModel(model);

      // If no model had been selected and a 3D model is currently displayed
    } else if (_currentModel != null && model == null) {
      _removeModel();
      _currentModel = null;
    }
  }

  /// Provides access to the front flash effect state.
  GlobalKey<FlashEffectState> _flashKey = GlobalKey();

  /// Take a photo and store it into the persistentAppData folder.
  /// Flutter is notified of this event via _onUnityMessage listener.
  void _takePhoto() => _callUnityFunction('NewPhoto');

  /// Change between front and back camera. Back camera does not support AR features.
  void _changeCamera() => _callUnityFunction('ChangeCamera');

  /// Starts GIF recording.
  ///
  /// Uses proprietary software.
  void _startGIFRecording() => _callUnityFunction('StartGIFRecording');

  /// Stops GIF recording and saves the data to the persistentAppData folder.
  /// Flutter is notified of this event via _onUnityMessage listener.
  ///
  /// Uses proprietary software.
  void _stopGIFRecording() => _callUnityFunction('StopGIFRecording');

  /// Starts video recording.
  ///
  /// Uses proprietary software.
  void _startVideoRecording() => _callUnityFunction('StartVideoRecording');

  /// Stops video recording and saves the data to the persistentAppData folder.
  /// Flutter is notified of this event via _onUnityMessage listener.
  ///
  /// Uses proprietary software.
  void _stopVideoRecording() => _callUnityFunction('StopVideoRecording');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Unity screen
            UnityWidget(
              isARScene: true,
              onUnityCreated: _onUnityCreated,
              onUnityMessage: _onUnityMessage,
            ),
            // Close button
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Bottom button bar
            BottomBar(
              key: _bottomBarKey,
              changeFilter: _changeFilter,
              takePhoto: _takePhoto,
              changeCamera: _changeCamera,
              startGIFRecording: _startGIFRecording,
              stopGIFRecording: _stopGIFRecording,
              startVideoRecording: _startVideoRecording,
              stopVideoRecording: _stopVideoRecording,
            ),
            // Flash effect
            FlashEffect(key: _flashKey),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Stop recording if in progress
    _stopGIFRecording();
    _stopVideoRecording();

    // '00' is the name of a transparent image texture
    // This function removes any visible filter
    _changeFilter('00');

    // Dispose resources
    _unityWidgetController.dispose();
    super.dispose();
  }
}
