// Feather disable all

/// Constructor that generates an infinitesimal point.
/// 
/// Using the `.Collide(otherShape)` method, points can collide with:
/// - No shapes
/// 
/// @param x
/// @param y
/// @param z

function BonkPoint(_x, _y, _z) constructor
{
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
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($"Collision not supported between \"{instanceof(self)}\" and \"{instanceof(_otherPrimitive)}\"");
        }
        
        return _nullReaction;
    }
}