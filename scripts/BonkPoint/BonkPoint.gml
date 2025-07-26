// Feather disable all

/// Constructor that generates an infinitesimal point.
/// 
/// @param x
/// @param y
/// @param z

function BonkPoint(_x, _y, _z) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_POINT;
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AABB        ] = BonkCoordInsideAABB;
        _array[@ BONK_TYPE_CAPSULE     ] = BonkCoordInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER    ] = BonkCoordInsideCylinder;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkCoordInsideCylinder;
        _array[@ BONK_TYPE_SPHERE      ] = BonkCoordInsideSphere;
        return _array;
    })();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggPoint(x, y, z, _color, _wireframe);
    }
    
    static Inside = function(_otherShape)
    {
        var _insideFunc = _insideFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(_otherShape, x, y, z);
        }
        else
        {
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($".Inside() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
}