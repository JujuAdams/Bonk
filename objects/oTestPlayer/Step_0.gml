if (not oCamera.mouseLock)
{
    if (keyboard_check_pressed(ord("R")))
    {
        shape.x = xstart;
        shape.y = ystart;
        shape.z = 200;
        velocity.Reset();
    }
    
    if (keyboard_check_pressed(vk_space)) velocity.zSpeed += 15;
    
    var _para = 2*(keyboard_check(ord("W")) - keyboard_check(ord("S")));
    var _perp = 2*(keyboard_check(ord("A")) - keyboard_check(ord("D")));
    var _sin  = dsin(oCamera.camYaw);
    var _cos  = dcos(oCamera.camYaw);
    velocity.xSpeed =  _para*_cos - _perp*_sin;
    velocity.ySpeed = -_para*_sin - _perp*_cos;
}
else
{
    velocity.xSpeed = 0;
    velocity.ySpeed = 0;
}

velocity.zSpeed -= 1;

BonkMoveAndCollide(shape, velocity, world, 40);

/*
var _x = shape.x;
var _y = shape.y;
var _z = shape.z;

shape.x += velocity.xSpeed;
shape.y += velocity.ySpeed;
shape.z += velocity.zSpeed;

with(oTestParent)
{
    shape.PushOut(other.shape, 40);
}

velocity.xSpeed = shape.x - _x;
velocity.ySpeed = shape.y - _y;
velocity.zSpeed = shape.z - _z;
*/