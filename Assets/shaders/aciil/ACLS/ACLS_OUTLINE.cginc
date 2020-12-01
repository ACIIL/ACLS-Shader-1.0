//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
            #include "./ACLS_HELPERS.cginc"

            uniform sampler2D _Outline_Sampler; uniform float4 _Outline_Sampler_ST;
            uniform Texture2D _MainTex;         uniform float4 _MainTex_ST;
            uniform Texture2D _OutlineTex;      uniform float4 _OutlineTex_ST;
            // uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            // uniform sampler2D _OutlineTex; uniform float4 _OutlineTex_ST;

            SamplerState sampler_MainTex_trilinear_repeat;

            uniform half _shadowCastMin_black;
            uniform float4 _Color;
            uniform float4 _Outline_Color;

            uniform int _outline_mode;
            uniform half _Outline_Width;
            uniform half _Farthest_Distance;
            uniform half _Nearest_Distance;
            uniform half _Is_BlendBaseColor;
            uniform half _Offset_Z;
            uniform int _Is_OutlineTex;

            uniform half _indirectAlbedoMaxAveScale;
            uniform half _indirectGIDirectionalMix;
            uniform half _indirectGIBlur;
            uniform half _directLightIntensity;
            uniform half _forceLightClamp;

            

#ifndef NotAlpha
            uniform Texture2D _ClippingMask; uniform float4 _ClippingMask_ST;
            uniform half _Clipping_Level;
            uniform half _Tweak_transparency;
            uniform int _Inverse_Clipping;
            uniform int _IsBaseMapAlphaAsClippingMask;
#endif



            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct VertexOutput {
                float4 pos          : SV_POSITION;
                float4 worldPos     : TEXCOORD0;
                float2 uv0          : TEXCOORD1;
                float3 wNormal    : TEXCOORD2;
                float3 dirGI        : TEXCOORD3;
                UNITY_SHADOW_COORDS(4)
                // LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
                half3 vertexLighting : TEXCOORD6;
                float outlineThick : TEXCOORD7;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };



//// vert            
            VertexOutput vert (VertexInput v) {
                UNITY_SETUP_INSTANCE_ID(v);
                VertexOutput o;
                UNITY_INITIALIZE_OUTPUT(VertexOutput, o);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.uv0           = v.texcoord0;
                o.wNormal     = UnityObjectToWorldNormal( v.normal);
                o.worldPos      = mul( unity_ObjectToWorld, v.vertex);
                // float3 worldviewPos     = float4(0,1,0);
                float3 worldviewPos     = _WorldSpaceCameraPos;
                // float3 worldviewPos     = StereoWorldViewPos(); //// wrong stereo for offline offset
                float outlineControlTex = tex2Dlod(_Outline_Sampler, float4(TRANSFORM_TEX(o.uv0, _Outline_Sampler), 0, 0)).r;
                o.outlineThick          = outlineControlTex;
                float outlineWidth      = saturate( RemapRange( (distance(o.worldPos.xyz, worldviewPos.xyz)),
                                                _Farthest_Distance, _Nearest_Distance, 0, 1));
                outlineWidth            *= outlineControlTex * _Outline_Width * 0.001;
                float3 posDiff          = worldviewPos.xyz - o.worldPos.xyz;
                float3 dirView          = normalize(posDiff);
                float4 viewDirectionVP  = mul( UNITY_MATRIX_VP, float4( dirView.xyz, 1));
                float4 posWorldHull     = o.worldPos;
                posWorldHull            = float4(posWorldHull.xyz + o.wNormal * outlineWidth, 1);

                UNITY_TRANSFER_FOG(o, o.pos);
                UNITY_TRANSFER_FOG(o, UnityWorldToClipPos(posWorldHull));
                posWorldHull.xyz    = posWorldHull.xyz + dirView * _Offset_Z;
                o.pos               = UnityWorldToClipPos(posWorldHull);
#ifdef VERTEXLIGHT_ON
                float3 vertTo0;
                o.vertexLighting    = softShade4PointLights_Atten(
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0
                    , unity_LightColor
                    , unity_4LightAtten0
                    , o.worldPos, o.wNormal, vertTo0);
#endif
#ifdef UNITY_PASS_FORWARDBASE
                o.dirGI = GIDominantDir();
#endif
                return o;
            }






