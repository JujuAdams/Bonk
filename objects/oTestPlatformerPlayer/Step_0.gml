if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(ord("R")))
    {
        shape.x = xstart;
        shape.y = ystart;
        shape.z = 200;
    }
    
    if (keyboard_check_pressed(vk_space)) zSpeed += 15;
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camYaw);
    var _cos  = dcos(oCamera.camYaw);
    
    xSpeed =  _para*_cos - _perp*_sin;
    ySpeed = -_para*_sin - _perp*_cos;
}
else
{
    xSpeed = 0;
    ySpeed = 0;
}

zSpeed -= 1;

shape.x += xSpeed;
shape.y += ySpeed;
shape.z += zSpeed;

with(oTestPlatformerFloor)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerAABB)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerCylinder)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerSphere)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerQuad)
{
    BonkCollideAndRespond(other.shape, shape, other);
}

with(oTestPlatformerTriangle)
{
    BonkCollideAndRespond(other.shape, shape, other);
}