/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize

function BonkAABB(_x, _y, _z, _xSize, _ySize, _zSize) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    xHalfSize = 0.5*_xSize;
    yHalfSize = 0.5*_ySize;
    zHalfSize = 0.5*_zSize;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetSize = function(_x = 2*xHalfSize, _y = 2*yHalfSize, _z = 2*zHalfSize)
    {
        xHalfSize = 0.5*_x;
        yHalfSize = 0.5*_y;
        zHalfSize = 0.5*_z;
        
        return self;
    }
    
    static GetAABB = function()
    {
        return {
            x1: x - xHalfSize,
            y1: y - yHalfSize,
            z1: z - zHalfSize,
            x2: x + xHalfSize,
            y2: y + yHalfSize,
            z2: z + zHalfSize,
        };
    }
    
    static Draw = function(_color = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, 2*xHalfSize, 2*yHalfSize, 2*zHalfSize, _color);
    }
    
    static Collide = function(_otherPrimitive)
    {
        static _nullReaction = __Bonk().__nullReaction;
        
        if (is_instanceof(_otherPrimitive, BonkAABB))
        {
            return BonkAABBInAABB(self, _otherPrimitive);
        }
        else if (is_instanceof(_otherPrimitive, BonkCylinder))
        {
            return BonkAABBInCylinder(self, _otherPrimitive);
        }
        
        if (BONK_STRICT_COLLISION_COMPATIBILITY)
        {
            __BonkError($"Collision not supported between \"{instanceof(self)}\" and \"{instanceof(_otherPrimitive)}\"");
        }
        
        return _nullReaction;
    }
}