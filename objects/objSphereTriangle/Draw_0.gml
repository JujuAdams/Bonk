var _result = sphere.Collision(triangle);

sphere.DebugDraw(_result.GetCollided()? c_red : c_lime);
triangle.DebugDraw(c_yellow);