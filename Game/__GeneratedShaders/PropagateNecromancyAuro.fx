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
// Texture Sampler for fs_param_Necromancy, using register location 1
float2 fs_param_Necromancy_size;
float2 fs_param_Necromancy_dxdy;

Texture fs_param_Necromancy_Texture;
sampler fs_param_Necromancy : register(s1) = sampler_state
{
    texture   = <fs_param_Necromancy_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Data, using register location 2
float2 fs_param_Data_size;
float2 fs_param_Data_dxdy;

Texture fs_param_Data_Texture;
sampler fs_param_Data : register(s2) = sampler_state
{
    texture   = <fs_param_Data_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Units, using register location 3
float2 fs_param_Units_size;
float2 fs_param_Units_dxdy;

Texture fs_param_Units_Texture;
sampler fs_param_Units : register(s3) = sampler_state
{
    texture   = <fs_param_Units_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
float4 FragSharpFramework__FragSharpStd__max__FragSharpFramework_vec4__FragSharpFramework_vec4__FragSharpFramework_vec4__FragSharpFramework_vec4(float4 a, float4 b, float4 c, float4 d)
{
    return max(max(a, b), max(c, d));
}

void Game__SimShader__SetPlayerVal__Game_PlayerTuple__float__float(inout float4 tuple, float player, float value)
{
    if (abs(player - 0.003921569) < .001)
    {
        tuple.r = value;
    }
    if (abs(player - 0.007843138) < .001)
    {
        tuple.g = value;
    }
    if (abs(player - 0.01176471) < .001)
    {
        tuple.b = value;
    }
    if (abs(player - 0.01568628) < .001)
    {
        tuple.a = value;
    }
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
    float4 data_here = tex2D(fs_param_Data, psin.TexCoords + (float2(0, 0)) * fs_param_Data_dxdy);
    float4 unit_here = tex2D(fs_param_Units, psin.TexCoords + (float2(0, 0)) * fs_param_Units_dxdy);
    float4 right = tex2D(fs_param_Necromancy, psin.TexCoords + (float2(1, 0)) * fs_param_Necromancy_dxdy), up = tex2D(fs_param_Necromancy, psin.TexCoords + (float2(0, 1)) * fs_param_Necromancy_dxdy), left = tex2D(fs_param_Necromancy, psin.TexCoords + (float2(-(1), 0)) * fs_param_Necromancy_dxdy), down = tex2D(fs_param_Necromancy, psin.TexCoords + (float2(0, -(1))) * fs_param_Necromancy_dxdy);
    float4 necromancy = FragSharpFramework__FragSharpStd__max__FragSharpFramework_vec4__FragSharpFramework_vec4__FragSharpFramework_vec4__FragSharpFramework_vec4(right, up, left, down) - float4(0.003921569, 0.003921569, 0.003921569, 0.003921569);
    if (abs(unit_here.r - 0.01176471) < .001)
    {
        Game__SimShader__SetPlayerVal__Game_PlayerTuple__float__float(necromancy, unit_here.g, 0.07843138);
    }
    __FinalOutput.Color = necromancy;
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