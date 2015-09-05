using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour {
    public ActorController actor; 
    public KeyLayout key;

    void Awake()
    {
        actor = gameObject.AddComponent<ActorController>();
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
            actor.Move(-1);
        }
        if (Input.GetKey(key.right))
        {
            actor.Move(1);
        }
        if (Input.GetKey(key.up))
        {
            actor.MoveY(1);
        }
        if (Input.GetKey(key.down))
        {
            actor.MoveY(-1);
        }
        if (Input.GetKeyDown(key.jump))
        {
            actor.Jump();
        }
	
	}
}