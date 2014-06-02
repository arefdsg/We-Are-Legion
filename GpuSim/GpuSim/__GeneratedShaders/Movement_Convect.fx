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
// Texture Sampler for fs_param_Data, using register location 1
float2 fs_param_Data_size;
float2 fs_param_Data_dxdy;

Texture fs_param_Data_Texture;
sampler fs_param_Data : register(s1) = sampler_state
{
    texture   = <fs_param_Data_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_CurrentData, using register location 2
float2 fs_param_CurrentData_size;
float2 fs_param_CurrentData_dxdy;

Texture fs_param_CurrentData_Texture;
sampler fs_param_CurrentData : register(s2) = sampler_state
{
    texture   = <fs_param_CurrentData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following methods are included because they are referenced by the fragment shader.
bool GpuSim__SimShader__Something(float4 u)
{
    return u.r > 0 + .001;
}

bool GpuSim__SimShader__IsStationary(float4 u)
{
    return abs(0.01960784 - u.r) < .001;
}

bool GpuSim__SimShader__Stayed(float4 u)
{
    return GpuSim__SimShader__IsStationary(u) || abs(0.003921569 - u.g) < .001;
}

bool GpuSim__SimShader__IsValid(float direction)
{
    return direction > 0 + .001;
}

float2 GpuSim__SimShader__dir_to_vec(float direction)
{
    float angle = (float)((direction * 255 - 1) * (3.1415926 / 2.0));
    return GpuSim__SimShader__IsValid(direction) ? float2(cos(angle), sin(angle)) : float2(0, 0);
}

float GpuSim__SimShader__Reverse(float dir)
{
    dir += 2 * 0.003921569;
    if (dir > 0.01568628 + .001)
    {
        dir -= 4 * 0.003921569;
    }
    return dir;
}

float GpuSim__SimShader__prior_direction(float4 u)
{
    float val = u.b;
    if (val >= 0.03137255 - .001)
    {
        val -= 0.03137255;
    }
    return val;
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
    float4 here = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentData_dxdy);
    float4 output = float4(0, 0, 0, 0);
    if (GpuSim__SimShader__Something(here))
    {
        if (GpuSim__SimShader__Stayed(here))
        {
            output = tex2D(fs_param_Data, psin.TexCoords + (float2(0, 0)) * fs_param_Data_dxdy);
        }
        else
        {
            output = tex2D(fs_param_Data, psin.TexCoords + (GpuSim__SimShader__dir_to_vec(GpuSim__SimShader__Reverse(GpuSim__SimShader__prior_direction(here)))) * fs_param_Data_dxdy);
        }
    }
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