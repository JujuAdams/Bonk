if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(vk_space)) velocityZ += 15;
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camYaw);
    var _cos  = dcos(oCamera.camYaw);
    
    cylinder.x +=  _para*_cos - _perp*_sin;
    cylinder.y += -_para*_sin - _perp*_cos;
}

velocityZ -= 1;
cylinder.z += velocityZ;

var _onGround = false;
repeat(1)
{
    var _collision = false;
    
    with(oTestPlatformerFloor)
    {
        var _reaction = BonkAABBInCylinder(aabb, other.cylinder).Reverse();
        if (_reaction.collision)
        {
            _collision = true;
            
            with(other.cylinder)
            {
                x += _reaction.dX;
                y += _reaction.dY;
                z += _reaction.dZ;
            }
            
            if (_reaction.dZ > 0) _onGround = true;
        }
    }
    
    with(oTestPlatformerAABB)
    {
        var _reaction = BonkAABBInCylinder(aabb, other.cylinder).Reverse();
        if (_reaction.collision)
        {
            _collision = true;
            
            with(other.cylinder)
            {
                x += _reaction.dX;
                y += _reaction.dY;
                z += _reaction.dZ;
            }
            
            if (_reaction.dZ > 0) _onGround = true;
        }
    }
    
    if (not _collision) break;
}

if (_onGround) velocityZ = 0;