// Feather disable all

/// @param targetShapes
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLineHitFirst(_targetShapes, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _map = ds_map_create();
    static _nullHit = __Bonk().__nullHit;
    
    var _closestHit      = undefined;
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
                    
                    var _hit = __lineHitFunction(self, _x1, _y1, _z1, _x2, _y2, _z2);
                    if (_hit.collision)
                    {
                        var _distance = point_distance_3d(_x1, _y1, _z1, _hit.x, _hit.y, _hit.z);
                        if (_distance < _closestDistance)
                        {
                            _closestDistance = _distance;
                            _closestHit = variable_clone(_hit);
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
                    
                    var _hit = __lineHitFunction(self, _x1, _y1, _z1, _x2, _y2, _z2);
                    if (_hit.collision)
                    {
                        var _distance = point_distance_3d(_x1, _y1, _z1, _hit.x, _hit.y, _hit.z);
                        if (_distance < _closestDistance)
                        {
                            _closestDistance = _distance;
                            _closestHit = variable_clone(_hit);
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
                
                var _hit = __lineHitFunction(self, _x1, _y1, _z1, _x2, _y2, _z2);
                if (_hit.collision)
                {
                    var _distance = point_distance_3d(_x1, _y1, _z1, _hit.x, _hit.y, _hit.z);
                    if (_distance < _closestDistance)
                    {
                        _closestDistance = _distance;
                        _closestHit = variable_clone(_hit);
                    }
                }
            }
        }
    }
    
    if (_closestHit != undefined)
    {
        ds_map_clear(_map);
        return _closestHit;
    }
    
    ds_map_clear(_map);
    return _nullHit;
}