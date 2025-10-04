// Feather disable all

/// Constructor that generates a ray that starts at a point and extending out in a direction. Rays
/// can check against the following shapes:
/// - Axis-Aligned Box
/// - Capsule
/// - Cylinder
/// - Quad
/// - Sphere
/// - Triangle
/// 
/// `.SetOrigin([x], [y], [z])`
/// 
/// `.SetDirection([dX], [dY], [dZ])`
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
/// `.x` `.y` `.z`
///     Coordinate of the origin of the ray.
/// 
/// `.dX` `.dY` `.dZ`
///     Direction that the ray is pointed in.
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ

function BonkRay(_x, _y, _z, _dX, _dY, _dZ) constructor
{
    static bonkType = BONK_TYPE_RAY;
    static __lineHitFunction = __BonkReturnNullHit;
    
    static _hitFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkRayHitAAB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkRayHitCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRayHitCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkRayHitQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRayHitSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkRayHitTriangle;
        _array[@ BONK_TYPE_WORLD   ] = BonkRayHitWorld;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    dX = _dX;
    dY = _dY;
    dZ = _dZ;
    
    
    
    static SetOrigin = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetDirection = function(_dX = dX, _dY = dY, _dZ = dZ)
    {
        dX = _dX;
        dY = _dY;
        dZ = _dZ;
        
        return self;
    }
    
    static Draw = function(_color = undefined, _thickness = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRayWithArrow(x, y, z, dX, dY, dZ, _color, _thickness, _wireframe);
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x,
            yMin: y,
            zMin: z,
            xMax: x,
            yMax: y,
            zMax: z,
        };
    }
    
    static Hit = function(_otherShape)
    {
        static _nullHit = __Bonk().__nullHit;
        
        var _hitFunc = _hitFuncLookup[_otherShape.bonkType];
        if (is_callable(_hitFunc))
        {
            return _hitFunc(_otherShape, x, y, z, dX, dY, dZ);
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
    
    static HitFirst = function(_targetShapes)
    {
        static _map = ds_map_create();
        static _nullHit = __Bonk().__nullHit;
        
        var _x = x1;
        var _y = y1;
        var _z = z1;
        
        var _dX = dX;
        var _dY = dY;
        var _dZ = dZ;
        
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
                        
                        var _hit = __lineHitFunction(self, _x, _y, _z, _dX, _dY, _dZ);
                        if (_hit.collision)
                        {
                            var _distance = point_distance_3d(_x, _y, _z, _hit.x, _hit.y, _hit.z);
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
                        
                        var _hit = __lineHitFunction(self, _x, _y, _z, _dX, _dY, _dZ);
                        if (_hit.collision)
                        {
                            var _distance = point_distance_3d(_x, _y, _z, _hit.x, _hit.y, _hit.z);
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
                    
                    var _hit = __lineHitFunction(self, _x, _y, _z, _dX, _dY, _dZ);
                    if (_hit.collision)
                    {
                        var _distance = point_distance_3d(_x, _y, _z, _hit.x, _hit.y, _hit.z);
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
    
    static CollisionList = function(_groupFilter = undefined, _list = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
    {
        return BonkCollisionLineList(x, y, z, x + dX, y + dY, z + dZ, _groupFilter, _list, _objectXY, _objectXZ);
    }
}