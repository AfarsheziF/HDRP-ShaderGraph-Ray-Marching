float2x2 GetRotationMatrix(float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    return float2x2(c, -s, s, c);
}

float3 Rotate(float3 p, float3 angle)
{
    p.yz = mul(p.yz, GetRotationMatrix(angle.x));
    p.xz = mul(p.xz, GetRotationMatrix(angle.y));
    p.xy = mul(p.xy, GetRotationMatrix(angle.z));
    return p;
}

float Sphere(float3 p, float4 sphere, float scale)
{
    //return length(p - sphere.xyz / scale) - sphere.w / (scale * 2);
    return length(p - sphere.xyz) - sphere.w;
}

float Capsule(float3 p, float3 a, float3 b, float r)
{
//    p = Rotate(p, rotation);
    
    float3 ab = b - a;
    float3 ap = p - a;
        
    float t = saturate(dot(ab, ap) / dot(ab, ab));
    
    float3 c = a + t * ab;
    return length(p - c) - r;
}

float Torus(float3 p, float3 position, float2 radius, float3 rotation)
{
    p -= position;
    p = Rotate(p, rotation);
    return length(float2(length(p.xz) - radius.x, p.y)) - radius.y;
}

//

float sdSphere(float3 p, float r)
{
    return length(p) - r;
}

float sdBox(float3 p, float3 b)
{
    float3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}
float sdTorus(float3 p, float2 radius, float3 rotation)
{
    //p -= position;
    p = Rotate(p, rotation);
    float2 q = float2(length(p.xz) - radius.x, p.y);
    return length(q) - radius.y;
}
float sdCutHollowSphere(float3 p, float r, float3 rotation, float height, float outRing)
{
    p = Rotate(p, rotation);
    
    // sampling independent computations (only depend on shape)
    float w = sqrt(r * r - height * height);
  
    // sampling dependant computations
    float2 q = float2(length(p.xz), p.y);
    return ((height * q.x < w * q.y) ? length(q - float2(w, height)) : abs(length(q) - r)) - outRing;
}