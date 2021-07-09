var _result = sphereA.Collision(sphereB);

sphereA.DebugDraw(_result.GetCollided()? c_red : c_lime);
sphereB.DebugDraw(c_lime);