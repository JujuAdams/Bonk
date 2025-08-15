// Feather disable all

with(sphereA)
{
    x += xSpeed;
    y += ySpeed;
    z += zSpeed;
}

with(sphereB)
{
    x += xSpeed;
    y += ySpeed;
    z += zSpeed;
}

var _sphereArray = [sphereA, sphereB];

var _j = 0;
repeat(array_length(_sphereArray))
{
    var _shapeA = _sphereArray[_j];
    
    var _i = _j+1;
    repeat(array_length(_sphereArray) - _i)
    {
        var _shapeB = _sphereArray[_i];
        
        var _reaction = _shapeA.Collide(_shapeB);
        if (_reaction.collision)
        {
            with(_reaction)
            {
                _shapeA.x += dX;
                _shapeA.y += dY;
                _shapeA.z += dZ;
                
                var _dist = sqrt(dX*dX + dY*dY + dZ*dZ);
                var _nX = dX / _dist;
                var _nY = dY / _dist;
                var _nZ = dZ / _dist;
                
                var _dot = 2*dot_product_3d(_shapeA.xSpeed, _shapeA.ySpeed, _shapeA.zSpeed, _nX, _nY, _nZ);
                _shapeA.xSpeed -= _nX*_dot;
                _shapeA.ySpeed -= _nY*_dot;
                _shapeA.zSpeed -= _nZ*_dot;
            }
        }
        
        ++_i;
    }
    
    ++_j;
}

var _quadArray = [quadLeft, quadTop, quadBelow, quadRight, quadBottom, quadAbove];
var _j = 0;
repeat(array_length(_sphereArray))
{
    var _shape = _sphereArray[_j];
    
    var _i = 0;
    repeat(array_length(_quadArray))
    {
        var _other = _quadArray[_i];
        
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
    
    ++_j;
}