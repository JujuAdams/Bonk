// Feather disable all

/// @param subjectShape
/// @param velocityStruct
/// @param shapeArray
/// @param [slopeThreshold=36]
/// @param [updateVelocity=true]

function BonkMoveAndCollide(_subjectShape, _velocityStruct, _shapeArray, _slopeThreshold = 36, _updateVelocity = true)
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
            _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
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