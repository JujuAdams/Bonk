/// @param x
/// @param y
/// @param z
/// @param radius

function BonkSphere(_x, _y, _z, _radius) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    radius = _radius;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
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
            z1: z - radius,
            x2: x + radius,
            y2: y + radius,
            z2: z + radius,
        };
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggSphere(x, y, z, radius, _color, _wireframe);
    }
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        if (is_instanceof(_otherPrimitive, BonkAABB))
        {
            return BonkAABBInSphere(_otherPrimitive, self).Reverse();
        }
        else if (is_instanceof(_otherPrimitive, BonkCylinder))
        {
            return BonkCylinderInSphere(_otherPrimitive, self).Reverse();
        }
        else if (is_instanceof(_otherPrimitive, BonkSphere))
        {
            return BonkSphereInSphere(self, _otherPrimitive);
        }
        else if (is_instanceof(_otherPrimitive, BonkQuad))
        {
            return BonkSphereInQuad(self, _otherPrimitive);
        }
        else if (is_instanceof(_otherPrimitive, BonkTriangle))
        {
            return BonkSphereInTriangle(self, _otherPrimitive);
        }
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($"Collision not supported between \"{instanceof(self)}\" and \"{instanceof(_otherPrimitive)}\"");
        }
        
        return _nullReaction;
    }
}