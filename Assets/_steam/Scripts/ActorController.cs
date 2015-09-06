using UnityEngine;
using System.Collections;

public class ActorController : MonoBehaviour {
    public Vector2 velocity;
    public bool isGrounded = false;
	void Start(){

	}
	void Update () {     
		Phys();
        //Debug.DrawRay(transform.position,velocity*1);
	}

	public void Move(float dir){
		if(isGrounded){
			velocity.x+=dir*_Root.Apendix.playerRunSpeed;
		} else{
			velocity.x+=dir*_Root.Apendix.playerAirSpeed;
		}
	}
    public void MoveY(float dir)
    {
        velocity.y += dir * _Root.Apendix.playerRunSpeed;
    }

	public void Jump(float strength){
        if (isGrounded) {
            velocity.y += strength;
            isGrounded = false;
        }
	}

	public void Jump(){
		Jump(_Root.Apendix.playerJumpPower);
	}

    public float tryHitFloor(){
        RaycastHit hit;
        return tryHitFloor(out hit);
    }
    public float tryHitFloor(out RaycastHit hit)
    {
        Vector3 origin = transform.position - Vector3.up * 0.5f * _Root.Apendix.playerHeight;
        Vector3 direction = Vector3.up * velocity.y * Time.deltaTime;
        if (Physics.Raycast(new Ray(origin, direction.normalized), out hit, 100f))
        {
            return hit.distance;
        } else {
            Debug.LogWarning("No collider underneith " + gameObject.name);
            return 0;
        }
    }
	
	void Phys(){
		Vector3 newPos = transform.position;
		newPos.x+=velocity.x*Time.deltaTime;
		newPos.y+=velocity.y*Time.deltaTime;
        RaycastHit hit;
        float dist = tryHitFloor(out hit);
        Debug.Log("IS " + dist + "<" + velocity.y);
        if (dist != 0 && isGrounded)
        if (dist < -velocity.y * Time.deltaTime) {
            if (isGrounded) {
                isGrounded = false;
            } else { 
                Debug.Log("down");
                isGrounded = true;
                velocity.y = 0;
                newPos.y = hit.point.y + _Root.Apendix.playerHeight * 0.5f;
            }
        }


        
        transform.position = newPos;

        if (isGrounded) {
            velocity -= velocity * Time.deltaTime * _Root.Apendix.playerFriction;
		} else {
            velocity -= velocity * Time.deltaTime * _Root.Apendix.playerAirFriction;
            velocity.y -= Time.deltaTime + _Root.Apendix.gravity;
		}
	}
}
