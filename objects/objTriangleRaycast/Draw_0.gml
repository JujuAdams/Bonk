var _result = objRay.ray.Collision(triangle);
triangle.DebugDraw(_result.GetCollided()? c_red : c_lime);