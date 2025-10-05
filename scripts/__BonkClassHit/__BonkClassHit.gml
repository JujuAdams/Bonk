// Feather disable all

function __BonkClassHit() constructor
{
    shape = undefined;
    
    x = 0;
    y = 0;
    z = 0;
    
    normalX = 0;
    normalY = 0;
    normalZ = 1;
    
    
    
    static __Null = function()
    {
        shape = undefined;
        
        x = 0;
        y = 0;
        z = 0;
        
        normalX = 0;
        normalY = 0;
        normalZ = 1;
        
        return self;
    }
    
    static CopyTo = function(_destination)
    {
        shape = _destination.shape;
        
        x = _destination.x;
        y = _destination.y;
        z = _destination.z;
        
        normalX = _destination.normalX;
        normalY = _destination.normalY;
        normalZ = _destination.normalZ;
        
        return self;
    }
}