function BonkSphere() constructor
{
    static toString = function()
    {
        return "sphere";
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
    
    static GetRadius = function()
    {
        return radius;
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
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    xPrevious = 0;
    yPrevious = 0;
    zPrevious = 0;
    
    radius = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawSphere(x, y, z, radius, _color);
    }
    
    #endregion
}