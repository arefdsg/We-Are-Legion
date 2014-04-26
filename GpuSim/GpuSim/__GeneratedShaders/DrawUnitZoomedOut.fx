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
// Texture Sampler for fs_param_Current, using register location 1
float2 fs_param_Current_size;
float2 fs_param_Current_dxdy;

Texture fs_param_Current_Texture;
sampler fs_param_Current : register(s1) = sampler_state
{
    texture   = <fs_param_Current_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Previous, using register location 2
float2 fs_param_Previous_size;
float2 fs_param_Previous_dxdy;

Texture fs_param_Previous_Texture;
sampler fs_param_Previous : register(s2) = sampler_state
{
    texture   = <fs_param_Previous_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Texture, using register location 3
float2 fs_param_Texture_size;
float2 fs_param_Texture_dxdy;

Texture fs_param_Texture_Texture;
sampler fs_param_Texture : register(s3) = sampler_state
{
    texture   = <fs_param_Texture_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

float fs_param_PercentSimStepComplete;

// The following methods are included because they are referenced by the fragment shader.
bool GpuSim__SimShader__Something(float4 u)
{
    return u.r > 0;
}

bool GpuSim__SimShader__selected(float4 u)
{
    float val = u.b;
    return val >= 0.01960784;
}

float4 GpuSim__DrawUnitZoomedOut__Presence(float4 data)
{
    return GpuSim__SimShader__Something(data) ? (GpuSim__SimShader__selected(data) ? float4(0.3294118, 0.7882353, 0.4196078, 1.0) : float4(0.5686275, 0.4862745, 0.509804, 1.0)) : float4(0, 0, 0, 0);
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
    float4 output = float4(0, 0, 0, 0);
    float4 right = tex2D(fs_param_Current, psin.TexCoords + (float2(1, 0)) * fs_param_Current_dxdy), up = tex2D(fs_param_Current, psin.TexCoords + (float2(0, 1)) * fs_param_Current_dxdy), left = tex2D(fs_param_Current, psin.TexCoords + (float2(-(1), 0)) * fs_param_Current_dxdy), down = tex2D(fs_param_Current, psin.TexCoords + (float2(0, -(1))) * fs_param_Current_dxdy), here = tex2D(fs_param_Current, psin.TexCoords + (float2(0, 0)) * fs_param_Current_dxdy);
    output = 0.5 * 0.25 * (GpuSim__DrawUnitZoomedOut__Presence(right) + GpuSim__DrawUnitZoomedOut__Presence(up) + GpuSim__DrawUnitZoomedOut__Presence(left) + GpuSim__DrawUnitZoomedOut__Presence(down)) + 0.5 * GpuSim__DrawUnitZoomedOut__Presence(here);
    __FinalOutput.Color = output;
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