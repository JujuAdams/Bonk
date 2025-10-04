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
    
    static CollisionList = function(_object = BonkObject, _groupFilter = -1, _list = undefined, _length = BONK_RAY_LENGTH)
    {
        return BonkCollisionLineList(x, y, z, x + _length*dX, y + _length*dY, z + _length*dZ, _object, _groupFilter, _list);
    }
    
    static HitFirst = function(_targetShapes)
    {
        return BonkRayHitFirst(_targetShapes, x, y, z, dX, dY, dZ);
    }
    
    static HitFirstInstance = function(_object = BonkObject, _groupFilter = -1)
    {
        return BonkRayHitFirst(CollisionList(_groupFilter, undefined, _object), x, y, z, dX, dY, dZ);
    }
}