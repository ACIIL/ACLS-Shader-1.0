using UnityEditor;
using UnityEngine;
// using System.Collections;
// using System.Collections.Generic;
// using System.Linq;
// using System;
using System.Reflection;

// Base prepared by Morioh for me.
// This code is based off synqark's arktoon-shaders and Xiexe. 
// Citation to "https://github.com/synqark", "https://github.com/synqark/arktoon-shaders", https://gitlab.com/xMorioh/moriohs-toon-shader.

public class ACLSInspector : ShaderGUI
{
    BindingFlags bindingFlags = BindingFlags.Public |
                                BindingFlags.NonPublic |
                                BindingFlags.Instance |
                                BindingFlags.Static;
    // Toon ramp
    MaterialProperty _CullMode = null;
    MaterialProperty _backFaceColorTint = null;
    MaterialProperty _Use_BaseAs1st = null;
    MaterialProperty _1st_ShadeMap = null;
    MaterialProperty _Use_1stAs2nd = null;
    MaterialProperty _2nd_ShadeMap = null;
    MaterialProperty _MainTex = null;
    MaterialProperty _Color = null;
    MaterialProperty _0_ShadeColor = null;
    MaterialProperty _1st_ShadeColor = null;
    MaterialProperty _2nd_ShadeColor = null;
    MaterialProperty _BaseColor_Step = null;
    MaterialProperty _BaseShade_Feather = null;
    MaterialProperty _ShadeColor_Step = null;
    MaterialProperty _1st2nd_Shades_Feather = null;
    MaterialProperty _ToonRampLightSourceType_Backwards = null;
    MaterialProperty _diffuseIndirectDirectSimMix = null;
    MaterialProperty _Diff_GSF_01 = null;
    MaterialProperty _DiffGSF_Offset = null;
    MaterialProperty _DiffGSF_Feather = null;
    // Specular Shine
    MaterialProperty _UseSpecularSystem = null;
    MaterialProperty _Is_BlendAddToHiColor = null;
    MaterialProperty _SpecColor = null;
    MaterialProperty _Glossiness = null;
    MaterialProperty _HighColor_Tex = null;
    MaterialProperty _highColTexSource = null;
    MaterialProperty _SpecularMaskHSV = null;
    MaterialProperty _HighColor = null;
    MaterialProperty _Is_SpecularToHighColor = null;
    MaterialProperty _TweakHighColorOnShadow = null;
    // Reflection
    MaterialProperty _useCubeMap = null;
    MaterialProperty _ENVMmode = null;
    MaterialProperty _ENVMix = null;
    MaterialProperty _envRoughness = null;
    MaterialProperty _CubemapFallbackMode = null;
    MaterialProperty _CubemapFallback = null;
    MaterialProperty _EnvGrazeMix = null;
    MaterialProperty _EnvGrazeRimMix = null;
    MaterialProperty _envOnRim = null;
    MaterialProperty _envOnRimColorize = null;
    // Rimlights
    MaterialProperty _RimLight = null;
    MaterialProperty _Add_Antipodean_RimLight = null;
    MaterialProperty _rimAlbedoMix = null;
    MaterialProperty _RimLightSource = null;
    MaterialProperty _RimLightColor = null;
    MaterialProperty _Ap_RimLightColor = null;
    MaterialProperty _RimLight_Power = null;
    MaterialProperty _Ap_RimLight_Power = null;
    MaterialProperty _RimLight_InsideMask = null;
    MaterialProperty _RimLightAreaOffset = null;
    MaterialProperty _LightDirection_MaskOn = null;
    MaterialProperty _Tweak_LightDirection_MaskLevel = null;
    MaterialProperty _rimLightLightsourceType = null;
    // Matcap
    MaterialProperty _MatCap = null;
    MaterialProperty _MatCapColMult = null;
    MaterialProperty _MatCapTexMult = null;
    MaterialProperty _MatCapColAdd = null;
    MaterialProperty _MatCapTexAdd = null;
    MaterialProperty _MatCapColEmis = null;
    MaterialProperty _MatCapTexEmis = null;
    MaterialProperty _Is_NormalMapForMatCap = null;
    MaterialProperty _NormalMapForMatCap = null;
    MaterialProperty _Tweak_MatCapUV = null;
    MaterialProperty _Rotate_MatCapUV = null;
    MaterialProperty _Rotate_NormalMapForMatCapUV = null;
    MaterialProperty _TweakMatCapOnShadow = null;
    MaterialProperty _Set_MatcapMask = null;
    MaterialProperty _Tweak_MatcapMaskLevel = null;
    MaterialProperty _McDiffAlbedoMix = null;
    // Emission
    MaterialProperty _Emissive_Color = null;
    MaterialProperty _EmissiveProportional_Color = null;
    MaterialProperty _Emissive_Tex = null;
    MaterialProperty _EmissionColorTex = null;
    MaterialProperty _emissiveUseMainTexA = null;
    MaterialProperty _emissiveUseMainTexCol = null;
    // Lighting Behaviour
    MaterialProperty _directLightIntensity = null;
    MaterialProperty _indirectAlbedoMaxAveScale = null;
    MaterialProperty _forceLightClamp = null;
    MaterialProperty _BlendOp = null;
    MaterialProperty _shadowCastMin_black = null;
    MaterialProperty _DynamicShadowMask = null;
    MaterialProperty _shadowUseCustomRampNDL = null;
    MaterialProperty _shadowNDLStep = null;
    MaterialProperty _shadowNDLFeather = null;
    MaterialProperty _shadowMaskPinch = null;
    MaterialProperty _shadowSplits = null;

