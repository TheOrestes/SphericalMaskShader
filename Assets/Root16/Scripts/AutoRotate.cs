﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoRotate : MonoBehaviour
{
    public float speed = 10.0f;
	// Use this for initialization
	void Start ()
    {
		
	}
	
	// Update is called once per frame
	void Update ()
    {
        gameObject.transform.Rotate(Vector3.up, speed * Time.deltaTime);	
	}
}
