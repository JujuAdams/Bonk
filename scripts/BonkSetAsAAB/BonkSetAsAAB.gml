// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetAsAAB(_x, _y, _z, _xSize, _ySize, _zSize, _groupVector = BONK_DEFAULT_GROUP)
{
    __BonkCommonFunctions(_groupVector);
    __BonkCommonAAB();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    mask_index = __BonkMaskAAB;
    image_xscale = _xSize / BONK_MASK_SIZE;
    image_yscale = _ySize / BONK_MASK_SIZE;
    
    
    
    SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    SetSize = function(_x = xSize, _y = ySize, _z = zSize)
    {
        xSize = _x;
        ySize = _y;
        zSize = _z;
        
        image_xscale = xSize / BONK_MASK_SIZE;
        image_yscale = ySize / BONK_MASK_SIZE;
        
        return self;
    }
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: z - 0.5*zSize,
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: z + 0.5*zSize,
        };
    }
    
    Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggAABB(x, y, z, xSize, ySize, zSize, _color, _wireframe);
    }
}