    MaterialProperty _indirectGIDirectionalMix = null;
    MaterialProperty _indirectGIBlur = null;
    // Light Map Shift Masks
    MaterialProperty _UseLightMap = null;
    MaterialProperty _LightMap = null;
    MaterialProperty _lightMap_remapArr = null;
    MaterialProperty _toonLambAry_01 = null;
    MaterialProperty _toonLambAry_02 = null;
    MaterialProperty _Set_1st_ShadePosition = null;
    MaterialProperty _Set_2nd_ShadePosition = null;
    // Ambient Occlusion Maps
    MaterialProperty _Set_HighColorMask = null;
    MaterialProperty _Tweak_HighColorMaskLevel = null;
    MaterialProperty _Set_RimLightMask = null;
    MaterialProperty _Tweak_RimLightMaskLevel = null;
    // Normal map
    MaterialProperty _NormalMap = null;
    MaterialProperty _DetailNormalMapScale01 = null;
    MaterialProperty _NormalMapDetail = null;
    MaterialProperty _DetailNormalMask = null;
    MaterialProperty _Is_NormalMapToBase = null;
    MaterialProperty _Is_NormalMapToHighColor = null;
    MaterialProperty _Is_NormalMapToRimLight = null;
    MaterialProperty _Is_NormaMapToEnv = null;
    // Alpha mask
    MaterialProperty _ZWrite = null;
    MaterialProperty _IsBaseMapAlphaAsClippingMask = null;
    MaterialProperty _ClippingMask = null;
    MaterialProperty _Inverse_Clipping = null;
    MaterialProperty _Clipping_Level = null;
    MaterialProperty _Tweak_transparency = null;
    MaterialProperty _UseSpecAlpha = null;
    MaterialProperty _DetachShadowClipping = null;
    MaterialProperty _Clipping_Level_Shadow = null;
    // Stencil Helpers. Requires Queue Order Edits
    MaterialProperty _Stencil = null;
    MaterialProperty _StencilComp = null;
    MaterialProperty _StencilOp = null;
    MaterialProperty _StencilFail = null;
    //
    static bool showToonramp = true;
    static bool showSpecularShine = false;
    static bool showReflection = false;
    static bool showRimlights = false;
    static bool showMatcap = false;
    static bool showEmission = false;
    static bool showLightingBehaviour = false;
    static bool showLightMapShiftMasks = false;
    static bool showAmbientOcclusionMaps = false;
    static bool showNormalmap = false;
    static bool showAlphamask = false;
    static bool StencilHelpers = false;

    // static bool showBlahA = false;
    // static bool showBlahB = false;
    // static bool showBlahC = false;

    // test
    // static int testInt = 1337;

    //
    bool iscutout = false;
    bool iscutoutAlpha = false;
    bool isDither = false;
    // bool issolid = false;


    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        // float whatThis = (float)(EditorGUI.GetField("kIndentPerLevel").GetRawConstantValue()); 
        // Debug.Log("blah " + whatThis);
        Material material = materialEditor.target as Material;
        Shader shader = material.shader;

