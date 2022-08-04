// Saves screenshot as PNG file.
using UnityEngine;
using System.Collections;
using System.IO;

public class PNGUploader : MonoBehaviour
{
    public CustomRenderTexture rTex;
    // Save immediately
    IEnumerator Start()
    {
        yield return UploadPNG();
    }

    IEnumerator UploadPNG()
    {
        yield return new WaitForEndOfFrame();


        RenderTexture.active = rTex;
        Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.RGBA4444, false);
        
        // ReadPixels looks at the active RenderTexture.
        tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
        tex.Apply();

        byte[] bytes = tex.EncodeToPNG();

        File.WriteAllBytes(Application.dataPath + "/../SavedTexture.png", bytes);
    }
}