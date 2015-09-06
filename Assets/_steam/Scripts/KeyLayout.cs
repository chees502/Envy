using UnityEngine;
using System.Collections;


public class KeyLayout
{
    public string up;
    public string down;
    public string left;
    public string right;
    public string jump;
    public KeyLayout()
    {
        SetKeys("w", "s", "a", "d", "space");
    }

    public void SetKeys(string up, string down, string left, string right, string jump)
    {
        this.up     = up;
        this.down   = down;
        this.left   = left;
        this.right  = right;
        this.jump   = jump;
    }
}
