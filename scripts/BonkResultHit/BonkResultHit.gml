// Feather disable all

/// Returned by all "hit" functions (e.g. `BonkRayHitSphere()`).
/// 
/// You'll almost certainly never need to create one of these structs yourself.

function BonkResultHit() constructor
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
}