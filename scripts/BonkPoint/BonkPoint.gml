function BonkPoint() constructor
{
    static toString = function()
    {
        return "point";
    }
    
    
    
    #region Setters / Getters
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        if ((x != _x) || (y != _y) || (z != _z))
        {
            xPrevious = x;
            yPrevious = y;
            zPrevious = z;
            
            x = _x;
            y = _y;
            z = _z;
        }
        
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
    
    static GetAABB = function()
    {
        return {
            x1: x,
            y1: y,
            z1: z,
            x2: x,
            y2: y,
            z2: z,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    xPrevious = 0;
    yPrevious = 0;
    zPrevious = 0;
    
    #endregion
    
    
    
    #region Debug Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawPoint(x, y, z, _color);
    }
    
    #endregion
}