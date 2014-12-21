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

// Texture Sampler for fs_param_CurrentUnits, using register location 3
float2 fs_param_CurrentUnits_size;
float2 fs_param_CurrentUnits_dxdy;

Texture fs_param_CurrentUnits_Texture;
sampler fs_param_CurrentUnits : register(s3) = sampler_state
{
    texture   = <fs_param_CurrentUnits_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PreviousUnits, using register location 4
float2 fs_param_PreviousUnits_size;
float2 fs_param_PreviousUnits_dxdy;

Texture fs_param_PreviousUnits_Texture;
sampler fs_param_PreviousUnits : register(s4) = sampler_state
{
    texture   = <fs_param_PreviousUnits_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_UnitTexture, using register location 5
float2 fs_param_UnitTexture_size;
float2 fs_param_UnitTexture_dxdy;

Texture fs_param_UnitTexture_Texture;
sampler fs_param_UnitTexture : register(s5) = sampler_state
{
    texture   = <fs_param_UnitTexture_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

// Texture Sampler for fs_param_ShadowTexture, using register location 6
float2 fs_param_ShadowTexture_size;
float2 fs_param_ShadowTexture_dxdy;

Texture fs_param_ShadowTexture_Texture;
sampler fs_param_ShadowTexture : register(s6) = sampler_state
{
    texture   = <fs_param_ShadowTexture_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

float fs_param_s;

float fs_param_t;

float fs_param_selection_blend;

float fs_param_selection_size;

float fs_param_solid_blend;

// The following variables are included because they are referenced but are not function parameters. Their values will be set at call time.
// Texture Sampler for fs_param_FarColor, using register location 7
float2 fs_param_FarColor_size;
float2 fs_param_FarColor_dxdy;

Texture fs_param_FarColor_Texture;
sampler fs_param_FarColor : register(s7) = sampler_state
{
    texture   = <fs_param_FarColor_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// The following methods are included because they are referenced by the fragment shader.
float2 Terracotta__SimShader__get_subcell_pos(VertexToPixel vertex, float2 grid_size, float2 grid_shift)
{
    float2 coords = vertex.TexCoords * grid_size + grid_shift;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

bool Terracotta__SimShader__IsUnit(float4 u)
{
    return u.r >= 0.003921569 - .001 && u.r < 0.02352941 - .001;
}

bool Terracotta__SimShader__Something(float4 u)
{
    return u.r > 0 + .001;
}

bool Terracotta__SimShader__show_selected(float4 u)
{
    float val = u.b;
    return 0.1254902 <= val + .001 && val < 0.5019608 - .001;
}

float4 Terracotta__SelectedUnitColor__Get(VertexToPixel psin, float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 1 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 2 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 3 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return tex2D(fs_param_FarColor, float2(1+.5,.5+ 4 + (int)player) * fs_param_FarColor_dxdy);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 Terracotta__DrawUnits__ShadowSprite(VertexToPixel psin, float player, float4 d, float4 u, float2 pos, sampler Texture, float2 Texture_size, float2 Texture_dxdy, float selection_blend, float selection_size, bool solid_blend_flag, float solid_blend)
{
    if (pos.x > 1 + .001 || pos.y > 1 + .001 || pos.x < 0 - .001 || pos.y < 0 - .001)
    {
        return float4(0.0, 0.0, 0.0, 0.0);
    }
    bool draw_selected = abs(u.g - player) < .001 && Terracotta__SimShader__show_selected(d);
    float4 clr = tex2D(Texture, pos);
    if (draw_selected)
    {
        if (clr.a > 0 + .001)
        {
            float a = clr.a;
            clr = Terracotta__SelectedUnitColor__Get(psin, u.g);
            clr.a = a;
        }
    }
    return clr;
}

bool Terracotta__SimShader__IsValid(float direction)
{
    return direction > 0 + .001;
}

float FragSharpFramework__FragSharpStd__fint_round(float v)
{
    return floor(255 * v + 0.5) * 0.003921569;
}

float Terracotta__SimShader__prior_direction(float4 u)
{
    float val = u.b;
    if (val >= 0.3764706 - .001)
    {
        val -= 0.3764706;
    }
    val = FragSharpFramework__FragSharpStd__fint_round(val);
    return val;
}

float2 Terracotta__SimShader__direction_to_vec(float direction)
{
    float angle = (direction * 255 - 1) * (3.141593 / 2.0);
    return Terracotta__SimShader__IsValid(direction) ? float2(cos(angle), sin(angle)) : float2(0, 0);
}

float2 Terracotta__SimShader__get_subcell_pos(VertexToPixel vertex, float2 grid_size)
{
    float2 coords = vertex.TexCoords * grid_size;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

float FragSharpFramework__FragSharpStd__Float(float v)
{
    return floor(255 * v + 0.5);
}

float Terracotta__Dir__Num(float4 d)
{
    return FragSharpFramework__FragSharpStd__Float(d.r) - 1;
}

float Terracotta__Player__Num(float4 u)
{
    return FragSharpFramework__FragSharpStd__Float(u.g) - 1;
}

float Terracotta__UnitType__UnitIndex(float4 u)
{
    return FragSharpFramework__FragSharpStd__Float(u.r - 0.003921569);
}

float4 Terracotta__UnitColor__Get(VertexToPixel psin, float player)
{
    if (abs(player - 0.003921569) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 1 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.007843138) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 2 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01176471) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 3 + (int)player) * fs_param_FarColor_dxdy);
    }
    if (abs(player - 0.01568628) < .001)
    {
        return tex2D(fs_param_FarColor, float2(0+.5,.5+ 4 + (int)player) * fs_param_FarColor_dxdy);
    }
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 Terracotta__DrawUnits__SolidColor(VertexToPixel psin, float player, float4 data, float4 unit)
{
    return abs(unit.g - player) < .001 && Terracotta__SimShader__show_selected(data) ? Terracotta__SelectedUnitColor__Get(psin, unit.g) : Terracotta__UnitColor__Get(psin, unit.g);
}

float4 Terracotta__DrawUnits__Sprite(VertexToPixel psin, float player, float4 d, float4 u, float2 pos, float frame, sampler Texture, float2 Texture_size, float2 Texture_dxdy, float selection_blend, float selection_size, bool solid_blend_flag, float solid_blend)
{
    if (pos.x > 1 + .001 || pos.y > 1 + .001 || pos.x < 0 - .001 || pos.y < 0 - .001)
    {
        return float4(0.0, 0.0, 0.0, 0.0);
    }
    bool draw_selected = abs(u.g - player) < .001 && Terracotta__SimShader__show_selected(d) && pos.y > selection_size + .001;
    pos.x += floor(frame);
    pos.y += Terracotta__Dir__Num(d) + 4 * Terracotta__Player__Num(u) + 4 * 4 * Terracotta__UnitType__UnitIndex(u);
    pos *= float2(1.0 / 32, 1.0 / 96);
    float4 clr = tex2D(Texture, pos);
    if (solid_blend_flag)
    {
        clr = solid_blend * clr + (1 - solid_blend) * Terracotta__DrawUnits__SolidColor(psin, player, d, u);
    }
    return clr;
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
    float4 shadow = float4(0.0, 0.0, 0.0, 0.0);
    float2 shadow_subcell_pos = Terracotta__SimShader__get_subcell_pos(psin, fs_param_CurrentData_size, float2(0.0, -(0.5)));
    float2 shadow_here = float2(0, 0) + float2(0, -(0.5));
    float4 shadow_cur = tex2D(fs_param_CurrentData, psin.TexCoords + (shadow_here) * fs_param_CurrentData_dxdy), shadow_pre = tex2D(fs_param_PreviousData, psin.TexCoords + (shadow_here) * fs_param_PreviousData_dxdy);
    float4 shadow_cur_unit = tex2D(fs_param_CurrentUnits, psin.TexCoords + (shadow_here) * fs_param_CurrentUnits_dxdy), shadow_pre_unit = tex2D(fs_param_PreviousUnits, psin.TexCoords + (shadow_here) * fs_param_PreviousUnits_dxdy);
    if (Terracotta__SimShader__IsUnit(shadow_cur_unit) || Terracotta__SimShader__IsUnit(shadow_pre_unit))
    {
        if (Terracotta__SimShader__Something(shadow_cur) && abs(shadow_cur.g - 0.003921569) < .001)
        {
            if (fs_param_s > 0.5 + .001)
            {
                shadow_pre = shadow_cur;
            }
            shadow += Terracotta__DrawUnits__ShadowSprite(psin, 0.01176471, shadow_pre, shadow_pre_unit, shadow_subcell_pos, fs_param_ShadowTexture, fs_param_ShadowTexture_size, fs_param_ShadowTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
        }
        else
        {
            if (Terracotta__SimShader__IsValid(shadow_cur.r))
            {
                float prior_dir = Terracotta__SimShader__prior_direction(shadow_cur);
                shadow_cur.r = prior_dir;
                float2 offset = (1 - fs_param_s) * Terracotta__SimShader__direction_to_vec(prior_dir);
                shadow += Terracotta__DrawUnits__ShadowSprite(psin, 0.01176471, shadow_cur, shadow_cur_unit, shadow_subcell_pos + offset, fs_param_ShadowTexture, fs_param_ShadowTexture_size, fs_param_ShadowTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
            }
            if (Terracotta__SimShader__IsValid(shadow_pre.r) && shadow.a < 0.025 - .001)
            {
                float2 offset = -(fs_param_s) * Terracotta__SimShader__direction_to_vec(shadow_pre.r);
                shadow += Terracotta__DrawUnits__ShadowSprite(psin, 0.01176471, shadow_pre, shadow_pre_unit, shadow_subcell_pos + offset, fs_param_ShadowTexture, fs_param_ShadowTexture_size, fs_param_ShadowTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
            }
        }
    }
    float4 output = float4(0.0, 0.0, 0.0, 0.0);
    float2 subcell_pos = Terracotta__SimShader__get_subcell_pos(psin, fs_param_CurrentData_size);
    float4 cur = tex2D(fs_param_CurrentData, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentData_dxdy), pre = tex2D(fs_param_PreviousData, psin.TexCoords + (float2(0, 0)) * fs_param_PreviousData_dxdy);
    float4 cur_unit = tex2D(fs_param_CurrentUnits, psin.TexCoords + (float2(0, 0)) * fs_param_CurrentUnits_dxdy), pre_unit = tex2D(fs_param_PreviousUnits, psin.TexCoords + (float2(0, 0)) * fs_param_PreviousUnits_dxdy);
    if (!(Terracotta__SimShader__IsUnit(cur_unit)) && !(Terracotta__SimShader__IsUnit(pre_unit)))
    {
        __FinalOutput.Color = shadow;
        return __FinalOutput;
    }
    if (Terracotta__SimShader__Something(cur) && abs(cur.g - 0.003921569) < .001)
    {
        if (fs_param_s > 0.5 + .001)
        {
            pre = cur;
        }
        float _s = (abs(cur_unit.a - 0.0) < .001 ? fs_param_t : fs_param_s);
        if (abs(cur_unit.a - 0.2588235) < .001)
        {
            cur_unit.a = 0.07058824;
            _s = 1.0 - _s;
        }
        float frame = _s * 6 + FragSharpFramework__FragSharpStd__Float(cur_unit.a);
        output += Terracotta__DrawUnits__Sprite(psin, 0.01176471, pre, pre_unit, subcell_pos, frame, fs_param_UnitTexture, fs_param_UnitTexture_size, fs_param_UnitTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
    }
    else
    {
        float frame = fs_param_s * 6 + FragSharpFramework__FragSharpStd__Float(0.02352941);
        if (Terracotta__SimShader__IsValid(cur.r))
        {
            float prior_dir = Terracotta__SimShader__prior_direction(cur);
            cur.r = prior_dir;
            float2 offset = (1 - fs_param_s) * Terracotta__SimShader__direction_to_vec(prior_dir);
            output += Terracotta__DrawUnits__Sprite(psin, 0.01176471, cur, cur_unit, subcell_pos + offset, frame, fs_param_UnitTexture, fs_param_UnitTexture_size, fs_param_UnitTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
        }
        if (Terracotta__SimShader__IsValid(pre.r) && output.a < 0.025 - .001)
        {
            float2 offset = -(fs_param_s) * Terracotta__SimShader__direction_to_vec(pre.r);
            output += Terracotta__DrawUnits__Sprite(psin, 0.01176471, pre, pre_unit, subcell_pos + offset, frame, fs_param_UnitTexture, fs_param_UnitTexture_size, fs_param_UnitTexture_dxdy, fs_param_selection_blend, fs_param_selection_size, true, fs_param_solid_blend);
        }
    }
    if (output.a < 0.025 - .001)
    {
        output = shadow;
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