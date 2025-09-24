if (not oCamera.camera.GetMouseLock())
{
    if (keyboard_check_pressed(ord("R")))
    {
        shape.SetPosition(xstart, ystart, 200);
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

var _pushOutReaction = BonkMoveAndCollide(shape, velocity, world, 40);
if (_pushOutReaction.pushOutType == BONK_PUSH_OUT_GRIPPY)
{
    onGroundFrames = 30;
}

if (onGroundFrames > 0)
{
    velocity.zSpeed = min(-0.3, velocity.zSpeed);
}

line.x1 = shape.x;
line.y1 = shape.y;
line.z1 = shape.z + 0.5*shape.height;
line.x2 = shape.x;
line.y2 = shape.y;
line.z2 = shape.z - 0.5*shape.height - 50;