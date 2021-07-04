var _collision = sphereA.Collision(sphereB);

sphereA.Draw();
sphereB.Draw(_collision.GetCollided()? c_red : c_lime);