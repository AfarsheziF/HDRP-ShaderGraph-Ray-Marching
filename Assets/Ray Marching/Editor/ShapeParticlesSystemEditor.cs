using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SdShapeParticleSystem))]
public class ShapeParticlesSystemEditor : Editor {
    public override void OnInspectorGUI() {
        base.OnInspectorGUI();

        SdShapeParticleSystem rayMarchManager = (SdShapeParticleSystem)target;

        if (GUILayout.Button("Create Particles")) {
            rayMarchManager.CreateGameObjects();
        }
    }
}
