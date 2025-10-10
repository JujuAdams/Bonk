// Feather disable all

/// Pushes the subject shape out of collisions found with the target shapes.
/// 
/// This function will then return deflect data (`BonkResultDeflect`) for the highest priority
/// collision. Collisions with slopes beneath the threshold ("grippy") take priority over
/// collisions with slopes above the threshold ("slippery") collisions, and higher depth collisions
/// take priority over lower depth collisions. The returned struct is statically allocated and
/// calling this function multiple times will reuse the same struct.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// The `slopeThreshold` parameter is measured in degrees and referes to the gradient angle of
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
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param subjectShape
/// @param targetShapes
/// @param [slopeThreshold=0]
/// @param [groupFilter]

function BonkDeflectManyExt(_subjectShape, _targetShapes, _slopeThreshold = 0, _groupFilter = -1)
{
    static _staticDeflectA = new BonkResultDeflect();
    static _staticDeflectB = new BonkResultDeflect();
    
    var _returnDeflect  = _staticDeflectA.__Null();
    var _workingDeflect = _staticDeflectB.__Null();
    
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
                        
                        if ((_reaction.deflectType > _returnDeflect.deflectType)
                        ||  ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType)))
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
    else if (is_handle(_targetShapes) && ds_exists(_targetShapes, ds_type_list)) //We were given a list
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
                        
                        if ((_reaction.deflectType > _returnDeflect.deflectType)
                        ||  ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType)))
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
                    
                    if ((_reaction.deflectType > _returnDeflect.deflectType)
                    ||  ((_depth > _largestDepth) && (_reaction.deflectType >= _returnDeflect.deflectType)))
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