//Various toggles on the function keys
if (keyboard_check_released(vk_f1)) showInfo = !showInfo;
if (keyboard_check_released(vk_f4)) window_set_fullscreen(!window_get_fullscreen());

//Lock the mouse if we left click
if (mouse_check_button_released(mb_left))
{
    camera.SetMouseLock(not camera.GetMouseLock());
}

//Always unlock the mouse if we press escape
if (keyboard_check_pressed(vk_escape))
{
    camera.SetMouseLock(false);
}

//If we've locked the mouse cursor, hide it
window_set_cursor(camera.GetMouseLock()? cr_none : cr_default);

if (camera.GetMouseLock())
{
    //Move based on keyboard input
    camera.Move(2*(keyboard_check(ord("W")) - keyboard_check(ord("S"))),
                2*(keyboard_check(ord("A")) - keyboard_check(ord("D"))),
                2*(keyboard_check(vk_space) - keyboard_check(vk_shift)));
}

fpsRealSmoothed = lerp(fpsRealSmoothed, fps_real, 0.05);