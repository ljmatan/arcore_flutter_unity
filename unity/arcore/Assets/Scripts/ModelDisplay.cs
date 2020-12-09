using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelDisplay : MonoBehaviour
{
    public GameObject FaceAttachment;

    public void DisplayModel(string name)
    {
        FaceAttachment.transform.Find(name).gameObject.SetActive(true);
    }

    public void RemoveModel(string name)
    {
        FaceAttachment.transform.Find(name).gameObject.SetActive(false);
    }
}
