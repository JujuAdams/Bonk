function BonkFloor() constructor
{
    static toString = function()
    {
        return "floor";
    }
    
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    z  = 0;
    
    static SetPosition = function(_x1 = x1, _y1 = y1, _x2 = x2, _y2 = y2, _z = z)
    {
        x1 = _x1;
        y1 = _y1;
        x2 = _x2;
        y2 = _y2;
        z  = _z;
        
        return self;
    }
    
    static GetPosition = function()
    {
        return {
            x1: x1,
            y1: y1,
            x2: x2,
            y2: y2,
            z:  z,
        };
    }
    
    static Draw = function(_color = undefined)
    {
        __BONK_VERIFY_UGG
        UggQuad(x1, y1, z,   x2, y1, z,   x1, y2, z,   _color);
    }
}