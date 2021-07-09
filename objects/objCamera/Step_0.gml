//Toggle the info panel if we press F1
if (keyboard_check_released(vk_f1)) show_info = !show_info;

//Lock the mouse if we press F3
if (keyboard_check_released(vk_f3))
{
    mouse_lock = !mouse_lock;
    mouse_lock_timer = 0;
    
    //Hide the mouse if we're locked
    window_set_cursor(mouse_lock? cr_none : cr_default);
}

//Toggle the fullscreen if we press f4
if (keyboard_check_released(vk_f4)) window_set_fullscreen(!window_get_fullscreen());

//If we've got the mouse locked...
if (mouse_lock)
{
    //Figure out where the centre of the window is
    var _centre_x = window_get_width()/2;
    var _centre_y = window_get_height()/2;
    
    //Increment a timer. Once that timer reaches 5, start pitching/panning the camera
    //There's a little bit of lag between pressing F3 and the mouse actually
    //centring in the window - this timer stops the camera freaking out!
    ++mouse_lock_timer;
    if (mouse_lock_timer > 4)
    {
        
        var _delta_x = window_mouse_get_x() - _centre_x;
        var _delta_y = window_mouse_get_y() - _centre_y;
        cam_yaw   -= 0.1*_delta_x;
        cam_pitch -= 0.1*_delta_y;
        
        cam_pitch = clamp(cam_pitch, -89, 89); //Make sure we can't gimbal lock the camera
    }
    
    //Now move the mouse
    window_mouse_set(_centre_x, _centre_y);
}

////Figure out where the camera is looking
cam_dx =  dcos(cam_yaw)*dcos(cam_pitch);
cam_dy = -dsin(cam_yaw)*dcos(cam_pitch);
cam_dz =  dsin(cam_pitch);

//Move parallel/perpendicular to the camera
var _para = 5*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
var _perp = 5*(keyboard_check(ord("A")) - keyboard_check(ord("D")));

cam_x += lengthdir_x(_para, cam_yaw) + lengthdir_x(_perp, cam_yaw + 90);
cam_y += lengthdir_y(_para, cam_yaw) + lengthdir_y(_perp, cam_yaw + 90);

cam_z += 5*(keyboard_check(vk_space) - keyboard_check(vk_shift));