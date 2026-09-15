// Feather disable all

/// @param function    Function to call to retrieve the height at a given position. The position may contain a fractional component
/// @param x           Position of the top-left corner
/// @param y           Position of the top-left corner
/// @param z           Position of the top-left corner
/// @param cellCountX  Number of cells in the x axis
/// @param cellCountY  Number of cells in the y axis
/// @param xScale      Scaling factor to apply (this is analogous to the width of a single cell in the x-axis)
/// @param yScale      Scaling factor to apply (this is analogous to the height of a single cell in the y-axis)
/// @param zScale      Scaling factor to apply
/// @param [tesselation=simple]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupHeightmap(_function, _x, _y, _z, _cellCountX, _cellCountY, _xScale, _yScale, _zScale, _tesselation = BONK_TESSELATE_SIMPLE, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonInstanceFunctions(_groupVector);
    __BonkCommonHeightmap(_function, _x, _y, _z, _cellCountX, _cellCountY, _xScale, _yScale, _zScale, _tesselation);
    UpdateAllTriangles();
    
    
    
    if (BONK_SET_INSTANCE_DEPTH)
    {
        depth = _z;
    }
    
    mask_index   = __BonkMaskHeightmap;
    image_xscale = __bonkWidth / BONK_MASK_SIZE;
    image_yscale = __bonkHeight / BONK_MASK_SIZE;
    image_angle  = 0;
    
    
    
    SetHeightmapSize = function(_cellCountX = cellCountX, _cellCountY = cellCountY)
    {
        cellCountX = _cellCountX;
        cellCountY = _cellCountY;
        
        UpdateAllTriangles();
        
        image_xscale = __bonkWidth / BONK_MASK_SIZE;
        image_yscale = __bonkHeight / BONK_MASK_SIZE;
    }
    
    SetScale = function(_xScale = xScale, _yScale = yScale, _zScale = zScale)
    {
        xScale = _xScale;
        yScale = _yScale;
        zScale = _zScale;
        
        UpdateAllTriangles();
        
        image_xscale = __bonkWidth / BONK_MASK_SIZE;
        image_yscale = __bonkHeight / BONK_MASK_SIZE;
    }
    
    DebugDrawMask = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }
}