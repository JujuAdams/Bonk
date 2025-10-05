// Feather disable all

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
}