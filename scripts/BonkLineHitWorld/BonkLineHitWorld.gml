// Feather disable all

/// @param world
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [groupFilter]
/// @param [struct]

function BonkLineHitWorld(_world, _x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
{
    static _map = ds_map_create();
    
    static _staticHitA = new BonkResultHit();
    static _staticHitB = new BonkResultHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    
    with(_world)
    {
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
                ds_map_clear(_map);
                
                if (_struct == undefined)
                {
                    return _returnHit;
                }
                else
                {
                    return _returnHit.__CopyTo(_struct);
                }
            }
            
            _i += 3;
        }
    }
    
    ds_map_clear(_map);
    return _returnHit.__Null();
}