// Feather disable all

/// @param subjectShape
/// @param velocityStruct
/// @param targetShapes
/// @param [slopeThreshold=0]
/// @param [updateVelocity=true]

function BonkMoveAndDeflect(_subjectShape, _velocityStruct, _targetShapes, _slopeThreshold = 0, _updateVelocity = true)
{
    static _nullDeflectData = __Bonk().__nullDeflectData;
    
    if ((not is_array(_targetShapes)) && (not ds_exists(_targetShapes, ds_type_list)))
    {
        _targetShapes = [_targetShapes];
    }
    
    var _returnData = _nullDeflectData;
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
        
        if (is_array(_targetShapes)) //We were given an array
        {
            var _i = 0;
            repeat(array_length(_targetShapes))
            {
                with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
                {
                    var _reaction = Deflect(_subjectShape, _slopeThreshold);
                    if (_reaction.deflectType != BONK_DEFLECT_NONE)
                    {
                        with(_reaction.collisionData)
                        {
                            var _depth = dX*dX + dY*dY + dZ*dZ;
                            if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnData.deflectType))
                            {
                                _largestDepth = _depth;
                                _returnData = _reaction.Clone();
                            }
                        }
                    }
                }
                
                ++_i;
            }
        }
        else if (ds_exists(_targetShapes, ds_type_list)) //We were given a list
        {
            var _i = 0;
            repeat(ds_list_size(_targetShapes))
            {
                with(_targetShapes[| _i]) //Use `with()` here to support iterating over objects
                {
                    var _reaction = Deflect(_subjectShape, _slopeThreshold);
                    if (_reaction.deflectType != BONK_DEFLECT_NONE)
                    {
                        with(_reaction.collisionData)
                        {
                            var _depth = dX*dX + dY*dY + dZ*dZ;
                            if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnData.deflectType))
                            {
                                _largestDepth = _depth;
                                _returnData = _reaction.Clone();
                            }
                        }
                    }
                }
                
                ++_i;
            }
        }
        else
        {
            with(_targetShapes) //Use `with()` here to support iterating over objects
            {
                var _reaction = Deflect(_subjectShape, _slopeThreshold);
                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnData.deflectType))
                        {
                            _largestDepth = _depth;
                            _returnData = _reaction.Clone();
                        }
                    }
                }
            }
        }
        
        if (_updateVelocity)
        {
            _velocityStruct.xSpeed = x - _x;
            _velocityStruct.ySpeed = y - _y;
            _velocityStruct.zSpeed = z - _z;
        }
    }
    
    return _returnData;
}