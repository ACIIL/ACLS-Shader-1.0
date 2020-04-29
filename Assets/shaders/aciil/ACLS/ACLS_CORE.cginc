//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_CORE
#define ACLS_CORE
            //// 
            #include "./ACLS_HELPERS.cginc"

            ////
            Texture2D _ClippingMask;    uniform float4 _ClippingMask_ST;

            Texture2D _NormalMap;       uniform float4 _NormalMap_ST;
            
            Texture2D _MainTex;         uniform float4 _MainTex_ST;
            Texture2D _1st_ShadeMap;    uniform float4 _1st_ShadeMap_ST;
            Texture2D _2nd_ShadeMap;    uniform float4 _2nd_ShadeMap_ST;

            Texture2D _Set_1st_ShadePosition;   uniform float4 _Set_1st_ShadePosition_ST;
            Texture2D _Set_2nd_ShadePosition;   uniform float4 _Set_2nd_ShadePosition_ST;

            Texture2D _HighColor_Tex;       uniform float4 _HighColor_Tex_ST;
            Texture2D _Set_HighColorMask;   uniform float4 _Set_HighColorMask_ST;
            
            Texture2D _Set_RimLightMask;    uniform float4 _Set_RimLightMask_ST;
            
            Texture2D _MatCapTexAdd;        uniform float4 _MatCapTexAdd_ST;
            Texture2D _MatCapTexMult;       uniform float4 _MatCapTexMult_ST;
            Texture2D _MatCapTexEmis;       uniform float4 _MatCapTexEmis_ST;
            Texture2D _NormalMapForMatCap;  uniform float4 _NormalMapForMatCap_ST;
            Texture2D _Set_MatcapMask;      uniform float4 _Set_MatcapMask_ST;

            Texture2D _Emissive_Tex;        uniform float4 _Emissive_Tex_ST;
            Texture2D _EmissionColorTex;    uniform float4 _EmissionColorTex_ST;

            sampler3D _DitherMaskLOD;

            //// sample sets: normals, albedo(shades/masks), AOs, matcap, emissionTex
            SamplerState sampler_MainTex_trilinear_repeat;
            SamplerState sampler_Set_1st_ShadePosition_trilinear_repeat;
            SamplerState sampler_NormalMap_trilinear_repeat;
            SamplerState sampler_MatCap_Sampler_linear_clamp;
            SamplerState sampler_EmissionColorTex_trilinear_repeat;

            ////
            uniform half _Clipping_Level;
            uniform half _Tweak_transparency;
            uniform int _Inverse_Clipping;
            uniform int _IsBaseMapAlphaAsClippingMask;
            
            uniform float4 _Color;
            uniform float4 _0_ShadeColor;
            uniform float4 _1st_ShadeColor;
            uniform float4 _2nd_ShadeColor;

            uniform float4 _HighColor;

            uniform float4 _RimLightColor;
            uniform float4 _Ap_RimLightColor;

            uniform float4 _MatCapColAdd;
            uniform float4 _MatCapColMult;
            uniform float4 _MatCapColEmis;

            uniform float4 _Emissive_Color;
            uniform float4 _EmissiveProportional_Color;

            uniform int _Is_NormalMapToBase;
            uniform int _Is_NormalMapToHighColor;
            uniform int _Is_NormalMapToRimLight;
            uniform int _Is_NormaMapToEnv;
            uniform int _Is_NormaMapEnv;
            // uniform int _Is_NormaMapMCAdd;
            // uniform int _Is_NormaMapMCMult;
            // uniform int _Is_NormaMapMCEmis;

            uniform int _Use_BaseAs1st;
            uniform int _Use_1stAs2nd;
            uniform half _BaseColor_Step;
            uniform half _ShadeColor_Step;
            uniform half _BaseShade_Feather;
            uniform half _1st2nd_Shades_Feather;

            uniform half _shadowCastMin_black;
            uniform half _Set_SystemShadowsToBase;
            uniform half _Is_UseTweakHighColorOnShadow;
            uniform half _Tweak_SystemShadowsLevel;
            uniform half _shaSatRatio;

            uniform half _highColTexSource;
            uniform half _Tweak_HighColorMaskLevel;
            uniform half _HighColor_Power;
            uniform int _Is_BlendAddToHiColor;
            uniform int _Is_SpecularToHighColor;
            uniform half _TweakHighColorOnShadow;

            uniform half _Tweak_RimLightMaskLevel;
            uniform int _RimLight;
            uniform int _Add_Antipodean_RimLight;
            uniform int _RimLightSource;
            uniform half _RimLightMixMode;
            uniform int _LightDirection_MaskOn;
            uniform half _RimLightAreaOffset;
            uniform half _RimLight_Power;
            uniform half _Ap_RimLight_Power;
            uniform half _RimLight_InsideMask;
            uniform half _Tweak_LightDirection_MaskLevel;

            uniform int _ENVMmode;
            uniform half _ENVMix;
            uniform half _envRoughness;
            uniform half _envOnRim;

            uniform half _Is_NormalMapForMatCap;
            uniform int _MatCap;
            uniform half _Is_BlendAddToMatCap;
            uniform half _Tweak_MatCapUV;
            uniform half _Rotate_MatCapUV;
            uniform half _Rotate_NormalMapForMatCapUV;
            uniform half _Is_UseTweakMatCapOnShadow;
            uniform half _TweakMatCapOnShadow;
            uniform half _Tweak_MatcapMaskLevel;

            uniform Texture2D _LightMap; uniform float4 _LightMap_ST;
            uniform TextureCube _CubemapFallback; uniform float4 _CubemapFallback_HDR;
            uniform Texture2D _NormalMapDetail; uniform float4 _NormalMapDetail_ST;
            uniform Texture2D _DetailNormalMask; uniform float4 _DetailNormalMask_ST;
            uniform Texture2D _DynamicShadowMask; uniform float4 _DynamicShadowMask_ST; uniform float4 _DynamicShadowMask_TexelSize;
            uniform float _Metallic;
            uniform float _Glossiness;
            uniform float _Anisotropic;
            uniform float _testMix;
            uniform int _Diff_GSF_01;
            uniform float _DiffGSF_Offset;
            uniform float _DiffGSF_Feather;
            uniform float4 _lightMap_remapArr;
            uniform int _UseLightMap;
            uniform float4 _toonLambAry_01;
            uniform float4 _toonLambAry_02;
            uniform int _UseSpecAlpha;
            uniform float _envOnRimColorize;
            uniform float _DetailNormalMapScale01;
            uniform int _CubemapFallbackMode;
            uniform float _EnvGrazeMix;
            uniform int _EnvGrazeRimMix;
            // uniform float _AO_shadePosFront_Offset;
            // uniform float _AO_shadePosBack_Offset;
            // uniform float _Occlusion_Spec;
            // uniform float _Occlusion_Rim;
            // uniform float _Occlusion_MatAdd;
            uniform int _ToonRampLightSourceType_Backwards;
            uniform int _UseSpecularSystem;
            uniform float3 _backFaceColorTint;
            uniform float4 _SpecularMaskHSV;
            uniform int _forceLightClamp;
            uniform float _rimAlbedoMix;
            uniform float _directLightIntensity;






            struct VertexInput {
                float4 vertex   : POSITION;
                float3 normal   : NORMAL;
                float4 tangent  : TANGENT;
                float2 uv       : TEXCOORD0;
                float4 color    : COLOR;
            };
            
            //// test "_centroid" for MSAA workarounds
            struct VertexOutput {
                float4 color    : COLOR0;
                float4 pos      : SV_POSITION;
                float4 center   : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float3 wNormal  : TEXCOORD2;
                float4 tangent  : TEXCOORD3;
                float3 bitTangent   : TEXCOORD4;
                float3 vertexLighting    : TEXCOORD5;
                float3 dirGI        : TEXCOORD7;
                float2 uv           : TEXCOORD8;
                float4 screenPos    : TEXCOORD9;
                float3 vertTo0      : TEXCOORD10;
                UNITY_SHADOW_COORDS(11)
                UNITY_FOG_COORDS(12)
            };






