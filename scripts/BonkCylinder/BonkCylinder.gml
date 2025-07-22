function BonkCylinder() constructor
{
    x = 0;
    y = 0;
    z = 0;
    
    height = 0;
    radius = 0;
    
    
    
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
    
    static GetPosition = function()
    {
        return {
            x: x,
            y: y,
            z: z,
        };
    }
    
    static GetHeight = function()
    {
        return height;
    }
    
    static GetRadius = function()
    {
        return radius;
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
    
    static Draw = function(_color = undefined)
    {
        __BONK_VERIFY_UGG
        UggCylinder(x, y, z - height/2, height, radius, _color);
    }
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        if (is_instanceof(_otherPrimitive, BonkAABB))
        {
            return BonkAABBInCylinder(_otherPrimitive, self).Reverse();
        }
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($"Collision not supported between \"{instanceof(self)}\" and \"{instanceof(_otherPrimitive)}\"");
        }
        
        return _nullReaction;
    }
}