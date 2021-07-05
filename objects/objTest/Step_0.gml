sphereB.SetPosition(mouse_x, mouse_y, 0);

ray.SetB(mouse_x, mouse_y, 0);
if (mouse_check_button_pressed(mb_right)) ray.SetA(mouse_x, mouse_y, 0);

if (mouse_check_button_pressed(mb_left))
{
    var _bullet = new BonkSphere().SetPosition(ray.x1, ray.y1, ray.z1).SetRadius(50);
    
    var _direction = BonkVecMultiply(BonkVecNormalize(BonkVecSubtract([ray.x2, ray.y2, ray.z2], [ray.x1, ray.y1, ray.z1])), 8);
    _bullet.velocityX = _direction[0];
    _bullet.velocityY = _direction[1];
    _bullet.velocityZ = _direction[2];
    
    array_push(bulletArray, _bullet);
}

var _i = 0;
repeat(array_length(bulletArray))
{
    var _bullet = bulletArray[_i];
    _bullet.x += _bullet.velocityX;
    _bullet.y += _bullet.velocityY;
    _bullet.z += _bullet.velocityZ;
    
    var _collision = _bullet.Collision(sphereA);
    if (_collision.GetCollided())
    {
        _bullet.x += _collision.depth*_collision.normalX;
        _bullet.y += _collision.depth*_collision.normalY;
        _bullet.z += _collision.depth*_collision.normalZ;
        
        var _new = BonkVecReflect([_bullet.velocityX,  _bullet.velocityY,  _bullet.velocityZ ],
                                  [_collision.normalX, _collision.normalY, _collision.normalZ]);
        
        _bullet.velocityX = _new[0];
        _bullet.velocityY = _new[1];
        _bullet.velocityZ = _new[2];
    }
    
    ++_i;
}