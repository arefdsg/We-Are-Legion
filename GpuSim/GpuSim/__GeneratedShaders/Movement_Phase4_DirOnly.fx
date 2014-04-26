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
// Texture Sampler for fs_param_Extra, using register location 1
float2 fs_param_Extra_size;
float2 fs_param_Extra_dxdy;

Texture fs_param_Extra_Texture;
sampler fs_param_Extra : register(s1) = sampler_state
{
    texture   = <fs_param_Extra_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Current, using register location 2
float2 fs_param_Current_size;
float2 fs_param_Current_dxdy;

Texture fs_param_Current_Texture;
sampler fs_param_Current : register(s2) = sampler_state
{
    texture   = <fs_param_Current_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Paths_Right, using register location 3
float2 fs_param_Paths_Right_size;
float2 fs_param_Paths_Right_dxdy;

Texture fs_param_Paths_Right_Texture;
sampler fs_param_Paths_Right : register(s3) = sampler_state
{
    texture   = <fs_param_Paths_Right_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Paths_Left, using register location 4
float2 fs_param_Paths_Left_size;
float2 fs_param_Paths_Left_dxdy;

Texture fs_param_Paths_Left_Texture;
sampler fs_param_Paths_Left : register(s4) = sampler_state
{
    texture   = <fs_param_Paths_Left_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Paths_Up, using register location 5
float2 fs_param_Paths_Up_size;
float2 fs_param_Paths_Up_dxdy;

Texture fs_param_Paths_Up_Texture;
sampler fs_param_Paths_Up : register(s5) = sampler_state
{
    texture   = <fs_param_Paths_Up_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Paths_Down, using register location 6
float2 fs_param_Paths_Down_size;
float2 fs_param_Paths_Down_dxdy;

Texture fs_param_Paths_Down_Texture;
sampler fs_param_Paths_Down : register(s6) = sampler_state
{
    texture   = <fs_param_Paths_Down_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following methods are included because they are referenced by the fragment shader.
bool GpuSim__SimShader__Something(float4 u)
{
    return u.r > 0;
}

bool GpuSim__SimShader__IsValid(float direction)
{
    return direction > 0;
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
    if (GpuSim__SimShader__Something(here))
    {
        float4 path = float4(0, 0, 0, 0);
        float4 extra = tex2D(fs_param_Extra, psin.TexCoords + (float2(0, 0)) * fs_param_Extra_dxdy);
        if (abs(extra.r - 0.003921569) < .001)
        {
            path = tex2D(fs_param_Paths_Right, psin.TexCoords + (float2(0, 0)) * fs_param_Paths_Right_dxdy);
        }
        if (abs(extra.r - 0.01176471) < .001)
        {
            path = tex2D(fs_param_Paths_Left, psin.TexCoords + (float2(0, 0)) * fs_param_Paths_Left_dxdy);
        }
        if (abs(extra.r - 0.007843138) < .001)
        {
            path = tex2D(fs_param_Paths_Up, psin.TexCoords + (float2(0, 0)) * fs_param_Paths_Up_dxdy);
        }
        if (abs(extra.r - 0.01568628) < .001)
        {
            path = tex2D(fs_param_Paths_Down, psin.TexCoords + (float2(0, 0)) * fs_param_Paths_Down_dxdy);
        }
        if ((path.g > 0 || path.b > 0) && GpuSim__SimShader__IsValid(path.r))
        {
            here.r = path.r;
        }
    }
    __FinalOutput.Color = here;
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