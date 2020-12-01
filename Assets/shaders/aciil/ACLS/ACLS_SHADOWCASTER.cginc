//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_SHADOWCASTER
#define ACLS_SHADOWCASTER
            ////
            #include "./ACLS_HELPERS.cginc"

            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _ClippingMask; uniform float4 _ClippingMask_ST;
            uniform sampler2D _Outline_Sampler; uniform float4 _Outline_Sampler_ST;
#ifdef Dither
            sampler3D _DitherMaskLOD;
#endif

            uniform int _DetachShadowClipping;
            uniform half _Tweak_transparency;
            uniform half _Clipping_Level;
            uniform half _Clipping_Level_Shadow;
            uniform int _Inverse_Clipping;
            uniform int _IsBaseMapAlphaAsClippingMask;
            // outline
            uniform half _outline_mode;
            uniform half _Outline_Width;
            uniform half _Farthest_Distance;
            uniform half _Nearest_Distance;
            uniform half _Offset_Z;






            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct VertexOutput {
                // V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD0;
                float4 worldPos    : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };






            void vert
            (
                VertexInput v,
                out VertexOutput o,
                out float4 opos : SV_POSITION
            )
            {
                o  = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.uv0 = v.texcoord0;
                opos = UnityObjectToClipPos(v.vertex);
                o.normalDir = UnityObjectToWorldNormal( v.normal);
                o.worldPos  = mul( unity_ObjectToWorld, v.vertex);
// #ifdef IsOutline
//                 //// outline
//                 // float3 worldviewPos     = float4(0,1,0);
//                 float3 worldviewPos     = StereoWorldViewPos();
//                 half4 outlineControlTex = tex2Dlod( _Outline_Sampler, float4( TRANSFORM_TEX(o.uv0, _Outline_Sampler), 0, 0));
//                 float outlineWidth      = smoothstep( _Farthest_Distance, _Nearest_Distance, distance(o.worldPos.xyz, worldviewPos.xyz)); 
//                 outlineWidth            *= outlineControlTex.r * _Outline_Width * 0.001;
//                 float3 posDiff          = worldviewPos.xyz - o.worldPos.xyz;
//                 float3 dirView          = normalize(posDiff);
//                 // float4 viewDirectionVP  = mul( UNITY_MATRIX_VP, float4( dirView.xyz, 1));
//                 float4 posWorldHull     = o.worldPos;
//                 if (_outline_mode)//// POS
//                 {
//                     outlineWidth    = outlineWidth * 2;
//                     float signVar   = (dot(normalize(v.vertex),normalize(v.normal))<0) ? -1 : 1;
//                     posWorldHull    = float4(posWorldHull.xyz + signVar*normalize(v.vertex) * outlineWidth, 1);
//                 }
//                 else//// NML
//                 {
//                     posWorldHull    = float4(posWorldHull.xyz + o.normalDir * outlineWidth, 1);
//                 }
//                 posWorldHull.xyz    = posWorldHull.xyz + dirView * _Offset_Z;
//                 float4 position      = UnityWorldSpaceShadowCasterPos(posWorldHull, v.normal);
// #else
                float4 position     = UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
// #endif
                // float4 position    = UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
                o.worldPos    = UnityApplyLinearShadowBias(position);
                opos    = o.worldPos;
            }






            float4 frag(VertexOutput i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_TARGET 
            {
                UNITY_SETUP_INSTANCE_ID(i);
#ifndef NotAlpha
                float2 Set_UV0          = i.uv0;
                float4 clippingMaskTex  = tex2D(_ClippingMask,TRANSFORM_TEX(Set_UV0, _ClippingMask));
                float4 mainTex          = tex2D(_MainTex, TRANSFORM_TEX(Set_UV0, _MainTex));
                float useMainTexAlpha   = (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clippingMaskTex.r;
                float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;
                float clipTest          = (_DetachShadowClipping) ? _Clipping_Level_Shadow : _Clipping_Level;
                clip(alpha - clipTest);
                clipTest                = saturate(alpha + _Tweak_transparency);
    #ifdef Dither

                float dither    = ScreenDitherToAlphaCutout_ac(screenPos.xy, (1 - clipTest));
                alpha           = alpha - dither;
                clip(alpha );
                // clip(alpha );
    #else //// Dither
                clip(clipTest);
    #endif //// Dither
                // return 0;
                SHADOW_CASTER_FRAGMENT(i)
#else //// NotAlpha
                // return 0;
                SHADOW_CASTER_FRAGMENT(i)
#endif //// NotAlpha
            }
#endif // ACLS_SHADOWCASTER
