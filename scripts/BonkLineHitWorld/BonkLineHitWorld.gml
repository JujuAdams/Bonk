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
    static _nullHit = __Bonk().__nullHit;
    
    with(_world)
    {
        var _cellXSize = __cellXSize;
        var _cellYSize = __cellYSize;
        var _cellZSize = __cellZSize;
    }
    
    var _closestHit      = undefined;
    var _closestDistance = infinity;
    
    //TODO - Clamp line inside world
    
    var _pointArray = Supercover3D(_x1/_cellXSize, _y1/_cellYSize, _z1/_cellZSize,
                                   _x2/_cellXSize, _y2/_cellYSize, _z2/_cellZSize);
    
    var _inside = false;
    var _i = 0;
    repeat(array_length(_pointArray) div 3)
    {
        var _x = _pointArray[_i  ];
        var _y = _pointArray[_i+1];
        var _z = _pointArray[_i+2];
        
        if (_inside)
        {
            if (not _world.CellInside(_x, _y, _z))
            {
                //Come out the other side of the world, exit
                break;
            }
        }
        else
        {
            if (not _world.CellInside(_x, _y, _z))
            {
                //Not inside yet, exit
                _i += 3;
                continue;
            }
            else
            {
                _inside = true;
            }
        }
        
        var _shapeArray = _world.GetShapeArray(_x, _y, _z);
        var _j = 0;
        repeat(array_length(_shapeArray))
        {
            var _shape = _shapeArray[_i];
            var _func = _shape.lineHitFunction; //FIXME - Make this more efficient
            if (is_callable(_func))
            {
                var _hit = _func(_shape, _x1, _y1, _z1, _x2, _y2, _z2);
                if (_hit.collision)
                {
                    var _distance = point_distance_3d(0,0,0, _hit.x, _hit.y, _hit.z);
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
            return _closestHit;
        }
        
        _i += 3;
    }
    
    return _nullHit;
}