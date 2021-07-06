if (mouse_check_button_pressed(mb_left))
{
    show_debug_message("!");
}

var _collision = point.Collision(aabb);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

aabb.DebugDraw(_collision.GetCollided()? c_red : c_lime);
ray.DebugDraw();
_collision.DebugDraw(c_yellow);

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);