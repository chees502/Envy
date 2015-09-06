Shader "HitMarker" {
	Properties {
		
		_OutSize ("OutterSize",Float) = 1
		_InSize ("InnerSize",Float) = 1
		_Width ("Width",Float) = 1
		_T ("Time",Float) = 1
		_Dir ("Direction",Float) =0.1
		_Thick ("Thickness",Float) =0.1
	}
 
	SubShader {
		Tags { "Queue" = "Transparent" }
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma target 3.0
			float _OutSize;
			float _InSize;
			float _Width;
			float _T;
			float _Thick;
			float _Dir;
			struct appdata {
				float4 vertex : POSITION;
				float3 texcoord : TEXCOORD0;
			};
 
			struct v2f {
				float4 pos : SV_POSITION;
				float3 texcoord : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};
 
 
 
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldPos = mul(_Object2World,v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}
			half4 frag (v2f i) : COLOR 
			{
				float pi = 3.141529;
				float3 dir = float3(0.5,0.5,0)-i.texcoord;
				float dist = length(dir);
				float texDot = (dot(normalize(dir),float3(1,0,0)));
				float modT = (dist-_InSize)*(_OutSize/_InSize);
				texDot = (atan2(dir.x,dir.y)+pi*2);
				texDot +=_Dir+_Width*0.5;
				texDot %=(pi*2);
				if(dist>_OutSize||dist<_InSize){
					discard;
				}
				if(texDot>_Width){
					discard;
				}
				if(dist+_Thick>_OutSize||dist-_Thick<_InSize){
					return half4(1,0,0,1);
				}
				float scale = (1-dist)*0.03;
				if(_Width<pi*2&&(texDot+_Thick+scale>_Width||texDot-_Thick-scale<0)){
					return half4(1,0,0,1);
				}
				if(modT<_T){
					
					return half4(0.9,0.55,0,1-(_T-modT));
				}
				return half4(0.9,0.5,0,0.5);
			/*
				if(abs(i.worldPos.x)<0.05){
					return half4(1,0.1,0.1,1.1);
				}
				if(abs(i.worldPos.y)<0.05){
					return half4(0.1,0.9,0.1,1.1);
				}
				float3 cell = (abs(i.worldPos))%_Size;
				float3 hard = (abs(i.worldPos))%_Hard;
				float v = !((cell.x>_Size-_Width||cell.x<_Width||cell.y>_Size-_Width||cell.y<_Width||cell.z>_Size-_Width||cell.z<_Width)||
				((hard.x<_Width+_Origin&&hard.x>-_Width+-_Origin)||
				 (hard.y<_Width+_Origin&&hard.y>-_Width+-_Origin)||
				 (hard.z<_Width+_Origin&&hard.z>-_Width+-_Origin)));
				 if(v){
					
					return half4(0.9,0.9,0.9,1.0);
				 }else{
					
					return half4(0.4,0.4,0.4,1.0);
				 }
				return half4(v,v,v,1.0);*/
   
			}
 
			ENDCG
		}
 
	}
	Fallback Off
}