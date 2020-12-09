using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Android;
using NatSuite;
using NatSuite.Recorders;
using NatSuite.Recorders.Clocks;
using NatSuite.Recorders.Inputs;

public class VideoRecording : MonoBehaviour
{
    [Header(@"Recording")]
    public int videoWidth;
    public int videoHeight;
    public bool recordMicrophone;

    private IMediaRecorder recorder;
    private CameraInput cameraInput;
    private AudioInput audioInput;
    private AudioSource microphoneSource;

    private IEnumerator Start () {
        videoWidth = GetComponent<Camera>().pixelWidth;
        videoHeight = GetComponent<Camera>().pixelHeight;
        // Start microphone
        microphoneSource = gameObject.AddComponent<AudioSource>();
        microphoneSource.mute =
        microphoneSource.loop = true;
        microphoneSource.bypassEffects =
        microphoneSource.bypassListenerEffects = false;
        microphoneSource.clip = Microphone.Start(null, true, 10, AudioSettings.outputSampleRate);
        yield return new WaitUntil(() => Microphone.GetPosition(null) > 0);
        microphoneSource.Play();
    }

    private void OnDestroy () {
        // Stop microphone
        microphoneSource.Stop();
        Microphone.End(null);
    }

    public void StartVideoRecording () {
        // Start recording
        var frameRate = 30;
        var sampleRate = recordMicrophone ? AudioSettings.outputSampleRate : 0;
        var channelCount = recordMicrophone ? (int)AudioSettings.speakerMode : 0;
        var clock = new RealtimeClock();
        recorder = new MP4Recorder(videoWidth, videoHeight, frameRate, sampleRate, channelCount);
    
        // Create recording inputs
        cameraInput = new CameraInput(recorder, clock, Camera.main);
        audioInput = recordMicrophone ? new AudioInput(recorder, clock, microphoneSource, true) : null;

        // Unmute microphone
        microphoneSource.mute = audioInput == null;
    }

    public async void StopVideoRecording () {
        // Mute microphone
        microphoneSource.mute = true;
        // Stop recording
        audioInput?.Dispose();
        cameraInput.Dispose();
        var path = await recorder.FinishWriting();

        // Log event and send a message to Flutter
        Debug.Log($"Saved recording to: {path}");
		UnityMessageManager.Instance.SendMessageToFlutter(path);
    }
}
