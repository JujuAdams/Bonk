var _collision = ray.Collision(sphereA);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

sphereA.DebugDraw(_collision.GetCollided()? c_red : c_lime);
ray.DebugDraw();
_collision.DebugDraw(c_yellow);

var _i = 0;
repeat(array_length(bulletArray))
{
    bulletArray[_i].DebugDraw();
    ++_i;
}

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);