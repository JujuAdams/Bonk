/// @param x1
/// @Param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkLine(_x1, _y1, _z1, _x2, _y2, _z2) constructor
{
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    isSegment = false;
    
    
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        if (isSegment)
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
        
        isSegment = true;
        
        return self;
    }
    
    static SetLine = function(_x, _y, _z, _dx, _dy, _dz)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        var _d = __BONK_VERY_LARGE / sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
        x2 = x1 + _d*_dx;
        y2 = y1 + _d*_dy;
        z2 = z1 + _d*_dz;
        
        isSegment = false;
        
        return self;
    }
    
    static Draw = function(_color = undefined, _thickness = undefined)
    {
        __BONK_VERIFY_UGG
        UggLine(x1, y1, z1, x2, y2, z2, _color, _thickness);
    }
}