var _result = objRay.ray.Collision(sphere);
sphere.DebugDraw(_result.GetCollided()? c_red : c_lime);