//// vert            
            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o  = (VertexOutput)0;
                o.pos           = UnityObjectToClipPos( v.vertex );
                o.worldPos      = mul( unity_ObjectToWorld, v.vertex);
                o.center        = mul( unity_ObjectToWorld, float4(0,0,0,1));
                o.wNormal       = UnityObjectToWorldNormal( v.normal);
                o.tangent       = ( float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w));
                o.bitTangent    = ( cross( o.wNormal, o.tangent.xyz ) * v.tangent.w);
                o.uv            = v.uv;
                o.screenPos     = ComputeScreenPos(o.pos);
                o.color         = v.color;
                UNITY_TRANSFER_FOG(o, o.pos);
                UNITY_TRANSFER_SHADOW(o, o.uv);

#ifdef VERTEXLIGHT_ON
                o.vertexLighting    = softShade4PointLights_Atten(
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0
                    , unity_LightColor
                    , unity_4LightAtten0,
                    o.worldPos, o.wNormal, o.vertTo0);
#endif                    
#ifdef UNITY_PASS_FORWARDBASE
                o.dirGI       = GIDominantDir();
#endif
                return o;
            }






//// Redefine UNITY_LIGHT_ATTENUATION without shadow multiply from AutoLight.cginc
                #ifdef POINT
                #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
                    unityShadowCoord3 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
                    fixed destName  = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                #endif

                #ifdef SPOT
                #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
                    unityShadowCoord4 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)); \
                    fixed destName  = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
                #endif

                #ifdef DIRECTIONAL
                // #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) fixed destName = 1;
                #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) fixed destName = UNITY_SHADOW_ATTENUATION(input, worldPos);
                #endif

                #ifdef POINT_COOKIE
                #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
                    unityShadowCoord3 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
                    fixed destName  = tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL * texCUBE(_LightTexture0, lightCoord).w;
                #endif

                #ifdef DIRECTIONAL_COOKIE
                #define UNITY_LIGHT_ATTENUATION_NOSHADOW(destName, input, worldPos) \
                    unityShadowCoord2 lightCoord    = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xy; \
                    fixed destName  = tex2D(_LightTexture0, lightCoord).w;
                #endif






