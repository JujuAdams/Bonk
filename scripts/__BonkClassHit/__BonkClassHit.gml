// Feather disable all

function __BonkClassHit() constructor
{
    collision = true;
    x = 0;
    y = 0;
    z = 0;
    normalX = 0;
    normalY = 0;
    normalZ = 1;
    
    static Clone = function()
    {
        var _new = new __BonkClassHit();
        
        _new.collision = collision;
        _new.x = x;
        _new.y = y;
        _new.z = z;
        _new.normalX = normalX;
        _new.normalY = normalY;
        _new.normalZ = normalZ;
         
        return _new;
    }
}