function BonkRay() constructor
{
    static toString = function()
    {
        return "point";
    }
    
    
    
    #region Setters / Getters
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        if (isRay)
        {
            x2 = x1 + __BONK_VERY_LARGE*(x2 - x1);
            y2 = y1 + __BONK_VERY_LARGE*(y2 - y1);
            z2 = z1 + __BONK_VERY_LARGE*(z2 - z1);
        }
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        isRay = false;
        
        return self;
    }
    
    static SetRay = function(_x, _y, _z, _dx, _dy, _dz)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        var _d = __BONK_VERY_LARGE / sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
        x2 = x1 + _d*_dx;
        y2 = y1 + _d*_dy;
        z2 = z1 + _d*_dz;
        
        isRay = true;
        
        return self;
    }
    
    static GetA = function()
    {
        return {
            x: x1,
            y: y1,
            z: z1,
        };
    }
    
    static GetB = function()
    {
        return {
            x: x2,
            y: y2,
            z: z2,
        };
    }
    
    static GetRay = function()
    {
        return isRay;
    }
    
    #endregion
    
    
    
    #region Variables
    
    x1 = 0;
    y1 = 0;
    z1 = 0;
    
    x2 = 0;
    y2 = 0;
    z2 = 0;
    
    isRay = false;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawRay(x1, y1, z1, x2, y2, z2, _color);
    }
    
    #endregion
}