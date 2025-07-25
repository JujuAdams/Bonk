// Feather disable all

/// Constructor that generates a z-aligned cylinder with additional collisions.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - AABBs
/// - Cylinder / CylinderExt
/// - Capsule
/// - Sphere
/// - Quad
/// - Triangle
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius

function BonkCylinderExt(_x, _y, _z, _height, _radius) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    height = _height;
    radius = _radius;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetHeight = function(_height = height)
    {
        height = _height;
        
        return self;
    }
    
    static SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            x1: x - radius,
            y1: y - radius,
            z1: z - 0.5*height,
            x2: x + radius,
            y2: y + radius,
            z2: z + 0.5*height,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCylinder(x, y, z - height/2, height, radius, _color, _wireframe);
    }
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        if (is_instanceof(_otherPrimitive, BonkAABB))
        {
            return BonkAABBInCylinder(_otherPrimitive, self).Reverse();
        }
        else if (is_instanceof(_otherPrimitive, BonkCylinder) || is_instanceof(_otherPrimitive, BonkCylinderExt))
        {
            return BonkCylinderInCylinder(self, _otherPrimitive);
        }
        else if (is_instanceof(_otherPrimitive, BonkCapsule))
        {
            return BonkCapsuleInCylinder(_otherPrimitive, self).Reverse();
        }
        else if (is_instanceof(_otherPrimitive, BonkSphere))
        {
            return BonkCylinderInSphere(self, _otherPrimitive);
        }
        else if (is_instanceof(_otherPrimitive, BonkQuad))
        {
            return BonkCapsuleInQuad(self, _otherPrimitive);
        }
        else if (is_instanceof(_otherPrimitive, BonkTriangle))
        {
            return BonkCapsuleInTriangle(self, _otherPrimitive);
        }
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($"Collision not supported between \"{instanceof(self)}\" and \"{instanceof(_otherPrimitive)}\"");
        }
        
        return _nullReaction;
    }
}