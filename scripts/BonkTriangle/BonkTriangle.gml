/// @param x1
/// @Param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3

function BonkTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) constructor
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
    
    normalX = 0;
    normalY = 0;
    normalZ = 0;
    planeDistance = 0;
    
    dirty = true;
    __CalculateNormal();
    
    
    
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
    
    static Draw = function(_color = undefined)
    {
        __BONK_VERIFY_UGG
        UggTriangle(x1, y1, z1, x2, y2, z2, x3, y3, z3, _color);
    }
}