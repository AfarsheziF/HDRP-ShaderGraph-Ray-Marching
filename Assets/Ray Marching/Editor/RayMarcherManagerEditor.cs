using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SdRayMarchManager))]
public class RayMarcherManagerEditor : Editor {
    public override void OnInspectorGUI() {
        base.OnInspectorGUI();

        SdRayMarchManager rayMarchManager = (SdRayMarchManager)target;

        if (GUILayout.Button("Draw")) {
            rayMarchManager.DrawShapes();
        }
    }
}
