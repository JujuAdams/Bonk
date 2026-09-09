if (BonkAsyncGetPendingWorkers() > 0)
{
    return;
}

if (instance_exists(oCamera))
{
    var _camera = oCamera.camera;
    
    if (not _camera.GetMouseLock())
    {
        if (keyboard_check_pressed(ord("R")))
        {
            x = xstart;
            y = ystart;
            z = 200;
            velocity.Reset();
        }
        
        if (keyboard_check_pressed(vk_space))
        {
            velocity.zSpeed += 5;
            onGroundFrames = 0;
        }
        
        var _para = moveAccel*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
        var _perp = moveAccel*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
        var _sin  = dsin(_camera.yaw);
        var _cos  = dcos(_camera.yaw);
        
        with(velocity)
        {
            xSpeed +=  _para*_cos - _perp*_sin;
            ySpeed += -_para*_sin - _perp*_cos;
        }
    }
}

with(velocity)
{
    xSpeed *= other.damping;
    ySpeed *= other.damping;
    zSpeed -= other.gravAccel;
}

--onGroundFrames;

var _pushOutData = BonkMoveAndDeflect(self, velocity, 40, oTestInstanceParent);
if (_pushOutData.deflectType == BONK_DEFLECT_GRIPPY)
{
    onGroundFrames = 10;
}

line.x1 = x;
line.y1 = y;
line.z1 = z + 0.5*height;
line.x2 = x;
line.y2 = y;
line.z2 = z - 0.5*height - 50;