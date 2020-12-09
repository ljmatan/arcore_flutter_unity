using UnityEngine;
using UnityEngine.EventSystems;
using System;
using System.Collections;
using System.Collections.Generic;

public class FilterChange : MonoBehaviour {
    private Texture2D texture;
    public GameObject FaceTexture;

    public void ChangeFilter(String message) 
    {
        texture = (Texture2D) Resources.Load ("texture_" + message);
        FaceTexture.GetComponent<Renderer>().material.mainTexture = texture;
    }
}