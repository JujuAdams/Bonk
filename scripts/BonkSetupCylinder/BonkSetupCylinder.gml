// Feather disable all

/// Sets the currently scoped instance as a Bonk instance of the cylinder type.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupCylinder(_x, _y, _z, _height, _radius, _groupVector = BONK_DEFAULT_GROUP)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    __BonkCommonFunctions(_groupVector);
    __BonkCommonCylinder();
    
    
    
    x = _x;
    y = _y;
    z = _z;
    
    if (BONK_SET_INSTANCE_DEPTH)
    {
        depth = -_z;
    }
    
    height = _height;
    radius = _radius;
    
    mask_index = __BonkMaskCircle;
    image_xscale = 2*_radius / BONK_MASK_SIZE;
    image_yscale = 2*_radius / BONK_MASK_SIZE;
    
    
    
    SetPosition = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        if (BONK_SET_INSTANCE_DEPTH)
        {
            depth = -_z;
        }
        
        return self;
    }
    
    SetHeight = function(_height = height)
    {
        height = _height;
        
        return self;
    }
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: z - 0.5*height,
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: z + 0.5*height,
        };
    }
    
    SetRadius = function(_radius = radius)
    {
        radius = _radius;
        
        image_xscale = 2*radius / BONK_MASK_SIZE;
        image_yscale = 2*radius / BONK_MASK_SIZE;
        
        return self;
    }
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggCylinder(x, y, z - height/2, height, radius, _color, _wireframe);
    }
}