// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkSetAsWorld(_cellXSize, _cellYSize, _cellZSize)
{
    if (BONK_DEBUG_INSTANCES)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize);
    
    DrawXY = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }
    
    x = 0;
    y = 0;
    
    mask_index = __BonkMaskAAB;
    image_xscale = 0;
    image_yscale = 0;
}