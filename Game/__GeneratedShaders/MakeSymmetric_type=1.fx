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
// Texture Sampler for fs_param_Info, using register location 1
float2 fs_param_Info_size;
float2 fs_param_Info_dxdy;

Texture fs_param_Info_Texture;
sampler fs_param_Info : register(s1) = sampler_state
{
    texture   = <fs_param_Info_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};


// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Game__MakeSymmetricBase__DoNothing__Sampler__vec2__Single(VertexToPixel psin, sampler Units, float2 Units_size, float2 Units_dxdy, float2 pos, float type)
{
    if (abs(type - 0.0) < .001)
    {
        if (all(pos < Units_size / 2 - .001))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    if (abs(type - 1.0) < .001)
    {
        if (all(pos < Units_size / 4 - .001))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    return true;
}

float2 Game__MakeSymmetricBase__QuadMirrorShift__Sampler__vec2__Single(VertexToPixel psin, sampler Info, float2 Info_size, float2 Info_dxdy, float2 pos, float type)
{
    float2 shift = float2(0, 0);
    if (abs(type - 0.0) < .001)
    {
        if (pos.x > Info_size.x / 2 + .001)
        {
            shift.x = 2 * pos.x - Info_size.x;
        }
        if (pos.y > Info_size.y / 2 + .001)
        {
            shift.y = 2 * pos.y - Info_size.y;
        }
    }
    if (abs(type - 1.0) < .001)
    {
        if (pos.x > Info_size.x / 4 + .001)
        {
            shift.x = 2 * pos.x - Info_size.x / 2;
        }
        if (pos.y > Info_size.y / 4 + .001)
        {
            shift.y = 2 * pos.y - Info_size.y / 2;
        }
    }
    return float2(shift.x, shift.y);
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
    float4 info = tex2D(fs_param_Info, psin.TexCoords + (float2(0, 0)) * fs_param_Info_dxdy);
    float2 pos = psin.TexCoords * fs_param_Info_size;
    if (Game__MakeSymmetricBase__DoNothing__Sampler__vec2__Single(psin, fs_param_Info, fs_param_Info_size, fs_param_Info_dxdy, pos, 1))
    {
        __FinalOutput.Color = info;
        return __FinalOutput;
    }
    float4 copy = tex2D(fs_param_Info, psin.TexCoords + (float2(0, 0) - Game__MakeSymmetricBase__QuadMirrorShift__Sampler__vec2__Single(psin, fs_param_Info, fs_param_Info_size, fs_param_Info_dxdy, pos, 1)) * fs_param_Info_dxdy);
    __FinalOutput.Color = copy;
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