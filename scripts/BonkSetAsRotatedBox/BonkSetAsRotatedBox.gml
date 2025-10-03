// Feather disable all

/// @param instance
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [objectXZ]

function BonkSetAsRotatedBox(_instance, _x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _objectXZ = BonkMaskXZ)
{
    with(_instance)
    {
        __BonkCommonFunctions();
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
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                mask_index = __BonkMaskAAB;
                image_xscale = (bbox_right - bbox_left) / BONK_MASK_SIZE;
                image_yscale = _zSize / BONK_MASK_SIZE;
            }
        }
        
        
        
        SetPosition = function(_x = x, _y = y, _z = z)
        {
            x = _x;
            y = _y;
            z = _z;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.x = x;
                __instanceXZ.y = z;
            }
            
            return self;
        }
        
        SetSize = function(_x = xSize, _y = ySize, _z = zSize)
        {
            xSize = _x;
            ySize = _y;
            zSize = _z;
            
            image_xscale = xSize / BONK_MASK_SIZE;
            image_yscale = ySize / BONK_MASK_SIZE;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = image_xscale;
                __instanceXZ.image_yscale = zSize / BONK_MASK_SIZE;
            }
        
            return self;
        }
    
        static SetRotation = function(_zRotation = zRotation)
        {
            zRotation = _zRotation;
            
            image_angle = _zRotation;
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = (bbox_right - bbox_left) / BONK_MASK_SIZE;
            }
            
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
            UggRotatedBox(x, y, z, xSize, ySize, zSize, zRotation, _color, _wireframe);
        }
        
        
        
        return self;
    }
}