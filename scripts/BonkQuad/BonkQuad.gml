// Feather disable all

/// Constructor that generates a quad.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - CylinderExt
/// - Capsule
/// - Sphere
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3

function BonkQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) constructor
{
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    x3 = _x3;
    y3 = _y3;
    z3 = _z3;
    
    
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        if (is_instanceof(_otherPrimitive, BonkCapsule) || is_instanceof(_otherPrimitive, BonkCylinderExt))
        {
            return BonkCapsuleInQuad(_otherPrimitive, self).Reverse();
        }
        else if (is_instanceof(_otherPrimitive, BonkSphere))
        {
            return BonkSphereInQuad(_otherPrimitive, self).Reverse();
        }
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($"Collision not supported between \"{instanceof(self)}\" and \"{instanceof(_otherPrimitive)}\"");
        }
        
        return _nullReaction;
    }
}