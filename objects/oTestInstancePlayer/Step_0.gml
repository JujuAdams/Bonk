if (not oCamera.camera.GetMouseLock())
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
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camera.yaw);
    var _cos  = dcos(oCamera.camera.yaw);
    velocity.xSpeed =  _para*_cos - _perp*_sin;
    velocity.ySpeed = -_para*_sin - _perp*_cos;
}
else
{
    velocity.xSpeed = 0;
    velocity.ySpeed = 0;
}

velocity.zSpeed -= gravAccel;
--onGroundFrames;

var _pushOutData = BonkMoveAndDeflect(self, velocity, 40, oTestInstanceParent);
if (_pushOutData.deflectType == BONK_DEFLECT_GRIPPY)
{
    onGroundFrames = 30;
}

if (onGroundFrames > 0)
{
    velocity.zSpeed = min(-0.3, velocity.zSpeed);
}

line.x1 = x;
line.y1 = y;
line.z1 = z + 0.5*height;
line.x2 = x;
line.y2 = y;
line.z2 = z - 0.5*height - 50;