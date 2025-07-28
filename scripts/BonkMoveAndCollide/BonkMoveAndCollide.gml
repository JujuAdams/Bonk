// Feather disable all

/// @param velocityStruct
/// @param subjectShape
/// @param shapeArray
/// @param [slopeThreshold=36]
/// @param [updateVelocity=true]

function BonkMoveAndCollide(_velocityStruct, _subjectShape, _shapeArray, _slopeThreshold = 36, _updateVelocity = true)
{
    if (not is_array(_shapeArray))
    {
        _shapeArray = [_shapeArray];
    }
    
    with(_subjectShape)
    {
        if (_updateVelocity)
        {
            var _x = x;
            var _y = y;
            var _z = z;
        }
        
        x += _velocityStruct.xSpeed;
        y += _velocityStruct.ySpeed;
        z += _velocityStruct.zSpeed;
        
        var _i = 0;
        repeat(array_length(_shapeArray))
        {
            var _reaction = Collide(_shapeArray[_i]);
            if (_reaction.collision)
            {
                var _dX = _reaction.dX;
                var _dY = _reaction.dY;
                var _dZ = _reaction.dZ;
                
                var _distance = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
                if ((_dZ / _distance) > clamp(dcos(_slopeThreshold), 0, 1))
                {
                    //If the slope is shallow enough, just move upwards
                    //This movement is approximate but good enough
                    z += _distance;
                }
                else
                {
                    //Otherwise move out as per normal which will typically slide the subject down slopes
                    x += _dX;
                    y += _dY;
                    z += _dZ;
                }
            }
            
            ++_i;
        }
        
        if (_updateVelocity)
        {
            _velocityStruct.xSpeed = x - _x;
            _velocityStruct.ySpeed = y - _y;
            _velocityStruct.zSpeed = z - _z;
        }
    }
}