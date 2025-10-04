// Feather disable all

/// @param instance
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [groupVector=BONK_DEFAULT_GROUP]


function BonkSetAsCylinder(_instance, _x, _y, _z, _height, _radius, _groupVector = BONK_DEFAULT_GROUP)
{
    with(_instance)
    {
        __BonkCommonFunctions(_groupVector);
        __BonkCommonCylinder();
        
        
        x = _x;
        y = _y;
        z = _z;
        
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
        
        Draw = function(_color = undefined, _wireframe = undefined)
        {
            __BONK_VERIFY_UGG
            UggCylinder(x, y, z - height/2, height, radius, _color, _wireframe);
        }
        
        
        
        return self;
    }
}