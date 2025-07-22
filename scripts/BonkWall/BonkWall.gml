/// @param x1
/// @Param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkWall(_x1, _y1, _z1, _x2, _y2, _z2) constructor
{
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    static SetA = function(_x = x1, _y = y1, _z = z1)
    {
        x1 = _x;
        y1 = _y;
        z1 = _z;
        
        return self;
    }
    
    static SetB = function(_x = x2, _y = y2, _z = z2)
    {
        x2 = _x;
        y2 = _y;
        z2 = _z;
        
        return self;
    }
    
    static Draw = function(_color = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z1,   x1, y1, z2,   x2, y2, z1,   _color);
    }
}