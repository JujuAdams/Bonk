// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the rotated box type.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonFunctions(_groupVector);
    __BonkCommonRotatedBox();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    xSize = _xSize;
    ySize = _ySize;
    zSize = _zSize;
    
    zRotation = _zRotation;
    
    mask_index = __BonkMaskRotatedBox;
    image_xscale = _xSize / BONK_MASK_SIZE;
    image_yscale = _ySize / BONK_MASK_SIZE;
    image_angle  = _zRotation;
    
    
    
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
    
    static SetRotation = function(_zRotation = zRotation)
    {
        zRotation = _zRotation;
        
        image_angle = _zRotation;
        
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
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggRotatedBox(x, y, z, xSize, ySize, zSize, zRotation, _color, _wireframe);
    }
}