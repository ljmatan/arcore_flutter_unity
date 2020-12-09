using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEditor;
using UnityEngine.Android;

public class PhotoCapture : MonoBehaviour
{
    public static PhotoCapture instance;

    void Awake() 
    {
        instance = this;
    }

    // Get necessary permissions
    void Start() 
    {
        if (!Permission.HasUserAuthorizedPermission(Permission.ExternalStorageRead))
            Permission.RequestUserPermission(Permission.ExternalStorageRead);
        if (!Permission.HasUserAuthorizedPermission(Permission.ExternalStorageWrite))
            Permission.RequestUserPermission(Permission.ExternalStorageWrite);
        if (!Permission.HasUserAuthorizedPermission(Permission.Microphone))
            Permission.RequestUserPermission(Permission.Microphone);
    }

    public IEnumerator Wait(float delay)
	{
		float pauseTarget = Time.realtimeSinceStartup + delay;
		
		while(Time.realtimeSinceStartup < pauseTarget)
		{
			yield return null;	
		}
	}

	public static event Action<Texture2D> OnScreenshotTaken;

    public Rect screenArea = default(Rect);

    public IEnumerator CaptureScreen() 
    {    
        // Wait for screen rendering to complete
        yield return new WaitForEndOfFrame();

		if(screenArea == default(Rect))
			screenArea = new Rect(0, 0, Screen.width, Screen.height);

        Texture2D texture = new Texture2D ((int)screenArea.width, (int)screenArea.height, TextureFormat.RGB24, false);
		texture.ReadPixels (screenArea, 0, 0);
		texture.Apply ();
		
		byte[] bytes;
		string fileExt;

		bytes = texture.EncodeToJPG();
		fileExt = ".jpg";

		if (OnScreenshotTaken != null)
			OnScreenshotTaken (texture);
		else
			Destroy (texture);
		
		string date = System.DateTime.Now.ToString("o");
		string screenshotFilename = date + fileExt;
		string path = Application.persistentDataPath + "/" + screenshotFilename;

		string androidPath = Path.Combine("GoVirol", screenshotFilename);
		path = Path.Combine(Application.persistentDataPath, androidPath);
		string pathonly = Path.GetDirectoryName(path);
		Directory.CreateDirectory(pathonly);

		System.IO.File.WriteAllBytes(path, bytes);

		UnityMessageManager.Instance.SendMessageToFlutter(path);
    }

    public void NewPhoto() 
    {
        instance.StartCoroutine(instance.CaptureScreen());
    }
}
