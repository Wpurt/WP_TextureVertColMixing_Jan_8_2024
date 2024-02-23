Shader "Custom/TextureBlendingUnlitShader"
{
    Properties{
        _Tint ("Tint", Color) = (1,1,1,1)

        _Texture1 ("Under Surface Albedo", 2D) = "white" {}
        _Texture2 ("Cover Albedo", 2D) = "white" {}
        [NoScaleOffset] _Texture1_Height ("Undr Srfc Tex Height", 2D) = "grey" {}
        [NoScaleOffset] _Texture2_Height ("Covr Text Height", 2D) = "grey" {}

        [NoScaleOffset] _DetailTexture1 ("Under Surface Detail", 2D) = "grey" {}

        _SmoothStepVars ("SmthStpPre/PostMask", Vector) = (2,2,2,1)
        _HeightAdjust ("Height Adjust", Range(0, 0.5)) = 0
    }
    SubShader{ 

        Pass{

            CGPROGRAM

            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"

            #include "TextureBlending.cginc"

            float4 _Tint;
            sampler2D _Texture1, _Texture2, _Texture1_Height, _Texture2_Height, _DetailTexture1;
            float4 _Texture1_ST;
            float4 _Texture2_ST;
            float4 _SmoothStepVars;
            float _HeightAdjust;

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
                
                //generate the mask to mix textures
                float4 mixMap = generateMixMapTexture(i.vertexColor, tex2D(_Texture1_Height, i.uv) + 
                    _HeightAdjust, tex2D(_Texture2_Height, i.uv2), _SmoothStepVars);

                //get the color of the pixels before lighting
                float4 baseColor = tex2D(_Texture2, i.uv2) * mixMap + tex2D(_Texture1, i.uv) * (mixMap * -1 + 1);
                
                //Lighting
                float4 diffuse = baseColor * (i.vertexColor.g * -1 + 1);

                return diffuse;
                //return mixMap;
                //return i.vertexColor;
            }
            ENDCG
        }
    }
}
    