        iscutout = shader.name.Contains("ACLS_Toon_Cutout");
        iscutoutAlpha = shader.name.Contains("ACLS_Toon_AlphaTransparent");
        isDither = shader.name.Contains("ACLS_Toon_AlphaCutout_Dither");
        // issolid = shader.name.Contains("ACLS_Toon_Solid");
        //
        foreach (var property in GetType().GetFields(bindingFlags)) 
        {                                                           
            if (property.FieldType == typeof(MaterialProperty))
            {
                try{ property.SetValue(this, FindProperty(property.Name, props)); } catch { /*Is it really a problem if it doesn't exist?*/ }
            }
        }
        //
        EditorGUI.BeginChangeCheck();
        {
            ACLStyles.ShurikenHeaderCentered(ACLStyles.ver);
            // EditorGUILayout.LabelField("New value----------------------------------------------------------------------");
            // EditorGUILayout.HelpBox("BLAH BLAH BLAH BLAH", MessageType.None, true);
            // testInt = EditorGUILayout.IntField(testInt);

            showLightingBehaviour = ACLStyles.ShurikenFoldout("General Lighting Behaviour", showLightingBehaviour);
            // if (showLightingBehaviour)
            // {
            //     EditorGUILayout.LabelField("foo");
            //     showBlahA = ACLStyles.ShurikenFoldout("blah tab A", showBlahA, EditorGUI.indentLevel);
            //     EditorGUI.indentLevel++;
            //     if (showBlahA)
            //     {
            //         EditorGUILayout.LabelField("foo");
            //         showBlahB = ACLStyles.ShurikenFoldout("blah tab B", showBlahB, EditorGUI.indentLevel);
            //         EditorGUI.indentLevel++;
            //         if(showBlahB)
            //         {
            //             EditorGUILayout.LabelField("foo");
            //             showBlahC = ACLStyles.ShurikenFoldout("blah tab C", showBlahC, EditorGUI.indentLevel);
            //             EditorGUI.indentLevel++;
            //             if(showBlahC)
            //             {
            //                 EditorGUILayout.LabelField("baz");
            //             }
            //             EditorGUI.indentLevel--;
            //             EditorGUILayout.LabelField("bar");
            //         }
            //         EditorGUI.indentLevel--;
            //         EditorGUILayout.LabelField("bar");
            //     }
            //     EditorGUI.indentLevel--;
            //     EditorGUILayout.LabelField("bar");
            // }
            if (showLightingBehaviour)
            {
                materialEditor.ShaderProperty(_CullMode, new GUIContent("Cull Mode", "Culling backward/forward/no faces"));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_backFaceColorTint, new GUIContent("Backface Color Tint", "Back face color. Use to tint backfaces in certain mesh setups.\nRecommend creating actual backface mesh as backfaces reveals depth sorting issues and line artifacts."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_shadowCastMin_black, new GUIContent("Dynamic Shadows Removal", "Counters undesirable hard dynamic shadow constrasts for NPR styles in maps with strong direct:ambient light contrasts.\nModifies direct light dynamic shadows behaviour: Each Directional/Point/Spot light in the scene has its own shadow settings and this slider at 1.0 \"brightens\" shadows away.\nUse 0.0 for intended PBR."));
                materialEditor.TexturePropertySingleLine(new GUIContent("Dynamic Shadows Mask (G)", "Works like Realtime Shadows Removal. Texture brightness removes like the slider value."), _DynamicShadowMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_DynamicShadowMask);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_shadowUseCustomRampNDL, new GUIContent("Dynamic shadow Backface","Force natural PBR Dynamic Shadowcast when surface is away from Direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_shadowNDLStep,new GUIContent("Step of Shadow","Angle Shadow Falloff begins.\nRecommend setting so complete shadow is perpendicular to light.\nDefault: 1. NPR: 0.52"));
                materialEditor.ShaderProperty(_shadowNDLFeather,new GUIContent("Feather of Shadow","Softness of Dynamic shadow. Recommend adjesting so complete shadow is perpendicular to light.\nDefault: 0.5. NPR: 0.025"));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_shadowSplits,new GUIContent("Shadow Steps","Use this for stylizing NPR by settings \"Steps\" of intensity."));
                materialEditor.ShaderProperty(_shadowMaskPinch,new GUIContent("Shadow Pinch","\"Pinches\" the frindge zone were shadow transitions from nothing to complete.\nUse this to stylize shadow as NPR."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_TweakHighColorOnShadow, new GUIContent("Specular Shadow Reactivity", "Affects Shine lobe's dimming in dynamic shadow. 0.0 is ignore dynamic shadows completely."));
                materialEditor.ShaderProperty(_TweakMatCapOnShadow, new GUIContent("Specular Matcap Shadow Reactivity", "Specular matcaps visibility in dynamic shadow. This depends on context looking like it reacts to direct light or not. 0.0 ignores masking by dynamic shadows."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_directLightIntensity, new GUIContent("Direct Light Intensity", "Soft counter for overbright maps. Dim direct light sources and thus rely more on map ambient."));
                materialEditor.ShaderProperty(_indirectAlbedoMaxAveScale, new GUIContent("Static GI Max:Ave", "How overall Indirect light is sampled by object, abstracted to two sources \"Max\" or \"Average\" color, is used on Diffuse (Toon Ramping).\n1: Use Max color with Average intelligently.\n>1:Strongly switch to Average color as Max color scales brighter, which matches a few NPR shaders behaviour and darkness."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_indirectGIDirectionalMix, new GUIContent("Indirect GI Directionality", "How Indirect light is sampled in the scene.\n0: Use a simple statistical color by object position.\n1: Use surface angle to light, which is PBR."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_indirectGIBlur, new GUIContent("Angular GI Blur", "Default 1.\nRaise to blur Indirect GI and reduce distinctness of surface angle. Good for converting Indirect GI from PRB to NPR."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_ToonRampLightSourceType_Backwards, new GUIContent("Diffuse Backwards Light Mode", "For pbr/npr effects on diffuse backface area.\nAll Light: Adds direct(with shadows) and ambient light together.\nNatural ambient: Closer to PBR, backface is only Indirect(ambient) light as there is realistically no direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_diffuseIndirectDirectSimMix, new GUIContent("Mix Direct Light", "Mix Direct Light into Backward Area by amount. A NPR helper to assist Core & Backward's Step/Feather setting's wrap distribution on Indirect light."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_forceLightClamp, new GUIContent("Scene Light Clamping", "Hard Counter for overbright maps.\nHDR: When map has correctly setup \"Exposure High Definition Range (HDR)\": balancing brightness with post proccess in a realistic range.\nLimit: Prevention when map overblows your avatar colors or you glow. These maps typically attempted \"Low Definition Range (LDR)\" light levelling, were it assumes scene lights are never over 100% white and toon shaders may clamp to 100% as enforcement rule, and that only emission light goes over 100% which causes bloom."));
                if (!(iscutoutAlpha)){
                    materialEditor.ShaderProperty(_BlendOp, new GUIContent("Additional Lights Blending", "How realtime Point and Spot lights combine color.\nRecommend MAX for NPR lighting that reduces overblowing color in none \"Exposure HDR\" maps (See Scene Light clamping for def).\nAdd: PBR,If you trust the maps lighting set for correct light adding.\nNot usable in Alpha Transparent due to Premultiply alpha blending needing ADD."));
                }
                else{
                    EditorGUILayout.LabelField("[Disabled] Additional Lights Blending");
                }
            }

            showToonramp = ACLStyles.ShurikenFoldout("Diffuse Reflection. Toon Ramp Effects", showToonramp);
            if (showToonramp)
            {
                // materialEditor.ShaderProperty(_CullMode, _CullMode.displayName);
                materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture(Forward)", "Main texture. As Forward Area intended for surface most towards light and the visual effect of being in direct light."), _MainTex);
                // materialEditor.TexturePropertySingleLine(new GUIContent("Main Tex", ""), _MainTex, _Color);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_MainTex);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Use_BaseAs1st, new GUIContent("Core Source", "Unless you have custom set to MainTex."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Core Texture", "If used as source. A NPR helper, \"Core Area\' is intended as the core area were light slowly angles perpendicular and artistically painted NPR effects may occur, for example painted subsurface colouring as light penetrates the acute surface and emits within the surface, or shadows may be painted to hint ambient occlusion(where light cannot enter and leave this sharp angle)."), _1st_ShadeMap);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Use_1stAs2nd, new GUIContent("Backward Source", "Unless you have custom set to MainTex."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Backward Texture", "If used as source. A NPR helper, \"Backwards Area\' is intended as the area were direct light cannot hit and artistically painted represents ambient light and no painted on shadows."), _2nd_ShadeMap);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Color, new GUIContent("Primary Diffuse Color", "Primary diffuse color control."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_0_ShadeColor, new GUIContent("Forward Color", "See Main (Forward) Texture tooltip."));
                materialEditor.ShaderProperty(_1st_ShadeColor, new GUIContent("Core Color", "See Core Texture tooltip."));
                materialEditor.ShaderProperty(_2nd_ShadeColor, new GUIContent("Backward Color", "See Backword Texture tooltip."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_BaseColor_Step, new GUIContent("Step Core", "Were Forward Area blends to Core and Core overwraps Backwards Area\n0.5 is perpendicular to direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BaseShade_Feather, new GUIContent("Feather Core", "Softens warp. Wraps away from light, so increase Step Core as you soften."));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_ShadeColor_Step, new GUIContent("Step Backward", "Were Backward Area blends behind & within Core Area.\n0.5 is perpendicular to direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_1st2nd_Shades_Feather, new GUIContent("Feather Backward", "Softens warp. Wraps away from light, so increase Backwards Step as you soften."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_Diff_GSF_01, new GUIContent("Diffuse GSF Effect",  "Custom Geometric Shadowing Function (GSF) effect to simulate darkening or tinting of diffuse light in rough or penetrable surfaces at acute angles.\nEnabling will reveal The true mixing of regions between Forward/Core/Backaward Areas. Use this to help setup NPR cloth/skin/subsurface/iridescents setups."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_DiffGSF_Offset, new GUIContent("Offset GSF", "Offset were GSF begins. You may need to use wide values."));
                materialEditor.ShaderProperty(_DiffGSF_Feather, new GUIContent("Feather GSF", "Blurs GSF"));
                EditorGUI.indentLevel--;
            }

            showLightMapShiftMasks = ACLStyles.ShurikenFoldout("Diffuse Light Shift Masks", showLightMapShiftMasks);
            if (showLightMapShiftMasks)
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Core AO (G)", "Manually forces diffuse \"Forwards\' Area to \'Core\' Area. Use to manually blend toon shadows by texture UV dynamically and union to light angle... which typically if painted on looks \"baked\" or unrealistic.\nYou may use a Ambient Occlusion Texture for this."), _Set_1st_ShadePosition);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_Set_1st_ShadePosition);
                // EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Backward AO (G)", "Manually forces diffuse \"Core\' Area to \'Backwards\' Area. Use to manually blend toon shadows by texture UV dynamically and union to light angle... which typically if painted on looks \"baked\" or unrealistic.\nYou may use a Ambient Occlusion Texture for this."), _Set_2nd_ShadePosition);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_Set_2nd_ShadePosition);
                // EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_UseLightMap, new GUIContent("LightMap Mode", "Overrides Diffuse NPR/PBR toon ramp wrapping according to intensity like a dynamic ambient occlusion (AO) mask which react to light direction onto the surface.\nScaled so 50% gray is no change, 100% white is bias towards Forward area, and 0% black is bias towards Backward Area.\nUse this Like a dynamic and reactive ambient occlusion mask to finely control NPR behaviour on diffuse.\nSetup: Define the diffuse area colors; set Core and Backward Steps to 0.5 (and Feather 0.0 for debug); apply & enable the light map from a AO mask; then finely control the Relevel's below for contolled diffuse wrapping."));
                 EditorGUILayout.HelpBox("However LightMap Mode for usage and setup.", MessageType.None, true);
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("LightMap Mask (G)", ""), _LightMap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_LightMap);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_lightMap_remapArr, new GUIContent("Remap Levels", "Relevel texture high and low intensities to a [0,1] clamp.\nAdjust [Z] for low blacks and [W] for high whites."));
                EditorGUILayout.HelpBox("Relevel texture high and low intensities to a [0,1] clamp.\nAdjust [Z] for low blacks and [W] for high whites.", MessageType.None, true);
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_toonLambAry_01, new GUIContent("Core Remap", "Maps the LightMap intensity to Core ramp.\nOutput = [X] * (Input) + [Y]"));
                materialEditor.ShaderProperty(_toonLambAry_02, new GUIContent("Backward Remap", "Maps the LightMap intensity to Backward ramp.\nOutput = [X] * (Input) + [Y]"));
                EditorGUILayout.HelpBox("These adjest the LightMap Mask to Core and Backword Area toon ramps.\nOutput = [X] * (Input) + [Y]", MessageType.None, true);
            }

            showSpecularShine = ACLStyles.ShurikenFoldout("Specular Reflection", showSpecularShine);
            if (showSpecularShine)
            {
                materialEditor.ShaderProperty(_UseSpecularSystem, new GUIContent("Enable Specular", "Enables The direct light and Cubemap effects. Off effectively sets Primary Specular Color black which means both are off."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_Is_BlendAddToHiColor, new GUIContent("Energy Conservation", "PBR and follows Standard Shader. Where specular Mask intensity dims diffuse color."));
                materialEditor.ShaderProperty(_SpecColor, new GUIContent("Primary Specular Color", "Applies tint on Specular shine and Cubemap color."));
                materialEditor.ShaderProperty(_Glossiness, new GUIContent("Smoothness", "Follows Standard. Higher reflects the world more perfectly. Affects Shine lobe and Cubemap."));
                materialEditor.TexturePropertySingleLine(new GUIContent("Specular Mask(RGB). Smoothness(A)", "You must know how \"specular setup\" works. (RGB) intensity means more metallic, lower color saturation means more metallic (reflects without tint from surface). (A) is Smoothness value."), _HighColor_Tex);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_HighColor_Tex);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_highColTexSource, new GUIContent("Blend Albedo", "If you dont have a custom spec mask, you may borrow and blend the diffuse textures.\nI recommend modifying (V) against pixel darkness, (I) for white intensity, (S) for metallicness."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_SpecularMaskHSV, new GUIContent("Texture (HSVI)", ""));
                EditorGUILayout.HelpBox("XYZW -> HSVI. Color adjestment when Blending from Albedo.", MessageType.None, true);
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_HighColor, new GUIContent("Shine Tint", "Multiplies over Shines color intensity and tints. Can use to shut it off (use black), or overpower in HDR (for controlling Sharp and Soft mode)."));
                materialEditor.ShaderProperty(_Is_SpecularToHighColor, new GUIContent("Specular Shine Type", "Override Shape and Soft brightness with Shine Tint.\nSharp: Toony\nSoft: Simple and subtle lode\nUnity: Follow Unity's PBR"));
            }

            showReflection = ACLStyles.ShurikenFoldout("Cubemap Reflection Behavour", showReflection);
            if (showReflection)
            {
                materialEditor.ShaderProperty(_useCubeMap, new GUIContent("Use Cubemap", "Enable sampling of CubeMap."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_ENVMmode, new GUIContent("Control Method", "Standard: Follows Standard Shader formula.\nOverride: You define Intensity and Roughness exactly and Intensitys follow roughness formula."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_ENVMix, new GUIContent("Intensity", "With Standard: Rescales value by this.\nWith Override: Replace the value from smoothness and ignores roughness mask (can use this to blur Cubemap into abstract tone)."));
                materialEditor.ShaderProperty(_envRoughness, new GUIContent("Roughness", "For Override only."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_CubemapFallbackMode, new GUIContent("Fallback Mode", "Fallback Cubemap intensifies to average lighting.\nSmart: Enables when map gives nothing.\nAlways: Always override with custom."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Fallback Cubemap", ""), _CubemapFallback);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_CubemapFallback);
                // // EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_EnvGrazeMix, new GUIContent("Use Natural Fresnel", "Natural unmaskable specular at sharp angles linked to Specular."));
                materialEditor.ShaderProperty(_EnvGrazeRimMix, new GUIContent("Use RimLight Fresnel", "Unmaskable specular at sharp angles linked to Specular. Uses Rim Lighting visibility as mask."));

            }

            showRimlights = ACLStyles.ShurikenFoldout("Rim Lighting (Simplified Cubemap Fresnel Effects)", showRimlights);
            if (showRimlights)
            {
                materialEditor.ShaderProperty(_RimLight, new GUIContent("Enable RimLight +", "Rimming towards light source.\nAlso activates this as mask for Cubemap Fresnel."));
                materialEditor.ShaderProperty(_Add_Antipodean_RimLight, new GUIContent("Enable RimLight -", "Rimming away from light source.\nAlso activates this as mask for Cubemap Fresnel."));
                materialEditor.ShaderProperty(_rimAlbedoMix, new GUIContent("Mix texture", "Mix to tint RimLight by source texture."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_RimLightSource, new GUIContent("Texture source", "Diffuse: Good for Matching Skin\"subsurface\" tones.\nSpecular: Good to match metallic tones as set in your Specular Reflection settings."));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_RimLightColor, new GUIContent("Color +", ""));
                materialEditor.ShaderProperty(_Ap_RimLightColor, new GUIContent("Color - ", ""));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_LightDirection_MaskOn, new GUIContent("Light direction mode", "Enables masking by light direction and dual + and - mode. Off makes + a simple overrap."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_Tweak_LightDirection_MaskLevel, new GUIContent("Polarize", "Split + and - more by light direction."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_RimLight_Power, new GUIContent("Power +", "Wrapping curvature"));
                materialEditor.ShaderProperty(_Ap_RimLight_Power, new GUIContent("Power -", "Wrapping curvature"));
                materialEditor.ShaderProperty(_RimLight_InsideMask, new GUIContent("Sharpness", "Tampers falloff to a shaper edge. Good for toony lines."));
                materialEditor.ShaderProperty(_RimLightAreaOffset, new GUIContent("Offset Wrap", "Shifts RimLights \"warp\". To control how the high and low of the rim curve appear."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_rimLightLightsourceType, new GUIContent("Light Type: Diffuse:Cubemap", "Light Rim Lights like a surface diffuse or Cubemap. First good for subsurface effects and 2nd for metallic/smoothness effect."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_envOnRim, new GUIContent("Mask by Cubemap", "Masks Rim Lighting by Cubemap colors. Uses Cubemap settings (even its off as a specular effect). I recommend overriding Cubemap Fallback and Roughness settings when applying this."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_envOnRimColorize, new GUIContent("Colorize by Cubemap", "Give Cubemap Color to tint RimLight."));
                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
            }

            showMatcap = ACLStyles.ShurikenFoldout("Matcaps", showMatcap);
            if (showMatcap)
            {
                materialEditor.ShaderProperty(_MatCap, new GUIContent("Use Matcaps", "Uses all or none. (Currently this to simplify solving 3 unique matcap systems and hit performance)"));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Type (Multiplies)", "Use this for \"baked\" toon ramp, subsurface, or iridescent Matcaps. It multiplies on the Diffuse Texture and then adds result. Lighting is Direct(with shadows) + Indirect.\nMasked by Diffuse Matcap Mask."), _MatCapTexMult, _MatCapColMult);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_MatCapTexMult);
                // EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Specular Type (Additive)", "Use this for \"baked\" Specular Reflection Matcaps. Intensity works like Cubemap Fallback.\nMasked by Global Specular Mask."), _MatCapTexAdd, _MatCapColAdd);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_MatCapTexAdd);
                // EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Emission Type", "Adds in texture and scales to HDR Color as set.\nMasked by Emission masks."), _MatCapTexEmis, _MatCapColEmis);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_MatCapTexEmis);
                // EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_Tweak_MatCapUV, new GUIContent("Scale UV", ""));
                materialEditor.ShaderProperty(_Rotate_MatCapUV, new GUIContent("Rotate UV", ""));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_Is_NormalMapForMatCap, new GUIContent("Use Normalmap", "Distort Matcaps by unique Normals."));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMapForMatCap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMapForMatCap);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Rotate_NormalMapForMatCapUV, new GUIContent("Rotate UV", ""));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask Diffuse Matcap", ""), _Set_MatcapMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_MatcapMask);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Tweak_MatcapMaskLevel, new GUIContent("Tweak Mask", ""));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_McDiffAlbedoMix, new GUIContent("Diffuse Albedo Mix", "How much of diffuse texture to mix in diffuse matcap."));

            }

            showEmission = ACLStyles.ShurikenFoldout("Emission", showEmission);
            if (showEmission)
            {
                materialEditor.ShaderProperty(_Emissive_Color, new GUIContent("Color", ""));
                materialEditor.ShaderProperty(_EmissiveProportional_Color, new GUIContent("Proportional color", "For Unrealistic proportional glow to world brightness. Scales color to the average lighting. You might want intensity higher than Emission Color."));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Color Tint (RGB)", "Source glow color."), _EmissionColorTex);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_EmissionColorTex);
                EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Area mask (G)", "A stronger override mask. If set bright areas will only glow. Can use this for pairing random Color Tint textures."), _Emissive_Tex);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Emissive_Tex);
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_emissiveUseMainTexA, new GUIContent("Mask from MainTex(A)", ""));
                materialEditor.ShaderProperty(_emissiveUseMainTexCol, new GUIContent("Tint from MainTex(RGBA)", ""));
            }

            showAmbientOcclusionMaps = ACLStyles.ShurikenFoldout("General Effect Masks", showAmbientOcclusionMaps);
            if (showAmbientOcclusionMaps)
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Global Specular Mask", "Hides all specular output.\nAlso masks Specular Matcap."), _Set_HighColorMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_HighColorMask);
                materialEditor.ShaderProperty(_Tweak_HighColorMaskLevel, new GUIContent("Tweak Mask", ""));
                EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Rim Light Mask", ""), _Set_RimLightMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_RimLightMask);
                materialEditor.ShaderProperty(_Tweak_RimLightMaskLevel, new GUIContent("Tweak Mask", ""));
                EditorGUI.indentLevel--;
            }

            showNormalmap = ACLStyles.ShurikenFoldout("Normal Map", showNormalmap);
            if (showNormalmap)
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMap);
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_DetailNormalMapScale01, new GUIContent("Detail Scaling", "None 0.0 enables the Detail Normal Map."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Detail Normal Map", ""), _NormalMapDetail);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMapDetail);
                EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("Detail Mask (G)", ""), _DetailNormalMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_DetailNormalMask);
                EditorGUI.indentLevel-=2;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_Is_NormalMapToBase, new GUIContent("Apply to Diffuse", ""));
                materialEditor.ShaderProperty(_Is_NormalMapToHighColor, new GUIContent("Apply to Specular", ""));
                materialEditor.ShaderProperty(_Is_NormalMapToRimLight, new GUIContent("Apply to Rim Lights", "When used alone can allow a NPR \"weavy\" rim effect."));
                materialEditor.ShaderProperty(_Is_NormaMapToEnv, new GUIContent("Apply to Cubemap", "Disable for a cheap NPR glossy effect against normalmapped others."));
            }

