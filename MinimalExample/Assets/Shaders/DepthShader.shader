Shader "Custom/DepthImage"
{
	SubShader{
		Tags{ "RenderType" = "Opaque" }

		UsePass "Standard/FORWARD"
		UsePass "Standard/FORWARD_DELTA"
		UsePass "Standard/SHADOWCASTER"
		UsePass "Standard/DEFERRED"

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _CameraDepthTexture;

			struct v2f {
				float4 pos : SV_POSITION;
				float4 scrPos:TEXCOORD1;
			};

			//Vertex Shader
			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.scrPos = ComputeScreenPos(o.pos);
				return o;
			}

			float4 frag(v2f i) : SV_Target1 {
				// Returns floating point value from 0 to 1.0, where, 0 is the eye, and 1.0 is the far plane.
				// Normally returns RFloat which is the red channel here. Added other channels for demo purposes.
				float4 pixel = float4(Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r), 0, 0, 1);
				return  pixel;
			}
			ENDCG
		}
	}

	SubShader{
		Tags{ "Queue"="Transparent" "RenderType" = "Transparent" }

		Blend SrcAlpha OneMinusSrcAlpha

		UsePass "Standard/FORWARD_DELTA"
		UsePass "Standard/SHADOWCASTER"

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float4 color : COLOR0;
				float2 uv : TEXCOORD0;
			};

			//Vertex Shader
			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.color = v.color;
				return o;
			}

			sampler2D _tex;

			float4 frag(v2f i) : SV_Target {
				float4 pixel = tex2D(_tex, i.uv.xy) * i.color;	// blending color vectors
				pixel = saturate(pixel);	// ensures color values are between 0 and 1 to prevent artifacts
				return pixel;
			}
			ENDCG
		}
	}

	FallBack "Diffuse"
}
