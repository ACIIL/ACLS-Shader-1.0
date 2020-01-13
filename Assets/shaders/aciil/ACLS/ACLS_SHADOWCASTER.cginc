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
				float2 texcoord0 : TEXCOORD0;
			};

			struct VertexOutput {
				// V2F_SHADOW_CASTER;
				float2 uv0 : TEXCOORD0;
				float4 worldPos	: TEXCOORD1;
			};






			VertexOutput vert (
				float4 vertex : POSITION,
				float2 uv : TEXCOORD0,
				out float4 outpos : SV_POSITION
			) {
				VertexOutput o	= (VertexOutput)0;
				o.uv0			= uv;
				outpos		= UnityObjectToClipPos( vertex );
				o.worldPos		= mul( unity_ObjectToWorld, vertex);
				// TRANSFER_SHADOW_CASTER(o)
				return o;
			}






			float4 frag(VertexOutput i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_TARGET {
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
				// alpha					= (alpha - 0.5);
				// alpha					= (alpha - 0.01);
				clip(alpha );
				// clip(alpha );
	#else //// Dither
				clip(clipTest);
	#endif //// Dither
				SHADOW_CASTER_FRAGMENT(i)
#else //// NotAlpha
				SHADOW_CASTER_FRAGMENT(i)
#endif //// NotAlpha
			}
#endif // ACLS_SHADOWCASTER
