// Feather disable all

/// @param world
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]
/// @param [groupFilter]

function BonkLineHitWorld(_world, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined, _groupFilter = undefined)
{
    static _map = ds_map_create();
    
    static _staticHitA = new BonkResultHit();
    static _staticHitB = new BonkResultHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    var _lineLength = point_distance_3d(_x1, _y1, _z1,   _x2, _y2, _z2);
    
    with(_world)
    {
        //Prepare parameters for early-out check
        var _bonkCellXSize = __bonkCellXSize;
        var _bonkCellYSize = __bonkCellYSize;
        var _bonkCellZSize = __bonkCellZSize;
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        var _signX = sign(_dX);
        var _signY = sign(_dY);
        var _signZ = sign(_dZ);
        
        if (_dX == 0) _dX = math_get_epsilon();
        if (_dY == 0) _dY = math_get_epsilon();
        if (_dZ == 0) _dZ = math_get_epsilon();
        
        //TODO - Replace with incremental algo
        var _pointArray = GetCellsFromLineExt(_x1, _y1, _z1, _x2, _y2, _z2);
        var _i = 0;
        repeat(array_length(_pointArray) div 3)
        {
            var _x = _pointArray[_i  ];
            var _y = _pointArray[_i+1];
            var _z = _pointArray[_i+2];
            
            var _shapeArray = _world.GetShapeArrayFromCell(_x, _y, _z); //TODO - Optimize by inlining
            var _j = 0;
            repeat(array_length(_shapeArray))
            {
                var _shape = _shapeArray[_j];
                if (not ds_map_exists(_map, _shape))
                {
                    _map[? _shape] = true;
                    
                    if ((_shape.LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _workingHit)).shape != undefined)
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
                
                ++_j;
            }
            
            if (not is_infinity(_closestDistance))
            {
                //Early out if the collision we found is in this cell (or behind it)
                //This prevents erroneous early-outs where a collision is found off in the distance when a closer collision could be found
                var _t = min(((_x + _signX)*_bonkCellXSize - _x1) / _dX,
                             ((_y + _signY)*_bonkCellYSize - _y1) / _dY,
                             ((_z + _signZ)*_bonkCellZSize - _z1) / _dZ);
                
                if (_closestDistance / _lineLength <= _t)
                {
                    ds_map_clear(_map);
                    return (_struct == undefined)? _returnHit : _returnHit.__CopyTo(_struct);
                }
            }
            
            _i += 3;
        }
        
        //Catch edge cases where we were not able to early-out
        if (not is_infinity(_closestDistance))
        {
            ds_map_clear(_map);
            return (_struct == undefined)? _returnHit : _returnHit.__CopyTo(_struct);
        }
    }
    
    ds_map_clear(_map);
    return (_struct == undefined)? _returnHit.Null() : _struct.Null();
}