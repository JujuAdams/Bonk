// Feather disable all

/// Returned by all "collide" functions (e.g. `BonkCylinderCollideCylinder()`) and is also part of
/// deflect data (please see `BonkResultDeflect()`).
/// 
/// You'll almost certainly never need to create one of these structs yourself.

function BonkResultCollide() constructor
{
    shape = undefined;
    
    dX = 0;
    dY = 0;
    dZ = 0;
    
    
    
    static __Null = function()
    {
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