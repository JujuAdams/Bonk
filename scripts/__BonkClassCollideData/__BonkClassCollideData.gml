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
}