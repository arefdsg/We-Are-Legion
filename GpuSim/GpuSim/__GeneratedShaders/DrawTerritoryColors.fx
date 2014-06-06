// This file was auto-generated by FragSharp. It will be regenerated on the next compilation.
// Manual changes made will not persist and may cause incorrect behavior between compilations.

#define PIXEL_SHADER ps_3_0
#define VERTEX_SHADER vs_3_0

// Vertex shader data structure definition
struct VertexToPixel
{
    float4 Position   : POSITION0;
    float4 Color      : COLOR0;
    float2 TexCoords  : TEXCOORD0;
    float2 Position2D : TEXCOORD2;
};

// Fragment shader data structure definition
struct PixelToFrame
{
    float4 Color      : COLOR0;
};

// The following are variables used by the vertex shader (vertex parameters).
float4 vs_param_cameraPos;
float vs_param_cameraAspect;

// The following are variables used by the fragment shader (fragment parameters).
// Texture Sampler for fs_param_Path, using register location 1
float2 fs_param_Path_size;
float2 fs_param_Path_dxdy;

Texture fs_param_Path_Texture;
sampler fs_param_Path : register(s1) = sampler_state
{
    texture   = <fs_param_Path_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

float fs_param_blend;

// The following methods are included because they are referenced by the fragment shader.
float FragSharpFramework__FragSharpStd__min(float a, float b, float c)
{
    return min(min(a, b), c);
}

// Compiled vertex shader
VertexToPixel StandardVertexShader(float2 inPos : POSITION0, float2 inTexCoords : TEXCOORD0, float4 inColor : COLOR0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position.w = 1;
    Output.Position.x = (inPos.x - vs_param_cameraPos.x) / vs_param_cameraAspect * vs_param_cameraPos.z;
    Output.Position.y = (inPos.y - vs_param_cameraPos.y) * vs_param_cameraPos.w;
    Output.TexCoords = inTexCoords;
    Output.Color = inColor;
    return Output;
}

// Compiled fragment shader
PixelToFrame FragmentShader(VertexToPixel psin)
{
    PixelToFrame __FinalOutput = (PixelToFrame)0;
    float4 dist = tex2D(fs_param_Path, psin.TexCoords + (float2(0, 0)) * fs_param_Path_dxdy);
    float4 enemy_dist = float4(FragSharpFramework__FragSharpStd__min(dist.y, dist.z, dist.w), FragSharpFramework__FragSharpStd__min(dist.x, dist.z, dist.w), FragSharpFramework__FragSharpStd__min(dist.x, dist.y, dist.w), FragSharpFramework__FragSharpStd__min(dist.x, dist.y, dist.z));
    float4 clr = float4(0.0, 0.0, 0.0, 0.0);
    if (dist.x < 0.07843138 - .001 && dist.x < enemy_dist.x - .001)
    {
        clr = float4(0.7, 0.3, 0.3, 0.5);
    }
    if (dist.y < 0.07843138 - .001 && dist.y < enemy_dist.y - .001)
    {
        clr = float4(0.1, 0.5, 0.1, 0.5);
    }
    if (dist.z < 0.07843138 - .001 && dist.z < enemy_dist.z - .001)
    {
        clr = float4(0.3, 0.7, 0.55, 0.5);
    }
    if (dist.w < 0.07843138 - .001 && dist.w < enemy_dist.w - .001)
    {
        clr = float4(0.3, 0.3, 0.7, 0.5);
    }
    clr.a *= fs_param_blend;
    clr.rgb *= clr.a;
    __FinalOutput.Color = clr;
    return __FinalOutput;
}

// Shader compilation
technique Simplest
{
    pass Pass0
    {
        VertexShader = compile VERTEX_SHADER StandardVertexShader();
        PixelShader = compile PIXEL_SHADER FragmentShader();
    }
}