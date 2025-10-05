// Feather disable all

/// Performs a raycast against the target shapes along a line segment. If you'd like to use a Bonk
/// line for raycasting then please use the `.HitFirst()` method on the line struct.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
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
    
    static _staticHitA = new __BonkClassHit();
    static _staticHitB = new __BonkClassHit();
    
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
    else if (ds_exists(_targetShapes, ds_type_list))
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
    return is_infinity(_closestDistance)? _returnHit.__Null() : _returnHit;
}