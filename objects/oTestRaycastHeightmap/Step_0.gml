if (keyboard_check_pressed(vk_tab))
{
    manual = true;
    alarm[0] = 1;
}

if (mouse_check_button_pressed(mb_right))
{
    var _result = D3FrustrumRay(oCamera.camera.GetViewMatrix(), oCamera.camera.GetProjectionMatrix());
    raycast.SetOrigin(_result.x, _result.y, _result.z);
    raycast.SetDirection(_result.dX, _result.dY, _result.dZ);
}