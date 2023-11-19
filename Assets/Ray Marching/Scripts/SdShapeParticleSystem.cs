using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

//[ExecuteAlways]
[ExecuteInEditMode]
public class SdShapeParticleSystem : MonoBehaviour {

    private int PARTICLES_SIZE;

    public ParticleSystem _particleSystem;
    ParticleSystem.Particle[] _particles;
    List<ParticleShape> particleShapes = new List<ParticleShape>();

    void Start() {
        CreateGameObjects();
    }

    void Update() {
        if (particleShapes.Count > 0) {
            int numParticlesAlive = _particleSystem.GetParticles(_particles);
            for (int i = 0; i < PARTICLES_SIZE; i++) {
                if (particleShapes[i].gameObject) {
                    if (i < numParticlesAlive) {
                        var particle = _particles[i];
                        particleShapes[i].gameObject.SetActive(true);
                        particleShapes[i].UpdateParticle(particle.position, particle.GetCurrentSize3D(_particleSystem));
                    }
                    else {
                        particleShapes[i].gameObject.SetActive(false);
                    }
                }
            }
        }
    }

    public void CreateGameObjects() {
        List<SdShape> shapes = new List<SdShape>(FindObjectsByType<SdShape>(FindObjectsInactive.Include, FindObjectsSortMode.InstanceID));
        shapes.ForEach((shape) => {
            if (shape.isParticleShape) {
                if (Application.isEditor) {
                    DestroyImmediate(shape.transform.gameObject);
                }
                else {
                    Destroy(shape.transform.gameObject);
                }
            }
        });
        particleShapes = new List<ParticleShape>();

        _particleSystem = GetComponent<ParticleSystem>();
        PARTICLES_SIZE = _particleSystem.main.maxParticles;
        _particles = new ParticleSystem.Particle[PARTICLES_SIZE];
        for (int i = 0; i < PARTICLES_SIZE; i++) {
            var particle = _particles[i];
            ParticleShape particleMesh = new ParticleShape(transform.TransformDirection(particle.position), particle.GetCurrentSize3D(_particleSystem), "ParticleSdShape", transform);
            particleShapes.Add(particleMesh);
        }
    }
}


class ParticleShape {
    public GameObject gameObject;

    public ParticleShape(Vector3 position, Vector3 size, string name, Transform transform) {
        gameObject = new GameObject(name);
        gameObject.transform.position = position;
        gameObject.transform.localScale = size;
        gameObject.transform.parent = transform;
        SdShape sdShape = gameObject.AddComponent<SdShape>();
        sdShape.blendType = SdFBlendType.Morph;
        sdShape.isParticleShape = true;
    }

    public void UpdateParticle(Vector3 position, Vector3 size) {
        gameObject.transform.position = position;
        gameObject.transform.localScale = size;
    }
}
