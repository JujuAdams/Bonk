// Feather disable all

/// @param subjectShape
/// @param targetShapes
/// @param [groupFilter]

function BonkCollideDeepest(_subjectShape, _targetShapes, _groupFilter = -1)
{
    static _nullCollisionData = __Bonk().__nullCollisionData;
    
    var _returnData = _nullCollisionData;
    var _largestDepth = 0;
    
    if (is_array(_targetShapes)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
            {
                var _reaction = Collide(_subjectShape, _groupFilter);
                if (_reaction.collision)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if (_depth > _largestDepth)
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
                var _reaction = Collide(_subjectShape, _groupFilter);
                if (_reaction.collision)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if (_depth > _largestDepth)
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
            var _reaction = Collide(_subjectShape, _groupFilter);
            if (_reaction.collision)
            {
                with(_reaction.collisionData)
                {
                    var _depth = dX*dX + dY*dY + dZ*dZ;
                    if (_depth > _largestDepth)
                    {
                        _largestDepth = _depth;
                        _returnData = _reaction.Clone();
                    }
                }
            }
        }
    }
    
    return _returnData;
}