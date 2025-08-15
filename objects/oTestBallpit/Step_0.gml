// Feather disable all

with(sphere)
{
    x += xSpeed;
    y += ySpeed;
    z += zSpeed;
}

var _shape = sphere;
var _array = [quadLeft, quadTop, quadBelow, quadRight, quadBottom, quadAbove];

var _i = 0;
repeat(array_length(_array))
{
    var _other = _array[_i];
    
    var _reaction = _shape.Collide(_other);
    if (_reaction.collision)
    {
        with(_reaction)
        {
            _shape.x += dX;
            _shape.y += dY;
            _shape.z += dZ;
            
            var _dist = sqrt(dX*dX + dY*dY + dZ*dZ);
            var _nX = dX / _dist;
            var _nY = dY / _dist;
            var _nZ = dZ / _dist;
            
            var _dot = 2*dot_product_3d(_shape.xSpeed, _shape.ySpeed, _shape.zSpeed, _nX, _nY, _nZ);
            _shape.xSpeed -= _nX*_dot;
            _shape.ySpeed -= _nY*_dot;
            _shape.zSpeed -= _nZ*_dot;
        }
    }
    
    ++_i;
}