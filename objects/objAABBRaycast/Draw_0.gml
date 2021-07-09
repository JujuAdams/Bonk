var _result = objRay.ray.Collision(aabb);
aabb.DebugDraw(_result.GetCollided()? c_red : c_lime);