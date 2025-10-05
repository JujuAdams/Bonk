// Feather disable all

/// Returned by all "deflect" functions (e.g. `BonkMoveAndDeflectExt()`). The `.collisionData`
/// variable in a deflect result is a struct made by the `BonkResultCollide()` constructor.
/// 
/// You'll almost certainly never need to create one these structs yourself.

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