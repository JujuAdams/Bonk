// Feather disable all

/// Sets the currently scoped instance as a Bonk instance that can be used to stored Bonk structs
/// in a spatial hash map. This is useful for storing static meshes generated from 3D models.
/// 
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkSetupWorld(_cellXSize, _cellYSize, _cellZSize)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    if (BONK_DEBUG_INSTANCES)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize);
    
    mask_index = __BonkMaskAAB;
    image_xscale = 0;
    image_yscale = 0;
}