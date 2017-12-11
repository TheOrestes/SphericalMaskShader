﻿Shader "Root16/SphericalMask"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EmissionColor("Emission Color", Color) = (1,1,1,1)
		_EmissionTex("Emission (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Position ("World Position", Vector) = (0,0,0,0)
		_Radius ("Sphere Radius", Range(0,100)) = 0.0
		_Softness("Sphere Softness", Range(0,100)) = 0.0
		_ColorStrength("Color Strength", Range(0,4)) = 1
		_EmissionStrength("Emission Strength", Range(1,4)) = 1
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_EmissionTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Spherical Mask
		uniform float4 GLOBALMASK_Position;
		uniform half GLOBALMASK_Radius;
		uniform half GLOBALMASK_Softness;
		half _ColorStrength;

		sampler2D _EmissionTex;
		fixed4 _EmissionColor;
		half _EmissionStrength;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			// Grayscale
			half grayscale = (c.r + c.g + c.b) * 0.333;
			fixed3 c_g = fixed3(grayscale,grayscale,grayscale);

			// _Emission
			fixed4 e = tex2D(_EmissionTex, IN.uv_EmissionTex) * _EmissionColor * _EmissionStrength ;

			half d = distance(GLOBALMASK_Position, IN.worldPos);
			half sum = saturate((d - GLOBALMASK_Radius) / -GLOBALMASK_Softness);
			fixed4 lerpColor = lerp(fixed4(c_g, 1), c * _ColorStrength, sum);

			fixed4 lerpEmission = lerp(fixed4(0,0,0,0), e, sum);

			o.Albedo = lerpColor.rgb;
			o.Emission = lerpEmission.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
