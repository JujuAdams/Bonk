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

var _array = [];
var _listXY = ds_list_create();
var _listXZ = ds_list_create();

with(shape.__instanceXY)
{
    instance_place_list(x + other.velocity.xSpeed,
                        y + other.velocity.ySpeed,
                        __BonkShapeSurrogateXY, _listXY, false);
}

//with(shape.__instanceXZ)
//{
//    instance_place_list(x + other.velocity.xSpeed,
//                        y + other.velocity.zSpeed,
//                        __BonkShapeSurrogateXZ, _listXZ, false);
//}

var _i = 0;
repeat(ds_list_size(_listXY))
{
    var _shape = _listXY[| _i].__shape;
    
    //var _index = ds_list_find_index(_listXZ, _shape.__instanceXZ);
    //if (_index >= 0)
    {
        array_push(_array, _shape);
    }
    
    ++_i;
}

var _pushOutReaction = BonkMoveAndCollide(shape, velocity, _array, 40);
if (_pushOutReaction.pushOutType == BONK_PUSH_OUT_GRIPPY)
{
    onGroundFrames = 5;
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

ds_list_destroy(_listXY);
ds_list_destroy(_listXZ);