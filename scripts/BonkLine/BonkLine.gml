// Feather disable all

/// Constructor that generates a line segment between two coordinates.
/// 
/// `.SetA([x], [y], [z])`
/// 
/// `.SetB([x], [y], [z])`
/// 
/// `.GetAABB()`
/// 
/// `.Draw([color], [thickness], [wireframe])`
///     Draws the shape. This uses Ugg, please see https://github.com/jujuadams/Ugg
/// 
/// `.Hit(otherShape)`
///     Checks whether the ray hits another shape. You may check against the following shapes:
///     - Axis-Aligned Box
///     - Capsule
///     - Cylinder
///     - Quad
///     - Sphere
///     - Triangle
///     
///     This method returns a struct that contains the following variables:
///     
///     `.collision`
///         Whether a collision was found. If no collision is found, this variable is set to `false`.
///     
///     `.x` `.y` `.z`
///         The point of impact. If there is no collision, all three variables will be set to `0`.
///     
///     N.B. The returned struct is statically allocated. Reusing `.Hit()` may cause the same struct
///          to be returned.
/// 
/// 
/// The struct created by the constructor contains the following values:
/// 
/// `.x1` `.y1` `.z1`
///     Coordinate of the origin of the line.
/// 
/// `.x2` `.y2` `.z2`
///     Coordinate of the destination of the line.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLine(_x1, _y1, _z1, _x2, _y2, _z2) constructor
{
    static bonkType = BONK_TYPE_LINE;
    static __lineHitFunction = __BonkReturnNullHit;
    
    static _hitFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkLineHitAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkLineHitCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkLineHitCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkLineHitQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkLineHitSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkLineHitTriangle;
        _array[@ BONK_TYPE_WORLD   ] = BonkLineHitWorld;
        return _array;
    })();
    
    
    
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            xMin: min(x1, x2),
            yMin: min(y1, y2),
            zMin: min(z1, z2),
            xMax: max(x1, x2),
            yMax: max(y1, y2),
            zMax: max(z1, z2),
        };
    }
    
    static Draw = function(_color = undefined, _thickness = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggArrow(x1, y1, z1, x2, y2, z2, undefined, _color, _thickness, _wireframe);
    }
    
    static OverlapInstances = function(_exclude = undefined, _array = undefined, _objectXY = undefined, _objectXZ = undefined)
    {
        return BonkLineOverlaps(x1, y1, z1, x2, y2, z2, _exclude, _array, _objectXY, _objectXZ);
    }
    
    static Hit = function(_otherShape)
    {
        static _nullHit = __Bonk().__nullHit;
        
        var _hitFunc = _hitFuncLookup[_otherShape.bonkType];
        if (is_callable(_hitFunc))
        {
            return _hitFunc(_otherShape, x1, y1, z1, x2, y2, z2);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkError($".Hit() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return _nullHit;
    }
    
    static HitFirst = function(_arrayOrObject)
    {
        static _map = ds_map_create();
        static _nullHit = __Bonk().__nullHit;
        
        var _x1 = x1;
        var _y1 = y1;
        var _z1 = z1;
        
        var _x2 = x2;
        var _y2 = y2;
        var _z2 = z2;
        
        var _closestHit      = undefined;
        var _closestDistance = infinity;
        
        var _targetArray = is_array(_arrayOrObject)? _arrayOrObject : [_arrayOrObject];
        var _j = 0;
        repeat(array_length(_targetArray))
        {
            with(_targetArray[_j])
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
            
            ++_j;
        }
        
        if (_closestHit != undefined)
        {
            ds_map_clear(_map);
            return _closestHit;
        }
        
        ds_map_clear(_map);
        return _nullHit;
    }
}