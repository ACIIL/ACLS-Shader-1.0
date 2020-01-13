﻿//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
Shader "ACiiL/toon/ACLS_Toon_Cutout" {
    Properties {
        [Enum(OFF,0,FRONT,1,BACK,2)] _CullMode("Cull Mode", int)    = 2  //OFF/FRONT/BACK

        [Header(Testing)]
        // _AO_shadePosFront_Offset("Front Offset", Range(-1,1))   = 0
        // _AO_shadePosBack_Offset("Back Offset", Range(-1,1))     = 0
        _AmbientColorDesat("Ambient Desaturation",Range(0,1))   = 0

        [Header(Toon ramp)]
        _MainTex("Main Tex", 2D)                                            = "white" {}
        [Enum(Self,0,MainTex,1)] _Use_BaseAs1st("1st shade source", Int)    = 1
        [NoScaleOffset] _1st_ShadeMap("--1st shade Tex", 2D)                = "white" {}
        [Enum(Self,0,Shade1,1)] _Use_1stAs2nd("2st shade source", Int)      = 1
        [NoScaleOffset] _2nd_ShadeMap("--2nd shade Tex", 2D)                = "white" {}
        [HDR] _Color("Base color", Color)                                   = (1,1,1,1)
        [HDR] _0_ShadeColor("--Foward color", Color)                        = (0.97,0.97,0.97,1)
        [HDR] _1st_ShadeColor("--Core color", Color)                        = (0.95,0.95,0.95,1)
        [HDR] _2nd_ShadeColor("--Back color", Color)                        = (0.9,0.9,0.9,1)
        _BaseColor_Step("Step: forward ", Range(0, 1))                      = 0.6
        _BaseShade_Feather("--Feather: forward", Range(0.0001, 1))          = 0.001
        _ShadeColor_Step("Step: back", Range(0, 1))                         = 0.4
        _1st2nd_Shades_Feather("--Feather: back", Range(0.0001, 1))         = 0.001
        [Space(18)]
        [Enum(Off,0,On,1)] _Diff_GSF_01("Toon ramp GSF effect", Int)        = 0
        _DiffGSF_Offset("--Offset",Range(0,2))                              = 1
        _DiffGSF_Feather("--Feather",Range(0.0001,2))                       = 0.2
        [Toggle(_)] _Set_SystemShadowsToBase("Shadow affects shading",Int ) = 0

        [Header(Specular Shine)]
        [Enum(Unity Specular Setup,0,Add,1)] _Is_BlendAddToHiColor("Specular Blend mode", Int ) = 1
        [HDR] _SpecColor("Specular Primary Color",Color)                                        = (.5,.5,.5,1)
        _Glossiness("Smoothness",Range(0,1))                                                    = .3
        _HighColor_Tex("--Specular Setup Tex: (RGB):Tint, (A):Smoothness", 2D)                  = "white" {}
        _highColTexSource("----Multiply with albedo", Range(0,1))                               = 0
        [HDR] _HighColor("Spec col 01", Color)                                                  = (1,1,1,1)
        [Enum(Sharp,0,Soft,1,Unity,2)] _Is_SpecularToHighColor("Specular mode", Int )           = 0
        _TweakHighColorOnShadow("Spec shadow mask", Range(0, 1))                                = 1

        [Header(World reflection)]
        [Enum(None,0,Standard,1,Override,2)] _ENVMmode("Reflection Setup:",Int)             = 0
        _ENVMix("--Reflection mix",Range(0,1))                                              = 1
        _envRoughness("--Reflection smoothness", Range(0, 1))                               = 0.34
        [Enum(Off,0,Smart,1,Replace,2)] _CubemapFallbackMode("Fallback mix mode:",Int)      = 0
        [NoScaleOffset] _CubemapFallback("--Fallback Cubemap",Cube)                         = "black" {}
        [Space(18)]
        [Enum(Off,0,On,1)] _EnvGrazeMix("Graze Natural mix",Int)                            = 1
        [Enum(Off,0,On,1)] _EnvGrazeRimMix("Graze RimLights Mask mix",Int)                  = 0
        _envOnRim("Mask on rimLights", Range(0,1))                                          = 0.25
        _envOnRimColorize("--Colorize rim lights", Range(0,1))                              = 0

        [Header(Rimlights)]
        [Enum(Off,0,Add,1)] _RimLight("RimLight blend",Int)                         = 1
        [Enum(Off,0,Add,1)] _Add_Antipodean_RimLight("Ap RimLight blend",Int)       = 1
        [Enum(None,0,Diffuse Tex,1,Specular Tex,2)] _RimLightSource("Source albedo",Int)   = 0
        [HDR] _RimLightColor("Color: RimLight",Color)                               = (0.8,0.8,0.8,1)
        [HDR] _Ap_RimLightColor("Color: Ap RimLight",Color)                         = (0.5,0.5,0.5,1)
        _RimLight_Power("Power: RimLight",Range(0, 1))                              = 0.5
        _Ap_RimLight_Power("Power: Ap RimLight",Range(0, 1))                        = 1
        _RimLight_InsideMask("Mask: Inside rimLight",Range(0.00001, 1))             = 0.3
        _RimLightAreaOffset("--Offset: RimLight",Range(-1, 1))                      = 0
        [Toggle(_)] _LightDirection_MaskOn("Use light direction",Int)               = 1
        _Tweak_LightDirection_MaskLevel("--Mask: Light direction",Range(0, 1))      = 0

        [Header(Matcap)]
        [Enum(Off,0,On,1)] _MatCap("Use MatCap", Int )                          = 0
        [HDR] _MatCapColMult ("Diffuse matcap", Color)                          = (1,1,1,1) 
        [NoScaleOffset] _MatCapTexMult ("Diffuse color", 2D)                    = "black" {}
        [HDR] _MatCapColAdd ("Specular matcap", Color)                          = (1,1,1,1)
        [NoScaleOffset] _MatCapTexAdd ("Specular color", 2D)                    = "black" {}
        [HDR] _MatCapColEmis ("Emissive matcap", Color)                         = (1,1,1,1)
        [NoScaleOffset] _MatCapTexEmis ("Emissive matcap", 2D)                  = "black" {}
        [Toggle(_)] _Is_NormalMapForMatCap("Use matcap normalMap ", Float )     = 0
        _NormalMapForMatCap("--MatCap normalMap", 2D)                           = "bump" {}
        [Space(9)]
        _Tweak_MatCapUV("Zoom matCap", Range(-0.5, 0.5))                        = 0
        _Rotate_MatCapUV("Rotate matCap", Range(-1, 1))                         = 0
        _Rotate_NormalMapForMatCapUV("Rotate normalMap matCap", Range(-1, 1))   = 0
        _TweakMatCapOnShadow("Specular Shadow mask", Range(0, 1))               = 0
        _Set_MatcapMask("Matcap Diffuse mask (G)", 2D)                          = "white" {}
        _Tweak_MatcapMaskLevel("--Tweak Mask", Range(-1, 1))                    = 0

        [Header(Emission)]
        [HDR] _Emissive_Color("Emissive color", Color)                          = (0,0,0,1)
        [HDR] _EmissiveProportional_Color("Emissive Proportional color", Color) = (0,0,0,1)
        _Emissive_Tex("Emissive mask (G)", 2D)                                  = "white" {}
        _EmissionColorTex("--Emissive color (RGB)", 2D)                         = "white" {}

        [Header(Dynamic Shadow control)]
        _shadowCastMin_black("Dynamic Shadow Removal",Range(0.0,1.0))          = 0.1
        [NoScaleOffset] _DynamicShadowMask("--Dynamic Shadow mask",2D)         = "white" {}

        [Header(Light Map Shift Masks)]
        [Enum(Off,0,On,1,Use Vertex Color Red,2)] _UseLightMap("Light Map mode", Int)   = 0
        _LightMap("Light map mask (G)", 2D)                                             = "gray" {}
        _lightMap_remapArr("--Range: (Z):LOW, (W):HIGH", Vector)                        = (-1,-1,0,1)
        // _lightMapCenter("--Mask pivot",Range(-0.5, 0.5))                             = 0
        _toonLambAry_01("----forward regraph: (X)C1+(Y) | (Z)C2+(W)", Vector)           = (1.2, -0.1, -1, -1)
        _toonLambAry_02("----back regraph: (X)C1+(Y) | (Z)C2+(W)", Vector)              = (2.0, 0.1, -1, -1)
        [NoScaleOffset] _Set_1st_ShadePosition("Forward Toon Shadows (G)", 2D)          = "white" {}
        [NoScaleOffset] _Set_2nd_ShadePosition("Backward Toon Shadow (G)", 2D)          = "white" {}
        
        [Header(Ambient Occlusion Maps)]
        _Set_HighColorMask("Specular Mask (G)", 2D)                     = "white" {}
        _Tweak_HighColorMaskLevel("--Tweak Mask", Range(-1, 1))         = 0
        _Set_RimLightMask("RimLight Mask (G)", 2D)                      = "white" {}
        _Tweak_RimLightMaskLevel("--Tweak Mask", Range(-1, 1))          = 0

        [Header(Normal map)]
        _NormalMap("NormalMap", 2D)                                 = "bump" {}
        _DetailNormalMapScale01("--Detail scale", Range(0,1))       = 0
        _NormalMapDetail("----Detail Normal map", 2d)               = "bump" {}
        _DetailNormalMask("----Detail Mask (G)", 2d)                = "white" {}
        [Toggle(_)] _Is_NormalMapToBase ("On Toon",Int)             = 1
        [Toggle(_)] _Is_NormalMapToHighColor("On High Color",Int)   = 1
        [Toggle(_)] _Is_NormalMapToRimLight("On Rims",Int)          = 1
        [Toggle(_)] _Is_NormaMapToEnv("On Reflection",Int)          = 1

        [Header(Alpha mask)]
        [Space(18)]
        // [Enum(Off,0,On,1)] _ZWrite("Z Write Depth sorting (Recommend off)",Int)     = 1
        [Enum(Clipping Mask,0,Main Texture,1)] _IsBaseMapAlphaAsClippingMask("Alpha mask source",Int)   = 1
        _ClippingMask("--Clipping mask (G)",2D)                                     = "white" {}
        [Toggle(_)] _Inverse_Clipping("Inverse clipping", Float )                   = 0
        _Clipping_Level("Clipping level", Range(0, 1))                              = 0 
        _Tweak_transparency("--Tweak transparency", Range(-1, 1))                   = 0
        [Space(18)]
        // [Toggle(_)] _UseSpecAlpha("Use specular Alpha",Float)                       = 0
        [Toggle(_)] _DetachShadowClipping("Separate Shadow Clipping Level",Int)     = 0
        _Clipping_Level_Shadow("--Shadow Clip", Range(0, 1))                        = 1

        [Header(Stencil Helpers. Requires Queue Order Edits)]
        _Stencil("Stencil ID [0;255]", Range(0,255))                                        = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("--Comparison", Int)     = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("--Pass", Int)                   = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFail("--Fail", Int)                 = 0
    }






    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }



        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One Zero
            Cull[_CullMode]
            ZWrite on

            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                Fail [_StencilFail]
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma multi_compile UNITY_PASS_FORWARDBASE
            #define IsClip
            #include "ACLS_CORE.cginc"
            ENDCG
        }



        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull[_CullMode]
            ZWrite off

            Stencil
            {
                Ref [_Stencil]
                Comp [_StencilComp]
                Pass [_StencilOp]
                Fail [_StencilFail]
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma multi_compile UNITY_PASS_FORWARDADD
            #define IsClip
            #include "ACLS_CORE.cginc"
            ENDCG
        }



        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1 ,  80
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_shadowcaster
            #define IsClip
            #include "ACLS_ShadowCaster.cginc"
            ENDCG
        }
    }
    FallBack "Legacy Shaders/VertexLit"
}