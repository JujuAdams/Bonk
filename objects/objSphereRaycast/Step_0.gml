if (mouse_check_button(mb_right))
{
    ray.SetRay(objCamera.camX,  objCamera.camY,  objCamera.camZ,
               objCamera.camDX, objCamera.camDY, objCamera.camDZ);
}