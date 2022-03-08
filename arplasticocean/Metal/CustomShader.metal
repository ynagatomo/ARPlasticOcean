//
//  CustomShader.metal
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/03/07.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

//    [[visible]]
//    void mySurfaceShader(realitykit::surface_parameters params)
//    {
//        // Retrieve the base color tint from the entity's material.
//        // half3 baseColorTint = (half3)params.material_constants().base_color_tint();
//
//        // Retrieve the entity's texture coordinates.
//        //    float2 uv = params.geometry().uv0();
//
//        // Flip the texture coordinates y-axis. This is only needed for entities
//        // loaded from USDZ or .reality files.
//        //    uv.y = 1.0 - uv.y;
//
//        // Sample a value from the material's base color texture based on the
//        // flipped UV coordinates.
//        //    auto tex = params.textures();
//        //    half3 color = (half3)tex.base_color().sample(textureSampler, uv).rgb;
//
//        // Multiply the tint by the sampled value from the texture, and
//        // assign the result to the shader's base color property.
//        //    color *= baseColorTint;
//        //    half3 color = baseColorTint;
//
//        half3 color = half3(0.0, 0.5, 0.9);
//        params.surface().set_base_color(color);
//    }

[[visible]]
void highWaveGeometryModifier(realitykit::geometry_parameters params)
{
    float3 pos = params.geometry().model_position();
    float3 offset = float3(0.0, cos(  3.14 * 2.0 * pos.x / 0.2
                                    + params.uniforms().time() * 1.4 ) * cos(3.14 * 2.0 * pos.z / 0.2
                                    + params.uniforms().time() / 2.0 ) * 0.02, 0.0);
    params.geometry().set_model_position_offset(offset);
}

