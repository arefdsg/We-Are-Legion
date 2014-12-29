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
// Texture Sampler for fs_param_Unit, using register location 1
float2 fs_param_Unit_size;
float2 fs_param_Unit_dxdy;

Texture fs_param_Unit_Texture;
sampler fs_param_Unit : register(s1) = sampler_state
{
    texture   = <fs_param_Unit_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_Building, using register location 2
float2 fs_param_Building_size;
float2 fs_param_Building_dxdy;

Texture fs_param_Building_Texture;
sampler fs_param_Building : register(s2) = sampler_state
{
    texture   = <fs_param_Building_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.

// The following methods are included because they are referenced by the fragment shader.
bool Terracotta__SimShader__Something__Terracotta_building(float4 u)
{
    return u.r > 0 + .001;
}

bool Terracotta__SimShader__IsBuilding__float(float type)
{
    return type >= 0.02352941 - .001 && type < 0.07843138 - .001;
}

bool Terracotta__SimShader__IsBuilding__Terracotta_unit(float4 u)
{
    return Terracotta__SimShader__IsBuilding__float(u.r);
}

bool Terracotta__SimShader__IsCenter__Terracotta_building(float4 b)
{
    return abs(b.g - 0.003921569) < .001 && abs(b.a - 0.003921569) < .001;
}

bool Terracotta__SimShader__selected__Terracotta_data(float4 u)
{
    float val = u.b;
    return val >= 0.3764706 - .001;
}

bool Terracotta__SimShader__selected__Terracotta_building(float4 u)
{
    return Terracotta__SimShader__selected__Terracotta_data(u);
}

float FragSharpFramework__FragSharpStd__fint_round__float(float v)
{
    return floor(255 * v + 0.5) * 0.003921569;
}

float Terracotta__SimShader__prior_direction__Terracotta_data(float4 u)
{
    float val = u.b;
    val = fmod(val, 0.1254902);
    val = FragSharpFramework__FragSharpStd__fint_round__float(val);
    return val;
}

float Terracotta__SimShader__select_state__Terracotta_data(float4 u)
{
    return u.b - Terracotta__SimShader__prior_direction__Terracotta_data(u);
}

bool Terracotta__SimShader__fake_selected__Terracotta_data(float4 u)
{
    float val = u.b;
    return 0.1254902 <= val + .001 && val < 0.5019608 - .001;
}

void Terracotta__SimShader__set_selected__Terracotta_data__bool(inout float4 u, bool selected)
{
    float state = Terracotta__SimShader__select_state__Terracotta_data(u);
    if (selected)
    {
        state = Terracotta__SimShader__fake_selected__Terracotta_data(u) ? 0.3764706 : 0.627451;
    }
    else
    {
        state = Terracotta__SimShader__fake_selected__Terracotta_data(u) ? 0.2509804 : 0.0;
    }
    u.b = Terracotta__SimShader__prior_direction__Terracotta_data(u) + state;
}

void Terracotta__SimShader__set_selected__Terracotta_building__bool(inout float4 u, bool selected)
{
    float4 d = u;
    Terracotta__SimShader__set_selected__Terracotta_data__bool(d, selected);
    u = d;
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
    float4 building_here = tex2D(fs_param_Building, psin.TexCoords + (float2(0, 0)) * fs_param_Building_dxdy);
    float4 unit_here = tex2D(fs_param_Unit, psin.TexCoords + (float2(0, 0)) * fs_param_Unit_dxdy);
    if (Terracotta__SimShader__Something__Terracotta_building(building_here) && Terracotta__SimShader__IsBuilding__Terracotta_unit(unit_here) && Terracotta__SimShader__IsCenter__Terracotta_building(building_here))
    {
        if (building_here.r >= 0.02745098 - .001)
        {
            building_here.r += 0.003921569;
            __FinalOutput.Color = building_here;
            return __FinalOutput;
        }
        float4 right = tex2D(fs_param_Building, psin.TexCoords + (float2(1, 0)) * fs_param_Building_dxdy), up = tex2D(fs_param_Building, psin.TexCoords + (float2(0, 1)) * fs_param_Building_dxdy), left = tex2D(fs_param_Building, psin.TexCoords + (float2(-(1), 0)) * fs_param_Building_dxdy), down = tex2D(fs_param_Building, psin.TexCoords + (float2(0, -(1))) * fs_param_Building_dxdy), up_right = tex2D(fs_param_Building, psin.TexCoords + (float2(1, 1)) * fs_param_Building_dxdy), up_left = tex2D(fs_param_Building, psin.TexCoords + (float2(-(1), 1)) * fs_param_Building_dxdy), down_right = tex2D(fs_param_Building, psin.TexCoords + (float2(1, -(1))) * fs_param_Building_dxdy), down_left = tex2D(fs_param_Building, psin.TexCoords + (float2(-(1), -(1))) * fs_param_Building_dxdy);
        if (abs(right.r - 0.02352941) < .001 || abs(up.r - 0.02352941) < .001 || abs(left.r - 0.02352941) < .001 || abs(down.r - 0.02352941) < .001 || abs(up_right.r - 0.02352941) < .001 || abs(up_left.r - 0.02352941) < .001 || abs(down_right.r - 0.02352941) < .001 || abs(down_left.r - 0.02352941) < .001)
        {
            building_here.r = 0.02745098;
        }
        if (!(Terracotta__SimShader__selected__Terracotta_building(building_here)))
        {
            bool is_selected = Terracotta__SimShader__selected__Terracotta_building(right) || Terracotta__SimShader__selected__Terracotta_building(up) || Terracotta__SimShader__selected__Terracotta_building(left) || Terracotta__SimShader__selected__Terracotta_building(down) || Terracotta__SimShader__selected__Terracotta_building(up_right) || Terracotta__SimShader__selected__Terracotta_building(up_left) || Terracotta__SimShader__selected__Terracotta_building(down_right) || Terracotta__SimShader__selected__Terracotta_building(down_left);
            Terracotta__SimShader__set_selected__Terracotta_building__bool(building_here, is_selected);
        }
    }
    __FinalOutput.Color = building_here;
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