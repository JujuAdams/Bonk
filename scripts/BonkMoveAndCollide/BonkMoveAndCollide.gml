// Feather disable all

/// @param subjectShape
/// @param velocityStruct
/// @param shapeArray
/// @param [slopeThreshold=0]
/// @param [updateVelocity=true]

function BonkMoveAndCollide(_subjectShape, _velocityStruct, _shapeArray, _slopeThreshold = 0, _updateVelocity = true)
{
    static _nullPushOutReaction = __Bonk().__nullPushOutReaction;
    
    if ((not is_array(_shapeArray)) && (not ds_exists(_shapeArray, ds_type_list)))
    {
        _shapeArray = [_shapeArray];
    }
    
    var _returnReaction = _nullPushOutReaction;
    var _largestDepth = 0;
    
    with(_subjectShape)
    {
        if (_updateVelocity)
        {
            var _x = x;
            var _y = y;
            var _z = z;
        }
        
        AddPosition(_velocityStruct.xSpeed, _velocityStruct.ySpeed, _velocityStruct.zSpeed);
        
        if (is_array(_shapeArray))
        {
            var _i = 0;
            repeat(array_length(_shapeArray))
            {
                var _reaction = _shapeArray[_i].PushOut(_subjectShape, _slopeThreshold);
                if (_reaction.pushOutType != BONK_PUSH_OUT_NONE)
                {
                    with(_reaction.collisionReaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.pushOutType >= _returnReaction.pushOutType))
                        {
                            _largestDepth = _depth;
                            _returnReaction = _reaction.Clone();
                        }
                    }
                }
                
                ++_i;
            }
        }
        else if (ds_exists(_shapeArray, ds_type_list))
        {
            var _i = 0;
            repeat(ds_list_size(_shapeArray))
            {
                var _reaction = _shapeArray[| _i].PushOut(_subjectShape, _slopeThreshold);
                if (_reaction.pushOutType != BONK_PUSH_OUT_NONE)
                {
                    with(_reaction.collisionReaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.pushOutType >= _returnReaction.pushOutType))
                        {
                            _largestDepth = _depth;
                            _returnReaction = _reaction.Clone();
                        }
                    }
                }
                
                ++_i;
            }
        }
        
        if (_updateVelocity)
        {
            _velocityStruct.xSpeed = x - _x;
            _velocityStruct.ySpeed = y - _y;
            _velocityStruct.zSpeed = z - _z;
        }
    }
    
    return _returnReaction;
}