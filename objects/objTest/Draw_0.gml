var _collision = ray.Collision(aabbA);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

aabbA.DebugDraw(_collision.GetCollided()? c_red : c_lime);
ray.DebugDraw(c_lime);

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);