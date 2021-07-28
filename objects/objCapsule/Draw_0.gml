var _result = capsule.Collision(triangle);

capsule.DebugDraw(_result.GetCollided()? c_red : c_lime);
triangle.DebugDraw(c_yellow);