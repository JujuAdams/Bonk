// Feather disable all

/// Constructor that creates a Bonk mesh as a struct rather than an instance. For further
/// information please refer to `BonkSetupMesh()` (though native GameMaker variables other than
/// `x` and `y` will not be set for structs).
/// 
/// @param matrix
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkStructMesh(_matrix, _cellXSize, _cellYSize, _cellZSize) constructor
{
    if (BONK_DEBUG_STRUCTS)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonMesh(_cellXSize, _cellYSize, _cellZSize);
    SetMatrix(_matrix);
    
    x = _matrix[12];
    y = _matrix[13];
    z = _matrix[14];
    
    static RemoveFromWorld = function()
    {
        if (__bonkWorld != undefined)
        {
            __bonkWorld.__RemoveShape(self);
            SetPosition = __SetPositionFree;
        }
    }
}