/// @param subjectShape
/// @param slopeThreshold
/// @param collideArray

function __BonkConvertCollideArrayToDeflect(_subjectShape, _slopeThreshold, _collideArray)
{
    static _staticDeflect = new BonkResultDeflect();
    var _result = _staticDeflect;
    
    var _collisionCount = array_length(_collideArray);
    if (_collisionCount <= 0)
    {
        return _result.Null();
    }
    
    var _minGripSlope = clamp(dcos(_slopeThreshold), 0, 1);
    
    //Flesh out all the collisions with extra data
    //TODO - Should we just do this for all collision returns?
    var _i = 0;
    repeat(array_length(_collideArray))
    {
        with(_collideArray[_i])
        {
            __distance = point_distance_3d(0,0,0,   dX, dY, dZ);
            __slope = dZ / max(0.0001, __distance);
            __grippy = (__slope >= _minGripSlope);
        }
        
        ++_i;
    }
    
    //Sort the array with a special algorithm
    array_sort(_collideArray, function(_a, _b)
    {
        if (_a.__grippy)
        {
            if (_b.__grippy)
            {
                //Sort grippy shapes by slope, descending
                return sign(_b.__slope - _a.__slope);
            }
            else
            {
                //Always put grippy on top
                return -1
            }
        }
        else
        {
            if (_b.__grippy)
            {
                //Always put slippy on bottom
                return +1;
            }
            else
            {
                //Sort grippy shapes by penetration distance, descending
                return sign(_b.__distance - _a.__distance);
            }
        }
    });
    
    //Handle the "most" collision first
    with(_collideArray[0])
    {
        if (__grippy)
        {
            var _foundSlippery = false;
            
            //If the slope is shallow enough, just move upwards
            //This movement is approximate but good enough
            _subjectShape.AddPosition(0, 0, __distance);
            
            with(_result)
            {
                other.__CopyTo(grippyCollision);
                primaryCollision = grippyCollision;
                deflectType = BONK_DEFLECT_GRIPPY;
            }
        }
        else
        {
            var _foundSlippery = true;
            
            //Otherwise move out as usual which will typically slide the subject down slopes
            _subjectShape.AddPosition(dX, dY, dZ);
            
            with(_result)
            {
                grippyCollision.Null();
                other.__CopyTo(slipperyCollision);
                primaryCollision = slipperyCollision;
                deflectType = BONK_DEFLECT_SLIPPERY;
            }
        }
    }
    
    //Then re-check and handle all other collisions
    var _i = 1;
    repeat(_collisionCount-1)
    {
        var _collideStruct = _subjectShape.Collide(_collideArray[_i].shape, -1, undefined, true);
        with(_collideStruct)
        {
            if (shape != undefined)
            {
                var _distance = point_distance_3d(0,0,0,   dX, dY, dZ);
                if (dZ / max(0.0001, _distance) > _minGripSlope)
                {
                    //If the slope is shallow enough, just move upwards
                    //This movement is approximate but good enough
                    _subjectShape.AddPosition(0, 0, _distance);
                }
                else
                {
                    if (not _foundSlippery)
                    {
                        _foundSlippery = true;
                        _collideStruct.__CopyTo(_result.slipperyCollision);
                    }
                    
                    //Otherwise move out as usual which will typically slide the subject down slopes
                    _subjectShape.AddPosition(dX, dY, dZ);
                }
            }
        }
        
        ++_i;
    }
    
    if (not _foundSlippery)
    {
        _result.slipperyCollision.Null();
    }
    
    return _result;
}