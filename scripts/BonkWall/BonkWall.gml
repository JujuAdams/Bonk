function BonkWall() constructor
{
    static toString = function()
    {
        return "wall";
    }
    
    
    
    #region Setters / Getters
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetNormal = function(_x = xNormal, _y = yNormal, _z = zNormal)
    {
        var _inverse_length = 1/sqrt(_x*_x + _y*_y + _z*_z);
        _x *= _inverse_length;
        _y *= _inverse_length;
        _z *= _inverse_length;
        
        xNormal = _x;
        yNormal = _y;
        zNormal = _z;
        
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
    
    static GetNormal = function()
    {
        return {
            x: xNormal,
            y: yNormal,
            z: zNormal,
        };
    }
    
    #endregion
    
    
    
    #region Variables
    
    x = 0;
    y = 0;
    z = 0;
    
    xNormal = 0;
    yNormal = 0;
    zNormal = 0;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_PLANE_DEFAULT_COLOR)
    {
        BonkDebugDrawPlane(x, y, z, xNormal, yNormal, zNormal, _color);
    }
    
    #endregion
}