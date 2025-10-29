// Feather disable all

/// Returns hit data (`BonkResultHit`) for the closest shape that the line segment touches by
/// iterating over the provided target shapes. If any of the shapes being tested are Bonk worlds
/// then this function will also test for collisions with structs stored inside the Bonk world. If
/// no hit is found, a `BonkResultHit` struct will still be returned but the `.shape` variable will
/// be set to `undefined`.
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
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param targetShapes
/// @param [groupFilter]
/// @param [struct]

function BonkLineHitFirstExt(_x1, _y1, _z1, _x2, _y2, _z2, _targetShapes, _groupFilter = -1, _struct = undefined)
{
    static _map = ds_map_create();
    
    static _staticHitA = new BonkResultHit();
    static _staticHitB = new BonkResultHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    
    if (is_array(_targetShapes))
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i])
            {
                if (not ds_map_exists(_map, self))
                {
                    _map[? self] = true;
                    
                    if (LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _workingHit).shape != undefined)
                    {
                        var _distance = point_distance_3d(_x1, _y1, _z1, _workingHit.x, _workingHit.y, _workingHit.z);
                        if (_distance < _closestDistance)
                        {
                            _closestDistance = _distance;
                            
                            //Swap over
                            var _tempHit = _workingHit;
                            _workingHit = _returnHit;
                            _returnHit  = _tempHit;
                        }
                    }
                }
            }
            
            ++_i;
        }
    }
    else if (is_handle(_targetShapes) && ds_exists(_targetShapes, ds_type_list))
    {
        var _i = 0;
        repeat(ds_list_size(_targetShapes))
        {
            with(_targetShapes[| _i])
            {
                if (not ds_map_exists(_map, self))
                {
                    _map[? self] = true;
                    
                    if (LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _workingHit).shape != undefined)
                    {
                        var _distance = point_distance_3d(_x1, _y1, _z1, _workingHit.x, _workingHit.y, _workingHit.z);
                        if (_distance < _closestDistance)
                        {
                            _closestDistance = _distance;
                            
                            //Swap over
                            var _tempHit = _workingHit;
                            _workingHit = _returnHit;
                            _returnHit  = _tempHit;
                        }
                    }
                }
            }
            
            ++_i;
        }
    }
    else
    {
        with(_targetShapes)
        {
            if (not ds_map_exists(_map, self))
            {
                _map[? self] = true;
                
                if (LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _workingHit).shape != undefined)
                {
                    var _distance = point_distance_3d(_x1, _y1, _z1, _workingHit.x, _workingHit.y, _workingHit.z);
                    if (_distance < _closestDistance)
                    {
                        _closestDistance = _distance;
                        
                        //Swap over
                        var _tempHit = _workingHit;
                        _workingHit = _returnHit;
                        _returnHit  = _tempHit;
                    }
                }
            }
        }
    }
    
    ds_map_clear(_map);
    
    if (_struct == undefined)
    {
        //Return the static struct
        return is_infinity(_closestDistance)? _returnHit.__Null() : _returnHit;
    }
    else
    {
        //Return the input struct
        return is_infinity(_closestDistance)? _struct.__Null() : _returnHit.__CopyTo(_struct);
    }
}