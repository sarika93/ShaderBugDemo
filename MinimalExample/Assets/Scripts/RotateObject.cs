using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObject : MonoBehaviour {
  public float AngularVelDeg;

  // Hacky script for rotating the cube to add some image variation.
  private void FixedUpdate() {
    float nextY = gameObject.transform.localEulerAngles.y + AngularVelDeg * Time.fixedDeltaTime;
    gameObject.transform.localEulerAngles = new Vector3(0, nextY, 0);
  }
}
