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

// Texture Sampler for fs_param_TargetData, using register location 2
float2 fs_param_TargetData_size;
float2 fs_param_TargetData_dxdy;

Texture fs_param_TargetData_Texture;
sampler fs_param_TargetData : register(s2) = sampler_state
{
    texture   = <fs_param_TargetData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

float2 fs_param_Destination_BL;

float2 fs_param_Destination_Size;

float2 fs_param_Selection_BL;

float2 fs_param_Selection_Size;

// The following methods are included because they are referenced by the fragment shader.
bool GpuSim__SimShader__selected(float4 u)
{
    float val = u.b;
    return val >= 0.03137255 - .001;
}

float2 GpuSim__SimShader__pack_coord(float x)
{
    float2 packed = float2(0, 0);
    packed.x = floor(x / 255.0);
    packed.y = x - packed.x * 255.0;
    return packed / 255.0;
}

float4 GpuSim__SimShader__pack_vec2(float2 v)
{
    float2 packed_x = GpuSim__SimShader__pack_coord(v.x);
    float2 packed_y = GpuSim__SimShader__pack_coord(v.y);
    return float4(packed_x.x, packed_x.y, packed_y.x, packed_y.y);
}

// Compiled vertex shader
VertexToPixel StandardVertexShader(float2 inPos : POSITION0, float2 inTexCoords : TEXCOORD0, float4 inColor : COLOR0)
{
    VertexToPixel Output = (VertexToPixel)0;
    Output.Position.w = 1;
    Output.Position.xy = inPos.xy;
    Output.TexCoords = inTexCoords;
    return Output;
}

// Compiled fragment shader
PixelToFrame FragmentShader(VertexToPixel psin)
{
    PixelToFrame __FinalOutput = (PixelToFrame)0;
    float4 here = tex2D(fs_param_Current, psin.TexCoords + (float2(0, 0)) * fs_param_Current_dxdy);
    float4 target = float4(0, 0, 0, 0);
    if (GpuSim__SimShader__selected(here))
    {
        float2 pos = psin.TexCoords * fs_param_Current_size;
        pos = (pos - fs_param_Selection_BL) / fs_param_Selection_Size;
        pos = pos * fs_param_Destination_Size + fs_param_Destination_BL;
        target = GpuSim__SimShader__pack_vec2(pos);
    }
    else
    {
        target = tex2D(fs_param_TargetData, psin.TexCoords + (float2(0, 0)) * fs_param_TargetData_dxdy);
    }
    __FinalOutput.Color = target;
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