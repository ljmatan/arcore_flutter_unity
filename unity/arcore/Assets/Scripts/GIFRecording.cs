using UnityEngine;
using NatSuite;
using NatSuite.Recorders;
using NatSuite.Recorders.Clocks;
using NatSuite.Recorders.Inputs;

public class GIFRecording : MonoBehaviour {    
    [Header("GIF Settings")]
    public int imageWidth;
    public int imageHeight;
    public float frameDuration = 0.1f; // seconds

    private GIFRecorder recorder;
    private CameraInput cameraInput;

    public void StartGIFRecording () {
        // Get screen size
        imageWidth = GetComponent<Camera>().pixelWidth;
        imageHeight = GetComponent<Camera>().pixelHeight;

        // Start recording
        recorder = new GIFRecorder(imageWidth, imageHeight, frameDuration);
        cameraInput = new CameraInput(recorder, new RealtimeClock(), Camera.main);

        // Get a real GIF look by skipping frames
        cameraInput.frameSkip = 4;
    }

    public async void StopGIFRecording () {
        // Stop the recording
        cameraInput.Dispose();
        var path = await recorder.FinishWriting();

        // Log path
        Debug.Log($"Saved animated GIF image to: {path}");

        // Send message to Flutter
		UnityMessageManager.Instance.SendMessageToFlutter(path);
    }
}