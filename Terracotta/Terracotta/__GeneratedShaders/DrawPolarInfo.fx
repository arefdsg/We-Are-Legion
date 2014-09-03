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
// Texture Sampler for fs_param_Geo, using register location 1
float2 fs_param_Geo_size;
float2 fs_param_Geo_dxdy;

Texture fs_param_Geo_Texture;
sampler fs_param_Geo : register(s1) = sampler_state
{
    texture   = <fs_param_Geo_Texture>;
    MipFilter = Point;
    MagFilter = Point;
    MinFilter = Point;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Texture Sampler for fs_param_PolarDistance, using register location 2
float2 fs_param_PolarDistance_size;
float2 fs_param_PolarDistance_dxdy;

Texture fs_param_PolarDistance_Texture;
sampler fs_param_PolarDistance : register(s2) = sampler_state
{
    texture   = <fs_param_PolarDistance_Texture>;
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

// The following methods are included because they are referenced by the fragment shader.
float2 GpuSim__SimShader__get_subcell_pos(VertexToPixel vertex, float2 grid_size)
{
    float2 coords = vertex.TexCoords * grid_size;
    float i = floor(coords.x);
    float j = floor(coords.y);
    return coords - float2(i, j);
}

float4 GpuSim__DrawDebugInfo__DrawDebugInfoTile(VertexToPixel psin, float index_x, float index_y, float2 pos, sampler Texture, float2 Texture_size, float2 Texture_dxdy, float2 SpriteSize)
{
    float4 clr = float4(0.0, 0.0, 0.0, 0.0);
    if (pos.x > 1 + .001 || pos.y > 1 + .001 || pos.x < 0 - .001 || pos.y < 0 - .001)
    {
        return clr;
    }
    pos = pos * 0.98 + float2(0.01, 0.01);
    pos.x += index_x;
    pos.y += index_y;
    pos *= SpriteSize;
    clr += tex2D(Texture, pos);
    return clr;
}

float4 GpuSim__DrawDebugInfo__DrawDebugNum(VertexToPixel psin, float num, float2 pos, sampler Texture, float2 Texture_size, float2 Texture_dxdy)
{
    return GpuSim__DrawDebugInfo__DrawDebugInfoTile(psin, num, 0.0, pos, Texture, Texture_size, Texture_dxdy, float2(1.0 / 128, 1.0 / 4));
}

float GpuSim__SimShader__unpack_val(float2 packed)
{
    float coord = 0;
    packed = floor(255.0 * packed + float2(0.5, 0.5));
    coord = 256 * packed.x + packed.y;
    return coord;
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
    float4 here = tex2D(fs_param_Geo, psin.TexCoords + (float2(0, 0)) * fs_param_Geo_dxdy);
    float dist = 0;
    float2 subcell_pos = GpuSim__SimShader__get_subcell_pos(psin, fs_param_Geo_size);
    if (here.r > 0.0 + .001)
    {
        if (all(subcell_pos > float2(0.5, 0.5) + .001))
        {
            float2 subcell_pos_1 = GpuSim__SimShader__get_subcell_pos(psin, fs_param_Geo_size * 2);
            output += GpuSim__DrawDebugInfo__DrawDebugNum(psin, GpuSim__SimShader__unpack_val(tex2D(fs_param_PolarDistance, psin.TexCoords + (float2(0, 0)) * fs_param_PolarDistance_dxdy).xy), subcell_pos_1, fs_param_Texture, fs_param_Texture_size, fs_param_Texture_dxdy) * float4(1, 0.5019608, 0.5019608, 1.0);
        }
        if (all(subcell_pos < float2(0.5, 0.5) - .001))
        {
            float2 subcell_pos_2 = GpuSim__SimShader__get_subcell_pos(psin, fs_param_Geo_size * 2);
            output += GpuSim__DrawDebugInfo__DrawDebugNum(psin, GpuSim__SimShader__unpack_val(tex2D(fs_param_PolarDistance, psin.TexCoords + (float2(0, 0)) * fs_param_PolarDistance_dxdy).zw), subcell_pos_2, fs_param_Texture, fs_param_Texture_size, fs_param_Texture_dxdy) * float4(1, 0.5019608, 0.5019608, 1.0);
        }
        __FinalOutput.Color = output;
        return __FinalOutput;
    }
    if (subcell_pos.y > 0.5 + .001)
    {
        dist = GpuSim__SimShader__unpack_val(tex2D(fs_param_PolarDistance, psin.TexCoords + (float2(0, 0)) * fs_param_PolarDistance_dxdy).xy);
    }
    else
    {
        dist = GpuSim__SimShader__unpack_val(tex2D(fs_param_PolarDistance, psin.TexCoords + (float2(0, 0)) * fs_param_PolarDistance_dxdy).zw);
    }
    if (here.r > 0.0 + .001)
    {
        dist = dist / 1024.0;
        output = float4(dist, dist, dist, 1.0);
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