            if (iscutout || iscutoutAlpha || isDither)
            {
                showAlphamask = ACLStyles.ShurikenFoldout("Alpha Settings", showAlphamask);
                if (showAlphamask)
                {
                    if (iscutoutAlpha)
                    {
                        materialEditor.ShaderProperty(_ZWrite, new GUIContent("ZWrite", "Depth sorting. Recommend Off for alpha mesh that does not overlay self.\nOn: when strange sort layering happens.\nUsing Transparency Render Queue requires having this off."));
                        ACLStyles.PartingLine();
                    }
                    materialEditor.ShaderProperty(_IsBaseMapAlphaAsClippingMask, new GUIContent("Alpha Mask Source", "Main Texture: The typical source alpha.\nClipping mask: Use a swappable alpha mask if you reuse a Diffuse Main Texture that wants variant alpha cutout zones... such as outfit masking."));
                    EditorGUI.indentLevel++;
                    materialEditor.TexturePropertySingleLine(new GUIContent("Clipping mask (G)", "If used. As a Alpha Mask Black 0.0 is invisible"), _ClippingMask);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_ClippingMask);
                    EditorGUI.indentLevel-=2;
                    ACLStyles.PartingLine();
                    materialEditor.ShaderProperty(_Inverse_Clipping, new GUIContent("Inverse Alpha", ""));
                    materialEditor.ShaderProperty(_Clipping_Level, new GUIContent("Cutout level", "Clip out mesh were alpha is below this."));
                    materialEditor.ShaderProperty(_Tweak_transparency, new GUIContent("Tweak Alpha", "Fine tune visible alpha. Good for Dithering adjustment."));
                    ACLStyles.PartingLine();
                    if (iscutoutAlpha)
                    {
                        materialEditor.ShaderProperty(_UseSpecAlpha, new GUIContent("Specular Alpha Mode", "Make specular reflections visible as a PBR effect.\nAlpha: Alpha only drives visibility.\nReflect: PBR like glass, shine is visible no matter how transparent.\nRecommend Reflect mode paired with Render Queue set to Transparent for PBR consistency."));
                        ACLStyles.PartingLine();
                    }
                    materialEditor.ShaderProperty(_DetachShadowClipping, new GUIContent("Split Shadow Cutout", "Control for dynamic shadows on alpha mesh. Designed so avatar effects like \"Blushes\" or \"Emotes panels\" do not artifact to dynamic shadow."));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Clipping_Level_Shadow, new GUIContent("Shadow Cutout level", "Proportional to Cutout level."));
                    EditorGUI.indentLevel--;
                }
            }

            StencilHelpers = ACLStyles.ShurikenFoldout("Stencil Helpers", StencilHelpers);
            if (StencilHelpers)
            {
                materialEditor.ShaderProperty(_Stencil, new GUIContent("Reference Num", ""));
                materialEditor.ShaderProperty(_StencilComp, new GUIContent("Compare" , ""));
                materialEditor.ShaderProperty(_StencilOp, new GUIContent("Pass", ""));
                materialEditor.ShaderProperty(_StencilFail, new GUIContent("Fail", ""));
                EditorGUILayout.HelpBox("For typical NPR stencil effects \"like eyes over hair\".\n1st material (eyes/lashes): Same ref Num / Comp:Always / Pass:Replace / Fail:Replace\n2nd material (Hair): Same ref Num / Comp:NotEqual / Pass:Keep / Fail:Keep\nRender Queue 2nd material after 1st.", MessageType.None, true);
            }
            materialEditor.RenderQueueField();
            ACLStyles.DrawButtons();
        }
    }
}