//// frag
            float4 frag(
                VertexOutput i
                , bool frontFace : SV_IsFrontFace ) : SV_TARGET 
            {
                int isBackFace          = !frontFace;
                i.wNormal               = normalize( i.wNormal);
                if(isBackFace) { //// flip normal for back faces.
                    i.wNormal = -i.wNormal;
                }
                i.tangent               = normalize(i.tangent);
                i.bitTangent            = normalize(i.bitTangent);
                float3 worldviewPos     = StereoWorldViewPos();
                float3 posDiff          = worldviewPos - i.worldPos.xyz;
                float viewDis           = length(posDiff);
                float3 dirView          = normalize(posDiff);
                //// screen pos
                float4 screenPos        = i.screenPos;
                float4 screenUV         = screenPos / (screenPos.w + 0.00001);
            #ifdef UNITY_SINGLE_PASS_STEREO
                screenUV.xy             *= float2(_ScreenParams.x * 2, _ScreenParams.y);
            #else
                screenUV.xy             *= _ScreenParams.xy;
            #endif

//// normal map
                UV_DD uv_normalMap              = UVDD(TRANSFORM_TEX(i.uv, _NormalMap));
                UV_DD uv_normalMapDetail        = UVDD(TRANSFORM_TEX(i.uv, _NormalMapDetail));
                UV_DD uv_normalMapDetailMask    = UVDD(TRANSFORM_TEX(i.uv, _DetailNormalMask));
                float3 normalMap            = UnpackNormal( _NormalMap.SampleGrad( sampler_NormalMap_trilinear_repeat, uv_normalMap.uv, uv_normalMap.dx, uv_normalMap.dy));
                if (_DetailNormalMapScale01)  //// slider > 0
                {
                    float4 normalDetailMask = _DetailNormalMask.SampleGrad( sampler_MainTex_trilinear_repeat, uv_normalMapDetailMask.uv, uv_normalMapDetailMask.dx, uv_normalMapDetailMask.dy);
                    float3 normalMapDetail  = UnpackNormal( _NormalMapDetail.SampleGrad( sampler_NormalMap_trilinear_repeat, uv_normalMapDetail.uv, uv_normalMapDetail.dx, uv_normalMapDetail.dy));
                    normalMap               = lerp( normalMap, BlendNormals(normalMap, normalMapDetail), (normalDetailMask.g * _DetailNormalMapScale01));
                }
                float3x3 tangentTransform   = float3x3( i.tangent.xyz , i.bitTangent.xyz, i.wNormal);
                float3 dirNormal            = normalize( mul( normalMap, tangentTransform ));
                // return float4(dirNormal*.5+.5,1);



//// albedo texure
                UV_DD uv_toon           = UVDD( TRANSFORM_TEX( i.uv, _MainTex));
                float4 mainTex          = _MainTex.SampleGrad( sampler_MainTex_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy);
//// clip & alpha handling. Here so clip() may interrupt flow.
#ifndef NotAlpha
                float clipMask          = _ClippingMask.Sample(sampler_MainTex_trilinear_repeat, TRANSFORM_TEX(i.uv, _ClippingMask));
                float useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clipMask.r;
                float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;

                float clipTest          = (alpha - _Clipping_Level);
                clip(clipTest);

    #ifndef IsClip
                // dither pattern with some a2c blending.

                alpha        = saturate(alpha + _Tweak_transparency);
                
        #ifdef UseAlphaDither
                //// citation to Silent and Xiexe for guidance and research documentation.
                //// assumes cutout blending + alpha to coverage. Subtracted alpha must return.
                // float dither    = tex3D(_DitherMaskLOD, float3(screenUV.xy * .25, alpha * .99), 0,0).a;
                // float dither    = ScreenDitherToAlpha_ac(screenUV.xy, ( alpha));
                // alpha           *= dither;
                float dither    = ScreenDitherToAlphaCutout_ac(screenUV.xy, (1 - alpha));
                alpha           = alpha - dither;
                clip(alpha);
        #endif //// UseAlphaDither
                alpha           = saturate(alpha);

                ////////////////
                //////////////// Alternative dither methods
                // {
                //     // // dither noise based on pos. a2c best but always noisy.
                //     alpha            = saturate(( alpha + _Tweak_transparency));
                //     float dither     = hash13(i.worldPos * 50);
                //     // float dither  = rand3(i.worldPos * 50);
                //     float alpha2     = saturate(alpha * alpha);
                //     float amix       = lerp(dither*(1-alpha), dither*alpha, 1-alpha2);
                //     alpha            = (amix) + alpha;
                //     alpha            = saturate(alpha);
                // }
                ////////////////
                ////////////////
    #else //// IsClip
                alpha           = 1;
    #endif //// IsClip
#else //// NotAlpha
                float alpha     = 1;
#endif //// NotAlpha


//// toon shade manual textures
                UNITY_BRANCH
                float4 shadeMapTex_1 = (_Use_BaseAs1st) ? (mainTex) : (_1st_ShadeMap.SampleGrad(sampler_MainTex_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy));
                float4 shadeMapTex_2 = 0;
                UNITY_BRANCH
                if (_Use_1stAs2nd > 1)
                {
                    shadeMapTex_2 = mainTex;
                } else if (_Use_1stAs2nd > 0)
                {
                    shadeMapTex_2 = shadeMapTex_1;
                } else
                {
                    shadeMapTex_2 = (_2nd_ShadeMap.SampleGrad(sampler_MainTex_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy));
                }



//// early light dir pass for dir for supporting DIRECT light dot()
#ifdef UNITY_PASS_FORWARDBASE
                float3 dirLight   = _WorldSpaceLightPos0.xyz;
#elif UNITY_PASS_FORWARDADD
                float3 dirLight   = normalize( lerp( _WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.worldPos.xyz, _WorldSpaceLightPos0.w));
#endif



//// main light direction with weighted factors of light types
#ifdef UNITY_PASS_FORWARDBASE
                float3 viewLightDirection   = normalize( UNITY_MATRIX_V[2].xyz + UNITY_MATRIX_V[1].xyz); // [1] = camera y upward, [2] = camera z forward
                //// experiment for weighted angles.
                // dirLight                    = dot(1, lightDirect) * _WorldSpaceLightPos0.xyz + dot(1, lightIndirectColAve) * (i.dirGI)  + dot(1, vertexLit) * (i.vertTo0) + (.0001 * viewLightDirection);
                dirLight                    = 100*(_WorldSpaceLightPos0.xyz) + (i.dirGI) + 0.001*(i.vertTo0) + .0001*(viewLightDirection);
                dirLight                    = normalize(dirLight);
                // return float4(((.5*dot(dirLight, i.wNormal)+.5)).xxx, 1);
#elif UNITY_PASS_FORWARDADD
#endif
                if (isBackFace) //// treat backfaces towards light
                {
                    dirLight    = -dirLight;
                }



//// dot() set. Organized extensive input values per effect, per normal map
                ////
                float3 dirNormalToonRamp        = _Is_NormalMapToBase       ? dirNormal : i.wNormal;
                float3 dirNormalSpecular        = _Is_NormalMapToHighColor  ? dirNormal : i.wNormal;
                float3 dirNormalEnv             = _Is_NormaMapToEnv         ? dirNormal : i.wNormal;
                float3 dirNormalRimLight        = _Is_NormalMapToRimLight   ? dirNormal : i.wNormal;
                float3 dirHalf                  = normalize(dirLight + dirView);
                float ldh_Norm_Full             = dot(dirLight, dirHalf);
                float ldh_Norm_Cap              = saturate(ldh_Norm_Full);
                float vdh_Norm_Full             = dot(dirView, dirHalf);
                //// normal toon
                struct Dot_Diff { float ndl; float ndv; float ldhS; float ldh;};
                Dot_Diff dDiff;
                dDiff.ndl   = dot(dirNormalToonRamp, dirLight)*.5+.5;
                dDiff.ndv   = saturate(dot(dirNormalToonRamp, dirView));
                dDiff.ldhS  = ldh_Norm_Full*.5+.5;
                dDiff.ldh   = saturate(ldh_Norm_Full);
                //// normal spec
                struct Dot_Spec { float ndhS; float ndh; float ndlS; float ndl; float ndv; float vdh; float ldh;};
                float spec_ndh  = dot(dirNormalSpecular, dirHalf);
                float spec_ndl  = dot(dirNormalSpecular, dirLight);
                Dot_Spec dSpec;
                dSpec.ndhS      = spec_ndh *.5+.5;
                dSpec.ndh       = saturate(spec_ndh);
                dSpec.ndlS      = spec_ndl *.5+.5;
                dSpec.ndl       = saturate(spec_ndl);
                dSpec.ndv       = saturate(dot(dirNormalSpecular, dirView));
                dSpec.vdh       = saturate(vdh_Norm_Full);
                dSpec.ldh       = ldh_Norm_Cap;
                //// normal env
                struct Dot_Env {float ndv; float ldh; float3 dirViewReflection;};
                Dot_Env dEnv;
                dEnv.ndv                = saturate(dot(dirNormalEnv, dirView));
                dEnv.ldh                = ldh_Norm_Cap;
                dEnv.dirViewReflection  = reflect(-dirView, dirNormalEnv);
                //// normal rimLight
                struct Dot_RimLight {float ndv; float ndlS;};
                Dot_RimLight dRimLight;
                dRimLight.ndv   = saturate( dot(dirNormalRimLight, dirView) + (.5*smoothstep(.1, 0, viewDis)));//// needs [-1,1]
                dRimLight.ndlS  = dot(dirNormalRimLight, dirLight)*.5+.5;
                //// normal mc add
                //// normal mc mult
                //// normal mc emis

                //// aniso support. Observe [-1..1]
                // float hdx_Norm_full = (dot(dirHalf,  i.tangent));
                // float hdy_Norm_full = (dot(dirHalf,  i.bitTangent));



//// Light attenuation (falloff and shadows), used for mixing in shadows and effects that react to shadow
            #ifdef DIRECTIONAL 
                //// directional lights handle UNITY_LIGHT_ATTENUATION() differently. I want to split attenuation and shadows, but both concepts fuse in directional lights
                UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
                float shadowFullTrue = lightAtten;
                lightAtten = smoothstep(0, 0.6, lightAtten);
                float shadowAtten = lightAtten;
            #else
                UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
                float shadowAtten = UNITY_SHADOW_ATTENUATION(i, i.worldPos.xyz);
                float shadowFullTrue = shadowAtten;
                shadowAtten = smoothstep(0, 0.6, shadowAtten);
            #endif
                //// regraph shadow fridge
                // float nShadowAtten  = 1 - shadowAtten;
                // shadowAtten         = ( (-(nShadowAtten * nShadowAtten) + 1));
                float attenRamp = shadowAtten;
                //// shadow influance for masking some effects.
                float shadowMask, shadowMaskSharp;
                shadowMaskSharp = smoothstep(min(_LightShadowData.x, 1), min(1,_LightShadowData.x+0.1), attenRamp);
                // shadowMaskSharp = smoothstep(min(_LightShadowData.x, 1), min(1,_LightShadowData.x+0.1), shadowAtten*(shadowAtten+0.001));
                shadowMask  = max(_LightShadowData.x, shadowMaskSharp);



//// toon ramp, prepare ramp masks
                //// toon ramp AO masks. These down ramp as to "force shadow".
                float shadowTex_1  = 1;
                float shadowTex_2  = 1;
                shadowTex_1 = _Set_1st_ShadePosition.SampleGrad(sampler_Set_1st_ShadePosition_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy).g;
                shadowTex_2 = _Set_2nd_ShadePosition.SampleGrad(sampler_Set_1st_ShadePosition_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy).g;
                //// light mask setup. N dol L modified by ****. 50% gray mean natural influence.
                float pivotOffset_1 = 0;
                float pivotOffset_2 = 0;
                float4 lightMask    = 0.5;
                UV_DD uv_lightMap   = UVDD( TRANSFORM_TEX( i.uv, _LightMap));
                UNITY_BRANCH
                if (_UseLightMap)
                {
                    lightMask   = _LightMap.SampleGrad( sampler_MainTex_trilinear_repeat, uv_lightMap.uv, uv_lightMap.dx, uv_lightMap.dy);
                    lightMask.g = ( RemapRange01(lightMask.g, _lightMap_remapArr[2], _lightMap_remapArr[3]));
                    //// enum mode 2. Use vertex color red
                    UNITY_BRANCH
                    if (_UseLightMap > 1) { //// use vertex color 
                        lightMask.g *= i.color.r;
                    }
                    //// bright side mix
                    float toonOffsetMask_1  = lightMask.g;
                    float2 AOmCalibrate_1   = (toonOffsetMask_1.xx * float2(_toonLambAry_01[0],_toonLambAry_01[0]) + float2(_toonLambAry_01[1],_toonLambAry_01[1]));
                    float AOmaskPivot_1     = ((0.5) > toonOffsetMask_1);
                    pivotOffset_1           = (AOmaskPivot_1) ? AOmCalibrate_1.y : AOmCalibrate_1.x;
                    //// dark side mix
                    float toonOffsetMask_2  = lightMask.g;
                    float2 AOmCalibrate_2   = (toonOffsetMask_2.xx * float2(_toonLambAry_02[0],_toonLambAry_02[0]) + float2(_toonLambAry_02[1],_toonLambAry_02[1]));
                    float AOmaskPivot_2     = ((0.5) > toonOffsetMask_2);
                    pivotOffset_2     = (AOmaskPivot_2) ? AOmCalibrate_2.y : AOmCalibrate_2.x;
                }
                //// Assist for shadow mask
                float shadeRamp_n0  = dDiff.ndl;
                //// ndl light side
                float shadeRamp_n1  = shadeRamp_n0;
                // UNITY_BRANCH
                // if (_Set_SystemShadowsToBase)
                // {
                //     // Because ACiiL is an insane unity shadow caster wizard who still dislikes rewriting CGincludes.
                //     float n1ShadowMask  = shadowMask;
                //     shadeRamp_n1    = (shadeRamp_n1 * n1ShadowMask);
                // }
                UNITY_BRANCH
                if (_UseLightMap)
                {
                    shadeRamp_n1    = (pivotOffset_1 + shadeRamp_n1) * 0.5;
                } 
                else {
                    shadeRamp_n1    = (shadeRamp_n1);
                }
                shadeRamp_n1    = (shadeRamp_n1 - _BaseColor_Step + _BaseShade_Feather);
                shadeRamp_n1    = 1 + shadeRamp_n1 * -shadowTex_1 / (_BaseShade_Feather);
                shadeRamp_n1    = saturate(shadeRamp_n1);
                //// ndl dark side
                float shadeRamp_n2  = shadeRamp_n0;
                UNITY_BRANCH
                if (_UseLightMap)
                {
                    shadeRamp_n2    = (pivotOffset_2 + shadeRamp_n2) * 0.5;
                } 
                else {
                    shadeRamp_n2    = (shadeRamp_n2);
                }
                shadeRamp_n2        = (shadeRamp_n2 - _ShadeColor_Step + _1st2nd_Shades_Feather);
                shadeRamp_n2        = 1 + shadeRamp_n2 * -shadowTex_2 / ( _1st2nd_Shades_Feather );
                shadeRamp_n2        = saturate(shadeRamp_n2);
                // return float4(shadeRamp_n2.xxx,1);
//// end toon ramp mask setup



//// setup shadow darkness control
                //// setup dynamic shadow limits
                float shadowAttenuation = shadowAtten;
                float shadowBlackness = 0;
                float shadowMinPotential = 0;
                UNITY_BRANCH
                if ( (_shadowCastMin_black) || !(_DynamicShadowMask_TexelSize.z <16)) 
                {
                    float dynamicShadowMask = _DynamicShadowMask.SampleGrad(sampler_MainTex_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy).g;
                    float tmp       = max(_shadowCastMin_black, dynamicShadowMask);
                    shadowBlackness = saturate( (shadowAttenuation + tmp)/(1 - tmp));
                    shadowMinPotential  = saturate( (_LightShadowData.x + tmp)/(1 - tmp));
                } else
                {
                    shadowBlackness = shadowAttenuation;
                }
                // return float4(shadowBlackness.xxx,1);



//// collect scene light sources
#ifdef UNITY_PASS_FORWARDBASE
                float3 lightIndirectColAve  = DecodeLightProbe_average();   //// average light from raw L0
                float3 lightIndirectMaxCol  = SHEvalDirectL1(float4(i.dirGI,1));    //// direct most light raw L1
                float3 lightIndirectAngCol  = shadeSH9LinearAndWhole(float4(i.wNormal,1));  //// All GI from direction and fixed for no negatives
                // float scaleGIL0L1           = saturate(LinearRgbToLuminance_ac(lightIndirectMaxCol) / (LinearRgbToLuminance_ac(lightIndirectColAve) + 0.00001) * .9);
                float scaleGIL0L1           = saturate(LinearRgbToLuminance_ac(lightIndirectMaxCol) - (LinearRgbToLuminance_ac(lightIndirectColAve)).xxx + 0.00001) * 1;
                float3 lightIndirectCol     = lerp(lightIndirectMaxCol, lightIndirectColAve, scaleGIL0L1);
                //// build direct light sources
                float3 lightDirect          = _LightColor0.rgb;
                float3 lightDirectSave      = lightDirect;
                //// build ambient LUM for reflection types
                float lightAverageLum   = LinearRgbToLuminance_ac((lightDirectSave * _LightShadowData.x * .5) + lightDirectSave + (lightIndirectCol)) * .34;
                float3 vertexLit        = i.vertexLighting;
                //// out light source by types
                float3 lightDirectSource    = (mixColorsMaxAve(lightIndirectMaxCol, lightDirect) + vertexLit) * _directLightIntensity;
                float3 lightIndirectSource  = lightIndirectCol + vertexLit;
#elif UNITY_PASS_FORWARDADD
                float3 lightIndirectColAve  = 0;
                float3 lightIndirectAngCol  = 0;
                float3 lightDirect          = _LightColor0.rgb;
                float3 lightDirectSave      = lightDirect;
                lightDirect                 *= lightAtten;
                float lightAverageLum       = lightAtten * LinearRgbToLuminance_ac((lightDirectSave * _LightShadowData.x * .5) + lightDirectSave) * .5;
                // float colSceneAmbientLum    = LinearRgbToLuminance_ac(lightDirect);
                // float colorIntSignal    = 0;
                //// out light source by types
                float3 lightDirectSource    = lightDirect * _directLightIntensity;
                float3 lightIndirectSource  = 0;
#endif



//// matcap
                float matcapMask    = 1;
                float matcapShaMask = 1;
                float3 mcMixAdd     = 0;
                float3 mcMixMult    = 1;
                float3 mcMixEmis    = 0;
                UNITY_BRANCH
                if (_MatCap)
                {
                    //// normalmap rotate
                    float2 rot_MatCapNmUV       = rotateUV(i.uv, float2(0.5,0.5), (_Rotate_NormalMapForMatCapUV * 3.141592654));
                    //// normal map
                    UV_DD uv_matcap_nm          = UVDD( TRANSFORM_TEX( rot_MatCapNmUV, _NormalMapForMatCap));
                    float4 normalMapForMatCap   = _NormalMapForMatCap.SampleGrad( sampler_NormalMap_trilinear_repeat, uv_matcap_nm.uv, uv_matcap_nm.dx, uv_matcap_nm.dy);
                    float3 matCapNormalMapTex   = UnpackNormal( normalMapForMatCap);
                    //// v.2.0.5: MatCap with camera skew correction. @kanihira
                    float3 dirNormalMatcap      = (_Is_NormalMapForMatCap) ? mul( matCapNormalMapTex, tangentTransform) : i.wNormal;
                    ////
                    float3 viewNormal                   = mul( UNITY_MATRIX_V, dirNormalMatcap);
                    float3 normalBlendMatcapUVDetail    = viewNormal.xyz * float3(-1,-1,1);
                    float3 normalBlendMatcapUVBase      = (mul( UNITY_MATRIX_V, float4(dirView,0) ).xyz * float3(-1,-1,1)) + float3(0,0,1);
                    float3 noSknewViewNormal            = (normalBlendMatcapUVBase * dot(normalBlendMatcapUVBase, normalBlendMatcapUVDetail) / normalBlendMatcapUVBase.z) - normalBlendMatcapUVDetail;
                    float2 viewNormalAsMatCapUV         = ((noSknewViewNormal).xy * 0.5) + 0.5;
                    //// matcap rotation
                    float2 scl_MatCapUV         = scaleUV(viewNormalAsMatCapUV, float2(0.5,0.5), -2 * _Tweak_MatCapUV + 1);
                    float2 rot_MatCapUV         = rotateUV(scl_MatCapUV, float2(0.5,0.5),  (_Rotate_MatCapUV * 3.141592654));
                    //// UV to texture
                    UV_DD uv_matcap         = UVDD( TRANSFORM_TEX( rot_MatCapUV, _MatCapTexAdd));
                    float4 matCapTexAdd     = _MatCapTexAdd.SampleGrad( sampler_MatCap_Sampler_linear_clamp, uv_matcap.uv, uv_matcap.dx, uv_matcap.dy);
                    float4 matCapTexMult    = _MatCapTexMult.SampleGrad( sampler_MatCap_Sampler_linear_clamp, uv_matcap.uv, uv_matcap.dx, uv_matcap.dy);
                    float4 matCapTexEmis    = _MatCapTexEmis.SampleGrad( sampler_MatCap_Sampler_linear_clamp, uv_matcap.uv, uv_matcap.dx, uv_matcap.dy);
                    ////
                    mcMixAdd          = matCapTexAdd.rgb * matCapTexAdd.a;
                    mcMixMult         = matCapTexMult.rgb * matCapTexMult.a;
                    mcMixEmis         = matCapTexEmis.rgb * matCapTexEmis.a;
                    UNITY_BRANCH
                    if (_TweakMatCapOnShadow)//// slider > 0
                    {
                        matcapShaMask       = lerp(1, shadowMask, _TweakMatCapOnShadow);
                    }
                    UV_DD uv_mcMask         = UVDD( TRANSFORM_TEX(i.uv, _Set_MatcapMask));
                    float4 matcapMaskTex    = _Set_MatcapMask.SampleGrad( sampler_MainTex_trilinear_repeat, uv_mcMask.uv, uv_mcMask.dx, uv_mcMask.dy);
                    matcapMask              *= saturate(matcapMaskTex.g + _Tweak_MatcapMaskLevel);
                }
                else {
                    matcapMask      = 0;
                }





//// toon ramp color setup
                //// Albedo variable remap zone of pain.
                // get albedo samples
                float3 albedoCol_1      = mainTex.rgb;
                float3 albedoCol_2      = shadeMapTex_1.rgb;
                float3 albedoCol_3      = shadeMapTex_2.rgb;
                //
                float3 shadeCol_1       = _0_ShadeColor.rgb     * _Color.rgb;
                float3 shadeCol_2       = _1st_ShadeColor.rgb   * _Color.rgb;
                float3 shadeCol_3       = _2nd_ShadeColor.rgb   * _Color.rgb;

//// Toon albedo and ramp mixer
                float3 toonMix_bright_albedo    = lerp(albedoCol_1, albedoCol_2, shadeRamp_n1);
                float3 toonMix_dark_albedo      = lerp(albedoCol_2, albedoCol_3, shadeRamp_n2);
                //// mix scene colors per ramp region
                //// how ambient light mixes affects both feedin of shadow attenuation and lighting selection
                if (_ToonRampLightSourceType_Backwards > 0) //// diffuse lighting: backface ramp is part of shadow
                {
                    float n2ShadowMask = 1 - min((1-shadeRamp_n2), shadowBlackness);
                    shadeRamp_n2 = n2ShadowMask;
                    float3 lightDirectSim = (lightDirectSource * shadowBlackness) + lightIndirectSource;
                    shadeCol_1 *= lightDirectSim;
                    shadeCol_2 *= lightDirectSim;
                    shadeCol_3 *= lightIndirectSource;
                    // shadeCol_3 *= (lightDirectSource * max(shadowMinPotential, _LightShadowData.x)) + lightIndirectSource;
                } else //// diffuse lighting: shadow is independent of ramp
                {
                    float3 lightDirectSim = (lightDirectSource * shadowBlackness) + lightIndirectSource;
                    shadeCol_1 *= lightDirectSim;
                    shadeCol_2 *= lightDirectSim;
                    shadeCol_3 *= lightDirectSim;
                }
                float3 toonMix_bright_mix       = lerp(shadeCol_1, shadeCol_2, shadeRamp_n1);
                float3 toonMix_dark_mix         = lerp(shadeCol_2, shadeCol_3, shadeRamp_n2);
                
                // return float4(shadeRamp_n1, shadeRamp_n2,0,1);
                float diff_GSF  = 0;
                UNITY_BRANCH
                if (_Diff_GSF_01)
                {
                    diff_GSF    = -GSF_Diff_ac(dDiff.ndl, dDiff.ndv, dDiff.ldhS) + 1;
                    diff_GSF    = StepFeatherRemap(diff_GSF, _DiffGSF_Offset, _DiffGSF_Feather);
                } 
                else {
                    diff_GSF  = min(shadeRamp_n1, shadeRamp_n2);
                }
                float3 shadeColor_albedo    = lerp(toonMix_bright_albedo, toonMix_dark_albedo, diff_GSF);//// textures
                float3 shadeColor_mix       = lerp(toonMix_bright_mix, toonMix_dark_mix, diff_GSF);//// ramp
                float3 shadeColor           = shadeColor_albedo * shadeColor_mix;//// mix ramp
                // return float4(shadeColor,1);



//// specular setup control
                //// specular tint _highColTexSource _SpecTintMix
                UV_DD uv_specularMask       = UVDD( TRANSFORM_TEX( i.uv, _Set_HighColorMask));
                float4 specularMask         = _Set_HighColorMask.SampleGrad( sampler_MainTex_trilinear_repeat, uv_specularMask.uv, uv_specularMask.dx, uv_specularMask.dy);
                float aoSpecularM           = saturate(specularMask.g + _Tweak_HighColorMaskLevel);
                UV_DD uv_specular           = UVDD( TRANSFORM_TEX( i.uv, _HighColor_Tex));
                float4 highColorTex         = _HighColor_Tex.SampleGrad( sampler_MainTex_trilinear_repeat, uv_specular.uv, uv_specular.dx, uv_specular.dy);
                float3 specularSrcCol       = highColorTex.rgb;
                float smoothness            = (highColorTex.a) * _Glossiness;
                
                //// blend spec textures and tint
                specularSrcCol  *= _SpecColor.rgb;
                if (_highColTexSource) // if mixing main texture
                {
                    specularSrcCol  = lerp(specularSrcCol, specularSrcCol * shadeColor_albedo, _highColTexSource);
                    specularSrcCol  = RGBToHSV(saturate(specularSrcCol * _SpecularMaskHSV.w));
                    specularSrcCol  = HSVToRGB(float3((specularSrcCol.x+_SpecularMaskHSV.x), saturate(specularSrcCol.y+_SpecularMaskHSV.y), max(0,specularSrcCol.z+_SpecularMaskHSV.z)));
                }
                float3 specularMatcapDes    = specularSrcCol;
                if (!(_UseSpecularSystem)) //// forgive this lazy switch. Needs code block shutoff.
                {
                    specularSrcCol = _EnvGrazeMix = _EnvGrazeRimMix = 0;
                } 
                float perceptualRoughness   = SmoothnessToPerceptualRoughness(smoothness);
                float oneMinusReflectivity  = 1;
                EnergyConservationBetweenDiffuseAndSpecularOMF(specularSrcCol, /* out */ oneMinusReflectivity);

                //// standard metallic/roughness mask prep
                // float4 highColorMask        = _Set_HighColorMask.Sample( sampler_MainTex_trilinear_repeat, TRANSFORM_TEX( i.uv, _Set_HighColorMask));
                // float metallic              = highColorMask.r * _Metallic;//// need open for possible metallic workflow
                // float smoothness            = (highColorMask.a) * _Glossiness;



//// Specular. High Color.
                float highColorInShadow         = 1;
                float specMaskSetup_1           = 0;
                UNITY_BRANCH
                if ((dSpec.ndl < 0) || (dSpec.ndv < 0)) //// impossible dot setups
                {
                    specMaskSetup_1             = 0;
                }
                else {
                    float roughness         = PerceptualRoughnessToRoughness_ac(perceptualRoughness);
                    roughness               = max(roughness, 0.002);
                    UNITY_BRANCH
                    if (_Is_SpecularToHighColor > 1) //// unity
                    {
                        float spec_NDF      = GGXTerm_ac(dSpec.ndh, roughness);
                        float spec_GSF      = SmithJointGGXVisibilityTerm_ac(dSpec.ndl, dSpec.ndv, roughness);
                        specMaskSetup_1     = (spec_NDF * spec_GSF * UNITY_PI);
                        specMaskSetup_1     *= dSpec.ndl;
                        specMaskSetup_1     = max(0, specMaskSetup_1);
                    }
                    else if (_Is_SpecularToHighColor > 0) //// smooth
                    {
                        specMaskSetup_1     = pow(dSpec.ndh, RoughnessToSpecPower_ac(roughness)) * UNITY_PI;
                        // specMaskSetup_1     = NDFBlinnPhongNormalizedTerm(dSpec.ndh, PerceptualRoughnessToSpecPower_ac(perceptualRoughness));
                        specMaskSetup_1     *= SmithBeckmannVisibilityTerm_ac(dSpec.ndl, dSpec.ndv, roughness);
                        specMaskSetup_1     *= dSpec.ndl;
                        // return float4(specMaskSetup_1.xxx,1);
                    }
                    else {  //// sharp
                        specMaskSetup_1     = (1 - step(dSpec.ndhS * KelemenGSF(dSpec.ndl, dSpec.ndv, dSpec.vdh), (1 - roughness)));
                    }
                    UNITY_BRANCH
                    if (_TweakHighColorOnShadow) //// slider > 0
                    {
                        highColorInShadow   = lerp(1, shadowMask, _TweakHighColorOnShadow);
                    }
                    specMaskSetup_1         *= highColorInShadow;
                }
                //// mix lobs, system intented to mix +1 spec's lobes
                float3 highColorTotalCol_1  = specularSrcCol * _HighColor.rgb;



//// Env Reflection
                float3 colEnv           = 0;
                float3 envOntoRimSetup  = 1;
                float envRimMask        = 0;
                float colEnvMask        = 1;
                float colGIGray         = 0;
                float LODrange;
                UNITY_BRANCH
                if ((_ENVMmode) || (_envOnRim > 0))
                {
                    float3 reflDir0 = BoxProjection(dEnv.dirViewReflection, i.worldPos, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
                    float pRoughnessFix;
                    float envLOD;
                    half mip,testw,testw2,testh,lodMax;
                    mip = testw = testw2 = testh = lodMax = 0;
                    unity_SpecCube0.GetDimensions(mip,testw,testw,lodMax);
                    UNITY_BRANCH
                    if (_ENVMmode > 1) //// override
                    {
                        pRoughnessFix = 1 - _envRoughness;
                        smoothness  = _envRoughness;
                        pRoughnessFix   = pRoughnessFix * (1.7 - 0.7 * pRoughnessFix);
                        envLOD  = perceptualRoughnessToMipmapLevel_ac(pRoughnessFix, lodMax);
                    } else
                    { //// standard
                        pRoughnessFix = perceptualRoughness * (1.7 - 0.7 * perceptualRoughness);
                        envLOD  = perceptualRoughnessToMipmapLevel_ac(pRoughnessFix, lodMax);
                    }
                    UNITY_BRANCH
                    if (_CubemapFallbackMode < 2) //// not override cubemap, solve real cubemaps
                    {
                        float4 refColor0    = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflDir0, envLOD);
                        refColor0.rgb   = DecodeHDR(refColor0, unity_SpecCube0_HDR);
                        colEnv  = refColor0.rgb;
                        UNITY_BRANCH
                        if (unity_SpecCube0_BoxMin.w < 0.9999)
                        {
                            unity_SpecCube1.GetDimensions(mip,testw2,testh,lodMax);
                            envLOD  = perceptualRoughnessToMipmapLevel_ac(pRoughnessFix, lodMax);
                            float3 reflDir1 = BoxProjection(dEnv.dirViewReflection, i.worldPos, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
                            float4 refColor1    = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(unity_SpecCube1, unity_SpecCube0, reflDir1, envLOD);
                            refColor1.rgb   = DecodeHDR(refColor1, unity_SpecCube1_HDR);
                            colEnv  = lerp(refColor1.rgb, refColor0.rgb, unity_SpecCube0_BoxMin.w);
                        }
                    }
                    UNITY_BRANCH
                    if (_CubemapFallbackMode) //// not off
                    {
                        // float testw=0; float testh=0;
                        // unity_SpecCube0.GetDimensions(testw,testh);
                        UNITY_BRANCH
                        if ( (_CubemapFallbackMode > 1) || (testw < 16)) //// mode forced or smart. Conditionals cannot short-circit
                        {
                            _CubemapFallback.GetDimensions(mip,testw,testh,lodMax);
                            envLOD  = perceptualRoughnessToMipmapLevel_ac(pRoughnessFix, lodMax);
                            float4 colEnvBkup   = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(_CubemapFallback, unity_SpecCube0, reflDir0, envLOD);
                            colEnvBkup.rgb  = DecodeHDR(colEnvBkup, _CubemapFallback_HDR);
                            colEnv  = colEnvBkup;
                            colEnv  *= lightAverageLum;
                        }
                    }
                    //// natural grazing rim mask
                    if (_EnvGrazeMix)
                    {
                        envRimMask = Pow4_ac(1 - dEnv.ndv);
                    }
                    //// env on rim lights
                    float colEnvGray    = LinearRgbToLuminance_ac(colEnv);
                    envOntoRimSetup = lerp(colEnvGray, colEnv, _envOnRimColorize); 
                    envOntoRimSetup = lerp(1, envOntoRimSetup, _envOnRim);

                    //// gi light at a weird angle
                    float3 refGIcol = shadeSH9LinearAndWhole(float4(normalize(i.wNormal + dEnv.dirViewReflection),1));
                    colGIGray       = LinearRgbToLuminance_ac(refGIcol);
                }



//// rim lighting
                float rimLightMask, rimlightApMask;
                float3 rimLightCol, rimLightApCol;
                rimLightMask    = rimlightApMask    = 0;
                rimLightCol     = rimLightApCol     = 0;
                UV_DD uv_rimLight           = UVDD( TRANSFORM_TEX( i.uv, _Set_RimLightMask));
                UNITY_BRANCH
                if ((_RimLight) || (_Add_Antipodean_RimLight))
                {
                    float4 rimLightMaskTex  = _Set_RimLightMask.SampleGrad( sampler_MainTex_trilinear_repeat, uv_rimLight.uv, uv_rimLight.dx, uv_rimLight.dy);
                    float rimLightTexMask   = saturate( rimLightMaskTex.g + _Tweak_RimLightMaskLevel);
                    ////
                    float rimArea           = (1.0 - dRimLight.ndv);
                    rimArea                 += _RimLightAreaOffset;
                    float rimLightPower     = pow(rimArea, exp2( lerp( 3, 0, _RimLight_Power )));
                    float RimLightPowerAp   = pow(rimArea, exp2( lerp( 3, 0, _Ap_RimLight_Power )));
                    // rim mask
                    float rimlightMaskSetup;
                    float rimlightApMaskSetup;
                    rimlightMaskSetup       = saturate( (rimLightPower - _RimLight_InsideMask) / (1.0 - _RimLight_InsideMask));
                    rimlightApMaskSetup     = saturate( (RimLightPowerAp - _RimLight_InsideMask) / (1.0 - _RimLight_InsideMask));
                    ////
                    UNITY_BRANCH
                    if (_LightDirection_MaskOn)
                    {
                        float vdl                   = (dot(UNITY_MATRIX_V[2].xyz, dirLight) * .1 + .1); /// camera z forward vector
                        float rimlightMaskToward    = (1 - dRimLight.ndlS) + _Tweak_LightDirection_MaskLevel;
                        float rimLightMaskAway      = dRimLight.ndlS + _Tweak_LightDirection_MaskLevel;
                        rimLightMask                = saturate( rimlightMaskSetup - rimlightMaskToward - vdl);
                        rimlightApMask              = saturate( rimlightApMaskSetup - rimLightMaskAway - vdl);
                    } 
                    else {
                        rimLightMask    = rimlightMaskSetup;
                        rimlightApMask  = 0;
                    }
                    ////
                    rimLightMask                *= rimLightTexMask;
                    rimlightApMask              *= rimLightTexMask;
                    //// colors input
                    float3 rimTexAlbedo = 1;
                    UNITY_BRANCH
                    if (_rimAlbedoMix)
                    {
                        UNITY_BRANCH
                        if (_RimLightSource) 
                        {
                            rimTexAlbedo = specularSrcCol;
                        } else
                        {
                            rimTexAlbedo = shadeColor_albedo;
                        }
                        rimTexAlbedo = lerp(1, rimTexAlbedo, _rimAlbedoMix);
                    }
                    rimLightCol = _RimLightColor.rgb * rimTexAlbedo;
                    rimLightApCol = _Ap_RimLightColor.rgb * rimTexAlbedo;
                }



//// Emission
#ifdef UNITY_PASS_FORWARDBASE
                float4 emissiveMask     = _Emissive_Tex.Sample( sampler_EmissionColorTex_trilinear_repeat, TRANSFORM_TEX( i.uv, _Emissive_Tex));
                float4 emissionTex      = _EmissionColorTex.Sample( sampler_EmissionColorTex_trilinear_repeat, TRANSFORM_TEX( i.uv, _EmissionColorTex));
                float3 emissionColor    = max( (_EmissiveProportional_Color * lightAverageLum), _Emissive_Color.rgb);
                float3 emissionMixReal  = emissionTex.rgb * emissionColor * emissionTex.a;
                float3 emissionMix      = emissionMixReal;
                if (_MatCap){
                    float3 emissionMatcap   = mcMixEmis * _MatCapColEmis.rgb;
                    emissionMix             = max(emissionMix, emissionMatcap);
                }
                // emissionMix             *= emissiveMask.g;
                // return float4(emissionMatcap,1);
#endif //// UNITY_PASS_FORWARDBASE



////////////////////////////////////////////////////////////////
//// The Mix zone. Blend everything. In intent all effects are prepared. Requires masks and color sets.
                float4 fragColor    = 0;
                float3 colDiffuse   = 0;
                float3 colSpecular  = 0;
                float3 colFernel    = 0;
                float3 colReflect   = 0;
                float3 colEmission  = 0;

//// base diffuse
                //// mcMixMult shadeColor_albedo shadeColor
                colDiffuse      = shadeColor;
                if (_MatCap){ //// gets scene lighting from toon ramp chain
                    {
                        float3 lightDirectSim = (shadowBlackness * lightDirectSource) + lightIndirectSource;
                        // float3 lightDirectSim = (shadowBlackness * lightDirectSource) + lightIndirectSource;
                        colDiffuse = lerp(colDiffuse, (colDiffuse + (lightDirectSim * mcMixMult.rgb * _MatCapColMult.rgb * _MatCapColMult.a)), matcapMask);
                    }
                }

//// fernel
                float3 rimMixer = 0;
                if (_RimLight)
                {
                    rimMixer    += rimLightCol * rimLightMask;
                }
                if (_Add_Antipodean_RimLight)
                {
                    rimMixer    += rimLightApCol * rimlightApMask;
                }
                colFernel   = rimMixer;
                colFernel   *= (lightDirectSource * shadowBlackness) + lightIndirectSource; //// light is lazy combined
                colFernel   *= envOntoRimSetup;
                
                
//// specularity
                colSpecular = specMaskSetup_1 * aoSpecularM;
                colSpecular *= FresnelTerm_ac(highColorTotalCol_1, dSpec.ldh);
                colSpecular *= (lightDirectSource); //// specular shadow mask is in effect's stack
                // colSpecular *= (lightDirectSource * shadowBlackness) + lightIndirectSource; //// specular shadow mask is in effect's stack
                // return float4(colSpecular,1);



//// reflection
                float3 envColMixCore    = specularSrcCol;
#ifdef UNITY_PASS_FORWARDBASE
                float envGrazeMask      = max( (envRimMask), ((_EnvGrazeRimMix) ? max(rimLightMask, rimlightApMask) : 0)); //// mix graze types
                float surfaceReduction;
                if (_ENVMmode > 1) //// override
                { 
                    surfaceReduction    = _ENVMix;
                }
                else if (_ENVMmode > 0) { //// standard
                    float roughness     = PerceptualRoughnessToRoughness_ac(perceptualRoughness);
                    surfaceReduction    = _ENVMix / (roughness * roughness + 1.0);
                }
                else { //// none
                    surfaceReduction    = 0;
                }
                ////
                if (_ENVMmode > 0) //// using env
                {
                    float grazingTerm       = saturate(smoothness + (1 - oneMinusReflectivity));
                    float envColMixGraze    = grazingTerm * (1 + colGIGray);
                    float3 envColMix        = lerp(envColMixCore, envColMixGraze.xxx, envGrazeMask); //// graze effect
                    colReflect              = colEnv;
                    colReflect              *= surfaceReduction.xxx * aoSpecularM.xxx;
                    colReflect              *= envColMix;
                    // colReflect              *= lightAverageLum;
                    // return float4(colReflect,1);
                }
#endif //// UNITY_PASS_FORWARDBASE
                //// spec matcap
                if (_MatCap){
                    colReflect      += mcMixAdd * _MatCapColAdd.rgb * specularMatcapDes * lightAverageLum * _MatCapColAdd.a * matcapShaMask * aoSpecularM;
                }



                //// energy conservation
                float3 colDiffuseTerms      = (colDiffuse);
                float3 colSpecularTerms     = colSpecular + colFernel + colReflect;
                // float3 colSpecularTerms     = (colSpecular + colFernel) * lightDirectSource + colReflect;
                //// solve oneMinusReflectivity again. Might be use for transparancy
                colDiffuseTerms             = EnergyConservationBetweenDiffuseAndSpecular_ac(
                                                _Is_BlendAddToHiColor, colDiffuseTerms, specularSrcCol, oneMinusReflectivity); /// oneMinusReflectivity unused

                //// emission blending in premultiply format
#if !defined(NotAlpha) && !defined(UseAlphaDither) //// cutout mode. dont use premultiplay block
                UNITY_BRANCH
                if (_UseSpecAlpha)
                {
                    PremultiplyAlpha_ac(colDiffuseTerms/* inout */, alpha/* inout */, 1);
                    fragColor.rgb   += colDiffuseTerms + colSpecularTerms;
                    fragColor.a     = alpha;
                }
                else {
                    float3 fuseCol  = colDiffuseTerms + colSpecularTerms;
                    fuseCol         *= alpha;
                    fragColor.rgb   += fuseCol;
                    fragColor.a     = alpha;
                }
#else //// NotAlpha
                fragColor.rgb   = colDiffuseTerms + colSpecularTerms;
                fragColor.a     = alpha;
#endif //// NotAlpha
                fragColor.rgb   = max(0, fragColor);
                if (_forceLightClamp)
                {
                    float sceneIntensity = LinearRgbToLuminance_ac(lightDirectSource + lightIndirectSource);
                    if (sceneIntensity > 1.0) //// bloom defaults at > 1.1
                    {
                        fragColor.rgb = fragColor.rgb / sceneIntensity;
                    }
                } 
                //// blend emission
#ifdef UNITY_PASS_FORWARDBASE
                emissionMix     = lerp( lerp(0, fragColor.rgb, emissiveMask.g), (emissionMix), emissiveMask.g);
                colEmission     = emissionMix;
                fragColor.rgb   += colEmission;
#endif // UNITY_PASS_FORWARDBASE

                //// backface tint
                if (isBackFace){
                    fragColor.rgb *= _backFaceColorTint;
                }

                if (!(_forceLightClamp)) /// non HDR self post pressing, like standard cheats on emission.
                {
                #ifndef UNITY_HDR_ON
                    //// non HDR maps recurve
                    float ExposureBias  = 2;
                    float3 curr = Uncharted2Tonemap(fragColor.rgb * ExposureBias);
                    float3 whiteScale   = 1 / Uncharted2Tonemap(11.2);
                    fragColor.rgb   =  curr * whiteScale;
                    ////
                    // fragColor.rgb   = ACESFilm(fragColor.rgb);
                #endif
                }

                UNITY_APPLY_FOG(i.fogCoord, fragColor);
                return fragColor;
            }
#endif //// ACLS_CORE