//// frag
            float4 frag(
                VertexOutput i,
                bool frontFace : SV_IsFrontFace) : SV_Target{
                UNITY_SETUP_INSTANCE_ID(i);
                bool isAmbientOnlyMap   = !(any(_LightColor0.rgb));
                bool isBackFace         = !frontFace;
//// dynamic shadow
//// found dynamic shadows dont work in the spatiality of outline hulls.
                half shadowAtten    = 1;
            #ifdef DIRECTIONAL
                half lightAtten     = 1;
            #else
                UNITY_LIGHT_ATTENUATION_NOSHADOW(lightAtten, i, i.worldPos.xyz);
            #endif

//// world light albedo
#ifdef UNITY_PASS_FORWARDBASE
                //// prepare cubemap albedo support lighting
                // half3 refGIcol  = shadeSH9LinearAndWhole(float4(normalize(i.wNormal + dEnv.dirViewReflection),1)); //// gi light at a weird angle
                // half3 colGIGray = LinearRgbToLuminance_ac(refGIcol);

                //// get vertex lighting
                half3 vertexLit = i.vertexLighting;
                //// build indirect light source
                half3 lightIndirectColAve   = DecodeLightProbe_average();   //// L0 Average light
                half3 lightIndirectColL1    = max(0, SHEvalDirectL1(normalize(i.dirGI)));    //// L1 raw. Add to L0 as max color of GI
                half3 lightIndirectColStatic = 0, lightIndirectColDir = 0;
                // if ((_indirectGIDirectionalMix) < 1)
                if (true)
                {
                    half3 stackIndirectMaxL0L1 = lightIndirectColL1 + lightIndirectColAve;
                    half ratioCols = RatioOfColors(stackIndirectMaxL0L1, lightIndirectColAve, _indirectAlbedoMaxAveScale);
                    lightIndirectColStatic  = lerp(stackIndirectMaxL0L1, lightIndirectColAve, ratioCols);
                }
                if (_indirectGIDirectionalMix > 0)
                {
                    float4 indirectGIDirectionBlur  = float4(i.wNormal, (_indirectGIBlur + 0.001) );
                    lightIndirectColDir = max(0, ShadeSH9_ac(indirectGIDirectionBlur)) / (indirectGIDirectionBlur.w);
                }
                half3 lightIndirectCol  = lerp(lightIndirectColStatic, lightIndirectColDir, _indirectGIDirectionalMix);

                //// build direct, indirect
                half3 lightDirect           = _LightColor0.rgb;
                half3 lightIndirectSource   = (lightIndirectCol);
                half3 lightDirectSource     = 0;
                if (isAmbientOnlyMap) //// this setup sucks for preserving Direct light effects
                {
                    if (any(lightIndirectColL1)) //// L1 in pure ambient maps is black. Recover by spliting indirect energy.
                    {
                        lightDirectSource   = lightIndirectColL1;
                    }
                    else
                    {
                        lightDirectSource   = lightIndirectColAve * .2;
                        lightIndirectSource = lightIndirectColAve * .7;
                    }
                }
                else
                {
                    lightDirectSource = lightDirect;
                }
                lightDirectSource = (lightDirectSource + vertexLit) * _directLightIntensity;
                lightIndirectSource += vertexLit;

#elif UNITY_PASS_FORWARDADD
                float3 lightDirect      = _LightColor0.rgb;
                lightDirect             *= lightAtten;
                //// out light source by types
                float3 lightDirectSource    = lightDirect * _directLightIntensity;
                float3 lightIndirectSource  = 0;
#endif

//// simple light systems reused
                // half3 lightSimpleSystem = (lightDirectSource * shadowAtten) + lightIndirectSource;
                lightDirect             = _LightColor0.rgb;
#ifdef UNITY_PASS_FORWARDBASE
                half3 cubeMapAveAlbedo  = ((lightDirect * max(_shadowCastMin_black,_LightShadowData.x) * .5) + lightDirect ) * .5 + lightIndirectSource;
                half lightAverageLum    = LinearRgbToLuminance_ac(cubeMapAveAlbedo);
#elif UNITY_PASS_FORWARDADD
                half3 cubeMapAveAlbedo  = ((lightDirect * max(_shadowCastMin_black,_LightShadowData.x) * .5) + lightDirect) * .5 * lightAtten;
                half lightAverageLum    = LinearRgbToLuminance_ac(cubeMapAveAlbedo);
#endif

//// maintex
                UV_DD uv_toon           = UVDD( TRANSFORM_TEX( i.uv0, _MainTex));
                float4 mainTex          = _MainTex.SampleGrad(sampler_MainTex_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy);

//// clip & alpha handling. Here so clip() may interrupt flow.
                if (!(i.outlineThick)) //// a black mask means nothing
                {
                    clip(-1);
                }
#ifndef NotAlpha
                half4 clipMask         = _ClippingMask.Sample(sampler_MainTex_trilinear_repeat, TRANSFORM_TEX(i.uv0, _ClippingMask));
                half useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clipMask.r;
                half alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;

                half clipTest          = (alpha - _Clipping_Level);
                clip(clipTest);

    #ifndef IsClip
                alpha        = saturate(alpha + _Tweak_transparency);
        #ifdef UseAlphaDither
                // dither pattern with some a2c blending.
                //// citation to Silent and Xiexe for guidance and research documentation.
                //// assumes cutout blending + alpha to coverage. Subtracted alpha must return.
                float dither    = ScreenDitherToAlphaCutout_ac(screenUV.xy, (1 - alpha));
                alpha           = alpha - dither;
                clip(alpha);
        #endif //// UseAlphaDither
                alpha           = saturate(alpha);
    #else //// IsClip
                alpha           = 1;
    #endif //// IsClip
#else //// NotAlpha
                float alpha     = 1;
#endif //// NotAlpha

//// albedo mixer
                float4 outlineTex   = _OutlineTex.SampleGrad(sampler_MainTex_trilinear_repeat, uv_toon.uv, uv_toon.dx, uv_toon.dy);
                // float4 outlineTex   = tex2D( _OutlineTex, TRANSFORM_TEX( i.uv0, _OutlineTex));
                float3 outlineColor = _Outline_Color.rgb;
                UNITY_BRANCH
                if (_Is_BlendBaseColor)
                {
                    outlineColor    *= mainTex.rgb;
                }
                UNITY_BRANCH
                if (_Is_OutlineTex)
                {
                    outlineColor    *= outlineTex.rgb;
                }
                outlineColor    *= cubeMapAveAlbedo;

                //// color proccessing
                if (_forceLightClamp)
                {
                    float sceneIntensity = LinearRgbToLuminance_ac(lightDirectSource + lightIndirectSource); //// grab all light at max potencial
                    if (sceneIntensity > 1.0) //// bloom defaults at > 1.1
                    {
                        outlineColor.rgb = outlineColor.rgb / sceneIntensity;
                    }
                }
                if (!(_forceLightClamp)) /// non HDR self post pressing, like how Standard cheats on emission.
                {
                #ifndef UNITY_HDR_ON
                    //// non HDR maps recurve
                    float ExposureBias  = 2;
                    float3 curr = Uncharted2Tonemap(outlineColor.rgb * ExposureBias);
                    float3 whiteScale   = 1 / Uncharted2Tonemap(11.2);
                    outlineColor.rgb   =  curr * whiteScale;
                #endif
                }

                UNITY_APPLY_FOG( i.fogCoord, outlineColor);
                float4 outlineColorA = float4(outlineColor, alpha);
                return outlineColorA;
            }