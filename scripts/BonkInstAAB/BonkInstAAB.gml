// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstAAB(_x, _y, _z, _xSize, _ySize, _zSize, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(_x, _y, 0, _objectXY))
    {
        bonkType = BONK_TYPE_AAB;
        __lineHitFunction = BonkLineHitAAB;
        
        static _collideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkAABCollideAAB;
            _array[@ BONK_TYPE_CAPSULE ] = BonkAABCollideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkAABCollideCylinder;
            _array[@ BONK_TYPE_SPHERE  ] = BonkAABCollideSphere;
            return _array;
        })();
        
        static _insideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkAABInsideAAB;
            _array[@ BONK_TYPE_CAPSULE ] = BonkAABInsideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkAABInsideCylinder;
            _array[@ BONK_TYPE_SPHERE  ] = BonkAABInsideSphere;
            return _array;
        })();
        
        __collideFuncLookup = _collideFuncLookup;
        __insideFuncLookup  = _insideFuncLookup;
        
        
        
        z = _z;
        
        xSize = _xSize;
        ySize = _ySize;
        zSize = _zSize;
        
        
        
        sprite_index = __BonkMaskAAB;
        image_xscale = _xSize / BONK_MASK_SIZE;
        image_yscale = _ySize / BONK_MASK_SIZE;
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ).id;
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                sprite_index = __BonkMaskAAB;
                image_xscale = other.image_xscale;
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
        
        
        
        return self;
    }
}