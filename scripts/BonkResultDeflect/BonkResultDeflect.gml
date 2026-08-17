// Feather disable all

/// Returned by all "deflect" functions (e.g. `BonkMoveAndDeflectExt()`). This struct contains
/// information about how a shape has responded to collisions and what collisions have occurred.
/// 
/// Multiple (in theory, an unbounded number) collisions can occur whilst moving a shape. Structs
/// constructed by this function will contain a "primary collision" which is the most important
/// collision if there have been multiple collisions. If both grippy and slippery collisions have
/// happened then the primary collision will be the deepest grippy collision. If no grippy
/// collisions have happened then the primary collision will be the deepest slippery collision.
/// 
/// At any rate, structs also contain information for both the deepest grippy collision as well as
/// information for the deepest slippery collision. Having this as two separate structs is helpful
/// for performing lots of collision detection in one operation rather than needing a separate
/// collision check.
/// 
/// Structs created by the constructor contain the following variables:
/// 
/// `.deflectType`
///   The type of deflection that occurred for the primary collision. This will be one of the
///     `BONK_DEFLECT_*` constants:
///     `BONK_DEFLECT_NONE`     = No collision was found and no deflection occurred.
///     `BONK_DEFLECT_SLIPPERY` = There was a collision and the slope was higher than the threshold.
///     `BONK_DEFLECT_GRIPPY`   = There was a collision and the slope was lower than the threshold.
/// 
/// `.primaryCollision`
///   Data for the primary collision between the two shapes. This is struct constructed by
///   `BonkResultCollide()` (please see that script for more information). The primary collision
///   struct will be the same identical struct as either `.grippyCollision` or `.slipperyCollision`.
/// 
/// `.grippyCollision`
///   Data for the deepest grippy collision between the two shapes. This is struct constructed by
///   `BonkResultCollide()` (please see that script for more information).
/// 
/// `.slipperyCollision`
///   Data for the deepest slippery collision between the two shapes. This is struct constructed by
///   `BonkResultCollide()` (please see that script for more information).

function BonkResultDeflect() constructor
{
    grippyCollision   = new BonkResultCollide();
    slipperyCollision = new BonkResultCollide();
    primaryCollision  = slipperyCollision;
    deflectType       = BONK_DEFLECT_NONE;
    
    static __Null = function()
    {
        if (deflectType != BONK_DEFLECT_NONE)
        {
            grippyCollision.__Null();
            slipperyCollision.__Null();
            primaryCollision = slipperyCollision;
            deflectType = BONK_DEFLECT_NONE;
        }
        
        return self;
    }
    
    static __CopyTo = function(_other)
    {
        grippyCollision.__CopyTo(_other.grippyCollision);
        slipperyCollision.__CopyTo(_other.slipperyCollision);
        _other.primaryCollision = (primaryCollision == grippyCollision)? _other.grippyCollision : _other.slipperyCollision;
        _other.deflectType = deflectType;
        
        return _other;
    }
}