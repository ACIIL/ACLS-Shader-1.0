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
    MaterialProperty _useCrossOverRim = null;
    MaterialProperty _crossOverPinch = null;
    MaterialProperty _crossOverStep = null;
    MaterialProperty _crossOverFeather = null;
    MaterialProperty _crosspOverRimPow = null;
    MaterialProperty _useRimLightOverTone = null;
    MaterialProperty _rimLightOverToneBlendColor1 = null;
    MaterialProperty _rimLightOverToneBlendColor2 = null;
    
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
    MaterialProperty _rimLightOverToneLow = null;
    MaterialProperty _rimLightOverToneHigh = null;
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
    MaterialProperty _BlurLevelMatcap0 = null;
    MaterialProperty _BlurLevelMatcap1 = null;
    MaterialProperty _BlurLevelMatcap2 = null;
    MaterialProperty _matcapRoughnessSource0 = null;
    MaterialProperty _matcapRoughnessSource1 = null;
    MaterialProperty _matcapRoughnessSource2 = null;
    MaterialProperty _CameraRolling_Stabilizer = null;
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
    MaterialProperty _shadeShadowOffset1 = null;
    MaterialProperty _shadeShadowOffset2 = null;

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
    // Outline
    MaterialProperty _OutlineTex = null;
    MaterialProperty _Outline_Sampler = null;
    MaterialProperty _Outline_Color = null;
    MaterialProperty _Is_BlendBaseColor = null;
    MaterialProperty _Is_OutlineTex = null;
    MaterialProperty _Outline_Width = null;
    MaterialProperty _Nearest_Distance = null;
    MaterialProperty _Farthest_Distance = null;
    MaterialProperty _Offset_Z = null;
    // Stencil Helpers. Requires Queue Order Edits
    MaterialProperty _Stencil = null;
    MaterialProperty _StencilComp = null;
    MaterialProperty _StencilOp = null;
    MaterialProperty _StencilFail = null;
    //
    MaterialProperty _DetailMap = null;
    MaterialProperty _DetailMask = null;
    MaterialProperty _DetailAlbedo = null;
    MaterialProperty _DetailSmoothness = null;
    //
    MaterialProperty _uvSet_ShadePosition = null;
    MaterialProperty _uvSet_LightMap = null;
    MaterialProperty _uvSet_NormalMapDetail = null;
    MaterialProperty _uvSet_NormalMapForMatCap = null;
    MaterialProperty _uvSet_DetailMap = null;
    MaterialProperty _uvSet_EmissionColorTex = null;
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
    static bool showDetailMask = false;
    static bool showAlphamask = false;
    static bool showStencilHelpers = false;
    static bool showOutline = false;

    // static bool showBlahA = false;
    // static bool showBlahB = false;
    // static bool showBlahC = false;

    // test
    // static int testInt = 1337;

    //
    bool iscutout = false;
    bool iscutoutAlpha = false;
    bool isDither = false;
    bool isOutline = false;
    // bool issolid = false;


    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        // float whatThis = (float)(EditorGUI.GetField("kIndentPerLevel").GetRawConstantValue()); 
        // Debug.Log("blah " + whatThis);
        Material material = materialEditor.target as Material;
        Shader shader = material.shader;

        iscutout = shader.name.Contains("Cutout");
        iscutoutAlpha = shader.name.Contains("AlphaTransparent");
        isDither = shader.name.Contains("Dither");
        isOutline = shader.name.Contains("Outline");
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
                materialEditor.ShaderProperty(_backFaceColorTint, new GUIContent("└ Backface Color Tint", "Back face color. Use to tint backfaces in certain mesh setups.\nRecommend creating actual backface mesh as backfaces reveals depth sorting issues and line artifacts."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Direct Light Adjestments:");
                materialEditor.ShaderProperty(_directLightIntensity, new GUIContent("Direct Light Intensity", "Soft counter for overbright maps. Dim direct light sources and thus rely more on map ambient."));
                materialEditor.ShaderProperty(_shadowCastMin_black, new GUIContent("Dynamic Shadows Removal", "Counters undesirable hard dynamic shadow constrasts for NPR styles in maps with strong direct:ambient light contrasts.\nModifies direct light dynamic shadows behaviour: Each Directional/Point/Spot light in the scene has its own shadow settings and this slider at 1.0 \"brightens\" shadows away.\nUse 0.0 for intended PBR."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Dynamic Shadows Mask (G)", "Works like Realtime Shadows Removal. Texture brightness removes like the slider value."), _DynamicShadowMask);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_shadowUseCustomRampNDL, new GUIContent("Use Direct Falloff","Force natural PBR Dynamic Light falloff from light. This falloff is also natural Dynamic Shadow."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_shadowNDLStep,new GUIContent("├ Step","Angle Falloff begins.\nRecommend setting so complete shadow is perpendicular to light.\nDefault: 1. NPR: 0.52"));
                materialEditor.ShaderProperty(_shadowNDLFeather,new GUIContent("└ Feather","Softness of falloff. Recommend adjesting so complete shadow is perpendicular to light.\nDefault: 0.5. NPR: 0.025"));
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("■ Shadow Filters:");
                materialEditor.ShaderProperty(_shadowSplits,new GUIContent("Shadow Steps","Use this for stylizing NPR by settings \"Steps\" of intensity."));
                materialEditor.ShaderProperty(_shadowMaskPinch,new GUIContent("Shadow Pinch","\"Pinches\" the frindge zone were shadow transitions from nothing to complete.\nUse this to stylize shadow as NPR."));
                EditorGUILayout.LabelField("■ Shadow On Speculars:");
                materialEditor.ShaderProperty(_TweakHighColorOnShadow, new GUIContent("Specular Shadow Reactivity", "Affects Shine lobe's dimming in dynamic shadow. 0.0 is ignore dynamic shadows completely."));
                materialEditor.ShaderProperty(_TweakMatCapOnShadow, new GUIContent("Specular Matcap Shadow Reactivity", "Specular matcaps visibility in dynamic shadow. This depends on context looking like it reacts to direct light or not. 0.0 ignores masking by dynamic shadows."));
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Indirect Light Adjestments:");
                materialEditor.ShaderProperty(_indirectAlbedoMaxAveScale, new GUIContent("Static GI Max:Ave", "How overall Indirect light is sampled by object, abstracted to two sources \"Max\" or \"Average\" color, is used on Diffuse (Toon Ramping).\n1: Use Max color with Average intelligently.\n>1:Strongly switch to Average color as Max color scales brighter, which matches a few NPR shaders behaviour and darkness."));
                materialEditor.ShaderProperty(_indirectGIDirectionalMix, new GUIContent("Indirect GI Directionality", "How Indirect light is sampled in the scene.\n0: Use a simple statistical color by object position.\n1: Use surface angle to light, which is PBR."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_indirectGIBlur, new GUIContent("└ Angular GI Blur", "Default 1.\nRaise to blur Indirect GI and reduce distinctness of surface angle. Good for converting Indirect GI from PRB to NPR."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Diffuse/Toon Light Behaviours:");
                materialEditor.ShaderProperty(_shadeShadowOffset1, new GUIContent("Shadow Offset Core", "NPR effect of \"flooding\" Core Area color within Dynamic Shadows.\nShifts Toon Ramp Core Step By this value."));
                materialEditor.ShaderProperty(_shadeShadowOffset2, new GUIContent("Shadow Offset Backword", "NPR effect of \"flooding\" Backward Area color within Dynamic Shadows.\nShifts Toon Ramp Backward Step By this value."));
                materialEditor.ShaderProperty(_ToonRampLightSourceType_Backwards, new GUIContent("Diffuse Backwards Light Mode", "For pbr/npr effects on diffuse backface area.\nAll Light: Adds direct(with shadows) and ambient light together.\nNatural ambient: Closer to PBR, backface is only Indirect(ambient) light as there is realistically no direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_diffuseIndirectDirectSimMix, new GUIContent("└ Mix Direct Light", "Mix Direct Light into Backward Area by amount. A NPR helper to assist Core & Backward's Step/Feather setting's wrap distribution on Indirect light."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ World Brightness Controls:");
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
                EditorGUILayout.LabelField("■ Texture Albedo Sources:");
                materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture(Forward)", "Main texture. As Forward Area intended for surface most towards light and the visual effect of being in direct light."), _MainTex);
                // materialEditor.TexturePropertySingleLine(new GUIContent("Main Tex", ""), _MainTex, _UVBLAH);
                // materialEditor.TextureProperty(_MainTex, "bleh", true);
                // materialEditor.TexturePropertyTwoLines(new GUIContent("Main Tex", "Words 1"), _MainTex, _UVBLAH, new GUIContent("_BAR", "words 2"), _BAR);
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
                EditorGUILayout.LabelField("■ Simple Tints:");
                materialEditor.ShaderProperty(_Color, new GUIContent("Primary Diffuse Color", "Primary diffuse color control."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_0_ShadeColor, new GUIContent("├ Forward Color", "See Main (Forward) Texture tooltip."));
                materialEditor.ShaderProperty(_1st_ShadeColor, new GUIContent("├ Core Color", "See Core Texture tooltip."));
                materialEditor.ShaderProperty(_2nd_ShadeColor, new GUIContent("└ Backward Color", "See Backword Texture tooltip."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Ramp Area Adjustments:");
                materialEditor.ShaderProperty(_BaseColor_Step, new GUIContent("Step Core", "Were Forward Area blends to Core and Core overwraps Backwards Area\n0.5 is perpendicular to direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BaseShade_Feather, new GUIContent("└ Feather Core", "Softens warp. Wraps away from light, so increase Step Core as you soften."));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_ShadeColor_Step, new GUIContent("Step Backward", "Were Backward Area blends behind & within Core Area.\n0.5 is perpendicular to direct light."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_1st2nd_Shades_Feather, new GUIContent("└ Feather Backward", "Softens warp. Wraps away from light, so increase Backwards Step as you soften."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Area Blend Behaviours:");
                materialEditor.ShaderProperty(_Diff_GSF_01, new GUIContent("Diffuse GSF Effect",  "Custom Geometric Shadowing Function (GSF) effect to simulate darkening or tinting of diffuse light in rough or penetrable surfaces at acute angles.\nEnabling will reveal The true mixing of regions between Forward/Core/Backaward Areas. Use this to help setup NPR cloth/skin/subsurface/iridescents setups."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_DiffGSF_Offset, new GUIContent("├ Offset GSF", "Offset were GSF begins. You may need to use wide values."));
                materialEditor.ShaderProperty(_DiffGSF_Feather, new GUIContent("└ Feather GSF", "Blurs GSF"));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_useCrossOverRim, new GUIContent("Cross Over Tone", "A outer rim effect that blends the Core and Backwards Area colors depending if your view is with or against the light. Use this for reactive \"Skin\" or roughness looking effects that adopts to the worlds lighting direction.\n This system is independent of the Step ranges of Core and Backwards Area."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_crossOverStep, new GUIContent("├ Step", "Rim start."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_crossOverFeather, new GUIContent("└ Feather", "Blur or sharpen."));
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_crosspOverRimPow, new GUIContent("├ Curve", "Power curve."));
                materialEditor.ShaderProperty(_crossOverPinch, new GUIContent("└ Pinch", "Affects Core and Backwards transition sharpness."));
                EditorGUI.indentLevel--;
            }

            showLightMapShiftMasks = ACLStyles.ShurikenFoldout("Diffuse Light Shift Masks", showLightMapShiftMasks);
            if (showLightMapShiftMasks)
            {
                EditorGUILayout.LabelField("■ NPR Ambient Occlusion Masks:");
                materialEditor.ShaderProperty(_uvSet_ShadePosition, new GUIContent("UV AO Set", ""));
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Core AO (G)", "Manually forces diffuse \"Forwards\' Area to \'Core\' Area. Use to manually blend toon shadows by texture UV dynamically and union to light angle... which typically if painted on looks \"baked\" or unrealistic.\nYou may use a Ambient Occlusion Texture for this."), _Set_1st_ShadePosition);
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Backward AO (G)", "Manually forces diffuse \"Core\' Area to \'Backwards\' Area. Use to manually blend toon shadows by texture UV dynamically and union to light angle... which typically if painted on looks \"baked\" or unrealistic.\nYou may use a Ambient Occlusion Texture for this."), _Set_2nd_ShadePosition);
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Light Map System:");
                materialEditor.ShaderProperty(_UseLightMap, new GUIContent("LightMap Mode", "Overrides Diffuse NPR/PBR toon ramp wrapping according to intensity like a dynamic Ambient Occlusion (AO) mask which reacts to light direction onto the surface.\n50% gray is no change, 100% white is bias towards Bright Area, and 0% black is bias towards Dark Area.\nSetup: Define the Color Areas in Diffuse Reflections (Feather works, Step is ignored); Enable the LightMap with a AO mask; then fine-tune the adjustments below."));
                EditorGUI.indentLevel++;
                EditorGUILayout.HelpBox("Hover over LightMap Mode for usage and setup.", MessageType.None, true);
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("LightMap Mask (G)", ""), _LightMap, _uvSet_LightMap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_LightMap);
                EditorGUI.indentLevel--;
                EditorGUILayout.LabelField("■ Light Map Adjustments:");
                materialEditor.ShaderProperty(_lightMap_remapArr, new GUIContent("Remap Levels", "Relevels LightMap's high and low intensity to a new [0,1] clamp.\nAdjust [Z] for darkness and [W] for brightness, and be mindful the 50% gray pivot shifts from this."));
                EditorGUI.indentLevel++;
                EditorGUILayout.HelpBox("Relevels LightMap's high and low intensity to a new [0,1] clamp.\nAdjust [Z] for darkness and [W] for brightness, and be mindful the 50% gray pivot shifts from this.", MessageType.None, true);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_toonLambAry_01, new GUIContent("Core Remap", "Maps the LightMap intensity to Core ramp.\nOutput = [X] * (Input) + [Y]"));
                materialEditor.ShaderProperty(_toonLambAry_02, new GUIContent("Backward Remap", "Maps the LightMap intensity to Backward ramp.\nOutput = [X] * (Input) + [Y]"));
                EditorGUI.indentLevel++;
                EditorGUILayout.HelpBox("By rule: higher value means brighter toon ramp shift by light direction.\nThese adjust the LightMap affect on new Core and Backward Areas.\nOutput = [X] * (Input) + [Y]. First adjest the [y], then deviate [x] from 1.0 (which means no change).", MessageType.None, true);
                EditorGUI.indentLevel--;
            }

            showSpecularShine = ACLStyles.ShurikenFoldout("Specular Reflection", showSpecularShine);
            if (showSpecularShine)
            {
                EditorGUILayout.LabelField("■ Specular Behaviour:");
                materialEditor.ShaderProperty(_UseSpecularSystem, new GUIContent("Enable Specular Effects", "Makes visible Direct Light and Cubemap effects.\nWhat is happening is off forces Primary Specular Color black as well as other shine factors off, well still processing roughness."));
                materialEditor.ShaderProperty(_Is_BlendAddToHiColor, new GUIContent("Energy Conservation", "ON: PBR, which high Specular Mask Dims Diffuse Effects to conserve Energy and match the Standard Shader Workflow. \nOFF: NPR, which Specular Color Simply Adds on Diffuse Effects."));
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Specular Workflow");
                materialEditor.TexturePropertySingleLine(new GUIContent("Specular Mask(RGB). Smoothness(A)", "You must know how \"specular setup\" works. (RGB) intensity means more metallic, lower color saturation means more metallic (reflects without tint from surface). (A) is Smoothness value."), _HighColor_Tex);
                EditorGUI.indentLevel++;
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_HighColor_Tex);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Glossiness, new GUIContent("├ Smoothness", "Follows Standard. Higher reflects the world more perfectly. Affects Shine lobe and Cubemap."));
                materialEditor.ShaderProperty(_SpecColor, new GUIContent("└ Primary Specular Color", "Applies tint on Specular shine and Cubemap color."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Fallback Source Albedo");
                materialEditor.ShaderProperty(_highColTexSource, new GUIContent("Blend Albedo", "If you dont have a custom spec mask, you may borrow and blend the diffuse textures.\nI recommend modifying (V) against pixel darkness, (I) for white intensity, (S) for metallicness."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_SpecularMaskHSV, new GUIContent("Finetune (HSVI)", ""));
                EditorGUILayout.HelpBox("XYZW -> HSVI. Color adjestment when Blending from Albedo.", MessageType.None, true);
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Shine Behaviour");
                materialEditor.ShaderProperty(_HighColor, new GUIContent("Shine Tint", "Multiplies over Shines color intensity and tints. Can use to shut it off (use black), or overpower in HDR (for controlling Sharp and Soft mode)."));
                materialEditor.ShaderProperty(_Is_SpecularToHighColor, new GUIContent("Shine Type", "Override Shape and Soft brightness with Shine Tint.\nSharp: Toony\nSoft: Simple and subtle lode\nUnity: Follow Unity's PBR"));
            }

            showReflection = ACLStyles.ShurikenFoldout("Cubemap Reflection Behavour", showReflection);
            if (showReflection)
            {
                materialEditor.ShaderProperty(_useCubeMap, new GUIContent("Use Cubemap", "Enable sampling of CubeMap."));
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_ENVMmode, new GUIContent("Control Method", "Standard: Follows Standard Shader formula.\nOverride: You define Intensity and Roughness exactly and Intensitys follow roughness formula."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_ENVMix, new GUIContent("├ Intensity", "With Standard: Rescales value by this.\nWith Override: Replace the value from smoothness and ignores roughness mask (can use this to blur Cubemap into abstract tone)."));
                materialEditor.ShaderProperty(_envRoughness, new GUIContent("└ Smoothness", "For Override only."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_CubemapFallbackMode, new GUIContent("Fallback Mode", "Fallback Cubemap intensifies to average lighting.\nSmart: Enables when map gives nothing.\nAlways: Always override with custom."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("└ Fallback Cubemap", ""), _CubemapFallback);
                // EditorGUI.indentLevel++;
                // materialEditor.TextureScaleOffsetProperty(_CubemapFallback);
                // // EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_EnvGrazeMix, new GUIContent("Use Natural Fresnel", "Natural unmaskable specular at sharp angles linked to Specular."));
                materialEditor.ShaderProperty(_EnvGrazeRimMix, new GUIContent("Use RimLight Fresnel", "Unmaskable specular at sharp angles linked to Specular.\nUses both Rim Light -/+ settings as mask."));
            }

            showRimlights = ACLStyles.ShurikenFoldout("Rim Lighting (Simplified Cubemap Fresnel Effects)", showRimlights);
            if (showRimlights)
            {
                materialEditor.ShaderProperty(_rimAlbedoMix, new GUIContent("Mix Albedo", "Mix to tint RimLight by source texture."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_RimLightSource, new GUIContent("└ Source", "Diffuse: Good for Matching Skin\"subsurface\" tones.\nSpecular: Good to match metallic tones as set in your Specular Color settings."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Direction Behaviour:");
                materialEditor.ShaderProperty(_LightDirection_MaskOn, new GUIContent("Light direction mode", "Enables masking by light direction and dual + and - mode. Off makes + a simple overrap."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_Tweak_LightDirection_MaskLevel, new GUIContent("└ Polarize", "Split + and - more by light direction."));
                EditorGUI.indentLevel--;
                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Primary Rim:");
                materialEditor.ShaderProperty(_RimLight, new GUIContent("RimLight +", "Rims towards light source.\nAlso activates this as mask for Cubemap Fresnel."));
                materialEditor.ShaderProperty(_RimLightColor, new GUIContent("├ Color", ""));
                materialEditor.ShaderProperty(_RimLight_Power, new GUIContent("└ Power", "Wrapping curvature"));
                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Optional Rim:");
                materialEditor.ShaderProperty(_Add_Antipodean_RimLight, new GUIContent("RimLight -", "Rim away from light source.\nAlso activates this as mask for Cubemap Fresnel."));
                materialEditor.ShaderProperty(_Ap_RimLightColor, new GUIContent("├ Color", ""));
                materialEditor.ShaderProperty(_Ap_RimLight_Power, new GUIContent("└ Power", "Wrapping curvature"));
                // ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Wrap Behaviour:");
                materialEditor.ShaderProperty(_RimLightAreaOffset, new GUIContent("Offset Wrap", "Shifts RimLights \"warp\". To control how the high and low of the rim curve appear."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_RimLight_InsideMask, new GUIContent("└ Sharpness", "Tampers falloff to a shaper edge. Good for toony lines."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Light Model:");
                materialEditor.ShaderProperty(_rimLightLightsourceType, new GUIContent("Light: Diffuse:Cubemap", "Light Rim Lights like a surface diffuse or Cubemap. First good for subsurface effects and 2nd for metallic/smoothness effect."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_envOnRim, new GUIContent("└ Mix Ave:Cubemap", "Masks Rim Lighting by simple ambience to Cubemap colors. Uses Cubemap settings. I recommend overriding Cubemap Fallback and Roughness settings when applying this."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_envOnRimColorize, new GUIContent("└ Colorize", "Scale from grayscale to color."));
                EditorGUI.indentLevel--;
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_useRimLightOverTone, new GUIContent("2nd Layer Tint", "Blend a 2nd layer tint over (-/+) Forward/Back Rim Lights. Use this to stylize white rim edges or whatever color blends.\nWorks when either Rim is enabled, so shut this off when you are not using it."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_rimLightOverToneLow, new GUIContent("├ Low Mask", "Think of the Rim Lights appearance as a Mask that goes [0, 1]; where 0 is nothing and 1 full rim color. Use this slider to mask around the 0 side of the range."));
                materialEditor.ShaderProperty(_rimLightOverToneHigh, new GUIContent("├ High Mask", "Think of the Rim Lights appearance as a Mask that goes [0, 1]; where 0 is nothing and 1 full rim color. Use this slider to mask around the 1 side of the range."));
                materialEditor.ShaderProperty(_rimLightOverToneBlendColor1, new GUIContent("├ + Color", "Color on + Rim."));
                materialEditor.ShaderProperty(_rimLightOverToneBlendColor2, new GUIContent("└ - Color", "Color on - Rim."));
                EditorGUI.indentLevel--;
            }

            showMatcap = ACLStyles.ShurikenFoldout("Matcap Controls", showMatcap);
            if (showMatcap)
            {
                materialEditor.ShaderProperty(_MatCap, new GUIContent("Use Matcaps", "Uses all or none. (Currently this to simplify solving 3 unique matcap systems and hit performance)"));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Diffuse Type (Multiplies)", "Use this for \"baked\" toon ramp, subsurface, or iridescent Matcaps. It multiplies on the Diffuse Texture and then adds result. Lighting is Direct(with shadows) + Indirect.\nMasked by Diffuse Matcap Mask."), _MatCapTexMult, _MatCapColMult);
                materialEditor.ShaderProperty(_McDiffAlbedoMix, new GUIContent("└ Diffuse Albedo Mix", "How much of diffuse texture to mix in diffuse matcap."));
                materialEditor.ShaderProperty(_matcapRoughnessSource1, new GUIContent("Blur Source:", "Blur Matcap by Specular roughness settings or override your own."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BlurLevelMatcap1, new GUIContent("└ Roughness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Specular Type (Additive)", "Use this for \"baked\" Specular Reflection Matcaps. Intensity works like Cubemap Fallback.\nMasked by Global Specular Mask."), _MatCapTexAdd, _MatCapColAdd);
                materialEditor.ShaderProperty(_matcapRoughnessSource0, new GUIContent("Blur Source:", "Blur Matcap by Specular roughness settings or override your own."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BlurLevelMatcap0, new GUIContent("└ Roughness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Emission Type", "Adds in texture and scales to HDR Color as set.\nMasked by Emission masks."), _MatCapTexEmis, _MatCapColEmis);
                materialEditor.ShaderProperty(_matcapRoughnessSource2, new GUIContent("Blur Source:", "Blur Matcap by Specular roughness settings or override your own."));
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(_BlurLevelMatcap2, new GUIContent("└ Roughness", "Manual override of blur."));
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ Texture Transforms:");
                materialEditor.ShaderProperty(_CameraRolling_Stabilizer, new GUIContent("Roll Stabilizer", "Envokes \"world upright\" matcaps by turning the matcap against your head roll. Used for fake hair shine and other specular effects."));
                materialEditor.ShaderProperty(_Rotate_MatCapUV, new GUIContent("Rotate UV", ""));
                materialEditor.ShaderProperty(_Tweak_MatCapUV, new GUIContent("Scale UV", ""));
                ACLStyles.PartingLine();
                EditorGUILayout.LabelField("■ NormalMap Controls:");
                materialEditor.ShaderProperty(_Is_NormalMapForMatCap, new GUIContent("Use Normal Map", "Distort Matcaps by unique Normals."));
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMapForMatCap, _uvSet_NormalMapForMatCap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMapForMatCap);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Rotate_NormalMapForMatCapUV, new GUIContent("└ Rotate UV", ""));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask Diffuse Matcap", ""), _Set_MatcapMask);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_Set_MatcapMask);
                EditorGUI.indentLevel--;
                materialEditor.ShaderProperty(_Tweak_MatcapMaskLevel, new GUIContent("└ Tweak Mask", ""));
                ACLStyles.PartingLine();
            }

            showEmission = ACLStyles.ShurikenFoldout("Emission Controls", showEmission);
            if (showEmission)
            {
                materialEditor.ShaderProperty(_Emissive_Color, new GUIContent("Color", ""));
                materialEditor.ShaderProperty(_EmissiveProportional_Color, new GUIContent("Proportional color", "For Unrealistic proportional glow to world brightness. Scales color to the average lighting. You might want intensity higher than Emission Color's intensity."));
                ACLStyles.PartingLine();
                materialEditor.TexturePropertySingleLine(new GUIContent("Color Tint (RGB)", "Source glow color."), _EmissionColorTex, _uvSet_EmissionColorTex);
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

            showNormalmap = ACLStyles.ShurikenFoldout("Normal Maps", showNormalmap);
            if (showNormalmap)
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", ""), _NormalMap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_NormalMap);
                EditorGUI.indentLevel--;
                ACLStyles.PartingLine();
                materialEditor.ShaderProperty(_DetailNormalMapScale01, new GUIContent("Detail Scaling", "None 0.0 enables the Detail Normal Map."));
                EditorGUI.indentLevel++;
                materialEditor.TexturePropertySingleLine(new GUIContent("Detail Normal Map", ""), _NormalMapDetail, _uvSet_NormalMapDetail);
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

            showDetailMask = ACLStyles.ShurikenFoldout("Detail Masks", showDetailMask);
            if (showDetailMask)
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Detail Map (RB)", "(R): Details albedo by intensity off from 50%.\n(B): Details smoothness by intensity off from 50%."), _DetailMap, _uvSet_DetailMap);
                EditorGUI.indentLevel++;
                materialEditor.TextureScaleOffsetProperty(_DetailMap);
                EditorGUI.indentLevel--;
                materialEditor.TexturePropertySingleLine(new GUIContent("DetailMask (RB)", "Masks the Detail Map by respective channels."), _DetailMask);
                EditorGUILayout.LabelField("■ Intensities:");
                materialEditor.ShaderProperty(_DetailAlbedo, new GUIContent("Albedo Intensity", ""));
                materialEditor.ShaderProperty(_DetailSmoothness, new GUIContent("Smoothness Intensity", ""));
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

            if (isOutline)
            {
                showOutline = ACLStyles.ShurikenFoldout("Outline Controls", showOutline);
                if (showOutline)
                {
                    EditorGUILayout.LabelField("■ Colors:");
                    materialEditor.ShaderProperty(_Outline_Color, new GUIContent("Outline Color", ""));
                    materialEditor.ShaderProperty(_Is_BlendBaseColor, new GUIContent("Use Main Tex", ""));
                    materialEditor.ShaderProperty(_Is_OutlineTex, new GUIContent("Use Outline Tex", ""));
                    materialEditor.TexturePropertySingleLine(new GUIContent("└ Outline Albedo(RGB)", ""), _OutlineTex);
                    EditorGUI.indentLevel++;
                    materialEditor.TextureScaleOffsetProperty(_Outline_Sampler);
                    EditorGUI.indentLevel--;
                    EditorGUILayout.LabelField("■ Shape Controls");
                    materialEditor.TexturePropertySingleLine(new GUIContent("Thickness Mask(R)", "White: Full thickness, 50%: Half, 0%: Clips out."), _Outline_Sampler);
                    materialEditor.ShaderProperty(_Outline_Width, new GUIContent("Outline Thickness", ""));
                    EditorGUI.indentLevel++;
                    materialEditor.ShaderProperty(_Farthest_Distance, new GUIContent("├ Near Distance", "Surface to camera distance less than this have zero thickness."));
                    materialEditor.ShaderProperty(_Nearest_Distance,  new GUIContent("└ Far Distance", "Surface to camera distance greater than this have full thickness."));
                    EditorGUI.indentLevel--;
                    materialEditor.ShaderProperty(_Offset_Z, new GUIContent("Camera Depth", "Pulls Outline towards/away from camera for depth sorting. Do use small values."));
                }
            }

            showStencilHelpers = ACLStyles.ShurikenFoldout("Stencil Helpers", showStencilHelpers);
            if (showStencilHelpers)
            {
                materialEditor.ShaderProperty(_Stencil, new GUIContent("Reference Num", ""));
                materialEditor.ShaderProperty(_StencilComp, new GUIContent("Compare" , ""));
                materialEditor.ShaderProperty(_StencilOp, new GUIContent("Pass", ""));
                materialEditor.ShaderProperty(_StencilFail, new GUIContent("Fail", ""));
                EditorGUILayout.HelpBox("For typical NPR stencil effects like \"Eyes over hair\".\n1st material (eyes/lashes): Same ref Num / Comp:Always / Pass:Replace / Fail:Replace\n2nd material (Hair): Same ref Num / Comp:NotEqual / Pass:Keep / Fail:Keep\nRender Queue 2nd material after 1st.", MessageType.None, true);
            }
            materialEditor.RenderQueueField();
            ACLStyles.DrawButtons();
        }
    }
}