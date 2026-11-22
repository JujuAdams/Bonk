// Feather disable all

/// @param function    Function to call to retrieve the height at a given position. The position may contain a fractional component
/// @param x           Position of the top-left corner
/// @param y           Position of the top-left corner
/// @param z           Position of the top-left corner
/// @param cellLeft
/// @param cellTop
/// @param cellCountX  Number of cells in the x axis
/// @param cellCountY  Number of cells in the y axis
/// @param xScale      Scaling factor to apply (this is analogous to the width of a single cell in the x-axis)
/// @param yScale      Scaling factor to apply (this is analogous to the height of a single cell in the y-axis)
/// @param zScale      Scaling factor to apply
/// @param [zMin]
/// @param [zMaz]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupHeightmap(_function, _x, _y, _z, _cellLeft, _cellTop, _cellCountX, _cellCountY, _xScale, _yScale, _zScale, _zMin = undefined, _zMax = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonInstanceFunctions(_groupVector);
    __BonkCommonHeightmap();
    
    if (BONK_SET_INSTANCE_DEPTH)
    {
        depth = _z;
    }
    
    heightFunction = _function;
    
    x = _x;
    y = _y;
    z = _z;
    
    cellLeft   = _cellLeft;
    cellTop    = _cellTop;
    cellCountX = _cellCountX;
    cellCountY = _cellCountY;
    
    xScale = _xScale;
    yScale = _yScale;
    zScale = _zScale;
    
    UpdateBoundingBox(_zMin, _zMax);
    
    mask_index  = __BonkMaskHeightmap;
    image_angle = 0;
    //image_*scale set by `UpdateBoundingBox()`
    
    
    
    SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        if (BONK_SET_INSTANCE_DEPTH)
        {
            depth = _z;
        }
        
        return self;
    }
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: z + __bonkMinZ,
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: z + __bonkMaxZ,
        };
    }
    
    DrawMask = function(_color = c_white, _z = z)
    {
        var _oldZ = gpu_get_depth();
        gpu_set_depth(_z);
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
        gpu_set_depth(_oldZ);
    }
}