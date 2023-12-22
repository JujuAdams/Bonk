function BonkTriangle() constructor
{
    static toString = function()
    {
        return "triangle";
    }
    
    
    
    #region Setters / Getters
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        if ((_x != x1) || (_y != y1) || (_z != z1)) dirty = true;
        
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        if ((_x != x2) || (_y != y2) || (_z != z2)) dirty = true;
        
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        return self;
    }
    
    static SetC = function(_x = x3, _y = y3, _z = z3)
    {
        if ((_x != x3) || (_y != y3) || (_z != z3)) dirty = true;
        
        x3 = _x;
        y3 = _y;
        z3 = _z;
        
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
    
    static GetC = function()
    {
        return {
            x: x3,
            y: y3,
            z: z3,
        };
    }
    
    static __CalculateNormal = function()
    {
        if (dirty)
        {
            dirty = false;
            
            var _dx12 = x2 - x1;
            var _dy12 = y2 - y1;
            var _dz12 = z2 - z1;
            
            var _dx13 = x3 - x1;
            var _dy13 = y3 - y1;
            var _dz13 = z3 - z1;
            
            normalX = -(_dz12*_dy13 - _dy12*_dz13);
            normalY = -(_dx12*_dz13 - _dz12*_dx13);
            normalZ = -(_dy12*_dx13 - _dx12*_dy13);
            
            var _d = 1 / sqrt(normalX*normalX + normalY*normalY + normalZ*normalZ);
            normalX *= _d;
            normalY *= _d;
            normalZ *= _d;
            
            planeDistance = x1*normalX + y1*normalY + z1*normalZ;
        }
    }
    
    static GetNormal = function()
    {
        __CalculateNormal();
        
        return {
            x: normalX,
            y: normalY,
            z: normalZ,
        };
    }
    
    static GetPlaneDistance = function()
    {
        __CalculateNormal();
        
        return planeDistance;
    }
    
    #endregion
    
    
    
    #region Variables
    
    x1 = 0;
    y1 = 0;
    z1 = 0;
    
    x2 = 0;
    y2 = 0;
    z2 = 0;
    
    x3 = 0;
    y3 = 0;
    z3 = 0;
    
    normalX = 0;
    normalY = 0;
    normalZ = 0;
    planeDistance = 0;
    
    dirty = false;
    
    #endregion
    
    
    
    #region Draw
    
    static DebugDraw = function(_color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
    {
        BonkDebugDrawTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3, _color);
    }
    
    #endregion
}