// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the sphere type.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param radius
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupSphere(_x, _y, _z, _radius, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonFunctions(_groupVector);
    __BonkCommonSphere();
    
    
    
    z = _z;
    radius = _radius;
    
    mask_index = __BonkMaskCircle;
    image_xscale = 2*_radius / BONK_MASK_SIZE;
    image_yscale = 2*_radius / BONK_MASK_SIZE;
    
    
    
    SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        image_xscale = 2*radius / BONK_MASK_SIZE;
        image_yscale = 2*radius / BONK_MASK_SIZE;
        
        return self;
    }
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: z - radius,
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: z + radius,
        };
    }
    
    Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggSphere(x, y, z, radius, _color, _wireframe);
    }
}