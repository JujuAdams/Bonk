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
        _destination.shape = shape;
        
        _destination.x = x;
        _destination.y = y;
        _destination.z = z;
        
        _destination.normalX = normalX;
        _destination.normalY = normalY;
        _destination.normalZ = normalZ;
        
        return self;
    }
}