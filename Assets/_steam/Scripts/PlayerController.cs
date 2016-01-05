using UnityEngine;
using System.Collections;

public class PlayerController : ActorController{
    public KeyLayout key;

    void Awake()
    {
        base.Awake();
        key = new KeyLayout();
    }

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
    void Update()
    {
        if (Input.GetKey(key.left))
        {
            Move(-1);
        }
        if (Input.GetKey(key.right))
        {
            Move(1);
        }
        if (Input.GetKey(key.up))
        {
            MoveY(1);
        }
        if (Input.GetKey(key.down))
        {
            MoveY(-1);
        }
        if (Input.GetKey(key.jump))
        {
            Jump();
        }
        base.Update();
	}
}