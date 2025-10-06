// Feather disable all

/// Returns collision data (`BonkResultCollide`) for the deepest collision for the subject shape
/// against the provided target shapes. If any of the shapes being tested are Bonk worlds then this
/// function will also test for collisions with structs stored inside the Bonk world. If no
/// collision is found, a `BonkResultCollide` struct will still be returned but the `.shape`
/// variable will be set to `undefined`.
/// 
/// This function will return a statically allocated struct. Calling this function multiple times
/// will reuse the same struct.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
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