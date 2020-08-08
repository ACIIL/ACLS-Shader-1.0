//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_SHADOWCASTER
#define ACLS_SHADOWCASTER
			////
			#include "./ACLS_HELPERS.cginc"

			uniform sampler2D _ClippingMask; uniform float4 _ClippingMask_ST;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
#ifdef Dither
			sampler3D _DitherMaskLOD;
#endif

			uniform int _DetachShadowClipping;
			uniform half _Tweak_transparency;
			uniform half _Clipping_Level;
			uniform half _Clipping_Level_Shadow;
			uniform int _Inverse_Clipping;
			uniform int _IsBaseMapAlphaAsClippingMask;






			struct VertexInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord0 : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput {
				// V2F_SHADOW_CASTER;
				float2 uv0 : TEXCOORD0;
				float4 worldPos	: TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
			};






			void vert(
				VertexInput v,
				out VertexOutput o,
				out float4 opos : SV_POSITION
			)
			{
                o  = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
                // UNITY_INITIALIZE_OUTPUT(VertexOutput, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.uv0 = v.texcoord0;
				opos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul( unity_ObjectToWorld, v.vertex);
				// float4 position	= UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
				// o.worldPos	= UnityApplyLinearShadowBias(position);
				// opos	= o.worldPos;
			}






			float4 frag(VertexOutput i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_TARGET 
			{
				UNITY_SETUP_INSTANCE_ID(i);
#ifndef NotAlpha
				float2 Set_UV0			= i.uv0;
				float4 clippingMaskTex	= tex2D(_ClippingMask,TRANSFORM_TEX(Set_UV0, _ClippingMask));
				float4 mainTex			= tex2D(_MainTex, TRANSFORM_TEX(Set_UV0, _MainTex));
				float useMainTexAlpha	= (_IsBaseMapAlphaAsClippingMask) ? mainTex.a : clippingMaskTex.r;
				float alpha             = (_Inverse_Clipping) ? (1.0 - useMainTexAlpha) : useMainTexAlpha;
				float clipTest			= (_DetachShadowClipping) ? _Clipping_Level_Shadow : _Clipping_Level;
				clip(alpha - clipTest);
				clipTest				= saturate(alpha + _Tweak_transparency);
	#ifdef Dither

				float dither			= ScreenDitherToAlphaCutout_ac(screenPos.xy, (1 - clipTest));
				// float dither			= tex3D(_DitherMaskLOD, float3(screenPos.xy * .25, clipTest * .99)).a;
				alpha					= alpha - dither;
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
