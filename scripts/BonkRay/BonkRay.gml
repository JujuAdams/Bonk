// Feather disable all

/// Constructor that generates a ray that starts at a point and extending out in a direction.
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ
/// 
/// The struct created by the constructor contains the following values:
///  `.x`  `.y`  `.z`  Coordinate of the origin of the ray.
/// `.dX` `.dY` `.dZ`  Direction that the ray is pointed in.
/// 
/// You may use the `.Draw(color, thickness, wireframe)` method to draw the shape, though this
/// method requires installation of Ugg. Please see https://github.com/jujuadams/Ugg
/// 
/// This shape cannot use the `.Collide()` nor `.Inside()` methods. Instead, rays can use the
/// special `.Hit(otherShape)` method. This method is compatible with the following shapes:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Quad
/// - Sphere
/// - Triangle
/// 
/// The `.Hit()` method returns a "hit" struct (instanceof `__BonkClassHit`). This struct contains
/// four values:
/// 
/// `.collision`    Boolean, whether the line hit the target.
/// `.x` `.y` `.z`  Coordinate of the point where the line hit the target.
/// 
/// If the line did *not* hit the other shape then `.x` `.y` `.z` will all be set to `0`.

function BonkRay(_x, _y, _z, _dX, _dY, _dZ) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_RAY;
    
    static _hitFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB    ] = BonkRayHitAABB;
        _array[@ BONK_TYPE_CAPSULE ] = BonkRayHitCapsule;
        _array[@ BONK_TYPE_CYLINDER] = BonkRayHitCylinder;
        _array[@ BONK_TYPE_QUAD    ] = BonkRayHitQuad;
        _array[@ BONK_TYPE_SPHERE  ] = BonkRayHitSphere;
        _array[@ BONK_TYPE_TRIANGLE] = BonkRayHitTriangle;
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
            x1: x,
            y1: y,
            z1: z,
            x2: x,
            y2: y,
            z2: z,
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
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($".Intersects() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return _nullHit;
    }
}