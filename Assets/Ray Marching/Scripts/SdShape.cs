using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class SdShape : MonoBehaviour {
    public SdShapeType shapeType;
    public SdFBlendType blendType;
    [SerializeField]
    public Vector4 shapeParams;
    [HideInInspector]
    public bool isParticleShape;
}

public enum SdShapeType { Sphere, Box, Torus, HollowSphere }
public enum SdFBlendType { Morph, Subtracion, Intersection }
