// Feather disable all

/// Constructor that creates a Bonk world as a struct rather than an instance. For further
/// information please refer to `BonkSetupWorld()` (though native GameMaker variables other than
/// `x` and `y` will not be set for structs).
/// 
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkStructWorld(_cellXSize, _cellYSize, _cellZSize) constructor
{
    if (BONK_DEBUG_STRUCTS)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize);
    
    static RemoveFromWorld = function()
    {
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__RemoveShape(self);
            SetPosition = __SetPositionFree;
        }
    }
}