if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(ord("R")))
    {
        cylinder.x = xstart;
        cylinder.y = ystart;
        cylinder.z = 200;
    }
    
    if (keyboard_check_pressed(vk_space)) velocityZ += 15;
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camYaw);
    var _cos  = dcos(oCamera.camYaw);
    
    velocityX =  _para*_cos - _perp*_sin;
    velocityY = -_para*_sin - _perp*_cos;
}

velocityZ -= 1;

var _steps = 1;
repeat(_steps)
{
    cylinder.x += velocityX / _steps;
    cylinder.y += velocityY / _steps;
    cylinder.z += velocityZ / _steps;
    
    with(oTestPlatformerFloor)
    {
        var _reaction = BonkAABBInCylinder(aabb, other.cylinder);
        if (_reaction.collision)
        {
            _reaction.Reverse();
            
            with(other)
            {
                cylinder.x += _reaction.dX;
                cylinder.y += _reaction.dY;
                cylinder.z += _reaction.dZ;
                
                var _velocityProjection = BonkVecProjectOntoPlane(velocityX, velocityY, velocityZ, _reaction.dX, _reaction.dY, _reaction.dZ);
                velocityX = _velocityProjection.x;
                velocityY = _velocityProjection.y;
                velocityZ = _velocityProjection.z;
            }
        }
    }
    
    with(oTestPlatformerAABB)
    {
        var _reaction = BonkAABBInCylinder(aabb, other.cylinder);
        if (_reaction.collision)
        {
            _reaction.Reverse();
            
            with(other)
            {
                cylinder.x += _reaction.dX;
                cylinder.y += _reaction.dY;
                cylinder.z += _reaction.dZ;
                
                var _velocityProjection = BonkVecProjectOntoPlane(velocityX, velocityY, velocityZ, _reaction.dX, _reaction.dY, _reaction.dZ);
                velocityX = _velocityProjection.x;
                velocityY = _velocityProjection.y;
                velocityZ = _velocityProjection.z;
            }
        }
    }
}