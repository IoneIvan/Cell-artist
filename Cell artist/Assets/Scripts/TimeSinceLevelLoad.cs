using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeSinceLevelLoad : MonoBehaviour
{
    public bool isReset = false;
    public Texture2D SampleTex;
    public CustomRenderTexture renderTextureSample;
    public List<CustomRenderTexture> Textures;
    public List<Material> Materials;

    void Awake()
    {
        for (int i = 0; i < Textures.Count; i++)
        {
            Textures[i].Initialize();
        }
    }

    void FixedUpdate()
    {
        float rand = Random.Range(0.0f, 1.0f);
        for (int i = 0; i < Materials.Count; i++)
        {
            Materials[i].SetFloat("_Random", rand);

            //set Sample Texture
            Materials[i].SetTexture("_MainTex", SampleTex);
            if (renderTextureSample == null)
            {
                Materials[i].SetTexture("_Sample", SampleTex);
            }
            else
            {
                Materials[i].SetTexture("_Sample", renderTextureSample);
            }

            //restart
            if (isReset)
            {
                Materials[i].SetFloat("_isReset", 1.0f);
            }
            else
            {
                Materials[i].SetFloat("_isReset", 0.0f);
            }
        }
        for (int i = 0; i < Textures.Count; i++)
        {
            Textures[i].Update();
        }
    }
}