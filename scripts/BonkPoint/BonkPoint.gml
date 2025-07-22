/// @param x
/// @param y
/// @param z

function BonkPoint(_x, _y, _z) constructor
{
    x = _x;
    y = _y;
    z = _z;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggPoint(x, y, z, _color, _wireframe);
    }
}