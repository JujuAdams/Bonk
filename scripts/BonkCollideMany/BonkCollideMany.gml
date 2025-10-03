// Feather disable all

/// @param shapeArray
/// @param subjectShape

function BonkCollideMany(_shapeArray, _subjectShape)
{
    static _nullCollisionReaction = __Bonk().__nullCollisionReaction;
    
    if ((not is_array(_shapeArray)) && (not ds_exists(_shapeArray, ds_type_list)))
    {
        _shapeArray = [_shapeArray];
    }
    
    var _returnReaction = _nullCollisionReaction;
    var _largestDepth = 0;
    
    if (is_array(_shapeArray))
    {
        var _i = 0;
        repeat(array_length(_shapeArray))
        {
            with(_shapeArray[_i]) //Use `with()` here to support iterating over objects
            {
                var _reaction = Collide(_subjectShape);
                if (_reaction.collision)
                {
                    with(_reaction.collisionReaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if (_depth > _largestDepth)
                        {
                            _largestDepth = _depth;
                            _returnReaction = _reaction.Clone();
                        }
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
            with(_shapeArray[| _i]) //Use `with()` here to support iterating over objects
            {
                var _reaction = Collide(_subjectShape);
                if (_reaction.collision)
                {
                    with(_reaction.collisionReaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if (_depth > _largestDepth)
                        {
                            _largestDepth = _depth;
                            _returnReaction = _reaction.Clone();
                        }
                    }
                }
            }
            
            ++_i;
        }
    }
    
    return _returnReaction;
}