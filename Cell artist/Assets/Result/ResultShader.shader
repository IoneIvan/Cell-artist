Shader "CellArt/Result"
{
    Properties
    {
        [MaterialToggle] _isReset("isReset", Float) = 0
        _Sample("Result Texture", 2D) = "bump" {}
        _Multiplication("Multiplication Texture", 2D) = "bump" {}
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

                sampler2D _Sample;
                sampler2D _Multiplication;


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
                float4 getMultiplication(v2f_customrendertexture IN, int x, int y) : COLOR
                {
                    fixed2 uv = IN.localTexcoord.xy + fixed2(x / _CustomRenderTextureWidth, y / _CustomRenderTextureHeight);
                    return tex2D(_Multiplication, uv);
                }


                float4 Multiplication(v2f_customrendertexture IN, int X, int Y)
                {
                    float4 layer = float4 (0, 0, 0, 0);

                    for (int x = -1; x < 2; x++)
                    {
                        for (int y = -1; y < 2; y++)
                        {
                            layer.r += get(IN, X + x, Y + y).r * (getMultiplication(IN, X , Y).r - 0.5) * 2;
                        }
                    }
                    for (int x = -1; x < 2; x++)
                    {
                        for (int y = -1; y < 2; y++)
                        {
                            layer.g += get(IN, X + x, Y + y).g * (getMultiplication(IN, X , Y).g - 0.5) * 2;
                        }
                    }
                    for (int x = -1; x < 2; x++)
                    {
                        for (int y = -1; y < 2; y++)
                        {
                            layer.b += get(IN, X + x, Y + y).b * (getMultiplication(IN, X , Y).b - 0.5) * 2;
                        }
                    }

                    //find error
                    layer.a = abs(layer.b - getSample(IN, X, Y).b);
                    layer.a += abs(layer.r - getSample(IN, X, Y).r);
                    layer.a += abs(layer.g - getSample(IN, X, Y).g);
                    return layer;
                }


                float4 frag(v2f_customrendertexture IN) : COLOR
                {
                    if (_isReset)
                    {
                        int r = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 1 * _Time.x * 0.0001)) * 1.01;
                        int g = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 2 * _Time.x * 0.0001)) * 1.01;
                        int b = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 3 * _Time.x * 0.0001)) * 1.01;
                        int a = rand(float3(IN.localTexcoord.x, IN.localTexcoord.y, 4 * _Time.x * 0.0001)) * 1.01;
                        float3 col = getSample(IN, 0, 0);
                        if (a > 0.8)
                            return float4(col.r, col.g, col.b, a);
                        else
                            return float4(r, g, b, a);

                    }
                    float4 self = get(IN, 0, 0);
                    float4 color = Multiplication(IN, 0, 0);
                    self.rgb = color.rgb;
                    self.a = 1 - color.a * 0.5;
                    return self;
                }
                ENDCG
            }
        }
}
