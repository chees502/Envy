Shader "Potal" {
	Properties {
		
		_Size ("Size",Float) = 1
        _MainTex ("Texture", 2D) = "white" { }
        _Color1 ("Color1", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (0,0,0,1)
		_SampleDist ("SampleDist",Float)=1
		_ZInit ("ZInit",Float)=1
		_Distort("DistortAmount",Float)=1
	}
 
	SubShader {
	    Tags {"Queue" = "Overlay" }
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			//Cull off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma target 3.0
			sampler2D _MainTex;
			float _Size;
			float4 _Color1;
			float4 _Color2;
			float _SampleDist;
			float _ZInit;
			float _Distort;
			struct appdata {
				float4 vertex : POSITION;
				float3 texcoord : TEXCOORD0;
			};
 
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD2;
				float3 texcoord : TEXCOORD3;
			};
 
 
 
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldPos = mul(_Object2World,v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}
			float GetValue (float2 texcoord){
				float dist = length(texcoord-float2(0.5,0.5));
				dist*=10;
				float value = tex2D(_MainTex,(texcoord*3)+_Time.x*3).r;
				float subValue = tex2D(_MainTex,(float2(texcoord.y*1,texcoord.x*-1))+_Time.x*3).r;
				float subsubValue = tex2D(_MainTex,(float2(texcoord.x*10,texcoord.y*10+_Time.x*-3))).r;
				value=(value+subValue+subsubValue)*0.333333;
				value=1-pow(1-abs(value*2-1),5);
				float modValue = value+dist;
				return modValue;
			}
			float GetX(float2 texcoord){
				float sample1 = GetValue(texcoord+float2(_SampleDist*0.001,0));
				float sample2 = GetValue(texcoord+float2(_SampleDist*-0.001,0));
				float temp = sample2-sample1;
				if(temp>0.05){
					return temp;
				}
				return 0;
			}
			float GetY(float2 texcoord){
				float sample1 = GetValue(texcoord+float2(0,_SampleDist*0.001));
				float sample2 = GetValue(texcoord+float2(0,_SampleDist*-0.001));
				float temp = sample2-sample1;
				if(temp>0.05){
					return temp;
				}
				return 0;
			}
			half4 frag (v2f i) : COLOR
			{
				float value = GetValue(i.texcoord.xy);
				float weight = value*0.5;
				half3 finalClr = _Color1+clamp(weight,0,1.5)*(_Color2-_Color1);
				value=_Size-value;
				half3 normal = normalize(half3(GetX(i.texcoord.xy),GetY(i.texcoord.xy),_ZInit));
				//return half4(weight,weight,weight,1);
				return half4(finalClr,value);
				float x = ((i.texcoord.x+normal.x*_Distort*clamp(value,0,1))%0.1)>0.05;
				float y = ((i.texcoord.y+normal.y*_Distort*clamp(value,0,1))%0.1)>0.05;
				float debug = x!=y;
				return half4((normal*0.5+0.5)*debug,value);
				return half4(normal*0.5+0.5,value);
   
			}
 
			ENDCG
		}
 
	}
	Fallback Off
}