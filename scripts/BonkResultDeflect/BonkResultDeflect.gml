// Feather disable all

/// Returned by all "deflect" functions (e.g. `BonkMoveAndDeflectExt()`). The `.collisionData`
/// variable in a deflect result is a struct made by the `BonkResultCollide()` constructor. You'll
/// almost certainly never need to create one of these structs yourself.
/// 
/// Structs created by the constructor contain the following variables:
/// 
/// `.deflectType`
///   The type of deflection that occurred. This will be one of the `BONK_DEFLECT_*` constants:
///   `BONK_DEFLECT_NONE`     = No collision was found and no deflection occurred.
///   `BONK_DEFLECT_SLIPPERY` = There was a collision and the slope was higher than the threshold.
///   `BONK_DEFLECT_GRIPPY`   = There was a collision and the slope was lower than the threshold.
///
/// `.collisionData`
///   Data for the collision between the two shapes. Please see `BonkResultCollide()` for more
///   information.

function BonkResultDeflect() constructor
{
    collisionData = new BonkResultCollide();
    deflectType   = BONK_DEFLECT_NONE;
    
    static __Null = function()
    {
        collisionData.__Null();
        deflectType = BONK_DEFLECT_NONE;
        
        return self;
    }
}