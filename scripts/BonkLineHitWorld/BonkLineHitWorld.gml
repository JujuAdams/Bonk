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

function BonkLineHitWorld(_world, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _map = ds_map_create();
    static _nullHit = __Bonk().__nullHit;
    
    var _closestHit      = undefined;
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
                    
                    var _hit = _shape.__lineHitFunction(_shape, _x1, _y1, _z1, _x2, _y2, _z2);
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
                
                ++_j;
            }
            
            if (_closestHit != undefined)
            {
                ds_map_clear(_map);
                return _closestHit;
            }
            
            _i += 3;
        }
    }
    
    ds_map_clear(_map);
    return _nullHit;
}