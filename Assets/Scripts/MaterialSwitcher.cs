using UnityEngine;

public class MaterialSwitcher : MonoBehaviour
{
    [SerializeField] private Material _material;
    private bool _isActiveMaterial;

    void Awake()
    {
        _isActiveMaterial = false;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftControl))
        {
            _isActiveMaterial = !_isActiveMaterial;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (_isActiveMaterial)
        {
            Graphics.Blit(src, dst, _material);
        }
        else
        {
            Graphics.Blit(src, dst);
        }
    }
}
