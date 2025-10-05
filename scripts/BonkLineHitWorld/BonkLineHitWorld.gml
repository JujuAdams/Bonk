// Feather disable all

/// Returns the point of impact where a line meets a Bonk world.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The point of impact. If there is no collision, all three variables will be set to `0`.
/// 
/// `.normalX` `.normalY` `.normalZ`
///     The normal of the surface at the point of impact. If there is no collision, a normal of
///     `{0, 0, 1}` will be returned.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same
///      struct to be returned.
/// 
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
    
    static _staticHitA = new __BonkClassHit();
    static _staticHitB = new __BonkClassHit();
    
    var _returnHit  = _staticHitA;
    var _workingHit = _staticHitB;
    
    var _closestDistance = infinity;
    
    with(_world)
    {
        //TODO - Replace with incremental algo
        var _pointArray = GetCellsFromLine(_x1, _y1, _z1, _x2, _y2, _z2);
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
                    
                    if ((_shape.LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _workingHit)).collision)
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
                    _returnHit.CopyTo(_struct);
                    return _struct;
                }
            }
            
            _i += 3;
        }
    }
    
    ds_map_clear(_map);
    return _returnHit.__Null();
}