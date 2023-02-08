Shader "Custom/GlitchShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}

        _ColorDirection ("Color Direction", Vector) = (0,0,0,0)
        _ColorRadius ("Color Radius", float) = 0.5

        _NoiseTex ("Noise (RGB)", 2D) = "white" {}
        _DisplacementFactor ("Displacement Factor", float) = 0.5
        _NoiseScale ("Noise Scale", float) = 0.5
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            fixed2 _ColorDirection;
            half _ColorRadius;

            sampler2D _NoiseTex;
            half _DisplacementFactor;
            half _NoiseScale;

            half _FlipUp;
            half _FlipDown;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;

                _FlipUp = 0.3;
                _FlipDown = 0.5;

                uv.y -= (1 - (uv.y + _FlipUp)) * step(uv.y, _FlipUp) + (1 - (uv.y + _FlipDown)) * step(_FlipDown, uv.y);

                fixed4 noise = tex2D(_NoiseTex, uv * _NoiseScale);
                uv += (noise.rg - 0.5) * _DisplacementFactor;

                fixed4 colR = tex2D(_MainTex, uv + _ColorDirection * _ColorRadius * 0.01);
                fixed4 colG = tex2D(_MainTex, uv - _ColorDirection * _ColorRadius * 0.01);
                
                float threshold = 0.5;
                float lum = 0.5;

                fixed4 col = tex2D(_MainTex, uv);
                col.rgb += colR.rgb * step(_ColorRadius, -threshold) * lum;
                col.rgb += colG.rgb * step(threshold, _ColorRadius) * lum;

                return col;
            }
            ENDCG
        }
    }
}
