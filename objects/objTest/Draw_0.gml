var _collision = sphereA.Collision(sphereB);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

sphereA.Draw(_collision.GetCollided()? c_red : c_lime);
sphereB.Draw();

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);