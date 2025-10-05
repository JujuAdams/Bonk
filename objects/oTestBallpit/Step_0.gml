// Feather disable all

var _j = 0;
repeat(array_length(sphereArray))
{
    var _shapeA = sphereArray[_j];
    with(_shapeA)
    {
        x += xSpeed;
        y += ySpeed;
        z += zSpeed;
    }
    
    var _i = _j+1;
    repeat(array_length(sphereArray) - _i)
    {
        var _shapeB = sphereArray[_i];
        
        var _reaction = _shapeA.Collide(_shapeB);
        if (_reaction.shape != undefined)
        {
            with(_reaction)
            {
                _shapeA.x += 0.5*dX;
                _shapeA.y += 0.5*dY;
                _shapeA.z += 0.5*dZ;
                
                _shapeB.x -= 0.5*dX;
                _shapeB.y -= 0.5*dY;
                _shapeB.z -= 0.5*dZ;
                
                var _dist = sqrt(dX*dX + dY*dY + dZ*dZ);
                var _nX = dX / _dist;
                var _nY = dY / _dist;
                var _nZ = dZ / _dist;
                
                var _vX = _shapeB.xSpeed - _shapeA.xSpeed;
                var _vY = _shapeB.ySpeed - _shapeA.ySpeed;
                var _vZ = _shapeB.zSpeed - _shapeA.zSpeed;
                
                var _dot = dot_product_3d(_nX, _nY, _nZ,   _vX, _vY, _vZ);
                
                var _nvX = _dot*_nX;
                var _nvY = _dot*_nY;
                var _nvZ = _dot*_nZ;
                
                _shapeA.xSpeed += _nvX;
                _shapeA.ySpeed += _nvY;
                _shapeA.zSpeed += _nvZ;
                
                _shapeB.xSpeed -= _nvX;
                _shapeB.ySpeed -= _nvY;
                _shapeB.zSpeed -= _nvZ;
            }
        }
        
        ++_i;
    }
    
    ++_j;
}

var _quadArray = [quadLeft, quadTop, quadBelow, quadRight, quadBottom, quadAbove];
var _j = 0;
repeat(array_length(sphereArray))
{
    var _shape = sphereArray[_j];
    
    var _i = 0;
    repeat(array_length(_quadArray))
    {
        var _other = _quadArray[_i];
        
        var _reaction = _shape.Collide(_other);
        if (_reaction.shape != undefined)
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