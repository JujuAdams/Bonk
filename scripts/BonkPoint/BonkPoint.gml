function BonkPoint() constructor
{
    x = 0;
    y = 0;
    z = 0;
    
    
    
    static SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
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
    
    static Draw = function(_color = undefined)
    {
        __BONK_VERIFY_UGG
        UggPoint(x, y, z, _color);
    }
}