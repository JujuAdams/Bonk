if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(vk_space)) velocityZ += 15;
    velocityZ -= 1;
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camYaw);
    var _cos  = dcos(oCamera.camYaw);
    
    cylinder.x +=  _para*_cos - _perp*_sin;
    cylinder.y += -_para*_sin - _perp*_cos;
    cylinder.z += velocityZ;
}

var _anyCollision = false;
repeat(5)
{
    var _collision = false;
    
    with(oTestPlatformerFloor)
    {
        var _reaction = BonkCylinderInFloor(other.cylinder, floor_);
        if (_reaction.collision)
        {
            _collision = true;
            
            with(other.cylinder)
            {
                x += _reaction.dX;
                y += _reaction.dY;
                z += _reaction.dZ;
            }
        }
    }
    
    if (_collision)
    {
        _anyCollision = true;
    }
    else
    {
        break;
    }
}

if (_anyCollision) velocityZ = 0;