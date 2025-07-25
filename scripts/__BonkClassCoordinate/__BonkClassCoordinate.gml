// Feather disable all

function __BonkClassCoordinate() constructor
{
    collision = true;
    x = 0;
    y = 0;
    z = 0;
    
    static __NoCollision = function()
    {
        collision = false;
        x = 0;
        y = 0;
        z = 0;
        
        return self;
    }
}