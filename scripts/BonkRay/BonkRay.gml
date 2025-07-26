// Feather disable all

/// Constructor that generates a ray that starts at a point and extending out in a direction.
/// 
/// This shape cannot use the `.Collide()` nor `.Inside()` methods. Instead, rays can use the
/// special `.Intersects(otherShape)` method. This method is compatible with the following shapes:
/// - AABB
/// - Capsule
/// - Cylinder / CylinderExt
/// - Quad
/// - Sphere
/// - Triangle
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ

function BonkRay(_x, _y, _z, _dX, _dY, _dZ) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_RAY;
    
    static _intersectsFuncLookup = (function()
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
    
    
    
    x1 = _x;
    y1 = _y;
    z1 = _z;
    
    dX = _dX;
    dY = _dY;
    dZ = _dZ;
    
    x2 = _x + BONK_RAY_LENGTH*_dX;
    y2 = _y + BONK_RAY_LENGTH*_dY;
    z2 = _z + BONK_RAY_LENGTH*_dZ;
    
    
    
    static SetOrigin = function(_x = x, _y = y, _z = z)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        x2 = x1 + BONK_RAY_LENGTH*dX;
        y2 = y1 + BONK_RAY_LENGTH*dY;
        z2 = z1 + BONK_RAY_LENGTH*dZ;
        
        return self;
    }
    
    static SetDirection = function(_dX = dX, _dY = dY, _dZ = dZ)
    {
        dX = _dX;
        dY = _dY;
        dZ = _dZ;
        
        x2 = x1 + BONK_RAY_LENGTH*dX;
        y2 = y1 + BONK_RAY_LENGTH*dY;
        z2 = z1 + BONK_RAY_LENGTH*dZ;
        
        return self;
    }
    
    static Draw = function(_color = undefined, _thickness = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggArrow(x1, y1, z1, x2, y2, z2, undefined, _color, _thickness, _wireframe);
    }
    
    static Intersects = function(_otherShape)
    {
        static _nullCoordinate = __Bonk().__nullCoordinate;
        
        var _intersectsFunc = _intersectsFuncLookup[_otherShape.bonkType];
        if (is_callable(_intersectsFunc))
        {
            return _intersectsFunc(_otherShape, x1, y1, z1, x2, y2, z2);
        }
        else
        {
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($".Intersects() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return _nullCoordinate;
    }
}