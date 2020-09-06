//// ACiiL
//// Citations in readme and in source.
//// https://github.com/ACIIL/ACLS-Shader
#ifndef ACLS_HELPERS
#define ACLS_HELPERS

#include "UnityStandardBRDF.cginc"
// #include "UnityBuiltin3xTreeLibrary.cginc"
// #include "UnityPBSLighting.cginc"

        struct UV_DD { //// holds UV and derivatives for conservative tex lookups
            float2 uv;
            float2 dx;
            float2 dy;
        };

        //// get UV derivatives 
        UV_DD UVDD(float2 UV){
            UV_DD o;// = (UV_DD)0;
            o.uv    = UV;  
            o.dx    = ddx(UV);
            o.dy    = ddy(UV);
            return o;
        }

        //// https://godotengine.org/qa/41400/simple-texture-rotation-shader
        float2 rotateUV(float2 uv, float2 pivot, float rotation) {
            float cosA  = cos(rotation);
            float sinA  = sin(rotation);
            return mul( (uv - pivot), 
                        float2x2(cosA, -sinA, sinA, cosA)) 
                        + pivot;
        }
        ////
        float2 scaleUV(float2 uv, float2 pivot, float scale)
        {
            return (uv - pivot) * scale + pivot;
        }
        //// UnityBuiltin3xTreeLibrary.cginc
        float ScreenDitherToAlphaCutout_ac(float2 uv, float c0)
        {
            //dither matrix reference: https://en.wikipedia.org/wiki/Ordered_dithering
            const float dither[64] = {
                0, 32, 8, 40, 2, 34, 10, 42,
                48, 16, 56, 24, 50, 18, 58, 26 ,
                12, 44, 4, 36, 14, 46, 6, 38 ,
                60, 28, 52, 20, 62, 30, 54, 22,
                3, 35, 11, 43, 1, 33, 9, 41,
                51, 19, 59, 27, 49, 17, 57, 25,
                15, 47, 7, 39, 13, 45, 5, 37,
                63, 31, 55, 23, 61, 29, 53, 21 };

            int xMat = int(uv.x) & 7;
            int yMat = int(uv.y) & 7;

            float limit = (dither[yMat * 8 + xMat] + 11.0) / 64.0;
            //could also use saturate(step(0.995, c0) + limit*(c0));
            return step(limit, c0 + 0.01);
            // return limit;
        }
        //// UnityBuiltin3xTreeLibrary.cginc
        float ScreenDitherToAlpha_ac(float2 uv, float c0)
        {
            //dither matrix reference: https://en.wikipedia.org/wiki/Ordered_dithering
            const float dither[64] = {
                0, 32, 8, 40, 2, 34, 10, 42,
                48, 16, 56, 24, 50, 18, 58, 26 ,
                12, 44, 4, 36, 14, 46, 6, 38 ,
                60, 28, 52, 20, 62, 30, 54, 22,
                3, 35, 11, 43, 1, 33, 9, 41,
                51, 19, 59, 27, 49, 17, 57, 25,
                15, 47, 7, 39, 13, 45, 5, 37,
                63, 31, 55, 23, 61, 29, 53, 21 };

            int xMat = int(uv.x) & 7;
            int yMat = int(uv.y) & 7;

            float limit = (dither[yMat * 8 + xMat] + 11.0) / 64.0;
            //could also use saturate(step(0.995, c0) + limit*(c0));
            //original step(limit, c0 + 0.01);

            return lerp(limit*c0, 1.0, c0);
        }
        //// UnityBuiltin3xTreeLibrary.cginc
        float ComputeAlphaCoverage_ac(float4 screenPos, float fadeAmount)
        {
            float2 pixelPosition = screenPos.xy / (screenPos.w + 0.00001);
            pixelPosition *= _ScreenParams;
            float coverage = ScreenDitherToAlpha_ac(pixelPosition, fadeAmount);
            return coverage;
        }

        //// raw ambient color by direction
        float3 DecodeLightProbe( float4 N ){
            return ShadeSH9(N);
        }

        //// Fancy shadeSH9 ringing correction 
        //// Method appears to be from:
        //// "Reconstructing Diffuse Lighting from Spherical Harmonic Data - Geomerics"
        //// this version from bakery.
        //// https://git.technolabs.com.br/ttravi/light-editor/blob/master/LightEditor/Assets/Bakery/shader/Bakery.cginc
        //// Other examples 
        //// https://github.com/kayru/Probulator/blob/master/Source/Probulator/SphericalHarmonics.h
        //// https://github.com/Xiexe/Unity-Lit-Shader-Templates/blob/68c695dc50ad18a754b1434f00366fd3a89fdc0f/XSShaderTemplates/Templates/Shared/LightingFunctions.cginc#L184
        float shEvaluateDiffuseL1Geomerics(float L0, float3 L1, float3 n)
        {
            // average energy
            float R0 = L0;

            // avg direction of incoming light
            float3 R1 = 0.5f * L1;

            // directional brightness
            float lenR1 = length(R1);

            // linear angle between normal and direction 0-1
            //float q = 0.5f * (1.0f + dot(R1 / lenR1, n));
            //float q = dot(R1 / lenR1, n) * 0.5 + 0.5;
            float q = dot(normalize(R1), n) * 0.5 + 0.5;

            // power for q
            // lerps from 1 (linear) to 3 (cubic) based on directionality
            float p = 1.0f + 2.0f * lenR1 / R0;

            // dynamic range constant
            // should vary between 4 (highly directional) and 0 (ambient)
            float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);

            return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
        }
        
        //// ambient color
        float3 DecodeLightProbe_average(){
            return float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
            // unity v2017.4.15f1. May break in other versions.
            //return (1 - softGI) * ShadeSH9( float4(N, 1)) + (softGI) * ShadeSH9( float4(0,0,0,1));
            // return ShadeSH9( float4(0,0,0,1));
        }

        //// (Unity)
        //// normal should be normalized, w=1.0
        half3 SHEvalLinearL0L1_ac (half4 normal)
        {
            half3 x;
            // Linear (L1) + constant (L0) polynomial terms
            x.r = dot(unity_SHAr,normal);
            x.g = dot(unity_SHAg,normal);
            x.b = dot(unity_SHAb,normal);
            return x;
        }
        // normal should be normalized, w=1.0
        half3 SHEvalLinearL2_ac (half4 normal)
        {
            half3 x1, x2;
            // 4 of the quadratic (L2) polynomials
            half4 vB = normal.xyzz * normal.yzzx;
            x1.r = dot(unity_SHBr,vB);
            x1.g = dot(unity_SHBg,vB);
            x1.b = dot(unity_SHBb,vB);

            // Final (5th) quadratic (L2) polynomial
            half vC = normal.x*normal.x - normal.y*normal.y;
            x2 = unity_SHC.rgb * vC;
            return x1 + x2;
        }
        ////
        half3 SHEvalDirectL1(half4 normal)
        {
            half3 L0;
            L0.r = dot(unity_SHAr,normal);
            L0.g = dot(unity_SHAg,normal);
            L0.b = dot(unity_SHAb,normal);
            return L0;
        }

        //// GI L0 + L2 terms integrated to an average.
        //// lox9973
        float3 DecodeLightProbeAllAverage()
        {
            return float3(unity_SHAr.w + unity_SHBr.z/3, unity_SHAg.w + unity_SHBg.z/3, unity_SHAb.w + unity_SHBb.z/3);
        }

        // normal should be normalized, w=1.0
        // output in active color space
        half3 ShadeSH9_ac (half4 normal)
        {
            // Linear + constant polynomial terms
            half3 res = SHEvalLinearL0L1_ac (normal);
            // Quadratic polynomials
            res += SHEvalLinearL2_ac (normal);
        #ifdef UNITY_COLORSPACE_GAMMA
            res = LinearToGammaSpace (res);
        #endif
            return res;
        }

        //// adaptive ringing corrected SH color
        float3 shadeSH9LinearAndWhole(float4 worldNormal)
        {
            float3 indirectDiffuse;
            float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
            indirectDiffuse.r = shEvaluateDiffuseL1Geomerics(L0.r, unity_SHAr.xyz, worldNormal.xyz);
            indirectDiffuse.g = shEvaluateDiffuseL1Geomerics(L0.g, unity_SHAg.xyz, worldNormal.xyz);
            indirectDiffuse.b = shEvaluateDiffuseL1Geomerics(L0.b, unity_SHAb.xyz, worldNormal.xyz);
            //// want to add more detail but L2 also rings
            // float3 L2       = SHEvalLinearL2_ac(worldNormal);
            // indirectDiffuse += L2;
            return max(0, indirectDiffuse);
        }

        //// Samples light probes and best guess primary direction.
        //// Neitri's help.
        //// https://www.gamasutra.com/view/news/129689/Indepth_Extracting_dominant_light_from_Spherical_Harmonics.php
        //// In-depth: Extracting dominant light from Spherical Harmonics 
        //// https://www.gamasutra.com/view/news/129689/Indepth_Extracting_dominant_light_from_Spherical_Harmonics.php
        //// "Stupid Spherical Harmonics (SH) Tricks"
        //// http://www.ppsloan.org/publications/StupidSH36.pdf
        float3 GIDominantDir()
        {
            // float3 GIsonar_dir_vec  = (.3 * unity_SHAr.xyz + .59 * unity_SHAg.xyz + .11 * unity_SHAb.xyz);
            float3 GIsonar_dir_vec  = 
                 (unity_ColorSpaceLuminance.r * unity_SHAr.xyz 
                + unity_ColorSpaceLuminance.g * unity_SHAg.xyz 
                + unity_ColorSpaceLuminance.b * unity_SHAb.xyz);
            // float3 GIsonar_dir_vec  = (unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz);
            // if ( dot( GIsonar_dir_vec, GIsonar_dir_vec) != 0)
            UNITY_FLATTEN
            if ( any(GIsonar_dir_vec))
            {
                GIsonar_dir_vec     = normalize(GIsonar_dir_vec);
            } else {
                GIsonar_dir_vec     = float3(0,0,0);
            }
            return GIsonar_dir_vec;
        }

        //// original cite from Arktoon
        //// Does not include unity_SHC term (incomplete L2)
        half3 GetSHLength ()
        {
            half3 x, x1;
            x.r     = length(unity_SHAr);
            x.g     = length(unity_SHAg);
            x.b     = length(unity_SHAb);
            x1.r    = length(unity_SHBr);
            x1.g    = length(unity_SHBg);
            x1.b    = length(unity_SHBb);
            return  x + x1;
        }

        // mix colors compromising saturation peaks and intensity
        float3 mixColorsMaxAve(float3 a, float3 b)
        {
            // return min((a + b)*.5, max(a, b));
            float3 ave  = (a+b)*.5;
            return (max(a, b)+ave)*.5;
        }

        //// https://www.shadertoy.com/view/ldtXDj
        //// camera HDR off means self curving color is safe, as Standard's emission cheats by curving intensity
        //// suggestion from lox9973
        float3 ACESFilm( float3 x )
        {
            float a = 2.51;
            float b = 0.03;
            float c = 2.43;
            float d = 0.59;
            float e = 0.14;
            return clamp((x*(a*x+b))/(x*(c*x+d)+e), 0.0, 1.0);
        }
        //// alternative tonemap
        //// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
        float3 Uncharted2Tonemap(float3 x)
        {
            float A = 0.15; // shoulder strength
            float B = 0.50; // linera strength
            float C = 0.10; // linear angle
            float D = 0.20; // toe strength
            float E = 0.02; // toe numerator
            float F = 0.30; // toe denominator
            float W = 11.2; // E/F = toe angle
            return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
        }

        // (Unity) Convert rgb to luminance
        // with rgb in linear space with sRGB primaries and D65 white point
        half LinearRgbToLuminance_ac(half3 linearRgb)
        {
            return dot(linearRgb, half3(0.2126729f,  0.7151522f, 0.0721750f));
        }

        // unity's modified version without the lambert tint darkening and hard distance clip.
        // vertTo0 - first VL position
        float3 softShade4PointLights_Atten (
            float4 lightPosX, float4 lightPosY, float4 lightPosZ,
            half4 unityLightColor[8],
            half4 unity4LightAtten0,
            float3 pos,
            float3 normal,
            out float3 vertTo0)
        {
            // to light vectors
            float4 toLightX = lightPosX - pos.x;
            float4 toLightY = lightPosY - pos.y;
            float4 toLightZ = lightPosZ - pos.z;
            vertTo0 = float3(toLightX[0], toLightY[0], toLightZ[0]);
            if ( any(vertTo0) != 0){
            // if ( dot( vertTo0, vertTo0) != 0){
                vertTo0 = normalize(vertTo0);
            } else {
                vertTo0 = float3(0,0,0);
            }
            // squared lengths
            float4 lengthSq = 0;
            lengthSq += toLightX * toLightX;
            lengthSq += toLightY * toLightY;
            lengthSq += toLightZ * toLightZ;
            // don't produce NaNs if some vertex position overlaps with the light
            lengthSq = max(lengthSq, 0.000001);
            // attenuation
            float4 disLimit = (lengthSq * unity4LightAtten0);
            disLimit        = ((disLimit) > 30) ? 1.#INF : disLimit;
            float4 atten    = (1.0 / (1.0 + disLimit));
            // atten    = lerp(0, atten, saturate(unity4LightAtten0*lengthSq));
            // float4 atten = saturate(1.0 / (1.0 + lengthSq * lightAttenSq) - 0.034);

            float3 col = 0;
            col += unityLightColor[0] * atten[0];
            col += unityLightColor[1] * atten[1];
            col += unityLightColor[2] * atten[2];
            col += unityLightColor[3] * atten[3];
            return col;
        }

        //// attenuated colors of 4 vertex lights and attenuation pass out of closest light.
        fixed3 softShade4PointLights_Atten (
            float4 lightPosX, float4 lightPosY, float4 lightPosZ,
            fixed3 lightColor0, fixed3 lightColor1, fixed3 lightColor2, fixed3 lightColor3,
            fixed4 lightAttenSq,
            float3 pos,
            out fixed4 attenVert
            )
        {
            // to light vectors
            float4 toLightX = lightPosX - pos.x;
            float4 toLightY = lightPosY - pos.y;
            float4 toLightZ = lightPosZ - pos.z;

            // squared lengths
            fixed4 lengthSq = 0;
            lengthSq += toLightX * toLightX;
            lengthSq += toLightY * toLightY;
            lengthSq += toLightZ * toLightZ;
            // don't produce NaNs if some vertex position overlaps with the light
            lengthSq = max(lengthSq, 0.000001);

            // attenuation
            fixed4 atten = saturate(1.0 / (1.0 + lengthSq * lightAttenSq) - 0.034);
            attenVert = atten;

            fixed3 col = 0;
            col += lightColor0 * atten[0];
            col += lightColor1 * atten[1];
            col += lightColor2 * atten[2];
            col += lightColor3 * atten[3];
            return col;
        }

        // Returns direction of first vertex light.
        float3 softShade4PointLights_direction (
            float4 lightPosX, float4 lightPosY, float4 lightPosZ,
            float3 pos)
        {
        #ifdef VERTEXLIGHT_ON
            float3 toLight      = float3(lightPosX[0], lightPosY[0], lightPosZ[0]) - pos;
            float3 dirVertLight = Unity_SafeNormalize(toLight);
        #else
            float3 toLight      = 0;
        #endif
            return toLight;
        }

        //// vrchat shader community. Not sure exactly whom poked the mirror code to solve this.
        bool IsInMirror()
        {
            return (unity_CameraProjection[2][0] != 0.0f) || (unity_CameraProjection[2][1] != 0.0f);
        }
        
        ////
        float sqr(float x){
            return x*x; 
        }

        //// Simplified box projection
        //// https://catlikecoding.com/unity/tutorials/rendering/part-8/
        float3 BoxProjection (
            float3 direction, float3 position,
            float4 cubemapPosition, float3 boxMin, float3 boxMax) 
        {
            UNITY_BRANCH
            if (cubemapPosition.w > 0) {
                float3 factors  =
                    ((direction > 0 ? boxMax : boxMin) - position) / direction;
                float scalar = min(min(factors.x, factors.y), factors.z);
                direction = direction * scalar + (position - cubemapPosition);
            }
            return direction;
        }

        //// https://www.shadertoy.com/view/4djSRW
        float hash13(float3 p3)
        {
            // p3 = frac(p3 * .1031);
            p3  = frac(p3 * 13);
            p3  += dot(p3, p3.yzx + 19.19);
            return frac((p3.x + p3.y) * p3.z);
        }

        float rand3(float3 co){
            return frac(sin(dot(co.xyz ,float3(12.9898,78.233,213.576))) * 43758.5453);
        }

        float3 hash3( float2 p )
        {
            float3 q = float3( dot(p,float2(127.1,311.7)), 
                        dot(p,float2(269.5,183.3)), 
                        dot(p,float2(419.2,371.9)) );
            return frac(sin(q)*43758.5453);
        }

        ////
        float3 StereoWorldViewPos() {
            #if UNITY_SINGLE_PASS_STEREO
            float3 cameraPos    = 
                float3((unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * .5); 
            #else
            float3 cameraPos    = _WorldSpaceCameraPos;
            #endif
            return cameraPos;
        }

        ////
        float3 StereoWorldViewDir( float3 worldPos) {
            float3 cameraPos    = StereoWorldViewPos();
            float3 worldViewDir = (cameraPos - worldPos);
            return worldViewDir;
        }

        ////
        float3 HSVToRGB( float3 c )
        {
            float4 K    = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
            float3 p    = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
            return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
        }

        ////
        float3 RGBToHSV(float3 c)
        {
            float4 K    = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 p    = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
            float4 q    = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
            float d     = q.x - min( q.w, q.y );
            float e     = 1.0e-10;
            return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
        }

        //// x: x, m: threshold, n: f(x=0)=
        inline float almostIdentity( float x, float m, float n )
        {
            if( x>m ) return x;
            float a = 2.0*n - m;
            float b = 2.0*m - 3.0*n;
            float t = x/m;
            return (a*t + b)*t*t + n;
        }

        //// (Unity). Modifed as LOD max is not 6 as Unity assumed.
        half perceptualRoughnessToMipmapLevel_ac(half perceptualRoughness,half lodMax)
        {
            return (perceptualRoughness * lodMax);
            // return log2(perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS);
        }
        
        ////
        half ColStrength_ac(half3 specular) {
                return max(max(specular.r, specular.g), specular.b);
        }

        //// Diffuse/Spec Energy conservation. Specular setup
        inline float3 EnergyConservationBetweenDiffuseAndSpecular_ac(
            int notConserveMode, half3 albedo, half3 specColor, out half oneMinusReflectivity)
        {
            // oneMinusReflectivity    = max(0, totalColLum.xxx - ColStrength_ac(specColor)); /// > 1 HDR specColor
            oneMinusReflectivity    = max(0, 1 - ColStrength_ac(specColor)); /// > 1 HDR specColor
            UNITY_BRANCH
            if (notConserveMode)
            {
                half3 albedoAdd     = albedo;
                return albedoAdd;
            } 
            else {
                // half3 albedoConMono = albedo * max(0, (albedo - specColor)); // intensity diff
                // half3 albedoConMono = albedo * max(0, (ColStrength_ac(albedo) - ColStrength_ac(specColor))); // intensity diff
                // half3 albedoConMono = albedo * max(0,(1 - ( specColor))); // not HDR safe.
                half3 albedoConMono = albedo * oneMinusReflectivity;
                return albedoConMono;
            }
        }

        //// Specular setup. Assumes color <= 1.0
        inline void EnergyConservationBetweenDiffuseAndSpecularOMF(half3 specColor, out half oneMinusReflectivity)
        {
            oneMinusReflectivity    = max(0, 1 - ColStrength_ac(specColor));
        }

        //// (Unity). Support of Metallic setup
        inline half OneMinusReflectivityFromMetallic_ac(half metallic)
        {
            // We'll need oneMinusReflectivity, so
            //   1-reflectivity = 1-lerp(dielectricSpec, 1, metallic) = lerp(1-dielectricSpec, 0, metallic)
            // store (1-dielectricSpec) in unity_ColorSpaceDielectricSpec.a, then
            //   1-reflectivity = lerp(alpha, 0, metallic) = alpha + metallic*(0 - alpha) =
            //                  = alpha - metallic * alpha
            half oneMinusDielectricSpec = unity_ColorSpaceDielectricSpec.a;
            return oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
        }

        //// (Unity). Metallic setup
        inline half3 DiffuseAndSpecularFromMetallic_ac(half3 albedo, half metallic, out half3 specColor, out half oneMinusReflectivity)
        {
            specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic);
            oneMinusReflectivity = OneMinusReflectivityFromMetallic(metallic);
            return albedo * oneMinusReflectivity;
        }

        //// shiny reflections are always visible. Dim diffuse and raise the final output alpha.
        void PremultiplyAlpha_ac (inout float3 diffuse, inout float alpha, float oneMinusReflectivity) 
        {
            //// alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
            diffuse *= alpha;
            // alpha   = lerp(alpha, 1, (1-oneMinusReflectivity));
            alpha = 1 - oneMinusReflectivity + alpha * oneMinusReflectivity;
            
        }

        ////
        inline half4 Pow4_ac (half4 x)
        {
            return x*x*x*x;
        }
        inline half4 Pow5_ac (half4 x)
        {
            return x*x*x*x*x;
        }
        //// (Unity) approximage Schlick with ^4 instead of ^5
        //// Lerps F0 to F90 as cosA decreases
        inline half3 FresnelLerpFast_ac (half3 F0, half3 F90, half cosA)
        {
            half t  = Pow4_ac(1 - cosA);
            return  lerp (F0, F90, t);
        }
        //// (Unity). CosA increasing converts color F0 to white.
        //// Modified to handle HDR specular.
        //// A deceptive name its more like "whiten"
        inline half3 FresnelTerm_ac (half3 F0, half cosA)
        {
            half t  = Pow5_ac(1 - cosA);        //// ala Schlick interpoliation
            half m  = ColStrength_ac(F0);
            return  F0 + (m-F0) * t;    //// HDR spec color limit
        }
        //// version that reuses specular reflectivity
        inline half3 FresnelTerm_ac (half3 F0, half cosA, half oneMinusReflectivity)
        {
            half t  = Pow5_ac(1 - cosA);        //// ala Schlick interpoliation
            half m  = 1-oneMinusReflectivity;
            return  F0 + (m-F0) * t;    //// HDR spec color limit
        }

        float PerceptualRoughnessToRoughness_ac(float perceptualRoughness)
        {
            return perceptualRoughness * perceptualRoughness;
        }

        //// Unity
        inline half PerceptualRoughnessToSpecPower_ac (half perceptualRoughness)
        {
            half m = PerceptualRoughnessToRoughness_ac(perceptualRoughness);   // m is the true academic roughness.
            // half m = perceptualRoughness * perceptualRoughness;   // m is the true academic roughness.
            half sq = max(1e-4f, m*m);
            half n = (2.0 / sq) - 2.0;  // https://dl.dropboxusercontent.com/u/55891920/papers/mm_brdf.pdf
            n = max(n, 1e-4f);          // prevent possible cases of pow(0,0), which could happen when roughness is 1.0 and NdotH is zero
            return n;
        }
        ////
        inline half RoughnessToSpecPower_ac (half roughness)
        {
            half m = (roughness);
            half sq = max(1e-4f, m*m);
            half n = (2.0 / sq) - 2.0;
            n = max(n, 1e-4f);
            return n;
        }

        //// Mihoyo's 2017-2018 unity GDC presentation on their toon shading.
        float StrandSpecular(
            float3 dirTangent,  float3 ndh,
            float exponent,     float strength)
        {
            float tdh       = dot(dirTangent, ndh);
            float sinTH     = sqrt(1 - tdh*tdh);
            float attenDir  = smoothstep(-1, 0, tdh);
            return attenDir * pow( sinTH, exponent) * strength;
        }

        //// Mihoyo's 2017-2018 unity GDC presentation on their toon shading.
        float3 ShiftTangent(float3 dirTangent, float3 dirNormal, float shift)
        {
            float3 shiftedT = dirNormal * shift + dirTangent;
            return normalize(shiftedT);
        }

        //// Mihoyo's 2017-2018 unity GDC presentation on their toon shading.
        float3 ShiftBitangent(float3 dirBitangent, float3 dirNormal, float shift)
        {
            float3 shiftedB = dirNormal * shift + dirBitangent;
            return normalize(shiftedB);
        }

        //// Trick for continous func ramps. Citing UTS2 for the common usage.
        float StepFeatherRemap(float normalization, float step, float feather)
        {
            float var   = normalization - step + feather;
            // var         = 1 + var / feather;
            var         = 0 + var / feather;
            return      saturate(var);
        }
        //// float3 version
        float3 StepFeatherRemap3(float3 normalization, float step, float feather)
        {
            float3 var  = normalization - step + feather;
            var         = 1 + var / feather;
            var         = var / normalization;
            return      max(0,var);
        }

        ////
        float RemapRange(float value, float low1, float high1, float low2, float high2)
        {
            return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
        }

        //// 
        float RemapRange01(float value, float low2, float high2)
        {
            return low2 + (value) * (high2 - low2);
        }

        //// https://www.jordanstevenstechart.com/physically-based-rendering
        //// KelemenGeometricShadowingFunction
        float KelemenGSF(float NdotL, float NdotV, float VdotH){
            float Gs    = (NdotL * NdotV) / (VdotH * VdotH); 
            return (Gs);
        }
        float AshikhminPremozeGSF(float NdotL, float NdotV)
        {
            float Gs    = (NdotL * NdotV)/(NdotL + NdotV - NdotL * NdotV);
            return  (Gs);
        }

        //// (Unity)
        inline float GGXTerm_ac (float NdotH, float roughness)
        {
            float a2    = roughness * roughness;
            float d     = (NdotH * a2 - NdotH) * NdotH + 1.0f;
            return      UNITY_INV_PI * a2 / (d * d + 1e-7f);
        }
        //// Ref: http://jcgt.org/published/0003/02/03/paper.pdf
        inline float SmithJointGGXVisibilityTerm_ac(float NdotL, float NdotV, float roughness)
        {
            // Approximation of the above formulation (simplify the sqrt, not mathematically correct but close enough)
            float a         = roughness;
            float lambdaV   = NdotL * (NdotV * (1 - a) + a);
            float lambdaL   = NdotV * (NdotL * (1 - a) + a);
            return          0.5f / (lambdaV + lambdaL + 1e-5f);
        }

        //// Generic Smith-Schlick visibility term
        inline half SmithVisibilityTerm_ac (half NdotL, half NdotV, half k)
        {
            half gL = NdotL * (1-k) + k;
            half gV = NdotV * (1-k) + k;
            return 1.0 / (gL * gV + 1e-5f); // This function is not intended to be running on Mobile,
                                            // therefore epsilon is smaller than can be represented by half
        }

        ////
        inline half SmithBeckmannVisibilityTerm_ac(half NdotL, half NdotV, half roughness)
        {
            half c = 0.797884560802865h; // c = sqrt(2 / Pi)
            half k = roughness * c;
            return SmithVisibilityTerm_ac (NdotL, NdotV, k) * 0.25f; // * 0.25 is the 1/4 of the visibility term
        }

        //// wip GSF for diffuse
        float GSF_Diff_ac (float NdotL, float NdotV, float LdotH)
        {
            float Gs    = NdotL*NdotV/max(.00001,(LdotH*max(NdotL,NdotV)));
            // float Gs    = NdotL*NdotV/max(.00001,(LdotH));
            return      Gs;
        }
        //// WardGeometricShadowingFunction
        float WardGSF(float NdotL, float NdotV)
        {
            float Gs    = pow( NdotL * NdotV, 0.5);
            return      (Gs);
        }

        //// (Unity) Note: Disney diffuse must be multiply by diffuseAlbedo / PI. This is done outside of this function.
        half DisneyDiffuse_fuzz(half NdotV, half NdotL, half LdotH, half perceptualRoughness)
        {
            half fd90 = 0.5 + 2 * LdotH * LdotH * perceptualRoughness;
            // Two schlick fresnel term
            half lightScatter   = (0 + (fd90 - 1) * Pow5(1 - NdotL));
            half viewScatter    = (0 + (fd90 - 1) * Pow5(1 - NdotV));
            // half lightScatter   = (1 + (fd90 - 1) * Pow5(1 - NdotL));
            // half viewScatter    = (1 + (fd90 - 1) * Pow5(1 - NdotV));

            return lightScatter * viewScatter;
        }

        //// UDN normal map blending
        //// https://blog.selfshadow.com/publications/blending-in-detail/
        float3 blend_udn(float3 n1, float3 n2)
        {
            return normalize(float3(n1.xy + n2.xy, n1.z));
            // return normalize(n1*dot(n1, n2)/n1.z - n2);
        }
        float3 blend_rnm(float4 n1, float4 n2)
        {
            float3 t = n1.xyz*float3( 2,  2, 2) + float3(-1, -1,  0);
            float3 u = n2.xyz*float3(-2, -2, 2) + float3( 1,  1, -1);
            float3 r = t*dot(t, u) - u*t.z;
            return normalize(r);
        }

        ////============================================================
        //// https://www.shadertoy.com/view/4sV3zt
        //// https://keithmaggio.wordpress.com/2011/02/15/math-magician-lerp-slerp-and-nlerp/
        float3 slerp(float3 start, float3 end, float percent)
        {
            float d     = dot(start, end);
            d           = clamp(d, -1.0, 1.0);
            float theta = acos(d)*percent;
            float3 RelativeVec  = normalize(end - start*d);
            return      ((start*cos(theta)) + (RelativeVec*sin(theta)));
        }

        //// Lyuma. (Silent?)
        float stepButAntialiased(float x0, float x) {
            float u = (x - x0);
            float pixwid = fwidth(u);
            return clamp(u / pixwid + 0.5, 0.0, 1.0);
        }

#endif