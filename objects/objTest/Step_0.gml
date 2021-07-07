point.SetPosition(mouse_x, mouse_y, 0);
aabbB.SetPosition(mouse_x, mouse_y, 0);
ray.SetB(mouse_x, mouse_y, 0);
if (mouse_check_button_pressed(mb_right)) ray.SetA(mouse_x, mouse_y, 0);