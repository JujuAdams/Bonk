// Feather disable all

function __BonkClassCollideReaction() constructor
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
}