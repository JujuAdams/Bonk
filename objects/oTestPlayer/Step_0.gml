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
            shape.x = xstart;
            shape.y = ystart;
            shape.z = 200;
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

var _pushOutData = BonkMoveAndDeflectExt(shape, velocity, world, 40);
if (_pushOutData.deflectType == BONK_DEFLECT_GRIPPY)
{
    onGroundFrames = 10;
}

line.x1 = shape.x;
line.y1 = shape.y;
line.z1 = shape.z + 0.5*shape.height;
line.x2 = shape.x;
line.y2 = shape.y;
line.z2 = shape.z - 0.5*shape.height - 50;

/*
var _x = shape.x;
var _y = shape.y;
var _z = shape.z;

shape.x += velocity.xSpeed;
shape.y += velocity.ySpeed;
shape.z += velocity.zSpeed;

with(oTestParent)
{
    shape.Deflect(other.shape, 40);
}

velocity.xSpeed = shape.x - _x;
velocity.ySpeed = shape.y - _y;
velocity.zSpeed = shape.z - _z;
*/