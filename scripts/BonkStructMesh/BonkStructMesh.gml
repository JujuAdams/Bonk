// Feather disable all

/// Constructor that creates a Bonk mesh as a struct rather than an instance. For further
/// information please refer to `BonkSetupMesh()` (though native GameMaker variables other than
/// `x` and `y` will not be set for structs).
/// 
/// @param matrix
/// @param meshData

function BonkStructMesh(_matrix, _meshData) constructor
{
    if (BONK_DEBUG_STRUCTS)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonMesh(_meshData);
    SetMatrix(_matrix);
    
    static RemoveFromWorld = function()
    {
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__RemoveShape(self);
            SetPosition = __SetPositionFree;
        }
    }
}