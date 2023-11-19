using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SdRayMarchManager : MonoBehaviour {

    const int maxShapesCount = 150;
    List<SdShape> sdShapes;

    public Material material;
    public bool debug;

    void Update() {
        DrawShapes();
    }

    public void DrawShapes() {
        sdShapes = new List<SdShape>(transform.GetComponentsInChildren<SdShape>());
        sdShapes = sdShapes.Where(shape =>
            shape.isActiveAndEnabled &&
            shape.transform.localScale.x > 0 &&
            shape.transform.localScale.y > 0 &&
            shape.transform.localScale.z > 0
            ).ToList();
        sdShapes = sdShapes.OrderByDescending((x) => x.blendType == SdFBlendType.Subtracion).ToList();
        if (sdShapes.Count > 0) {
            sdShapes.Reverse();
            Vector4[] _shapesPos = new Vector4[maxShapesCount];
            Vector4[] _ShapesScale = new Vector4[maxShapesCount];
            Vector4[] _ShapesRotation = new Vector4[maxShapesCount];
            Vector4[] _ShapesParams = new Vector4[maxShapesCount];
            float[] _ShapesMagnitude = new float[maxShapesCount];
            float[] _ShapesTypes = new float[maxShapesCount];
            float[] _BlendType = new float[maxShapesCount];

            for (var i = 0; i < sdShapes.Count; i++) {
                if (i < maxShapesCount) {
                    if (sdShapes[i].isParticleShape) {
                        _shapesPos[i] = sdShapes[i].transform.position;
                        _ShapesScale[i] = sdShapes[i].transform.localScale;
                    }
                    else {
                        _shapesPos[i] = sdShapes[i].transform.position - transform.position;
                        _ShapesScale[i] = Vector3.Scale(sdShapes[i].transform.localScale, transform.localScale);
                    }
                    _ShapesMagnitude[i] = sdShapes[i].transform.localScale.normalized.magnitude;
                    _ShapesRotation[i] = sdShapes[i].transform.rotation.eulerAngles;
                    _ShapesParams[i] = sdShapes[i].shapeParams;
                    _ShapesTypes[i] = ((float)sdShapes[i].shapeType);
                    _BlendType[i] = ((float)sdShapes[i].blendType);
                }
            };

            material.SetFloat("_Scale", transform.localScale.x);
            material.SetInt("_NumShapes", sdShapes.Count);
            material.SetVectorArray("_ShapesPos", _shapesPos);
            material.SetVectorArray("_ShapesScale", _ShapesScale);
            material.SetVectorArray("_ShapesRotation", _ShapesRotation);
            material.SetVectorArray("_ShapesParams", _ShapesParams);
            material.SetFloatArray("_ShapesMagnitude", _ShapesMagnitude);
            material.SetFloatArray("_ShapesTypes", _ShapesTypes);
            material.SetFloatArray("_BlendType", _BlendType);
        }
    }
    private void OnDrawGizmos() {
        if (debug) {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireCube(transform.position, transform.localScale);
        }
    }
}
