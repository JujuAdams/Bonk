// Feather disable all

/// Pushes a shape (the "subject shape") outside any and all of the target shapes.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
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
/// @param subjectShape
/// @param targetShapes
/// @param [slopeThreshold=0]
/// @param [groupFilter]

function BonkDeflectManyExt(_subjectShape, _targetShapes, _slopeThreshold = 0, _groupFilter = -1)
{
    static _staticDeflectA = new BonkResultDeflect();
    static _staticDeflectB = new BonkResultDeflect();
    
    var _returnDeflect  = _staticDeflectA;
    var _workingDeflect = _staticDeflectB;
    
    var _largestDepth = -infinity;
    
    if (is_array(_targetShapes)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
            {
                var _reaction = Deflect(_subjectShape, _slopeThreshold, _groupFilter, _workingDeflect);
                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType))
                        {
                            _largestDepth = _depth;
                            
                            //Swap over
                            var _tempDeflect = _workingDeflect;
                            _workingDeflect = _returnDeflect;
                            _returnDeflect  = _tempDeflect;
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
                var _reaction = Deflect(_subjectShape, _slopeThreshold, _groupFilter, _workingDeflect);
                if (_reaction.deflectType != BONK_DEFLECT_NONE)
                {
                    with(_reaction.collisionData)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType))
                        {
                            _largestDepth = _depth;
                            
                            //Swap over
                            var _tempDeflect = _workingDeflect;
                            _workingDeflect = _returnDeflect;
                            _returnDeflect  = _tempDeflect;
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
            var _reaction = Deflect(_subjectShape, _slopeThreshold, _groupFilter, _workingDeflect);
            if (_reaction.deflectType != BONK_DEFLECT_NONE)
            {
                with(_reaction.collisionData)
                {
                    var _depth = dX*dX + dY*dY + dZ*dZ;
                    if ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType))
                    {
                        _largestDepth = _depth;
                        
                        //Swap over
                        var _tempDeflect = _workingDeflect;
                        _workingDeflect = _returnDeflect;
                        _returnDeflect  = _tempDeflect;
                    }
                }
            }
        }
    }
    
    return is_infinity(_largestDepth)? _returnDeflect.__Null() : _returnDeflect;
}