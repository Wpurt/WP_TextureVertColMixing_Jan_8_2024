// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TextureBlendingUnlitShader"
{
    Properties{
        _Tint ("Tint", Color) = (1,1,1,1)
        _Texture1 ("Surface Texture", 2D) = "white" {}
        _Texture2 ("Cover Texture", 2D) = "white" {}
        [NoScaleOffset] _Texture1_Height ("Surface Texture Height", 2D) = "grey" {}
        [NoScaleOffset] _Texture2_Height ("Cover Texture Height", 2D) = "grey" {}
        _SmoothStepVars ("SmthStpPre/PostMask", Vector) = (2,2,2,1)
    }
    SubShader{ 

        Pass{

            CGPROGRAM

            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"

            #include "TextureBlending.cginc"

            float4 _Tint;
            sampler2D _Texture1, _Texture2, _Texture1_Height, _Texture2_Height;
            float4 _Texture1_ST;
            float4 _Texture2_ST;

            struct Interpolators {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };

            struct VertexData{
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
                float4 vertexColor : COLOR;
            };

            Interpolators Vert (VertexData v) {
                Interpolators i;
                i.position = UnityObjectToClipPos(v.position); 
                i.uv = v.uv * _Texture1_ST.xy + _Texture1_ST.zw;
                i.uv2 = v.uv * _Texture2_ST.xy + _Texture2_ST.zw;
                i.vertexColor = v.vertexColor;
                return i;
            }

            float4 Frag (Interpolators i) : SV_TARGET {
                
                float4 mixMap = generateMixMapTexture(i.vertexColor, tex2D(_Texture1_Height, i.uv), tex2D(_Texture2_Height, i.uv2));

                return tex2D(_Texture2, i.uv2) * mixMap + tex2D(_Texture1, i.uv) * (mixMap * -1 + 1);
                //return mixMap;
                //return i.vertexColor;
            }
            ENDCG
        }
    }
}
