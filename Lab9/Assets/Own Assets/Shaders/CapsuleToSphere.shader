Shader "Custom/CapsuleToSphere" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
            
			struct v2f {
				float2 uv : TEXCOORD0;
                float4 posInObjectCoords : TEXCOORD1;
				float4 pos : SV_POSITION;
			};
            
			v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
			{
                float posDifference = 0.505;
                
				v2f o;
                o.posInObjectCoords = vertex;
                if (o.posInObjectCoords.y > 0.5)
                {
                    o.pos.y = o.pos.y - posDifference;
                    vertex.y = vertex.y - posDifference;
                }
                else if (o.posInObjectCoords.y < -0.5)
                {
                    o.pos.y = o.pos.y + posDifference;
                    vertex.y = vertex.y + posDifference;
                }
				o.pos = UnityObjectToClipPos(vertex);
				o.uv = uv;
				return o;
			}
            
			sampler2D _MainTex;

			fixed4 frag(v2f i) : SV_Target
			{
                if (i.posInObjectCoords.y > -0.5 && i.posInObjectCoords.y < 0.5)
                {
                   discard; // drop the fragment if y coordinate > -0.5 and y coordinate < 0.5
                }
                
				fixed4 c = 0;
				fixed3 baseColor = tex2D(_MainTex, i.uv).rgb;
				c.rgb = baseColor;

				return c;
			}
		ENDCG
		}
	}
}