// Feather disable all

/// Constructor that generates a line segment between two coordinates.
/// 
/// This shape cannot use the `.Collide()` nor `.Inside()` methods. Instead, lines can use the
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
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLine(_x1, _y1, _z1, _x2, _y2, _z2) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_LINE;
    
    static _hitFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkRayHitAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkRayHitCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkRayHitCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkRayHitCylinder;
        _array[@ BONK_TYPE_QUAD        ] = BonkRayHitQuad;
        _array[@ BONK_TYPE_SPHERE      ] = BonkRayHitSphere;
        _array[@ BONK_TYPE_TRIANGLE    ] = BonkRayHitTriangle;
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
    
    static Draw = function(_color = undefined, _thickness = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggArrow(x1, y1, z1, x2, y2, z2, undefined, _color, _thickness, _wireframe);
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
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($".Hit() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return _nullHit;
    }
}