if (mouse_check_button(mb_right))
{
    var _ray = ray;
    with(objCamera)
    {
        if (mouseLock)
        {
            _ray.SetRay(camX, camY, camZ,   camDX, camDY, camDZ);
        }
        else
        {
            var _farPoint = BonkMouseToWorldspace(view_matrix, projection_matrix);
            _ray.SetA(camX, camY, camZ);
            _ray.SetB(_farPoint[0], _farPoint[1], _farPoint[2]);
        }
    }
}