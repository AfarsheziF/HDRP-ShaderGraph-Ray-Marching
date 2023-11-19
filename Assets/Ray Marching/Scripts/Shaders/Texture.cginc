//// Tri-Planar mapping
//float3 GetTex3D(UnityTexture2D tex, float3 p, float3 n)
//{
//    float3 blending = abs(n);
//    blending = normalize(max(blending, 0.00001));
    
//    // normalized total value to 1.0
//    float b = (blending.x + blending.y + blending.z);
//    blending /= b;
    
//    float4 xaxis = SAMPLE_TEXTURE2D(tex, p.yz);
//    float4 yaxis = SAMPLE_TEXTURE2D(tex, p.xz);
//    float4 zaxis = SAMPLE_TEXTURE2D(tex, p.xy);
    
//    // blend the results of the 3 planar projections.
//    return (xaxis * blending.x + yaxis * blending.y + zaxis * blending.z).rgb;
//}

float3 Triplanar(UnityTexture2D Texture, UnitySamplerState _sampler, float tiling)
{
    //Triplanar mapping
    float3 n = abs(normal);
    float powerValue = 20;
    n *= pow(n, float3(powerValue, powerValue, powerValue));
    n /= n.x + n.y + n.z;
        
    float3 xz = SAMPLE_TEXTURE2D(Texture, _sampler, p.xz * tiling + tiling).rgb;
    float3 yz = SAMPLE_TEXTURE2D(Texture, _sampler, p.yz * tiling + tiling).rgb;
    float3 xy = SAMPLE_TEXTURE2D(Texture, _sampler, p.xy * tiling + tiling).rgb;
        
    float3 col = yz * n.x + xz * n.y + xy * n.z;
    return col;
}