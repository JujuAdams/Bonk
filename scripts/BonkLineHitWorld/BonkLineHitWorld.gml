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
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
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
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        if (_dX == 0)
        {
            var _t1 = -infinity;
            var _t2 =  infinity;
        }
        else
        {
            var _t1 = (-_x1) / _dX;
            var _t2 = (__xSize - _x1) / _dX;
        }
        
        if (_dY == 0)
        {
            var _t3 = -infinity;
            var _t4 =  infinity;
        }
        else
        {
            var _t3 = (-_y1) / _dY;
            var _t4 = (__ySize - _y1) / _dY;
        }
        
        if (_dZ == 0)
        {
            var _t5 = -infinity;
            var _t6 =  infinity;
        }
        else
        {
            var _t5 = (-_z1) / _dZ;
            var _t6 = (__zSize - _z1) / _dZ;
        }
        
        var _tMin = max(min(_t1, _t2), min(_t3, _t4), min(_t5, _t6));
        var _tMax = min(max(_t1, _t2), max(_t3, _t4), max(_t5, _t6));
        
        if ((_tMax < 0) || (_tMin > 1) || (_tMin > _tMax))
        {
            return _nullHit;
        }
        
        _tMin = clamp(_tMin, 0, 1);
        _tMax = clamp(_tMax, 0, 1);
        
        var _t = (_tMin < 0)? _tMax : _tMin;
        
        var _hitX = _x1 + _t*_dX;
        if ((_hitX < 0) || (_hitX >= __xSize))
        {
            return _nullHit;
        }
        
        var _hitY = _y1 + _t*_dY;
        if ((_hitY < 0) || (_hitY >= __ySize))
        {
            return _nullHit;
        }
        
        var _hitZ = _z1 + _t*_dZ;
        if ((_hitZ < 0) || (_hitZ >= __zSize))
        {
            return _nullHit;
        }
        
        var _clampedX1 = _x1 + _tMin*_dX;
        var _clampedY1 = _y1 + _tMin*_dY;
        var _clampedZ1 = _z1 + _tMin*_dZ;
        
        var _clampedX2 = _x1 + _tMax*_dX;
        var _clampedY2 = _y1 + _tMax*_dY;
        var _clampedZ2 = _z1 + _tMax*_dZ;
        
        var _cellXSize = __cellXSize;
        var _cellYSize = __cellYSize;
        var _cellZSize = __cellZSize;
        
        //TODO - Replace with incremental algo
        var _pointArray = __BonkSupercover(_clampedX1/_cellXSize, _clampedY1/_cellYSize, _clampedZ1/_cellZSize,
                                           _clampedX2/_cellXSize, _clampedY2/_cellYSize, _clampedZ2/_cellZSize);
        
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
                    
                    var _hit = _shape.lineHitFunction(_shape, _x1, _y1, _z1, _x2, _y2, _z2);
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