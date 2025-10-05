// Feather disable all

function __BonkClassCollideData() constructor
{
    collision = true;
    shape = undefined;
    dX = 0;
    dY = 0;
    dZ = 0;
    
    static __Null = function()
    {
        collision = false;
        shape = undefined;
        dX = 0;
        dY = 0;
        dZ = 0;
        
        return self;
    }
    
    static __Reverse = function(_shape)
    {
        if (shape != undefined)
        {
            shape = _shape;
        }
        
        dX = -dX;
        dY = -dY;
        dZ = -dZ;
        
        return self;
    }
    
    static Clone = function()
    {
        var _new = new __BonkClassCollideData();
        
        _new.collision = collision;
        _new.shape = undefined;
        _new.dX = dX;
        _new.dY = dY;
        _new.dZ = dZ;
         
        return _new;
    }
}