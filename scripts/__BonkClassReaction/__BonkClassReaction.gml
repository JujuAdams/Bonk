// Feather disable all

function __BonkClassReaction() constructor
{
    collision = true;
    dX = 0;
    dY = 0;
    dZ = 0;
    
    static __NoCollision = function()
    {
        collision = false;
        dX = 0;
        dY = 0;
        dZ = 0;
    }
}