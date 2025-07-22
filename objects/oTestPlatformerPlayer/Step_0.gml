if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(ord("R")))
    {
        cylinder.x = xstart;
        cylinder.y = ystart;
        cylinder.z = 200;
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

var _steps = 5;
repeat(_steps)
{
    cylinder.x += xSpeed / _steps;
    cylinder.y += ySpeed / _steps;
    cylinder.z += zSpeed / _steps;
    
    with(oTestPlatformerFloor)
    {
        BonkCollisionResponse(BonkAABBInCylinder(aabb, other.cylinder).Reverse(), other.cylinder, other);
    }
    
    with(oTestPlatformerAABB)
    {
        BonkCollisionResponse(BonkAABBInCylinder(aabb, other.cylinder).Reverse(), other.cylinder, other);
    }
}