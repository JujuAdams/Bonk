// Feather disable all

/// Constructor that generates a line segment between two coordinates.
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ

function BonkRay(_x, _y, _z, _dX, _dY, _dZ) constructor
{
    static _collideFuncLookup = __Bonk().__collideFuncLookup;
    
    static bonkType = BONK_TYPE_RAY;
    
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
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        var _collideFunc = _collideFuncLookup[bonkType][_otherPrimitive.bonkType];
        if (is_callable(_collideFunc))
        {
            return _collideFunc(self, _otherPrimitive);
        }
        else
        {
            if (BONK_STRICT_COLLISION_COMPATIBILITY)
            {
                __BonkError($"Collision not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherPrimitive)}\" (type={_otherPrimitive.bonkType})");
            }
        }
        
        return _nullReaction;
    }
}