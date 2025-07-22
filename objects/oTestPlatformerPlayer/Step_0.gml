if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(ord("R")))
    {
        primitive.x = xstart;
        primitive.y = ystart;
        primitive.z = 200;
    }
    
    if (keyboard_check_pressed(vk_space)) zSpeed += 15;
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camYaw);
    var _cos  = dcos(oCamera.camYaw);
    
    xSpeed =  _para*_cos - _perp*_sin;
    ySpeed = -_para*_sin - _perp*_cos;
}

zSpeed -= 1;

var _steps = 1;
repeat(_steps)
{
    primitive.x += xSpeed / _steps;
    primitive.y += ySpeed / _steps;
    primitive.z += zSpeed / _steps;
    
    with(oTestPlatformerFloor)
    {
        BonkCollision(other, other.primitive, primitive);
    }
    
    with(oTestPlatformerAABB)
    {
        BonkCollision(other, other.primitive, primitive);
    }
    
    with(oTestPlatformerCylinder)
    {
        BonkCollision(other, other.primitive, primitive);
    }
}