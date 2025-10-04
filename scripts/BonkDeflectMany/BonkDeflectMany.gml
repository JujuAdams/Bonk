// Feather disable all

/// Pushes a shape (the "subject shape") outside any and all of the shapes in the shape array.
/// 
/// The `slopeThreshold` argument is measured in degrees and referes to the gradient angle of
/// colliding surfaces that the surface bumps into. A slope threshold of `0` degrees is a flat
/// floor, a slope threshold of `90` degrees is a flat wall.
/// 
/// If, at the point of collision with a shape, a slope has a gradient angle lower than the
/// threshold then the subject shape will be pushed up (positive z) out of the shape instead of
/// sliding out of it. If the slope is steeper than the threshold (the slope gradient angle is
/// greater than the slope threshold) then the subject shape will slide off the surface.
/// 
/// You will typically want to leave the slope threshold at `0` for any "physics objects" in your
/// game; that is, objects that are intended move and roll around the environment freely. The
/// player character and non-player characters alike will want a slope threshold of some kind. I
/// personally like an angle of `40` degrees.
/// 
/// @param shapeArray
/// @param subjectShape
/// @param [slopeThreshold=0]

function BonkDeflectMany(_shapeArray, _subjectShape, _slopeThreshold = 0)
{
    static _nullDeflectData = __Bonk().__nullDeflectData;
    
    var _returnData = _nullDeflectData;
    var _largestDepth = 0;
    
    if (is_array(_shapeArray)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_shapeArray))
        {
            with(_shapeArray[_i]) //Use `with()` here to support iterating over objects
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
    else if (ds_exists(_shapeArray, ds_type_list)) //We were given a list
    {
        var _i = 0;
        repeat(ds_list_size(_shapeArray))
        {
            with(_shapeArray[| _i]) //Use `with()` here to support iterating over objects
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
        with(_shapeArray[| _i]) //Use `with()` here to support iterating over objects
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
    
    return _returnData;
}