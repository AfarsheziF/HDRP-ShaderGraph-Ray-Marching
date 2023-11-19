#ifndef SHAPESRAYMARCHER_INCLUDE
#define SHAPESRAYMARCHER_INCLUDE

//

#include "./Shaders/Geometry.cginc"
#include "./Shaders/Blends.cginc"

const int MaxShapesCount = 150; // For reference. Should match the count on the manager script.

float4 _ShapesPos[150];
float4 _ShapesScale[150];
float4 _ShapesRotation[150];
float4 _ShapesParams[150];
float _ShapesMagnitude[150];
float _ShapesTypes[150];
float _BlendType[150];
int _NumShapes;
float _Scale;
//float _Time;

float _mergeFactor;
float _maxDistance;

float GetSdShape(float type, float3 pos, float3 scale, float4 rotation, float4 params)
{
    float sdShape;
    if (type == 0)
    {
        sdShape = sdSphere(pos, 1 / scale);
    }
    else if (type == 1)
    {
        sdShape = sdBox(pos, 1 / scale);
    }
    else if (type == 2)
    {
        sdShape = sdTorus(pos, 1 / scale, rotation);
       
    }
    else if (type == 3)
    {
        sdShape = sdCutHollowSphere(pos, 1 / scale, rotation, params.x * .0001, params.y * .0005);
    }
    else
    {
        sdShape = sdSphere(pos, 1 / scale);
    }
    
    return sdShape;
}

float GetBlend(float p1, float p2, float type, float factor)
{
    float sd = smin(p1, p2, factor);
    if (type == 1)
    {
        sd = substruct(p1, p2);

    }
    else if (type == 2)
    {
        sd = intersect(p1, p2);
    }
    return sd;
}

float GetDist(float3 p)
{
    float containerScale = _Scale;
    float sd = _maxDistance;
    
    float3 pos = (p - _ShapesPos[0].xyz / containerScale);
    float3 sc = (1 / _ShapesScale[0] * (containerScale * 2));
    float shape = GetSdShape(_ShapesTypes[0], pos, sc, _ShapesRotation[0], _ShapesParams[0]);
    sd = smin(sd, shape, _mergeFactor * _ShapesMagnitude[0]);
     
    if (_NumShapes > 0)
    {
        for (int i = 1; i < _NumShapes; i++)
        {
            float3 sdPos = (p - _ShapesPos[i].xyz / containerScale);
            sc = 1 / _ShapesScale[i] * (containerScale * 2);
            shape = GetSdShape(_ShapesTypes[i], sdPos, sc, _ShapesRotation[i], _ShapesParams[i]);
            sd = GetBlend(sd, shape, _BlendType[i], _mergeFactor * _ShapesMagnitude[i]);
        }
    }
    return sd;
}

float RayMarch(
    float3 ro,
    float3 rd,
    float maxSamples,
    float maxDistance,
    float surfDistance)
{
    float dO = 0;
    float dS;
    
    for (int i = 0; i < maxSamples; i++)
    {
        float3 p = ro + dO * rd;
        dS = GetDist(p);
        dO += dS;
        if (dS < surfDistance || dO > maxDistance)
        {
            break;

        }
    }
    
    return dO;
}

float3 GetNormal(float3 p)
{
    float2 eps = float2(1e-2, 0);
    float3 n = GetDist(p) - float3(
        GetDist(p - eps.xyy),
        GetDist(p - eps.yxy),
        GetDist(p - eps.yyx)
    );
    return normalize(n);
}

void RayMarcher_float(
    float3 RayOrigin,
    float3 RayDirection,
    float maxSamples,
    float maxDistance,
    float surfDistance,
    float mergeFactor,
    out float alpha,
    out float3 p,
    out float3 normal
)
{
    _mergeFactor = mergeFactor;
    _maxDistance = maxDistance;
    
    alpha = 0;
    normal = 0;
 
    float d = RayMarch(RayOrigin, RayDirection, maxSamples, maxDistance, surfDistance);
    if (d < maxDistance)
    {
        p = RayOrigin + RayDirection * d; // hit point
        normal = GetNormal(p); // normal for hit point   
        alpha = d;
    }
    else
    {
        discard;
    }

}
#endif