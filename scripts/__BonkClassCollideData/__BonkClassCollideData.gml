// Feather disable all

function __BonkClassCollideData() constructor
{
    collision = true;
    dX = 0;
    dY = 0;
    dZ = 0;
    
    static __Reverse = function()
    {
        dX = -dX;
        dY = -dY;
        dZ = -dZ;
        
        return self;
    }
    
    static Clone = function()
    {
        var _new = new __BonkClassCollideData();
        
        _new.collision = collision;
        _new.dX = dX;
        _new.dY = dY;
        _new.dZ = dZ;
         
        return _new;
    }
}