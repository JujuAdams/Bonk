var _result = ray.Collision(sphere);
sphere.DebugDraw(_result.GetCollided()? c_red : c_lime);
ray.DebugDraw(c_yellow);