// Feather disable all

/// Returns collision data for the deepest collision with one of the given target shapes. The
/// `subjectShape` should be either a Bonk struct or Bonk instance.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// @param subjectShape
/// @param targetShapes
/// @param [groupFilter]

function BonkCollideDeepestExt(_subjectShape, _targetShapes, _groupFilter = -1)
{
    static _staticCollideA = new BonkResultCollide();
    static _staticCollideB = new BonkResultCollide();
    
    var _returnCollide  = _staticCollideA;
    var _workingCollide = _staticCollideB;
    
    var _largestDepth = -infinity;
    
    if (is_array(_targetShapes)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
            {
                var _reaction = Collide(_subjectShape, _groupFilter, _workingCollide);
                if (_reaction.shape != undefined)
                {
                    with(_reaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if (_depth > _largestDepth)
                        {
                            _largestDepth = _depth;
                            
                            //Swap over
                            var _tempCollide = _workingCollide;
                            _workingCollide = _returnCollide;
                            _returnCollide  = _tempCollide;
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
                var _reaction = Collide(_subjectShape, _groupFilter, _workingCollide);
                if (_reaction.shape != undefined)
                {
                    with(_reaction)
                    {
                        var _depth = dX*dX + dY*dY + dZ*dZ;
                        if (_depth > _largestDepth)
                        {
                            _largestDepth = _depth;
                            
                            //Swap over
                            var _tempCollide = _workingCollide;
                            _workingCollide = _returnCollide;
                            _returnCollide  = _tempCollide;
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
            var _reaction = Collide(_subjectShape, _groupFilter, _workingCollide);
            if (_reaction.shape != undefined)
            {
                with(_reaction)
                {
                    var _depth = dX*dX + dY*dY + dZ*dZ;
                    if (_depth > _largestDepth)
                    {
                        _largestDepth = _depth;
                        
                        //Swap over
                        var _tempCollide = _workingCollide;
                        _workingCollide = _returnCollide;
                        _returnCollide  = _tempCollide;
                    }
                }
            }
        }
    }
    
    return is_infinity(_largestDepth)? _returnCollide.__Null() : _returnCollide;
}