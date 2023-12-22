var _result = cylinder.Collision(triangle);
cylinder.DebugDraw(_result.GetCollided()? c_red : c_lime);
triangle.DebugDraw(c_yellow);