Shader "CellArt/Multiplication"
{
    Properties
    {
        [MaterialToggle] _isReset("isReset", Float) = 0
        _Random("Random", Float) = 0.1
        _Sample("Sample Texture", 2D) = "bump" {}
        _Result("Result Texture", 2D) = "bump" {}

    }

    SubShader
    {
       Lighting Off
       Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0;

            float rand(float3 co)
            {
                return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 45.5432))) * 43758.5453);
            }




            half _isReset;
            half _Random;

            sampler2D _Sample;
            sampler2D _Result;



            float4 get(v2f_customrendertexture IN, int x, int y) : COLOR
            {
                fixed2 uv = IN.localTexcoord.xy + fixed2(x / _CustomRenderTextureWidth, y / _CustomRenderTextureHeight);
                return tex2D(_SelfTexture2D, uv);
            }
            float4 getSample(v2f_customrendertexture IN, int x, int y) : COLOR
            {
                fixed2 uv = IN.localTexcoord.xy + fixed2(x / _CustomRenderTextureWidth, y / _CustomRenderTextureHeight);
                return tex2D(_Sample, uv);
            }
            float4 getResult(v2f_customrendertexture IN, int x, int y) : COLOR
            {
                fixed2 uv = IN.localTexcoord.xy + fixed2(x / _CustomRenderTextureWidth, y / _CustomRenderTextureHeight);
                return tex2D(_Result, uv);
            }


            float4 Multiplication(v2f_customrendertexture IN, int X, int Y)
            {

                float4 layer = float4 (0, 0, 0, 0);
                for (int x = -1; x < 2; x++)
                {
                    for (int y = -1; y < 2; y++)
                    {
                        layer.r += getResult(IN, X + x, Y + y).r * (get(IN, X, Y).r - 0.5) * 2;
                    }
                }
                for (int x = -1; x < 2; x++)
                {
                    for (int y = -1; y < 2; y++)
                    {
                        layer.g += getResult(IN, X + x, Y + y).g * (get(IN, X, Y).g - 0.5) * 2;
                    }
                }
                for (int x = -1; x < 2; x++)
                {
                    for (int y = -1; y < 2; y++)
                    {
                        layer.b += getResult(IN, X + x, Y + y).b * (get(IN, X , Y).b - 0.5) * 2;
                    }
                }


                //find error
                layer.a = abs(layer.b - getSample(IN, X, Y).b);
                layer.a += abs(layer.r - getSample(IN,  X, Y).r);
                layer.a += abs(layer.g - getSample(IN,  X, Y).g);

                return layer;
            }


            //Update
            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                if (_isReset)
                {
                    float r = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, _Random * 0.0001));
                    float g = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 2 * _Random * 0.0001));
                    float b = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 3 * _Random * 0.0001));
                    int a = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 4 * _Random * 0.0001)) * 1.01;
                    return float4(r, g, b, a);
                }

                float myErr = Multiplication(IN, 0, 0).a;
                int2 me = int2(0, 0);
                for (int x = -1; x < 2; x++)
                {
                    for (int y = -1; y < 2; y++)
                    {
                        if (myErr > Multiplication(IN, x, y).a)
                        {
                            myErr = Multiplication(IN, x, y).a;
                            me = int2(x, y);
                        }
                    }
                }

                float4 self = get(IN, me.x, me.y);

                //mutation
                if (rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 5 * _Random * 0.0001)) < 0.01)
                {
                    float r = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, _Random * 0.0001));
                    float g = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 2 * _Random * 0.0001));
                    float b = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 3 * _Random * 0.0001));
                    self = float4(r, g, b, 1);
                }

                self.a = Multiplication(IN, 0, 0).a;
                return self;
            }
            ENDCG
        }
    }
}
