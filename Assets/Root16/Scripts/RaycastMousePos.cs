using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RaycastMousePos : MonoBehaviour
{
    private Camera _camera;
    private RaycastHit _hit;
    private Ray _ray;
    private Vector3 _mousePos, _smoothPoint;

    public float _radius, _softness, _smoothness, _scaleFactor;

    // Use this for initialization
    void Start ()
    {
        _camera = GetComponent<Camera>();
	}
	
	// Update is called once per frame
	void Update ()
    {
	    if(Input.GetKey(KeyCode.UpArrow))
        {
            _radius += _scaleFactor * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            _radius -= _scaleFactor * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            _softness += _scaleFactor * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            _softness -= _scaleFactor * Time.deltaTime;
        }

        Mathf.Clamp(_radius, 0.1f, 100);
        Mathf.Clamp(_softness, 0.1f, 100);

        _mousePos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0);
        _ray = _camera.ScreenPointToRay(_mousePos);

        if(Physics.Raycast(_ray, out _hit))
        {
            _smoothPoint = Vector3.MoveTowards(_smoothPoint, _hit.point, _smoothness * Time.deltaTime);
            Vector4 pos = new Vector4(_smoothPoint.x, _smoothPoint.y, _smoothPoint.z, 0);
            Shader.SetGlobalVector("GLOBALMASK_Position", pos);
        }

        Shader.SetGlobalFloat("GLOBALMASK_Radius", _radius);
        Shader.SetGlobalFloat("GLOBALMASK_Softness", _softness);

        Debug.Log("radius : " + _radius);
        Debug.Log("softness : " + _softness);
    }
}
 