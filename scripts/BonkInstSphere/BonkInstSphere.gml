// Feather disable all

/// @param x
/// @param y
/// @param z
/// @param radius
/// @param [objectXY]
/// @param [objectYZ]

function BonkInstSphere(_x, _y, _z, _radius, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    with(instance_create_depth(_x, _y, 0, _objectXY))
    {
        z = _z;
        radius = _radius;
        
        sprite_index = BonkMaskCircle;
        image_xscale = BONK_MASK_SIZE / (2*_radius);
        image_yscale = BONK_MASK_SIZE / (2*_radius);
        
        if (BONK_INSTANCE_XZ)
        {
            __instanceXZ = instance_create_depth(_x, _z, 0, _objectXZ);
            with(__instanceXZ)
            {
                __instanceXY = other;
                
                sprite_index = BonkMaskCircle;
                image_xscale = BONK_MASK_SIZE / (2*_radius);
                image_yscale = BONK_MASK_SIZE / (2*_radius);
            }
        }
        
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
            
            image_xscale = BONK_MASK_SIZE / (2*radius);
            image_yscale = BONK_MASK_SIZE / (2*radius);
            
            if (BONK_INSTANCE_XZ)
            {
                __instanceXZ.image_xscale = BONK_MASK_SIZE / (2*radius);
                __instanceXZ.image_yscale = BONK_MASK_SIZE / (2*radius);
            }
            
            return self;
        }
        
        GetAABB = function()
        {
            return {
                xMin: x - radius,
                yMin: y - radius,
                zMin: z - radius,
                xMax: x + radius,
                yMax: y + radius,
                zMax: z + radius,
            };
        }
        
        Draw = function(_color = undefined, _wireframe = undefined)
        {
            __BONK_VERIFY_UGG
            UggSphere(x, y, z, radius, _color, _wireframe);
        }
        
        bonkType = BONK_TYPE_AAB;
        lineHitFunction = BonkLineHitAAB;
        
        __collideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkAABCollideAAB;
            _array[@ BONK_TYPE_CAPSULE ] = BonkAABCollideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkAABCollideCylinder;
            _array[@ BONK_TYPE_SPHERE  ] = BonkAABCollideSphere;
            return _array;
        })();
        
        __insideFuncLookup = (function()
        {
            var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
            _array[@ BONK_TYPE_AAB     ] = BonkAABInsideAAB;
            _array[@ BONK_TYPE_CAPSULE ] = BonkAABInsideCapsule;
            _array[@ BONK_TYPE_CYLINDER] = BonkAABInsideCylinder;
            _array[@ BONK_TYPE_SPHERE  ] = BonkAABInsideSphere;
            return _array;
        })();
        
        return self;
    }
}