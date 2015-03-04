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
// Texture Sampler for fs_param_CurrentData, using register location 1
float2 fs_param_CurrentData_size;
float2 fs_param_CurrentData_dxdy;

Texture fs_param_CurrentData_Texture;
sampler fs_param_CurrentData : register(s1) = sampler_state
{
    texture   = <fs_param_CurrentData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PreviousData, using register location 2
float2 fs_param_PreviousData_size;
float2 fs_param_PreviousData_dxdy;

Texture fs_param_PreviousData_Texture;
sampler fs_param_PreviousData : register(s2) = sampler_state
{
    texture   = <fs_param_PreviousData_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_CurrentUnit, using register location 3
float2 fs_param_CurrentUnit_size;
float2 fs_param_CurrentUnit_dxdy;

Texture fs_param_CurrentUnit_Texture;
sampler fs_param_CurrentUnit : register(s3) = sampler_state
{
    texture   = <fs_param_CurrentUnit_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PreviousUnit, using register location 4
float2 fs_param_PreviousUnit_size;
float2 fs_param_PreviousUnit_dxdy;

Texture fs_param_PreviousUnit_Texture;
sampler fs_param_PreviousUnit : register(s4) = sampler_state
{
    texture   = <fs_param_PreviousUnit_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Texture, using register location 5
float2 fs_param_Texture_size;
float2 fs_param_Texture_dxdy;

Texture fs_param_Texture_Texture;
sampler fs_param_Texture : register(s5) = sampler_state
{
    texture   = <fs_param_Texture_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

float fs_param_PercentSimStepComplete;

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Terracotta__SimShader__Something__Terracotta_data(float4 u)
{
    return u.r > 0 + .001;
}

bool Terracotta__SimShader__IsStationary__Terracotta_data(float4 d)
{
    return d.r >= 0.01960784 - .001;
}

bool Terracotta__SimShader__fake_selected__Terracotta_data(float4 u)
{
    float val = u.b;
    return 0.1254902 <= val + .001 && val < 0.5019608 - .001;
}

float4 Terracotta__SelectedUnitColor__Get__float(float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return float4(0.1490196, 0.6588235, 0.1333333, 1.0);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return float4(0.1490196, 0.6588235, 0.1333333, 1.0);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return float4(0.1490196, 0.6588235, 0.1333333, 1.0);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return float4(0.1490196, 0.6588235, 0.1333333, 1.0);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 Terracotta__UnitColor__Get__float(float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return float4(0.4392157, 0.4078431, 0.6117647, 1.0);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return float4(0.572549, 0.2588235, 0.2235294, 1.0);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return float4(0.3803922, 0.6117647, 0.7058824, 1.0);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return float4(0.9647059, 0.6431373, 0.6980392, 1.0);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 Terracotta__DrawUnits__SolidColor__float__Terracotta_data__Terracotta_unit(float player, float4 data, float4 unit)
{
    return abs(unit.g - player) < .001 && Terracotta__SimShader__fake_selected__Terracotta_data(data) ? Terracotta__SelectedUnitColor__Get__float(unit.g) : Terracotta__UnitColor__Get__float(unit.g);
}

float4 Terracotta__DrawUnits__Presence__float__Terracotta_data__Terracotta_unit(float player, float4 data, float4 unit)
{
    return (Terracotta__SimShader__Something__Terracotta_data(data) && !(Terracotta__SimShader__IsStationary__Terracotta_data(data))) ? Terracotta__DrawUnits__SolidColor__float__Terracotta_data__Terracotta_unit(player, data, unit) : float4(0.0, 0.0, 0.0, 0.0);
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
    float4 output = float4(0.0, 0.0, 0.0, 0.0);
    float4 data_right = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(1, 0)) * fs_param_CurrentData_dxdy), data_up = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(0, 1)) * fs_param_CurrentData_dxdy), data_left = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(-(1), 0)) * fs_param_CurrentData_dxdy), data_down = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(0, -(1))) * fs_param_CurrentData_dxdy), data_here = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentData_dxdy);
    float4 unit_right = tex2D(fs_param_CurrentUnit, psin.TexCoords + (float2(1, 0)) * fs_param_CurrentUnit_dxdy), unit_up = tex2D(fs_param_CurrentUnit, psin.TexCoords + (float2(0, 1)) * fs_param_CurrentUnit_dxdy), unit_left = tex2D(fs_param_CurrentUnit, psin.TexCoords + (float2(-(1), 0)) * fs_param_CurrentUnit_dxdy), unit_down = tex2D(fs_param_CurrentUnit, psin.TexCoords + (float2(0, -(1))) * fs_param_CurrentUnit_dxdy), unit_here = tex2D(fs_param_CurrentUnit, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentUnit_dxdy);
    output = 0.5 * 0.25 * (Terracotta__DrawUnits__Presence__float__Terracotta_data__Terracotta_unit(0.003921569, data_right, unit_right) + Terracotta__DrawUnits__Presence__float__Terracotta_data__Terracotta_unit(0.003921569, data_up, unit_up) + Terracotta__DrawUnits__Presence__float__Terracotta_data__Terracotta_unit(0.003921569, data_left, unit_left) + Terracotta__DrawUnits__Presence__float__Terracotta_data__Terracotta_unit(0.003921569, data_down, unit_down)) + 0.5 * Terracotta__DrawUnits__Presence__float__Terracotta_data__Terracotta_unit(0.003921569, data_here, unit_here);
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